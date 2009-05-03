module ExtendedFormHelper
  def extended_control(type, object_name, method, options = {}, &block)
    ExtendedFormControl.new(type, object_name, method, self, options).extended_control(&block)
  end

  def extended_text_field(object_name, method, options = {}, &block)
    ExtendedFormControl.new(:text_field, object_name, method, self, options).extended_control(&block)
  end

  def extended_text_area(object_name, method, options = {}, &block)
    ExtendedFormControl.new(:text_area, object_name, method, self, options).extended_control(&block)
  end

  def extended_password_field(object_name, method, options = {}, &block)
    if options[:value] == true
      options[:value] = nil
    elsif !options[:value]
      options[:value] = ''
    end
    ExtendedFormControl.new(:password_field, object_name, method, self, options).extended_control(&block)
  end

  def extended_file_field(object_name, method, options = {}, &block)
    ExtendedFormControl.new(:file_field, object_name, method, self, options).extended_control(&block)
  end

  def extended_check_box(object_name, method, options = {}, &block)
    ExtendedFormControl.new(:check_box, object_name, method, self, options).extended_control(&block)
  end

  def extended_submit(object_name, value = nil, options = {}, &block)
    if Hash === value && options == {}
      value, options = nil, value
    end
    if String === object_name
      object_name, value = nil, object_name
    end
    ExtendedFormControl.new(:submit, object_name, nil, self, options.merge(:value => value)).extended_control(&block)
  end

  def error_messages_on(object, method, options = {})
    options.reverse_merge!(:prepend_text => '', :append_text => '', :css_class => 'formError')

    if (obj = (object.respond_to?(:errors) ? object : instance_variable_get("@#{object}"))) && (errors = obj.errors.on(method))
      if errors.is_a?(Array)
        content_tag(:ul, errors.map{ |error| content_tag(:li, "#{options[:prepend_text]}#{error}#{options[:append_text]}", :class => options[:css_class]) }, :class => options[:css_class].pluralize)
      else
        content_tag(:div, "#{options[:prepend_text]}#{errors}#{options[:append_text]}", :class => options[:css_class])
      end
    else
      ''
    end
  end
end

class ActionView::Helpers::FormBuilder
  %w(extended_text_field extended_text_area extended_password_field extended_file_field extended_check_box).each do |helper|
    field_helpers << helper
    class_eval %Q{
      def #{helper}(method, options = {}, &block)
        @template.#{helper}(@object_name, method, objectify_options(options), &block)
      end
    }, __FILE__, __LINE__
  end

  field_helpers << 'extended_control'
  def extended_control(type, method, options = {}, &block)
    @template.extended_control(type, @object_name, method, objectify_options(options), &block)
  end

  field_helpers << 'extended_submit'
  def extended_submit(value = nil, options = {}, &block)
    if Hash === value && options == {}
      value, options = nil, value
    end
    @template.extended_submit(@object_name, value, objectify_options(options), &block)
  end

  self.field_helpers << 'error_messages_on'
  def error_messages_on(method, options = {})
    @template.error_messages_on(@object || @object_name, method, options)
  end
end
