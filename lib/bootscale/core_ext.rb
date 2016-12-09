module Kernel
  alias_method :require_without_cache, :require
  def require(path)
    require_without_cache(Bootscale.cache[path] || path)
  end
end

class << Kernel
  alias_method :require_without_cache, :require
  def require(path)
    require_without_cache(Bootscale.cache[path] || path)
  end
end

class Module
  alias_method :autoload_without_cache, :autoload
  def autoload(const, path)
    autoload_without_cache(const, Bootscale.cache[path] || path)
  end
end
