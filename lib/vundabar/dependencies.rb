class Object
  def self.const_missing(constant)
    constant = constant.to_s
    require constant.to_snake_case
    constant.to_constant
  end
end
