      name = one[:now_filename] || one[:was_filename]
  # - - - - - - - - - - - - - - - - - - -

  # - - - - - - - - - - - - - - - - - - -

  # - - - - - - - - - - - - - - - - - - -

      {        range: range,
        before_lines: parse_common_lines,
            sections: parse_sections
      }
  # - - - - - - - - - - - - - - - - - - -

  # - - - - - - - - - - - - - - - - - - -

  # - - - - - - - - - - - - - - - - - - -

          added_lines: added_lines,
          after_lines: after_lines
  # - - - - - - - - - - - - - - - - - - -

  def parse_prefix_lines
    parse_lines(%r|^([^-+].*)|) # don't start with - or +
  end

    parse_lines(/^\-(.*)/) # start with a -
    parse_lines(/^\+(.*)/) # start with a +
    parse_lines(%r|^ (.*)|) # start with a space
  def parse_lines(re)
    lines = []
    while md = re.match(@lines[@n])
      lines << md[1]
      @n += 1
    end
    lines
    @n += 1 if %r|^\-\-\- (.*)|.match(@lines[@n])
    @n += 1 if %r|^\+\+\+ (.*)|.match(@lines[@n])
    was, now = get_was_now_filenames(prefix[0])
    now = nil if prefix[1] == 'deleted file mode 100644'
    was = nil if prefix[1] == 'new file mode 100644'
    [was, now]
  def get_was_now_filenames(line)
    # eg 'diff --git "a/em pty.h" "b/empty.h"'
    if md = /^diff --git (\".*?\") (\".*?\")/.match(line)
      return [ unescaped(md[1]), unescaped(md[2]) ]
    # eg 'diff --git a/empty.h b/empty.h'
    md = /^diff --git ([^ ]*) ([^ ]*)/.match(line)
    return [ unescaped(md[1]), unescaped(md[2]) ]
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -