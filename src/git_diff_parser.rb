    was_filename,now_filename = parse_was_now_filenames(prefix_lines)
      next_line
    size ? size.to_i : 1
    next_line
      next_line
    next_line if %r|^\-\-\- (.*)|.match(line)
    next_line if %r|^\+\+\+ (.*)|.match(line)
    was,now = get_was_now_filenames(prefix[0])
    now = nil if prefix[1].start_with?('deleted file mode')
    was = nil if prefix[1].start_with?('new file mode')
    next_line if /^\\ No newline at end of file/.match(line)
      next_line
  def next_line
    @n += 1
  end
