const assert = require('node:assert/strict');
const { execFileSync } = require('node:child_process');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const script = path.resolve(__dirname, '..', '.squad', 'templates', 'skills', 'distributed-mesh', 'sync-mesh.sh');
const harness = `
if command -v cygpath >/dev/null 2>&1; then
  SYNC_SCRIPT=$(cygpath -u "$SYNC_SCRIPT")
fi
jq() {
  case "$2" in
    *remote-trusted*) ;;
    *remote-opaque*) printf '%s\\n' mesh ;;
    *.source) printf '%s\\n' "$TEST_SOURCE" ;;
    *.sync_to) printf '%s\\n' "$TEST_TARGET" ;;
    *.auth*) printf '%s\\n' "$TEST_AUTH" ;;
    *) return 1 ;;
  esac
}
curl() {
  printf '%s\\0' "$@" > curl-args
  if [ "$TEST_FAIL" = true ]; then return 1; fi
  while [ "$#" -gt 0 ]; do
    if [ "$1" = --output ]; then
      printf '%s\\n' 'published contract' > "$2"
      return 0
    fi
    shift
  done
  return 1
}
date() { printf '%s' 'fixed-date'; }
source "$SYNC_SCRIPT"
cat "$TEST_TARGET/SUMMARY.md" > summary-result
`;

for (const [name, auth, token, fail] of [
  ['NoAuth', '', '', false],
  ['MissingBearerToken', 'bearer', '', false],
  ['BearerToken', 'bearer', 'test-token', false],
  ['CurlFailure', '', '', true],
]) {
  test(`MeshSync_${name}_PreservesArgumentsAndResult`, () => {
    const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'dotfiles-mesh-test-'));
    const source = 'https://example.invalid/$(printf injected > source-marker)?q="quoted"';
    const target = 'published $(printf injected > target-marker)';
    try {
      execFileSync('bash', ['-c', harness], {
        cwd: directory,
        env: { ...process.env, SYNC_SCRIPT: script, TEST_SOURCE: source, TEST_TARGET: target,
          TEST_AUTH: auth, MESH_TOKEN: token, TEST_FAIL: String(fail) },
        stdio: 'pipe',
      });
      const args = fs.readFileSync(path.join(directory, 'curl-args'), 'utf8').split('\0').slice(0, -1);
      const expected = ['--silent', '--fail'];
      if (token) expected.push('--header', `Authorization: Bearer ${token}`);
      expected.push('--url', source, '--output', `${target}/SUMMARY.md`);
      assert.deepEqual(args, expected);
      assert.equal(fs.existsSync(path.join(directory, 'source-marker')), false);
      assert.equal(fs.existsSync(path.join(directory, 'target-marker')), false);
      const summary = fs.readFileSync(path.join(directory, 'summary-result'), 'utf8');
      assert.equal(summary, fail ? '# mesh — unavailable (fixed-date)\n' : 'published contract\n');
    } finally {
      fs.rmSync(directory, { recursive: true, force: true });
    }
  });
}

test('MeshSync_BearerShellMetacharacters_ArePassedLiterally', () => {
  const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'dotfiles-mesh-test-'));
  const token = 'test $(printf injected > token-marker) "quoted"';
  try {
    execFileSync('bash', ['-c', harness], {
      cwd: directory,
      env: { ...process.env, SYNC_SCRIPT: script, TEST_SOURCE: 'https://example.invalid/summary',
        TEST_TARGET: 'published', TEST_AUTH: 'bearer', MESH_TOKEN: token, TEST_FAIL: 'false' },
      stdio: 'pipe',
    });
    const args = fs.readFileSync(path.join(directory, 'curl-args'), 'utf8').split('\0').slice(0, -1);
    assert.deepEqual(args, ['--silent', '--fail', '--header', `Authorization: Bearer ${token}`,
      '--url', 'https://example.invalid/summary', '--output', 'published/SUMMARY.md']);
    assert.equal(fs.existsSync(path.join(directory, 'token-marker')), false);
  } finally {
    fs.rmSync(directory, { recursive: true, force: true });
  }
});
