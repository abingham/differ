  # parse_was_now_filenames()
  test 'D5F',
  'parse was_now_filenames with space in filename' do
    was_filename,_ = GitDiffParser.new(was_line).parse_was_now_filenames(nil)
    assert_equal 'a/sandbox/ab cd', was_filename
  test 'E14',
  'parse was_now_filenames with embedded space in filename and line ends tab' do
    was_filename,_ = GitDiffParser.new(was_line + "\t").parse_was_now_filenames(nil)
    assert_equal 'a/sandbox/ab cd', was_filename
  'parse was_now_filenames for deleted file' do
    lines =  [
      '--- a/sandbox/xxx',
      '+++ /dev/null'
    ].join("\n")
    was_filename, now_filename = GitDiffParser.new(lines).parse_was_now_filenames(nil)
    assert_equal 'a/sandbox/xxx', was_filename
    assert_equal '/dev/null',     now_filename
  'parse was_now_filenames for new file' do
    lines = [
      '--- /dev/null',
      '+++ b/sandbox/untitled_6TJ'
    ].join("\n")
    was_filename, now_filename = GitDiffParser.new(lines).parse_was_now_filenames(nil)
    assert_equal '/dev/null', was_filename
    assert_equal 'b/sandbox/untitled_6TJ', now_filename
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'BEE',
  'parse was_now_filenames for new empty file which has prefix-lines only' do
    diff_lines = [
      'diff --git a/empty.h b/empty.h',
      'new file mode 100644',
      'index 0000000..e69de29'
    ]
    was_filename, now_filename = GitDiffParser.new('').parse_was_now_filenames(diff_lines)
    assert_equal '/dev/null', was_filename, 'was_filename'
    assert_equal 'a/empty.h', now_filename, 'now_filename'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'BB1',
  'parse was_now_filenames for deleted empy file which has prefix-lines only' do
    diff_lines = [
      'diff --git a/Deleted.java b/Deleted.java',
      'deleted file mode 100644',
      'index e69de29..0000000'
    ]
    was_filename, now_filename = GitDiffParser.new('').parse_was_now_filenames(diff_lines)
    assert_equal 'a/Deleted.java', was_filename, 'was_filename'
    assert_equal '/dev/null', now_filename, 'now_filename'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A90',
  'parse was_now_filenames for renamed file which has prefix-lines only' do
    diff_lines = [
      'diff --git a/old_name.h b/new_name.h',
      'similarity index 100%',
      'rename from old_name.h',
      'rename to new_name.h'
    ]
    was_filename, now_filename = GitDiffParser.new('').parse_was_now_filenames(diff_lines)
    assert_equal 'a/old_name.h', was_filename, 'was_filename'
    assert_equal 'b/new_name.h', now_filename, 'now_filename'