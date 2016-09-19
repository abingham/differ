    while /^diff --git/.match(line) do
    if range = re.match(line)
    while /^[\+\- ]/.match(line)
    while md = re.match(line)
    @n += 1 if %r|^\-\-\- (.*)|.match(line)
    @n += 1 if %r|^\+\+\+ (.*)|.match(line)
  def get_was_now_filenames(first_line)
    return was_now_match(:uf, :uf, first_line, 1, 2) ||
           was_now_match(:uf, :qf, first_line, 1, 2) ||
           was_now_match(:qf, :qf, first_line, 1, 3) ||
           was_now_match(:qf, :uf, first_line, 1, 3)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def was_now_match(was, now, first_line, was_index, now_index)
    filename = {
      :qf => '("(\\"|[^"])+")', # quoted,   eg "b/emb ed\"ed.h"
      :uf => '([^ ]*)',         # unquoted, eg a/plain
    }
    md = %r[^diff --git #{filename[was]} #{filename[now]}$].match(first_line)
    return nil if md.nil?
    return [ unescaped(md[was_index]), unescaped(md[now_index]) ]
    # filename[1..-2] to lose the opening and closing "
    # then unescape without using eval
    filename = unescape(filename[1..-2]) if filename[0].chr == '"'
    # drop leading a/ or b/
    filename[2..-1]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def unescape(str)
    # http://stackoverflow.com/questions/8639642/best-way-to-escape-and-unescape-strings-in-ruby
    unescapes = {
        "\\\\" => "\x5c",
        '"'    => "\x22",
        "'"    => "\x27"
    }
    str.gsub(/\\(?:([#{unescapes.keys.join}]))/) {
      $1 == '\\' ? '\\' : unescapes[$1]
    }
    @n += 1 if /^\\ No newline at end of file/.match(line)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def line
    @lines[@n]