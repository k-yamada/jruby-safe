class Binding
  # Returns the value of some variable.
  #
  #   a = 2
  #   binding["a"]  #=> 2
  #
  def [](x)
    if RUBY_VERSION.to_f > 2.1
      local_variable_get(x)
    else
      eval(x.to_s)
    end
  end

  # Set the value of a local variable.
  #
  #   b = binding
  #   b["a"] = 4
  #   eval("a", b)  #=> 4
  def []=(l, v)
    if RUBY_VERSION.to_f > 2.1
      local_variable_set(l, v)
    else
      eval("#{l} = nil; lambda {|v| #{l} = v}").call(v)
    end
  end
end
