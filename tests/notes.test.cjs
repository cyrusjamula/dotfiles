const assert = require('node:assert/strict');
const { execFileSync, spawnSync } = require('node:child_process');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const scripts = path.resolve(__dirname, '..', '.squad', 'templates', 'scripts', 'notes');
const gitEnv = { ...process.env, GIT_AUTHOR_NAME: 'Test', GIT_AUTHOR_EMAIL: 'test@example.invalid',
  GIT_COMMITTER_NAME: 'Test', GIT_COMMITTER_EMAIL: 'test@example.invalid' };

function git(repo, ...args) {
  return execFileSync('git', ['-c', 'commit.gpgsign=false', '-c', 'core.hooksPath=', '-C', repo, ...args],
    { env: gitEnv, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] }).trim();
}

function runScript(repo, name, ...args) {
  return spawnSync('pwsh', ['-NoProfile', '-File', path.join(scripts, name), '-RepoPath', repo, '-Quiet', ...args],
    { env: gitEnv, encoding: 'utf8' });
}

function success(result) {
  assert.equal(result.status, 0, result.stderr || result.stdout);
}

function fixture() {
  const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'dotfiles-notes-test-'));
  const remote = path.join(directory, 'remote');
  const local = path.join(directory, 'local');
  const peer = path.join(directory, 'peer');
  for (const repo of [remote, local, peer]) fs.mkdirSync(repo);
  git(remote, 'init', '--bare', '--initial-branch=main');
  git(local, 'init', '--initial-branch=main');
  git(local, 'commit', '--allow-empty', '-m', 'fixture');
  git(local, 'remote', 'add', 'origin', remote);
  git(local, 'push', 'origin', 'main');
  git(peer, 'clone', remote, '.');
  return { directory, remote, local, peer };
}

function decisions(repo) {
  return git(repo, 'notes', '--ref=squad/test', 'show', 'HEAD')
    .split('\n').filter(line => line.trim()).map(line => JSON.parse(line).decision).sort();
}

test('Notes_EmptyRemote_CreatesFirstNamespace', () => {
  const f = fixture();
  try {
    success(runScript(f.local, 'write-note.ps1', '-Agent', 'test', '-Type', 'decision',
      '-Content', '{"decision":"first"}', '-NoPush'));
    assert.deepEqual(decisions(f.local), ['first']);
  } finally {
    fs.rmSync(f.directory, { recursive: true, force: true });
  }
});

test('Notes_NoPushWrites_PreservePendingAndRemoteEntries', () => {
  const f = fixture();
  try {
    git(f.peer, 'notes', '--ref=squad/test', 'add', '-m', '{"decision":"remote-first"}', 'HEAD');
    git(f.peer, 'push', 'origin', 'refs/notes/squad/test');
    success(runScript(f.local, 'write-note.ps1', '-Agent', 'test', '-Type', 'decision',
      '-Content', '{"decision":"local-first"}', '-NoPush'));
    success(runScript(f.local, 'write-note.ps1', '-Agent', 'test', '-Type', 'decision',
      '-Content', '{"decision":"local-second"}', '-NoPush'));
    assert.deepEqual(decisions(f.local), ['local-first', 'local-second', 'remote-first']);

    git(f.peer, 'notes', '--ref=squad/test', 'append', '-m', '{"decision":"remote-second"}', 'HEAD');
    git(f.peer, 'push', 'origin', 'refs/notes/squad/test');
    success(runScript(f.local, 'fetch.ps1', '-Merge'));
    assert.deepEqual(decisions(f.local), ['local-first', 'local-second', 'remote-first', 'remote-second']);
    success(runScript(f.local, 'write-note.ps1', '-Agent', 'test', '-Type', 'decision',
      '-Content', '{"decision":"local-third"}'));
    git(f.peer, 'fetch', 'origin', '+refs/notes/squad/test:refs/notes/squad/test');
    assert.deepEqual(decisions(f.peer), ['local-first', 'local-second', 'local-third', 'remote-first', 'remote-second']);
  } finally {
    fs.rmSync(f.directory, { recursive: true, force: true });
  }
});

test('Notes_Setup_MigratesUnsafeRefspecAndImportsAllNamespaces', () => {
  const f = fixture();
  try {
    for (const agent of ['test', 'other']) {
      git(f.peer, 'notes', `--ref=squad/${agent}`, 'add', '-m', '{"decision":"remote"}', 'HEAD');
      git(f.peer, 'push', 'origin', `refs/notes/squad/${agent}`);
    }
    git(f.local, 'config', '--add', 'remote.origin.fetch', 'refs/notes/*:refs/notes/*');
    success(runScript(f.local, 'fetch.ps1', '-Setup', '-Merge'));
    success(runScript(f.local, 'fetch.ps1', '-Setup', '-Merge'));
    const refspecs = git(f.local, 'config', '--get-all', 'remote.origin.fetch').split('\n');
    assert.equal(refspecs.includes('refs/notes/*:refs/notes/*'), false);
    assert.equal(refspecs.filter(ref => ref === '+refs/notes/squad/*:refs/notes/remotes/origin/squad/*').length, 1);
    assert.deepEqual(decisions(f.local), ['remote']);
    assert.equal(JSON.parse(git(f.local, 'notes', '--ref=squad/other', 'show', 'HEAD')).decision, 'remote');
  } finally {
    fs.rmSync(f.directory, { recursive: true, force: true });
  }
});

test('Notes_FetchFailure_DoesNotAppendOrDiscardLocalNotes', () => {
  const f = fixture();
  try {
    git(f.local, 'notes', '--ref=squad/test', 'add', '-m', '{"decision":"pending"}', 'HEAD');
    const result = runScript(f.local, 'write-note.ps1', '-Agent', 'test', '-Type', 'decision',
      '-Content', '{"decision":"new"}', '-Remote', 'missing', '-NoPush');
    assert.notEqual(result.status, 0);
    assert.deepEqual(decisions(f.local), ['pending']);
    assert.match(result.stderr, /Failed to fetch notes/);
  } finally {
    fs.rmSync(f.directory, { recursive: true, force: true });
  }
});

test('Notes_InvalidJson_DoesNotEchoPayload', () => {
  const f = fixture();
  try {
    const result = runScript(f.local, 'write-note.ps1', '-Agent', 'test', '-Type', 'decision',
      '-Content', 'invalid-payload-marker', '-NoPush');
    assert.notEqual(result.status, 0);
    assert.match(result.stderr, /Content must be valid JSON/);
    assert.equal((result.stdout + result.stderr).includes('invalid-payload-marker'), false);
  } finally {
    fs.rmSync(f.directory, { recursive: true, force: true });
  }
});
