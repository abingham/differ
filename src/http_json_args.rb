# frozen_string_literal: true

require_relative 'base58'
require_relative 'http_json/request_error'
require 'json'

# Checks for arguments synactic correctness
class HttpJsonArgs

  def initialize(body)
    @args = json_parse(body)
    unless @args.is_a?(Hash)
      raise request_error('body is not JSON Hash')
    end
  rescue JSON::ParserError
    raise request_error('body is not JSON')
  end

  # - - - - - - - - - - - - - - - -

  def get(path)
    case path
    when '/sha'   then ['sha',[]]
    when '/alive' then ['alive?',[]]
    when '/ready' then ['ready?',[]]
    when '/diff'  then ['diff',[id, old_files, new_files]]
    else
      raise request_error('unknown path')
    end
  end

  private

  def json_parse(body)
    if body === ''
      {}
    else
      JSON.parse(body)
    end
  end

  # - - - - - - - - - - - - - - - -

  def id
    name = present_arg(__method__)
    arg = @args[name]
    unless well_formed_id?(arg)
      raise malformed(name)
    end
    arg
  end

  def well_formed_id?(arg)
    Base58.string?(arg) && arg.size === 6
  end

  # - - - - - - - - - - - - - - - -

  def old_files
    name = present_arg(__method__)
    @args[name]
  end

  def new_files
    name = present_arg(__method__)
    @args[name]
  end

  # - - - - - - - - - - - - - - - -

  def present_arg(name)
    name = name.to_s
    unless @args.has_key?(name)
      raise missing(name)
    end
    name
  end

  # - - - - - - - - - - - - - - - -

  def missing(arg_name)
    request_error("#{arg_name} is missing")
  end

  def malformed(arg_name)
    request_error("#{arg_name} is malformed")
  end

  # - - - - - - - - - - - - - - - -

  def request_error(text)
    # Exception messages use the words 'body' and 'path'
    # to match RackDispatcher's exception keys.
    HttpJson::RequestError.new(text)
  end

end
