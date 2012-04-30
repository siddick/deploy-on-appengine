class File
  class << self
    alias :_org_join :join
    def join(*args)
      _org_join(*args).sub(/^.*file:/, 'file:')
    end
  end
end
