    now_files = { }
    @old_files = { }
    @new_files = { }
    @old_files = { 'hiker.h' => '' }
    @new_files = { }
    @old_files = { 'sub-dir/hiker.h' => '' }
    @new_files = { }
    @old_files = { 'd1/d2/d3/d4/hiker.h' => '' }
    @new_files = { }
    @old_files = { 'hiker.h' => "a\nb\nc\nd\n" }
    @new_files = { }
    @old_files = { 'dir/hiker.h' => "a\nb\nc\nd\n" }
    @new_files = { }
    @old_files = { '1/2/3/4/hiker.h' => "a\nb\nc\nd\n" }
    @new_files = { }
    @old_files = { 'hiker.h' => "a\nb\nc\nd\n" }
    @new_files = { 'hiker.h' => '' }
    @old_files = { '3/2/1/hiker.h' => "a\nb\nc\nd\n" }
    @new_files = { '3/2/1/hiker.h' => '' }
    @old_files = { '1/hiker.h' => "a\nb\nc\nd\n" }
    @new_files = { '1/hiker.h' => '' }
    @old_files = { }
    @new_files = { 'diamond.h' => '' }
    @old_files = { }
    @new_files = { 'sub-dir/diamond.h' => '' }
    @old_files = { }
    @new_files = { '1/2/3/4/diamond.h' => '' }
    @old_files = { }
    @new_files = { 'diamond.h' => "a\nb\nc\nd" }
    @old_files = { }
    @new_files = { '4/diamond.h' => "a\nb\nc\nd" }
    @old_files = { }
    @new_files = { '1/2/3/4/diamond.h' => "a\nb\nc\nd" }
    @old_files = { 'diamond.h' => '' }
    @new_files = { 'diamond.h' => '' }
    @old_files = { 'x/diamond.h' => '' }
    @new_files = { 'x/diamond.h' => '' }
    @old_files = { 'x/y/z/diamond.h' => '' }
    @new_files = { 'x/y/z/diamond.h' => '' }
    @old_files = { 'diamond.h' => "a\nb\nc\nd" }
    @new_files = { 'diamond.h' => "a\nb\nc\nd" }
    @old_files = { 'd/diamond.h' => "a\nb\nc\nd" }
    @new_files = { 'd/diamond.h' => "a\nb\nc\nd" }
    @old_files = { 'w/e/r/diamond.h' => "a\nb\nc\nd" }
    @new_files = { 'w/e/r/diamond.h' => "a\nb\nc\nd" }
    @old_files = { 'diamond.h' => 'a' }
    @new_files = { 'diamond.h' => 'b' }
    @old_files = { 'x/diamond.h' => 'a' }
    @new_files = { 'x/diamond.h' => 'b' }
    @old_files = {
    @new_files = {
      '@@ -4 +4 @@',
      '@@ -6 +6 @@',
    @old_files = {
    @new_files = {
      '@@ -4 +4 @@',
      '@@ -6 +6 @@',
    @old_files = { 'hiker.h'   => "a\nb\nc\nd" }
    @new_files = { 'diamond.h' => "a\nb\nc\nd" }
  # - - - - - - - - - - - - - - - - - - - -

    @old_files = { 'hiker.h'   => "a\nb\nc\nd" }
    @new_files = { 'x/diamond.h' => "a\nb\nc\nd" }
  # - - - - - - - - - - - - - - - - - - - -

    @old_files = { 'hiker.h'   => "a\nb\nc\nd" }
    @new_files = { 'x/y/z/diamond.h' => "a\nb\nc\nd" }
  # - - - - - - - - - - - - - - - - - - - -

    @old_files = { '1/2/3/hiker.h'   => "a\nb\nc\nd" }
    @new_files = { 'x/y/z/diamond.h' => "a\nb\nc\nd" }
    @old_files = { 'hiker.h'   => "a\nb\nc\nd" }
    @new_files = { 'diamond.h' => "a\nb\nX\nd" }
      '@@ -3 +3 @@ b',
  # - - - - - - - - - - - - - - - - - - - -

    @old_files = { '1/2/hiker.h'   => "a\nb\nc\nd" }
    @new_files = { 'x/y/diamond.h' => "a\nb\nX\nd" }
      '@@ -3 +3 @@ b',
    @old_files = {
    @new_files = {
      '@@ -2,0 +3 @@ xyz',
    lines += [ '' ] unless lines === []
    actual = GitDiffer.new(self).diff(@old_files, @new_files)
    my_assert_equal expected, actual