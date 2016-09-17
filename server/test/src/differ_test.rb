  'empty was_files and empty now_files shows as benign nothing' do
    assert_diff []
  # - - - - - - - - - - - - - - - - - - - -
  # delete
  'deleted empty file shows as delete file' do
    assert_diff [
      'diff --git a/hiker.h b/hiker.h',
      'deleted file mode 100644',
      'index e69de29..0000000'
    ]
  'deleted non-empty file shows as delete file and all -deleted lines' do
    assert_diff [
      'diff --git a/hiker.h b/hiker.h',
      'deleted file mode 100644',
      'index d68dd40..0000000',
      '--- a/hiker.h',
      '+++ /dev/null',
      '@@ -1,4 +0,0 @@',
      '-a',
      '-b',
      '-c',
      '-d'
  'all lines deleted but file not deleted shows as all -deleted lines' do
    assert_diff [
      'diff --git a/hiker.h b/hiker.h',
      'index d68dd40..e69de29 100644',
      '--- a/hiker.h',
      '+++ b/hiker.h',
      '@@ -1,4 +0,0 @@',
      '-a',
      '-b',
      '-c',
      '-d'
  'added empty file shows as new file' do
    assert_diff [
      'diff --git a/diamond.h b/diamond.h',
      'new file mode 100644',
      'index 0000000..e69de29'
    ]
  'added non-empty file shows as all +added lines' do
    assert_diff [
      'diff --git a/diamond.h b/diamond.h',
      'new file mode 100644',
      'index 0000000..27a7ea6',
      '--- /dev/null',
      '+++ b/diamond.h',
      '@@ -0,0 +1,4 @@',
      '+a',
      '+b',
      '+c',
      '+d',
      '\\ No newline at end of file'
  'unchanged empty-file has no diff' do
    assert_diff []
  'unchanged non-empty file has no diff' do
    assert_diff []
  'change in non-empty file shows as +added and -deleted lines' do
    assert_diff [
      'diff --git a/diamond.h b/diamond.h',
      'index 2e65efe..63d8dbd 100644',
      '--- a/diamond.h',
      '+++ b/diamond.h',
      '@@ -1 +1 @@',
      '-a',
      '\\ No newline at end of file',
      '+b',
      '\\ No newline at end of file'
  'change in non-empty file shows as +added and -deleted lines',
    assert_diff [
      'diff --git a/diamond.h b/diamond.h',
      'index a737c21..49a3313 100644',
      '--- a/diamond.h',
      '+++ b/diamond.h',
      '@@ -1,8 +1,8 @@',
      ' #ifndef DIAMOND',
      ' #define DIAMOND',
      ' ',
      '-#include <strin>',
      '+#include <string>',
      ' ',
      '-void diamond(char)',
      '+void diamond(char);',
      ' ',
      ' #endif',
      '\\ No newline at end of file'
  'renamed file shows as similarity 100%' do
    assert_diff [
      'diff --git a/hiker.h b/diamond.h',
      'similarity index 100%',
      'rename from hiker.h',
      'rename to diamond.h'
  'renamed and slightly changed file shows as <100% similarity index' do
    assert_diff [
      'diff --git a/hiker.h b/diamond.h',
      'similarity index 57%',
      'rename from hiker.h',
      'rename to diamond.h',
      'index 27a7ea6..2de4cc6 100644',
      '--- a/hiker.h',
      '+++ b/diamond.h',
      '@@ -1,4 +1,4 @@',
      ' a',
      ' b',
      '-c',
      '+X',
      ' d',
      '\\ No newline at end of file'
    ]
  def assert_diff(lines)
    lines = lines + [''] unless lines == []
    expected = lines.join("\n")
    actual = Differ.new(@was_files, @now_files).diff
    assert_equal expected, actual