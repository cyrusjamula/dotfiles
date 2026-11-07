const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');
const { isUntriagedIssue } = require('../.squad/templates/ralph-triage.js');

const root = path.resolve(__dirname, '..');
const team = fs.readFileSync(path.join(root, '.squad', 'team.md'), 'utf8')
  .replace('## Members', '## Members\n\n| Name | Role |\n|------|------|\n| Alex | Lead |');
const AsyncFunction = Object.getPrototypeOf(async function () {}).constructor;

async function runTriage(workflow, title, teamMarkdown = team) {
  const yaml = fs.readFileSync(path.join(root, ...workflow), 'utf8').replace(/\r\n/g, '\n');
  const script = yaml.slice(yaml.indexOf('          script: |\n') + '          script: |\n'.length)
    .split('\n').map(line => line.replace(/^ {12}/, '')).join('\n');
  const labels = [];
  const comments = [];
  await new AsyncFunction('require', 'context', 'core', 'github', script)(
    () => ({
      existsSync: () => true,
      readFileSync: file => file === '.squad/team.md' ? teamMarkdown : '',
    }),
    { payload: { issue: { number: 1, title, labels: [{ name: 'squad' }] } }, repo: { owner: 'owner', repo: 'repo' } },
    { info() {}, warning(message) { throw new Error(message); } },
    { rest: { issues: {
      async addLabels(request) { labels.push(...request.labels); },
      async createComment(request) { comments.push(request.body); },
    } } },
  );
  return { labels, comments };
}

for (const [name, workflow] of [
  ['Active', ['.github', 'workflows', 'squad-triage.yml']],
  ['Template', ['.squad', 'templates', 'workflows', 'squad-triage.yml']],
]) {
  for (const [scenario, title, label, reason] of [
    ['BugFix', 'bug fix for shell loading', 'squad:copilot', 'Good fit for @copilot'],
    ['Documentation', 'documentation update', 'squad:copilot', 'Good fit for @copilot'],
    ['BoldBugFix', '**bug fix** for shell loading', 'squad:copilot', 'Good fit for @copilot'],
    ['NeedsReview', 'refactoring installers', 'squad:copilot', 'needs review'],
    ['NotSuitable', 'architecture bug fix', 'squad:alex', 'Not suitable'],
  ]) {
    test(`${name}_FormattedCapabilityHeadings_${scenario}`, async () => {
      const result = await runTriage(workflow, title);
      assert.deepEqual(result.labels, [label, 'go:needs-research']);
      assert.equal(result.comments.length, 1);
      assert.ok(result.comments[0].includes(reason));
    });
  }

  test(`${name}_InlineCapabilityKeywords_PreserveCustomRouting`, async () => {
    const inlineTeam = team.replace('🟢 Good fit — auto-route when enabled:**', '🟢 Good fit: **customtask**, customother');
    const result = await runTriage(workflow, 'customtask request', inlineTeam);
    assert.deepEqual(result.labels, ['squad:copilot', 'go:needs-research']);
  });
}

for (const [scenario, labels] of [
  ['ObjectLabels', [{ name: 'squad' }, { name: 'squad:copilot' }]],
  ['StringLabels', ['squad', 'squad:copilot']],
  ['MixedCase', [{ name: 'SQUAD' }, 'SQUAD:COPILOT']],
]) {
  test(`Heartbeat_${scenario}_SkipsCopilotAssignment`, () => {
    assert.equal(isUntriagedIssue({ labels }, ['squad:alex']), false);
  });
}

test('Heartbeat_UnassignedSquadIssue_RemainsEligible', () => {
  assert.equal(isUntriagedIssue({ labels: ['squad'] }, ['squad:alex']), true);
});

test('Heartbeat_MemberAssignment_RemainsExcluded', () => {
  assert.equal(isUntriagedIssue({ labels: ['squad', 'squad:alex'] }, ['squad:alex']), false);
});

test('Heartbeat_NonSquadIssue_RemainsExcluded', () => {
  assert.equal(isUntriagedIssue({ labels: [] }, ['squad:alex']), false);
});

test('Heartbeat_PullRequest_RemainsExcluded', () => {
  assert.equal(isUntriagedIssue({ labels: ['squad'], pull_request: {} }, ['squad:alex']), false);
});
