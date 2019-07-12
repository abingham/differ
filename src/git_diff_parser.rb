# Parses the output of 'git diff' command.
class GitDiffParser
      parse_section(range)
  def parse_section(range)
    range[:deleted_lines] = parse_lines(/^\-(.*)/)
    range[:added_lines] = parse_lines(/^\+(.*)/)
    parse_newline_at_eof
    range
#    So in this example its @@ -4,7 +15,8 @@
#  The chunk range information contains at most two chunk ranges.
#  @@ -4,7 +15,8 is for added lines (-4,7) and deleted lines (+5,8)
#  @@ -4,7 @@ is for deleted lines only.
#  @@ +15,8 @@ is for added lines only.
#
#  For -deleted lines, L,S refers to the original file.
#  For   +added lines, L,S refers to the new file.
#  The ,S is optional and if missing indicates a chunk size of 1.
#  So -3 is the same as -3,1
#  And -1 is the same as -1,1
#  And -3 +5 is the same as -3,1 +5,1
#  If this is a     new file (--- /dev/null) the range is -0,0
#  If this is a deleted file (+++ /dev/null) the range is -0,0