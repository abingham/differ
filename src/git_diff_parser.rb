require_relative 'line_splitter'

# Parses the output of 'git diff' command.
# Assumes the --unified=0 option has been used
# so there are no context lines.

class GitDiffParser

  def initialize(diff_text)
    @lines = LineSplitter.line_split(diff_text)
    @n = 0
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def parse_all
    all = []
    while /^diff --git/.match(line) do
      all << parse_one
    end
    all
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def parse_one
    old_filename,new_filename = parse_old_new_filenames(parse_header)
    {
      new_filename: new_filename,
      old_filename: old_filename,
             hunks: parse_hunks
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def parse_hunks
    hunks = []
    while hunk = parse_hunk
      hunks << hunk
    end
    hunks
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def parse_hunk
    if range = parse_range
      range[:deleted] = parse_lines(/^\-(.*)/)
      range[:added  ] = parse_lines(/^\+(.*)/)
      range
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def parse_range
    re = /^@@ -(\d+)(,\d+)? \+(\d+)(,\d+)? @@.*/
    if range = re.match(line)
      next_line
      { old_start_line:range[1].to_i,
        new_start_line:range[3].to_i
      }
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def parse_header
    line0 = line
    next_line
    lines = []
    while header?(line)
      lines << line
      next_line
    end
    [line0] + lines
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def parse_old_new_filenames(header)
    if %r|^\-\-\- (.*)|.match(line)
      next_line
    end
    if %r|^\+\+\+ (.*)|.match(line)
      next_line
    end
    old_filename,new_filename = old_new_filenames(header[0])
    if header[1].start_with?('deleted file mode')
      new_filename = nil
    end
    if header[1].start_with?('new file mode')
      old_filename = nil
    end
    [old_filename, new_filename]
  end

  private

  def header?(line)
    (!line.nil?) &&             # still more lines
    (line !~ /^diff --git/) &&  # not in next file
    (line !~ /^[-]/) &&         # not in --- filename
    (line !~ /^[+]/)            # not in +++ filename
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def old_new_filenames(first_line)
    return old_new_filename_match(:uf, :uf, first_line) ||
           old_new_filename_match(:uf, :qf, first_line) ||
           old_new_filename_match(:qf, :qf, first_line) ||
           old_new_filename_match(:qf, :uf, first_line)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  FILENAME_REGEXS = {
    :qf => '("(\\"|[^"])+")', # quoted-filename,   eg "b/emb ed\"ed.h"
    :uf => '([^ ]*)',         # unquoted-filename, eg a/plain
  }

  def old_new_filename_match(q1, q2, first_line)
    md = %r[^diff --git #{FILENAME_REGEXS[q1]} #{FILENAME_REGEXS[q2]}$].match(first_line)
    if md.nil?
      return nil
    end
    old_index = 1
    if q1 === :uf
      new_index = 2
    else
      new_index = 3
    end
    [ cleaned(md[old_index]), cleaned(md[new_index]) ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def cleaned(filename)
    if quoted?(filename)
      filename = unquoted(filename)
    end
    without_ab_prefix(unescaped(filename))
  end

  def quoted?(filename)
    filename[0].chr === '"'
  end

  def unquoted(filename)
    filename[1..-2]
  end

  def without_ab_prefix(filename)
    # Drop leading a/ or b/
    # Note: there is a [git diff] option --no-prefix which removes
    # the leading a/ b/ from the output. Using that option would
    # require removing a/ b/ from a lot of test code.
    filename[2..-1]
  end

  def unescaped(str)
    # Avoiding eval.
    # http://stackoverflow.com/questions/8639642/best-way-to-escape-and-unescape-strings-in-ruby
    unescapes = {
        "\\\\" => "\x5c",
        '"'    => "\x22",
        "'"    => "\x27"
    }
    str.gsub(/\\(?:([#{unescapes.keys.join}]))/) {
      $1 === '\\' ? '\\' : unescapes[$1]
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def parse_lines(re)
    lines = []
    while md = re.match(line)
      lines << md[1]
      next_line
    end
    parse_newline_at_eof
    lines
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def parse_newline_at_eof
    if /^\\ No newline at end of file/.match(line)
      next_line
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def line
    @lines[@n]
  end

  def next_line
    @n += 1
  end

end

#--------------------------------------------------------------
# Git diff format notes
#
# LINE: --- a/gapper.rb
#
#  The original file is preceded by ---
#  If this is a new file this is --- /dev/null
#
# LINE: +++ b/gapper.rb
#
#  The new file is preceded by +++
#  If this is a deleted file this is +++ /dev/null
#
# LINE: @@ -4,7 +4,8 @@ def time_gaps(from, to, seconds_per_gap)
#
#  Following this is a change hunk containing the line differences.
#  A hunk begins with range information. The range information
#  is surrounded by double-at signs.
#    So in this example its @@ -4,7 +15,8 @@
#  The hunk range information contains two hunk ranges.
#  @@ -4,7 +15,8 is for added lines (-4,7) and deleted lines (+5,8)
#
#  Each hunk range is of the format L,S where
#  L is the starting line number and
#  S is the number of lines the change hunk applies to.
#
#  For -deleted lines, L,S refers to the original file.
#  For   +added lines, L,S refers to the new file.
#
#  The ,S is optional and if missing indicates a hunk size of 1.
#  So -3 is the same as -3,1
#  And -1 is the same as -1,1
#  And -3 +5 is the same as -3,1 +5,1
#
#  If this is a     new file (--- /dev/null) the range is -0,0
#  If this is a deleted file (+++ /dev/null) the range is -0,0
#
# LINE:\ No newline at end of file
#
#  Following this, optionally, is a single line starting with a \ character
#  as above. I wondered if the format of this was that the initial \
#  means the line is a comment line and that there could be (are) other
#  comments, but googling does not indicate this.
#--------------------------------------------------------------
# https://www.gnu.org/software/diffutils/manual/html_node/Detailed-Unified.html#Detailed%20Unified
# https://stackoverflow.com/questions/2529441
# http://en.wikipedia.org/wiki/Diff
# http://www.chemie.fu-berlin.de/chemnet/use/info/diff/diff_3.html
