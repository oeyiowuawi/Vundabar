module Vundabar
  module Associations
    def has_many(name, options = {})
      define_method(name) do
        class_name = name.to_s.singularize.capitalize
        model = options.fetch(:class_name, class_name).to_constant
        foreign_key_column = self.class.to_s.downcase + "_id"
        foreign_key = options.fetch(:foreign_key, foreign_key_column)
        model.where("#{foreign_key} LIKE ?", id)
      end
    end


    def belongs_to(model_name, options = {})
      define_method(model_name) do
        class_name = model_name.to_s.singularize.capitalize
        model = options.fetch(:class_name, class_name).to_constant
        foreign_key = model_name.to_s.concat("_id")
        value = send(foreign_key)
        model.find_by(id: value)
      end
    end
  end
end
