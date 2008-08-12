module ExtendedFormHelper
  def extended_submit_tag(value = 'Save changes', options = {})
    extended_input(submit_tag(value, options), 'submit')
  end

  def extended_text_field(object, method, options = {})
    label_text = options.delete(:label)

    html = extended_label(object, method, label_text)
    html << text_field(object, method, options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, 'text')
  end

  def extended_file_field(object, method, options = {})
    label_text = options.delete(:label)

    html = extended_label(object, method, label_text)
    html << file_field(object, method, options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, 'file')
  end

  def extended_text_area(object, method, options = {})
    label_text = options.delete(:label)

    html = extended_label(object, method, label_text)
    html << text_area(object, method, options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, 'textArea')
  end

  def extended_password_field(object, method, options = {})
    label_text = options.delete(:label)

    options[:value] = '' unless options[:value]

    html = extended_label(object, method, label_text)
    html << password_field(object, method, options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, 'password')
  end

  def extended_check_box(object, method, options = {}, checked_value = '1', unchecked_value = '0')
    label_text = options.delete(:label)

    html = check_box(object, method, options, checked_value, unchecked_value)
    html << extended_label(object, method, label_text)
    html << extended_error_message_on(object, method, options)

    extended_input(html, 'checkBox')
  end

  def extended_upload_image_field(object, method, options = {})
    label_text = options.delete(:label)

    object_self = case object
      when String, Symbol
        instance_variable_get("@#{object.to_s.sub(/\[\]$/, '')}") rescue nil
      else
        object
    end
    
    image = object_self ? object_self.send(method) : nil
    version = options.delete(:preview_version)
    image = image.send(version) if image && version

    html = extended_label(object, method, label_text)
    html << image_tag(image.url) if image
    html << upload_column_field(object, method, options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, %w(file imageUpload))
  end

  def extended_upload_file_field(object, method, options = {})
    label_text = options.delete(:label)

    object_self = case object
      when String, Symbol
        instance_variable_get("@#{object.to_s.sub(/\[\]$/, '')}") rescue nil
      else
        object
    end

    file = object_self ? object_self.send(method) : nil

    html = extended_label(object, method, label_text)
    html << link_to(File.basename(file.url), file.url) if file
    html << upload_column_field(object, method, options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, %w(file fileUpload))
  end

private

  def extended_label(object, method, text)
    text.blank? ? '' : label(object, method, text)
  end

  def extended_error_message_on(object, method, options = {})
    case object
      when String, Symbol
        error_message_on(object.to_s.sub(/\[\]$/, ''), method) # rescue ''
      else
        error_message_on(object, method)
    end
  end

  def extended_input(content, types, options = {})
    klasses = types.to_a.map{ |type| "#{type}Field" } + ['field']
    content_tag(:div, content, :class => klasses.join(' '))
  end
end

ActionView::Helpers::FormBuilder.class_eval do
  %w(extended_text_field extended_text_area extended_password_field extended_file_field extended_upload_image_field extended_upload_file_field).each do |selector|
    self.field_helpers << selector
    class_eval %Q{
      def #{selector}(method, options = {})
        @template.send(#{selector.inspect}, @object_name, method, objectify_options(options))
      end
    }, __FILE__, __LINE__
  end

  self.field_helpers << 'extended_check_box'

  def extended_check_box(method, options = {}, checked_value = '1', unchecked_value = '0')
    @template.extended_check_box(@object_name, method, objectify_options(options), checked_value, unchecked_value)
  end

  self.field_helpers << 'extended_submit'

  def extended_submit(value = "Save changes", options = {})
    @template.extended_submit_tag(value, options.reverse_merge(:id => "#{object_name}_submit"))
  end
end
