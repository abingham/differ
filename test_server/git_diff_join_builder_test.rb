  'hunk with a space in its filename' do
      added('Please rename me!', 1),
  'hunk with defaulted now line info' do
      added('aaa', 1),
    'two hunks with leading and trailing',
      '@@ -2,1 +2,1 @@',
      '@@ -11,1 +11,1 @@',
      'bbb',
      'qqq',
      same('aaa', 1),
      deleted('bbb', 2),
      added('ccc', 2),
      same('ddd',  3),
      same('eee',  4),
      same('fff',  5),
      same('ggg',  6),
      same('hhh',  7),
      same('nnn',  8),
      same('ooo',  9),
      same('ppp', 10),
      deleted('qqq', 11),
      added('rrr', 11),
      same('sss', 12),
      same('ttt', 13)
  test '1C8', %w(
  two hunks,
  one with deleted only lines from top
  one with added only lines at the end ) do
      '@@ -1,2 +0,0 @@',
      '-bbb',
      '@@ -10,0 +9,2 @@',
      '+uuu',
      '+vvv'
      'aaa',
      'ttt',
      deleted('aaa', 1),
      deleted('bbb', 2),
      same('ccc', 1),
      same('ddd', 2),
      same('eee', 3),
      same('fff', 4),
      same('ppp', 5),
      same('qqq', 6),
      same('rrr', 7),
      same('ttt', 8),
      added('uuu', 9),
      added('vvv', 10)
    'one hunk with two sections',
      same('aaa', 1),
      same('bbb', 2),
      deleted('ccc', 3),
      added('ddd', 3),
      same('eee', 4),
      deleted('fff', 5),
      added('ggg', 5),
      same('hhh', 6),
      same('iii', 7),
      same('jjj', 8)
  'one hunk with one section with only lines added' do
      '@@ -3,0 +4,3 @@',
      same('aaa', 1),
      same('bbb', 2),
      same('ccc', 3),
      added('ddd', 4),
      added('eee', 5),
      added('fff', 6),
      same('ggg', 7),
      same('hhh', 8),
      same('iii', 9),
      same('jjj', 10)
  'one hunk with one section with only lines deleted' do
      'EEE',
      'FFF',
      same('aaa', 1),
      same('bbb', 2),
      same('ccc', 3),
      same('ddd', 4),
      deleted('EEE', 5),
      deleted('FFF', 6),
      same('ggg', 5),
      same('hhh', 6),
      same('iii', 7),
      same('jjj', 8)
    'one hunk with one section',
      'index 71af3cd..0a682ee 100644',
      '@@ -6,3 +6 @@',
      'ggg',
      'hhh',
      'iii',
      same('bbb', 1),
      same('ccc', 2),
      same('ddd', 3),
      same('eee', 4),
      same('fff', 5),
      deleted('ggg', 6),
      deleted('hhh', 7),
      deleted('iii', 8),
      added('jjj', 6),
      same('kkk', 7),
      same('lll', 8),
      same('mmm', 9),
      same('nnn', 10)
    'one hunk with one section',
      'index cbe236c..e32c1da 100644',
      '@@ -3 +3,3 @@ bbb',
      '-ccc',
      '+ZZZ'
      same('aaa', 1),
      same('bbb', 2),
      deleted('ccc', 3),
      added('XXX', 3),
      added('YYY', 4),
      added('ZZZ', 5),
      same('ddd', 6),
      same('eee', 7),
      same('fff', 8),
  #- - - - - - - - - - - - - - - - - - - - - - -
    my_assert_equal @expected, actual
  def section(index)
    { :type => :section, index:index }
  def same(line, number)
    src(:same, line, number)
  def deleted(line, number)
    src(:deleted, line, number)
  def added(line, number)
    src(:added, line, number)
  def src(type, line, number)
    { type:type, line:line, number:number }