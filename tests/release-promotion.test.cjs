const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { spawnSync } = require('node:child_process');
const test = require('node:test');
const YAML = require('yaml');

const workflows = path.join(__dirname, '..', '.squad', 'templates', 'workflows');
const promote = YAML.parse(fs.readFileSync(path.join(workflows, 'squad-promote.yml'), 'utf8'));
const release = YAML.parse(fs.readFileSync(path.join(workflows, 'squad-release.yml'), 'utf8'));
const main = promote.jobs['preview-to-main'];
const dispatch = main.steps.find(step => step.name === 'Dispatch release on main');

test('Promotion_DispatchesMainAfterSuccessfulPushOnly', () => {
  const merge = main.steps.find(step => step.name === 'Merge preview → main');
  assert.ok(main.steps.indexOf(dispatch) > main.steps.indexOf(merge));
  assert.match(merge.run, /git push origin main/);
  assert.equal(merge.if, "${{ inputs.dry_run == 'false' }}");
  assert.equal(dispatch.if, merge.if);
  assert.equal(merge['continue-on-error'], undefined);
  assert.equal(dispatch['continue-on-error'], undefined);
  assert.equal(dispatch.env.GH_TOKEN, '${{ secrets.GITHUB_TOKEN }}');
  assert.deepEqual(main.permissions, { contents: 'write', actions: 'write' });
  assert.deepEqual(promote.permissions, { contents: 'write' });
  assert.equal(promote.jobs['dev-to-preview'].permissions, undefined);
});

test('Release_PreservesPushTriggerAndRestrictsDispatchToMain', () => {
  assert.deepEqual(release.on.push.branches, ['main']);
  assert.ok(Object.hasOwn(release.on, 'workflow_dispatch'));
  assert.equal(release.jobs.release.if, "github.ref == 'refs/heads/main'");
  assert.deepEqual(release.permissions, { contents: 'write' });
});

for (const [name, exitCode] of [['Success', 0], ['Failure', 1]]) {
  test(`Promotion_DispatchCommand_${name}`, () => {
    const command = dispatch.run.replace('${{ github.repository }}', 'owner/example');
    const result = spawnSync('bash', ['-e'], {
      input: `gh() { printf '%s\\n' "$@"; return ${exitCode}; }\n${command}\n`,
      encoding: 'utf8',
    });
    assert.ifError(result.error);
    assert.equal(result.status, exitCode, result.stderr);
    assert.deepEqual(result.stdout.trim().split(/\r?\n/), [
      'workflow', 'run', 'squad-release.yml', '--repo', 'owner/example', '--ref', 'main',
    ]);
  });
}
