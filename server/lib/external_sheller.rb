
require_relative './external_parent_chainer'
require_relative './string_cleaner'

class ExternalSheller

  def initialize(parent)
    @parent = parent
  end

  attr_reader :parent

  # modifiers

  def cd_exec(path, *commands)
    output, exit_status = exec(["[[ -d #{path} ]]", "cd #{path}"] + commands)
    [output, exit_status]
  end

  def exec(*commands)
    command = commands.join(' && ')
    log << ''
    log << ''
    log << ''
    log << "#{'-'*40}"
    log << "shell.exec:COMMAND: #{command}"
    output = `#{command}`
    exit_status = $?.exitstatus
    log << "shell.exec:NO-OUTPUT:" if output == ''
    log << "shell.exec:OUTPUT:#{output}" if output != ''
    log << "shell.exec:EXITED:#{exit_status}"
    [cleaned(output), exit_status]
  end

  private

  include ExternalParentChainer
  include StringCleaner

end
