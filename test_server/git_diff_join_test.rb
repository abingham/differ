    # $ git init
    # $ touch empty.rb
    # $ git add . && git commit -m "1" && git tag 1 HEAD
    # $ rm empty.rb
    # $ git add . && git commit -m "2" && git tag 2 HEAD
    # $ git diff --unified=0 --ignore-space-at-eol --indent-heuristic 1 2 --
      'diff --git a/empty.rb b/empty.rb',
      'empty.rb' =>
        was_filename: 'empty.rb',
        now_filename: nil,
        chunks: []
    my_assert_equal expected_diffs, actual_diffs
    expected = { 'empty.rb' => [] }
    # $ git init
    # $ echo -n something > non-empty.h
    # $ git add . && git commit -m "1" && git tag 1 HEAD
    # $ rm non-empty.h
    # $ git add . && git commit -m "2" && git tag 2 HEAD
    # $ git diff --unified=0 --ignore-space-at-eol --indent-heuristic 1 2 --
        was_filename: "non-empty.h",
        now_filename: nil,
        chunks:
            was: { start_line:1, size:1 },
            now: { start_line:0, size:0 },
            deleted_lines: [ "something" ],
            added_lines: [],
    my_assert_equal expected_diffs, actual_diffs
          line: 'something',
          type: :deleted,
          number: 1
    # $ git init
    # $ echo x > dummy
    # $ git add . && git commit -m "1" && git tag 1 HEAD
    # $ touch empty.h
    # $ git add . && git commit -m "2" && git tag 2 HEAD
    # $ git diff --unified=0 --ignore-space-at-eol --indent-heuristic 1 2 --
        was_filename: nil,
        now_filename: 'empty.h',
        chunks: []
    my_assert_equal expected_diffs, actual_diffs
    # $ git init
    # $ echo x > dummy
    # $ git add . && git commit -m "1" && git tag 1 HEAD
    # $ echo -n 'something' > non-empty.c
    # $ git add . && git commit -m "2" && git tag 2 HEAD
    # $ git diff --unified=0 --ignore-space-at-eol --indent-heuristic 1 2 --
      'diff --git a/non-empty.c b/non-empty.c',
      'new file mode 100644',
      'index 0000000..a459bc2',
      '--- /dev/null',
      '+++ b/non-empty.c',
      '@@ -0,0 +1 @@',
      '+something',
      '\\ No newline at end of file'
      'non-empty.c' =>
        was_filename: nil,
        now_filename: 'non-empty.c',
        chunks:
            was: { start_line:0, size:0 },
            now: { start_line:1, size:1 },
            deleted_lines: [],
            added_lines: [ 'something' ],
    my_assert_equal expected_diffs, actual_diffs
        { :type => :added, :line => 'something', :number => 1 }
  test 'AA6',
  'empty file is copied' do
    # $ touch plain
    # $ git add . && git commit -m "1" && git tag 1 HEAD
    # $ mv plain copy
    # $ git add . && git commit -m "2" && git tag 2 HEAD
    # $ git diff --unified=0 --ignore-space-at-eol --indent-heuristic 1 2 --
    diff_lines =
    [
      'diff --git a/plain b/copy',
      'similarity index 100%',
      'rename from plain',
      'rename to copy'
    ].join("\n")

    expected_diffs =
    {
      'copy' =>
      {
        was_filename: 'plain',
        now_filename: 'copy',
        chunks: []
      }
    }
    actual_diffs = GitDiffParser.new(diff_lines).parse_all
    my_assert_equal expected_diffs, actual_diffs

    expected = { 'copy' => [] }
    assert_join(expected, diff_lines, visible_files = {})
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # $ echo xxx > plain
    # $ git add . && git commit -m "1" && git tag 1 HEAD
    # $ mv plain copy
    # $ git add . && git commit -m "2" && git tag 2 HEAD
    # $ git diff --unified=0 --ignore-space-at-eol --indent-heuristic 1 2 --
        was_filename: 'plain',
        now_filename: 'copy',
        chunks: []
    my_assert_equal expected_diffs, actual_diffs
    # Note use of -n in the echoes. This is to get the \\No newline at end of file
    # $ git init
    # $ echo -n 'something' > non-empty.c
    # $ git add . && git commit -m "1" && git tag 1 HEAD
    # $ echo -n 'something changed' > non-empty.c
    # $ git add . && git commit -m "2" && git tag 2 HEAD
    # $ git diff --unified=0 --ignore-space-at-eol --indent-heuristic 1 2 --
      'diff --git a/non-empty.c b/non-empty.c',
      'index a459bc2..605f7ff 100644',
      '--- a/non-empty.c',
      '+++ b/non-empty.c',
      '@@ -1 +1 @@',
      '-something',
      '\\ No newline at end of file',
      '+something changed',
      '\\ No newline at end of file',
      'non-empty.c' =>
        was_filename: 'non-empty.c',
        now_filename: 'non-empty.c',
        chunks:
            was: { start_line:1, size:1 },
            now: { start_line:1, size:1 },
            deleted_lines: [ 'something' ],
            added_lines: [ 'something changed' ],
    my_assert_equal expected_diffs, actual_diffs
        { :type => :deleted, :line => 'something', :number => 1 },
        { :type => :added, :line => 'something changed', :number => 1 }
    my_assert_equal expected, actual
  include GitDiffJoin
