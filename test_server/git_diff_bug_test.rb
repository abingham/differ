  # - - - - - - - - - - - - - - - - - - - - - -

  'specific real dojo that once failed a diff' do
    expected =
      {
          old_filename: 'recently_used_list.cpp',
          new_filename: 'was_recently_used_list.test.cpp',
          chunks: []
      }
    ]
    assert_equal expected, diff