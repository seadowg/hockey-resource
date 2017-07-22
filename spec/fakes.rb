class FakeIO
  def initialize
    @buffer = []
  end

  def write(input)
    @buffer << input
  end

  def read
    @buffer.pop
  end
end

class FakeRestClient
  def initialize
    @response_map = {}
    @posts = []
  end

  def add_response(url, response)
    @response_map[url] = response
  end

  def post(url, body, headers = {})
    @posts << FakePost.new(url, body, headers)

    if @response_map[url]
      @response_map[url]
    else
      ""
    end
  end

  def posts
    @posts
  end
end

class FakePost
  attr_reader :url
  attr_reader :headers
  attr_reader :body

  def initialize(url, body, headers)
    @url = url
    @headers = headers
    @body = body
  end
end

class FakeFS
  def get(path)
    [FakeFile.new(path)]
  end
end

class FakeFile
  attr_reader :path

  def initialize(path)
    @path = path
  end
end
