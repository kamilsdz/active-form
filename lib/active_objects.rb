class ActiveObjects
  include ActiveModel::Model

  class << self
    def i18n_scope
      :activerecord
    end
  
    def lookup_ancestors
      [new.send(:object_class)]
    end
  end

  def initialize(attr = {})
    generate_attr_accessors
    if attr[:id].present?
      @object = object_class.find(attr[:id])
      generate_instances_for @object
    else
      super(attr)
    end
  end
  
  def save
    if valid?
      persist!
    else
      false
    end
  end
  
  def update(attr)
    assign_attributes(attr)
    if valid?
      update_form!
    else
      false
    end
  end

  private
  
  def object_class
    raise 'Not implemented object_class method'
  end
  
  def permitted_attributes
    raise 'Not implemented permitted_attributes method'
  end
  
  def hash_attributes
    {}.tap { |hash| permitted_attributes.each { |attr| hash[attr] = send(attr) } }
  end
  
  def generate_attr_accessors
    permitted_attributes.each do |attr|
      class_eval { attr_accessor attr }
    end
  end
  
  def generate_instances_for(_object)
    permitted_attributes.each do |attr|
      instance_variable_set("@#{attr}", @object.send(attr))
    end
  end
  
  def persist!
    object_class.create hash_attributes
  end
  
  def update_form!
    @object.update hash_attributes
  end
end
