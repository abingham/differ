
# Uses a hex-id on each test to selectively run specific tests.
# A good way to generate unique hex-ids is uuidgen.
# Write your test methods as follows:
#
#    class SomeTest < MiniTest::Test
#
#      include TestHexIdHelpers
#
#      test '0C1F2F',
#      'some long description',
#      'possibly spanning',
#      'several lines' do
#        ...
#        ...
#        ...
#      end
#
#    end

module TestHexIdHelpers # mix-in

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    @@args = (ARGV.sort.uniq - ['--']).map(&:upcase)  # eg 2DD6F3 eg 2dd
    @@seen_ids = []

    def test(id, *lines, &block)
      # check hex-id is well-formed
      diagnostic = "'#{id}',#{lines.join}"
      hex_chars = '0123456789ABCDEF'
      is_hex_id = id.chars.all? { |ch| hex_chars.include? ch }
      has_empty_line = lines.any? { |line| line.strip == '' }
      has_space_line = lines.any? { |line| line.strip != line }
      raise  "no hex-ID: #{diagnostic}" if id == ''
      raise "bad hex-ID: #{diagnostic}" unless is_hex_id
      raise "empty line: #{diagnostic}" if has_empty_line
      raise "space line: #{diagnostic}" if has_space_line
      # if no hex-id supplied, or test method matches any supplied hex-id
      # then define a mini_test method using the hex-id
      no_args = @@args == []
      any_arg_is_part_of_id = @@args.any?{ |arg| id.include?(arg) }
      if no_args || any_arg_is_part_of_id
        raise "duplicate hex_ID: #{diagnostic}" if @@seen_ids.include?(id)
        @@seen_ids << id
        name = lines.join(' ')
        # make test_id attribute available inside defined method
        block_with_test_id = lambda {
          self.instance_eval { class << self; self end }.send(:attr_accessor, 'test_id')
          self.test_id = id
          self.instance_eval &block
        }
        define_method("test_'#{id}',\n #{name}\n".to_sym, &block_with_test_id)
      end
    end

    # complain about any unfound hex-id args
    ObjectSpace.define_finalizer(self, proc {
      unseen_arg = lambda { |arg| @@seen_ids.none? { |id| id.include?(arg) } }
      unseen_args = @@args.find_all { |arg| unseen_arg.call(arg) }
      if unseen_args != []
        message = 'the following test id arguments were *not* found'
        bar = 'X' * message.length
        lines = [ '', bar, message, "#{unseen_args}", bar, '' ]
        # can't raise in a finalizer
        lines.each { |line| STDERR.puts line }
      end
    })

  end

end
