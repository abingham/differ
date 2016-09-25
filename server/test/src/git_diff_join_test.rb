    actual_diffs = GitDiffParser.new(diff_lines).parse_all
    expected = { 'xx.rb' => [] }
    assert_join(expected, diff_lines, visible_files = {})
    actual_diffs = GitDiffParser.new(diff_lines).parse_all
    expected =
    {
    assert_join(expected, diff_lines, visible_files = {})
    actual_diffs = GitDiffParser.new(diff_lines).parse_all
    expected = { 'empty.h' => [] }
    assert_join(expected, diff_lines, visible_files = {})
    actual_diffs = GitDiffParser.new(diff_lines).parse_all
    expected =
    assert_join(expected, diff_lines, visible_files = {})
    expected = { 'copy' => [] }
    assert_join(expected, diff_lines, visible_files = {})
    actual_diffs = GitDiffParser.new(diff_lines).parse_all
    expected =
    assert_join(expected, diff_lines, visible_files = {})
    expected_diffs = {}

    expected =
    assert_join(expected, diff_lines, visible_files)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_join(expected, diff_lines, visible_files)
    actual = git_diff_join(diff_lines, visible_files)
    assert_equal expected, actual