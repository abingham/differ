# Combines diff and lines to build a data structure that
# containes a complete diff-view of a joined back up file;
#    the lines that were deleted
#    the lines that were added
#    the lines that were unchanged
#
# diff: created from GitDiffParser. The diff between two tags (run-tests) of a file.
# lines: an array containing the current content of the diffed file.

module GitDiffJoinBuilder # mix-in

  module_function

  def git_diff_join_builder(diff, lines)
    join = []
    line_number = 1
    from = 0
    index = 0
    diff[:chunks].each do |chunk|
      to = chunk[:range][:now][:start_line] #+ chunk[:before_lines].length - 1
      line_number = fill(join, :same, lines, from, to, line_number)
      chunk[:sections].each do |section|
        join << { :type => :section, :index => index }
        index += 1
                      fill_all(join, :deleted, section[:deleted_lines], line_number)
        line_number = fill_all(join, :added,   section[:added_lines  ], line_number)
        #line_number = fill_all(join, :same,    section[:after_lines  ], line_number)
      end
      from = line_number - 1
    end
    last_lines = lines[line_number-1..lines.length]
    fill_all(join, :same, last_lines, line_number)
    join
  end

  private

  def fill_all(join, type, lines, line_number)
    lines ||= []
    fill(join, type, lines, 0, lines.length, line_number)
  end

  def fill(join, type, lines, from, to, line_number)
    (from...to).each do |n|
      join << { type: type, line: lines[n], number: line_number }
      line_number += 1
    end
    line_number
  end

end
