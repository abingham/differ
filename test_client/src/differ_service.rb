require_relative 'http_json/request_packer'
require_relative 'http_json/response_unpacker'
require_relative 'differ_exception'

class DifferService

  def initialize(externals)
    requester = HttpJson::RequestPacker.new(externals.http, 'differ-server', 4567)
    @http = HttpJson::ResponseUnpacker.new(requester, DifferException)
  end

  def ready?
    @http.get(__method__, {})
  end

  def sha
    @http.get(__method__, {})
  end

  def diff(was_files, now_files)
    @http.get(__method__, {
      was_files:was_files,
      now_files:now_files
    })
  end

  def diff2(old_files, new_files)
    @http.get(__method__, {
      old_files:old_files,
      new_files:new_files
    })
  end

end