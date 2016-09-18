
require_relative './git_diff_parser'
require_relative './git_diff_builder'

module GitDiff # mix-in

  module_function

  # Creates data structure containing diffs for all files.

  def git_diff(diff_lines, visible_files)
    view = {}
    diffs = GitDiffParser.new(diff_lines).parse_all
    diffs.each do |path, diff|
      md = %r{^(.)/(.*)}.match(path)
      filename = md[2]

      if new_file?(diff)
        file_content = empty_file?(diff) ? [] : diff[:chunks][0][:sections][0][:added_lines]
        view[filename] = newify(file_content)
      elsif deleted_file?(diff)
        file_content = empty_file?(diff) ? [] : diff[:chunks][0][:sections][0][:deleted_lines]
        view[filename] = deleteify(file_content)
      else
        file_content = visible_files[filename]
        view[filename] = GitDiffBuilder.new.build(diff, LineSplitter.line_split(file_content))
      end
      visible_files.delete(filename)
    end
    # other files have not changed...
    visible_files.each do |filename, content|
      view[filename] = sameify(content)
    end
    view
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def empty_file?(diff)
    diff[:chunks] == []
  end

  def new_file?(diff)
    diff[:was_filename] == '/dev/null'
  end

  def deleted_file?(diff)
    diff[:now_filename] == '/dev/null'
  end

  def sameify(source)
    ify(LineSplitter.line_split(source), :same)
  end

  def newify(lines)
    ify(lines, :added)
  end

  def deleteify(lines)
    ify(lines, :deleted)
  end

  def ify(lines, type)
    lines.collect.each_with_index do |line, number|
      { line: line, type: type, number: number + 1 }
    end
  end

end
