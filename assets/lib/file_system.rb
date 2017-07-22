class FileSystem
  def get(path)
    Dir.glob(path).map { |f| File.new(f) }
  end
end
