      'diff --git file with_space file with_space',
      '+++ file with_space',
      'diff --git untitled_5G3 untitled_5G3',
      '--- untitled_5G3',
      '+++ untitled_5G3',
  test '555',
  'non-empty file created' do
    @diff_lines =
    [
      'diff --git non-empty.created non-empty.created',
      'new file mode 100644',
      'index 0000000..a459bc2',
      '--- /dev/null',
      '+++ non-empty.created',
      '@@ -0,0 +1 @@',
      '+something',
      '\\ No newline at end of file',
    ]
    @source_lines =
    [
      'something'
    ]
    @expected =
    [
      section(0),
      added('something', 1),
    ]
    assert_equal_builder
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

      'diff --git lines lines',
      '--- lines',
      '+++ lines',
      'diff --git lines lines',
      '--- lines',
      '+++ lines',
      'diff --git lines lines',
      '--- lines',
      '+++ lines',
      'diff --git lines lines',
      '--- lines',
      '+++ lines',
      'diff --git lines lines',
      '--- lines',
      '+++ lines',
      'diff --git lines lines',
      '--- lines',
      '+++ lines',
      'diff --git lines lines',
      '--- lines',
      '+++ lines',