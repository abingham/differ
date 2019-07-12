    all = []
      all << parse_one
    old_filename,new_filename = parse_old_new_filenames(parse_prefix_lines)
      new_filename: new_filename,
      old_filename: old_filename,
            chunks: parse_chunks
  def parse_chunks
    while chunk = parse_chunk
  def parse_chunk
      range[:deleted] = parse_lines(/^\-(.*)/)
      range[:added  ] = parse_lines(/^\+(.*)/)
      range
    re = /^@@ -(\d+)(,\d+)? \+(\d+)(,\d+)? @@.*/
      { old_start_line:range[1].to_i, new_start_line:range[3].to_i }
  def parse_old_new_filenames(prefix)
    old_filename,new_filename = old_new_filenames(prefix[0])
    new_filename = nil if prefix[1].start_with?('deleted file mode')
    old_filename = nil if prefix[1].start_with?('new file mode')
    [old_filename, new_filename]
  def old_new_filenames(first_line)
    return old_new_filename_match(:uf, :uf, first_line) ||
           old_new_filename_match(:uf, :qf, first_line) ||
           old_new_filename_match(:qf, :qf, first_line) ||
           old_new_filename_match(:qf, :uf, first_line)
  FILENAME_REGEXS = {
    :qf => '("(\\"|[^"])+")', # quoted-filename,   eg "b/emb ed\"ed.h"
    :uf => '([^ ]*)',         # unquoted-filename, eg a/plain
  }

  def old_new_filename_match(q1, q2, first_line)
    md = %r[^diff --git #{FILENAME_REGEXS[q1]} #{FILENAME_REGEXS[q2]}$].match(first_line)
    old_index = 1
    new_index = (q1 === :uf) ? 2 : 3
    [ unescaped(md[old_index]), unescaped(md[new_index]) ]
    parse_newline_at_eof
  def parse_newline_at_eof
    next_line if /^\\ No newline at end of file/.match(line)
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def next_line
    @n += 1
  end
