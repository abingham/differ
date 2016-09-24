
require_relative './lib_test_base'

class GitDiffJoinTest < LibTestBase

  def self.hex(suffix)
    '74C' + suffix
  end

  include GitDiffJoin

  test 'A5C',
  'empty file is deleted' do
    diff_lines =
    [
      'diff --git a/xx.rb b/xx.rb',
      'deleted file mode 100644',
      'index e69de29..0000000'
    ].join("\n")

    actual_diffs = GitDiffParser.new(diff_lines).parse_all
    expected_diffs =
    {
      'xx.rb' =>
      {
        :prefix_lines =>
        [
          'diff --git a/xx.rb b/xx.rb',
          'deleted file mode 100644',
          'index e69de29..0000000'
        ],
        :was_filename => 'xx.rb',
        :now_filename => nil,
        :chunks => []
      }
    }
    assert_equal expected_diffs, actual_diffs

    visible_files = {}
    expected_join = { 'xx.rb' => [] }

    actual_join = git_diff_join(diff_lines, visible_files)
    assert_equal expected_join, actual_join
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '0C6',
  'non-empty file is deleted' do
    diff_lines =
    [
      'diff --git a/non-empty.h b/non-empty.h',
      'deleted file mode 100644',
      'index a459bc2..0000000',
      '--- a/non-empty.h',
      '+++ /dev/null',
      '@@ -1 +0,0 @@',
      '-something',
      '\\ No newline at end of file'
    ].join("\n")

    actual_diffs = GitDiffParser.new(diff_lines).parse_all
    expected_diffs =
    {
      "non-empty.h"=>
      {
        :prefix_lines=>
        [
          "diff --git a/non-empty.h b/non-empty.h",
          "deleted file mode 100644",
          "index a459bc2..0000000"
        ],
        :was_filename => "non-empty.h",
        :now_filename => nil,
        :chunks =>
        [
          {
            :range =>
            {
              :was => { :start_line => 1, :size => 1 },
              :now => { :start_line => 0, :size => 0 }
            },
            :before_lines => [],
            :sections =>
            [
              {
                :deleted_lines => [ "something" ],
                :added_lines => [],
                :after_lines =>[]
              }
            ]
          }
        ]
      }
    }
    assert_equal expected_diffs, actual_diffs

    visible_files = {}
    expected_join = {
      'non-empty.h' =>
      [
        {
          :line => 'something',
          :type => :deleted,
          :number => 1
        }
      ]
    }

    actual_join = git_diff_join(diff_lines, visible_files)
    assert_equal expected_join, actual_join
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A2C',
  'empty file is created' do
    diff_lines =
    [
      'diff --git a/empty.h b/empty.h',
      'new file mode 100644',
      'index 0000000..e69de29'
    ].join("\n")

    actual_diffs = GitDiffParser.new(diff_lines).parse_all
    expected_diffs =
    {
      'empty.h' =>
      {
        :prefix_lines =>
        [
          'diff --git a/empty.h b/empty.h',
          'new file mode 100644',
          'index 0000000..e69de29'
        ],
        :was_filename => nil,
        :now_filename => 'empty.h',
        :chunks => []
      }
    }
    assert_equal expected_diffs, actual_diffs

    visible_files = {}
    expected_join = { 'empty.h' => [] }

    actual_join = git_diff_join(diff_lines, visible_files)
    assert_equal expected_join, actual_join
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'D09',
  'non-empty file is created' do
    diff_lines =
    [
      "diff --git a/non-empty.c b/non-empty.c",
      "new file mode 100644",
      "index 0000000..a459bc2",
      "--- /dev/null",
      "+++ b/non-empty.c",
      "@@ -0,0 +1 @@",
      "+something",
      "\\ No newline at end of file"
    ].join("\n")

    actual_diffs = GitDiffParser.new(diff_lines).parse_all
    expected_diffs =
    {
      "non-empty.c" =>
      {
        :prefix_lines =>
        [
          "diff --git a/non-empty.c b/non-empty.c",
          "new file mode 100644",
          "index 0000000..a459bc2"
        ],
        :was_filename => nil,
        :now_filename => "non-empty.c",
        :chunks =>
        [
          {
            :range =>
            {
              :was => { :start_line => 0, :size => 0 },
              :now => { :start_line => 1, :size => 1}
            },
            :before_lines => [],
            :sections =>
            [
              {
                :deleted_lines => [],
                :added_lines => [ "something" ],
                :after_lines => []
              }
            ]
          }
        ]
      }
    }

    assert_equal expected_diffs, actual_diffs

    expected_join =
    {
      'non-empty.c' =>
      [
        { :type => :added, :line => "something", :number => 1 }
      ]
    }
    visible_files = {}
    actual_join = git_diff_join(diff_lines, visible_files)
    assert_equal expected_join, actual_join
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'AA7',
  'non-empty file is copied' do
    diff_lines =
    [
      'diff --git a/plain b/copy',
      'similarity index 100%',
      'copy from plain',
      'copy to copy'
    ].join("\n")

    expected_diffs =
    {
      'copy' =>
      {
        :prefix_lines =>
        [
          'diff --git a/plain b/copy',
          'similarity index 100%',
          'copy from plain',
          'copy to copy'
        ],
        :was_filename => 'plain',
        :now_filename => 'copy',
        :chunks => []
      }
    }
    actual_diffs = GitDiffParser.new(diff_lines).parse_all
    assert_equal expected_diffs, actual_diffs

    expected_join =
    {
      'copy' => []
    }
    visible_files = {}
    actual_join = git_diff_join(diff_lines, visible_files)
    assert_equal expected_join, actual_join
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '4D0',
  'existing file is changed' do
    diff_lines =
    [
      "diff --git a/non-empty.c b/non-empty.c",
      "index a459bc2..605f7ff 100644",
      "--- a/non-empty.c",
      "+++ b/non-empty.c",
      "@@ -1 +1 @@",
      "-something",
      "\\ No newline at end of file",
      "+something changed",
      "\\ No newline at end of file",
    ].join("\n")

    actual_diffs = GitDiffParser.new(diff_lines).parse_all
    expected_diffs =
    {
      "non-empty.c" =>
      {
        :prefix_lines =>
        [
          "diff --git a/non-empty.c b/non-empty.c",
          "index a459bc2..605f7ff 100644"
        ],
        :was_filename => "non-empty.c",
        :now_filename => "non-empty.c",
        :chunks =>
        [
          {
            :range =>
            {
              :was => { :start_line => 1, :size => 1 },
              :now => { :start_line => 1, :size => 1 }
            },
            :before_lines => [],
            :sections =>
            [
              {
                :deleted_lines => [ "something" ],
                :added_lines => [ "something changed"],
                :after_lines => []
              }
            ]
          }
        ]
      }
    }
    assert_equal expected_diffs, actual_diffs

    visible_files = {}
    expected_join =
    {
      'non-empty.c' =>
      [
        { :type => :section, :index => 0 },
        { :type => :deleted, :line => "something", :number => 1 },
        { :type => :added, :line => "something changed", :number => 1 }
      ]
    }

    actual_join = git_diff_join(diff_lines, visible_files)
    assert_equal expected_join, actual_join
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '35C',
  'unchanged file' do
    diff_lines = [].join("\n")
    actual_diffs = GitDiffParser.new(diff_lines).parse_all
    expected_diffs =
    {
    }
    assert_equal expected_diffs, actual_diffs
    visible_files = { 'wibble.txt' => 'content' }
    expected_join =
    {
      'wibble.txt' =>
      [
        { :type => :same, :line => 'content', :number => 1}
      ]
    }
    actual_join = git_diff_join(diff_lines, visible_files)
    assert_equal expected_join, actual_join
  end

end