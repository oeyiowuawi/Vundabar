module Vundabar
  module Association
    def has_many(model_name, options)
      define_method(model_name) do
        model = model_name.to_constant
        model.where("id LIKE ?", options[:foreign_key])
      end

    end
  end
end


A Post has many comments
a comment belongs to a post(this guy )
