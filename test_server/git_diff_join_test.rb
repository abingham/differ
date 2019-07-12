  # - - - - - - - - - - - - - - - - - - - - - - - -

    old_files = { 'empty.rb' => '' }
    new_files = {}

    [
        old_filename: 'empty.rb',
        new_filename: nil,
    ]

    assert_join(expected, diff_lines, old_files, new_files)
    old_files = { 'non-empty.h' => 'something' }
    new_files = {}

    [
        old_filename: 'non-empty.h',
        new_filename: nil,
            old_start_line:1,
            deleted: [ 'something' ],
            new_start_line:0,
            added: [],
    ]

    assert_join(expected, diff_lines, old_files, new_files)
    old_files = {}
    new_files = { 'empty.h' => '' }
    [
        old_filename: nil,
        new_filename: 'empty.h',
    ]
    assert_join(expected, diff_lines, old_files, new_files)
    old_files = {}
    new_files = { 'non-empty.c' => 'something' }
    [
        old_filename: nil,
        new_filename: 'non-empty.c',
            old_start_line:0,
            deleted: [],
            new_start_line:1,
            added: [ 'something' ],
    ]
    assert_join(expected, diff_lines, old_files, new_files)
    # $ git init
    old_files = { 'plain' => '' }
    new_files = { 'copy'  => '' }
    [
        old_filename: 'plain',
        new_filename: 'copy',
    ]
    expected =
    {
      'copy' =>
      [
        {
          number: 1,
          type: :same,
          line: ''
        }
      ]
    }
    assert_join(expected, diff_lines, old_files, new_files)
    # $ git init
    old_files = { 'plain' => 'xxx' }
    new_files = { 'copy' => 'xxx' }
    [
        old_filename: 'plain',
        new_filename: 'copy',
    ]
    expected =
    {
      'copy' =>
      [
        {
          number: 1,
          type: :same,
          line: 'xxx'
        }
      ]
    }
    assert_join(expected, diff_lines, old_files, new_files)
  'existing non-empty file is changed' do
    old_files = { 'non-empty.c' => 'something' }
    new_files = { 'non-empty.c' => 'something changed' }
    [
        old_filename: 'non-empty.c',
        new_filename: 'non-empty.c',
            old_start_line:1,
            deleted: [ 'something' ],
            new_start_line:1,
            added: [ 'something changed' ],
    ]
    assert_join(expected, diff_lines, old_files, new_files)
    expected_diffs = []
    my_assert_equal expected_diffs, actual_diffs
    old_files = { 'wibble.txt' => 'content' }
    new_files = { 'wibble.txt' => 'content' }
    assert_join(expected, diff_lines, old_files, new_files)
  def assert_join(expected, diff_lines, old_files, new_files)
    actual = git_diff_join(diff_lines, old_files, new_files)