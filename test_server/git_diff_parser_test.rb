require 'json'
require 'tempfile'
    my_assert_equal lines, GitDiffParser.new(lines.join("\n")).lines
    my_assert_equal 'e mpty.h', was_filename, 'was_filename'
    my_assert_equal 'e mpty.h', now_filename, 'now_filename'
    my_assert_equal "li n\"ux", was_filename, 'was_filename'
    my_assert_equal "em bed\"ded", now_filename, 'now_filename'
    my_assert_equal 'plain', was_filename, 'was_filename'
    my_assert_equal "em bed\"ded", now_filename, 'now_filename'
    my_assert_equal "emb ed\"ded", was_filename, 'was_filename'
    my_assert_equal 'plain', now_filename, 'now_filename'
    my_assert_equal 'Deleted.java', was_filename, 'was_filename'
    my_assert_equal 'empty.h', now_filename, 'now_filename'
    my_assert_equal 'old_name.h', was_filename, 'was_filename'
    my_assert_equal "new \"name.h", now_filename, 'now_filename'
    my_assert_equal '1/2/3/empty.h', now_filename, 'now_filename'
    my_assert_equal '1/2/3/old_name.h', was_filename, 'was_filename'
    my_assert_equal '1/2/3/new_name.h', now_filename, 'now_filename'
    my_assert_equal '1/2/3/old_name.h', was_filename, 'was_filename'
    my_assert_equal '4/5/6/new_name.h', now_filename, 'now_filename'
    my_assert_equal "s/d/f/li n\"ux", was_filename, 'was_filename'
    my_assert_equal "u/i/o/em bed\"ded", now_filename, 'now_filename'
    my_assert_equal "a/d/f/li n\"ux", was_filename, 'was_filename'
    my_assert_equal "b/u/i/o/em bed\"ded", now_filename, 'now_filename'
        was_filename: '\\was_newfile_FIU', # <-- single backslash
        now_filename: nil,
        chunks:
            now: { start_line:0, size:0 },
            was: { start_line:1, size:1 },
            deleted_lines: [ 'Please rename me!' ],
            added_lines: []
    my_assert_equal expected, actual
        was_filename: 'original',
        now_filename: nil,
        chunks: []
    my_assert_equal expected, actual
        was_filename: 'untitled.rb',
        now_filename: nil,
        chunks:
            was: { start_line:1, size:3 },
            now: { start_line:0, size:0 },
            deleted_lines: [ 'def answer', '  42', 'end'],
            added_lines: []
    my_assert_equal expected, actual
        was_filename: 'was_\\wa s_newfile_FIU', # <-- single backslash
        now_filename: '\\was_newfile_FIU',      # <-- single backslash
        chunks: []
    my_assert_equal expected, actual
        was_filename: 'oldname',
        now_filename: 'newname',
        chunks: []
    my_assert_equal expected, actual
      '@@ -6,1 +6,1 @@ For example, the potential anagrams of "biro" are',
      was_filename: 'instructions',
      now_filename: 'instructions_new',
      chunks:
      [
        {
          was: { start_line:6, size:1 },
          now: { start_line:6, size:1 },
          deleted_lines: [ 'obir obri oibr oirb orbi orib' ],
          added_lines: [ 'obir obri oibr oirb orbi oribx' ]
        }
      ]
    my_assert_equal expected, actual
      '@@ -1,1 +1,1 @@',
      '@@ -14,2 +14,2 @@',
      was_filename: 'lines',
      now_filename: 'lines',
      chunks:
      [
        {
          was: { start_line:1, size:1 },
          now: { start_line:1, size:1 },
          deleted_lines: [ 'ddd' ],
          added_lines: [ 'eee' ]
        }
      ]
    }
      was_filename: 'other',
      now_filename: 'other',
      chunks:
      [
        {
          was: { start_line:14, size:2 },
          now: { start_line:14, size:2 },
          deleted_lines: [ 'CCC', 'DDD' ],
          added_lines: [ 'EEE', 'FFF' ]
        }
      ]
    }
    my_assert_equal expected, parser.parse_all
      was: { start_line:3, size:1 },
      now: { start_line:5, size:1 },
    my_assert_equal expected, GitDiffParser.new(lines).parse_range
      was: { start_line:3, size:1 },
      now: { start_line:5, size:9 },
    my_assert_equal expected, GitDiffParser.new(lines).parse_range
      was: { start_line:3, size:4 },
      now: { start_line:5, size:1 },
    my_assert_equal expected, GitDiffParser.new(lines).parse_range
      was: { start_line:3, size:4 },
      now: { start_line:5, size:6 },
    my_assert_equal expected, GitDiffParser.new(lines).parse_range
    my_assert_equal 0, parser.n
    my_assert_equal 1, parser.n
      '@@ -3,1 +3,1 @@',
      '@@ -8,1 +8,1 @@',
      was_filename: 'lines',
      now_filename: 'lines',
      chunks:
      [
        {
          was: { start_line:3, size:1 },
          now: { start_line:3, size:1 },
          deleted_lines: [ 'BBB' ],
          added_lines: [ 'CCC' ]
        },
        {
          was: { start_line:8, size:1 },
          now: { start_line:8, size:1 },
          deleted_lines: [ 'SSS' ],
          added_lines: [ 'TTT' ]
        }
      ]
    }

    my_assert_equal expected, GitDiffParser.new(lines).parse_one
  'diff one-chunk one-line' do
      '@@ -4,1 +4,1 @@',
      '+BBB'
      was: { start_line:4, size:1 },
      now: { start_line:4, size:1 },
      deleted_lines: [ 'AAA' ],
      added_lines: [ 'BBB' ]
    }

    my_assert_equal expected, GitDiffParser.new(lines).parse_chunk_one
  'diff one-chunk two-lines' do
      '@@ -17,2 +17,2 @@',
      '-DDD',
      '+EEE',
      '+FFF'
          was: { start_line:17, size:2 },
          now: { start_line:17, size:2 },
          deleted_lines: [ 'CCC','DDD' ],
          added_lines: [ 'EEE','FFF' ]
        }
      ]
    my_assert_equal expected, GitDiffParser.new(lines).parse_chunk_all
      '@@ -4,1 +4,2 @@ COMMENT',
      '+ZZZ'
      was_filename: 'gapper.rb',
      now_filename: 'gapper.rb',
      chunks:
          was: { start_line:4, size:1 },
          now: { start_line:4, size:2 },
          deleted_lines: [ 'XXX' ],
          added_lines: [ 'YYY', 'ZZZ' ]
    my_assert_equal expected, GitDiffParser.new(lines).parse_one
    my_assert_equal lines, GitDiffParser.new(all_lines).parse_prefix_lines
      '@@ -9,1 +9,1 @@ class TestGapper < Test::Unit::TestCase',
      '@@ -19,1 +19,1 @@ class TestGapper < Test::Unit::TestCase',
      was_filename: 'test_gapper.rb',
      now_filename: 'test_gapper.rb',
      chunks:
      [
        {
          was: { start_line:9, size:1 },
          now: { start_line:9, size:1 },
          deleted_lines: [ 'p Timw.now' ],
          added_lines: [ 'p Time.now' ]
        },
        {
          was: { start_line:19, size:1 },
          now: { start_line:19, size:1 },
          deleted_lines: [ 'q Timw.now' ],
          added_lines: [ 'q Time.now' ]
        }
      ]
    my_assert_equal expected, GitDiffParser.new(lines).parse_one
      '@@ -5,1 +5,1 @@ CCC',
      '@@ -9,1 +9,1 @@ FFF',
      '+HHH'
      was_filename: 'lines',
      now_filename: 'lines',
      chunks:
      [
        {
          was: { start_line:5, size:1 },
          now: { start_line:5, size:1 },
          deleted_lines: [ 'DDD' ],
          added_lines: [ 'EEE' ]
        },
        {
          was: { start_line:9, size:1 },
          now: { start_line:9, size:1 },
          deleted_lines: [ 'GGG' ],
          added_lines: [ 'HHH' ]
        }
      ]
    }
    my_assert_equal expected, GitDiffParser.new(lines).parse_one
      '@@ -5,1 +5,1 @@',
      '@@ -7,1 +7,1 @@',
      '+JJJ'
      was_filename: 'lines',
      now_filename: 'lines',
      chunks:
      [
        {
          was: { start_line:5, size:1 },
          now: { start_line:5, size:1 },
          deleted_lines: [ 'DDD' ],
          added_lines: [ 'EEE' ]
        },
        {
          was: { start_line:7, size:1 },
          now: { start_line:7, size:1 },
          deleted_lines: [ 'HHH' ],
          added_lines: [ 'JJJ' ]
        }
      ]
    }
    my_assert_equal expected, GitDiffParser.new(lines).parse_one
      '@@ -5,1 +5,1 @@',
      '@@ -13,1 +13,1 @@',
      '+UUU'
       was_filename: 'lines',
       now_filename: 'lines',
       chunks:
       [
         {
           was: { start_line:5, size:1 },
           now: { start_line:5, size:1 },
           deleted_lines: [ 'DDD' ],
           added_lines: [ 'EEE' ]
         },
         {
           was: { start_line:13, size:1 },
           now: { start_line:13, size:1 },
           deleted_lines: [ 'TTT' ],
           added_lines: [ 'UUU' ]
        }
      ]
    }
    my_assert_equal expected, GitDiffParser.new(lines).parse_one
=begin
      was_filename: 'sandbox/CircularBufferTest.cpp',
      now_filename: 'sandbox/CircularBufferTest.cpp',
      chunks:
      [
        {
          was: { start_line:35, size:3 },
          now: { start_line:35, size:8 },
          deleted_lines: [],
          added_lines:
            '',
            'TEST(CircularBuffer, NotFullAfterCreation)',
            '{',
            '    CHECK_FALSE(CircularBuffer_IsFull(buffer));',
            '}'
          ]
        }
      ]
    }
    my_assert_equal expected, GitDiffParser.new(lines).parse_one
=end
      '+abc',
      was_filename: "hiker.h",
      now_filename: "hiker.txt",
      chunks: []
       was_filename: 'wibble.c',
       now_filename: 'wibble.c',
       chunks:
       [
         {
           was: { start_line:1, size:2 },
           now: { start_line:1, size:3 },
           deleted_lines: [],
           added_lines: ['abc']
         }
       ]
    my_assert_equal expected_diffs, actual_diffs