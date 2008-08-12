module ExtendedFormHelper
# 
#   def submit_controls(options = {}) #todo test
#     options[:save_label] ||= 'Save'
#     options[:class_name] ||= 'submitControls'
#     controls = submit_tag(options[:save_label], :class => 'save')
# 
#     if options[:destroy_link] #todo POST method, question
#       options[:destroy_label] ||= 'Delete'
#       options[:confirm_delete] ||= 'Sure to delete?'
#       controls << link_to(options[:destroy_label], options[:destroy_link], :method => :delete, :confirm => options[:confirm_delete], :class => 'destroy')
#     end
# 
#     content_tag(:fieldset, controls, :class => options[:class_name])
#   end
# 
  # def extended_submit_tag(value = 'Save changes', options = {})
  #   extended_input(submit_tag(value, options), 'submit')
  # end
# 
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

#   def extended_check_box(object, method, options = {}, checked_value = '1', unchecked_value = '0')
#     label_text = options.delete(:label)
# 
#     html = check_box(object, method, options, checked_value, unchecked_value)
#     html << extended_label(object, method, label_text)
#     html << extended_error_message_on(object, method, options)
# 
#     extended_input(html, 'checkBox')
#   end
# 
#   def extended_upload_file_field(object, method, options = {})
#     label_text = options.delete(:label)
# 
#     object_self = case object
#     when String, Symbol
#       instance_variable_get("@#{object.sub(/\[\]$/, '')}") rescue nil
#     else
#       object
#     end
# 
#     file = object_self ? object_self.send(method) : nil
# 
#     html = extended_label(object, method, label_text)
#     html << link_to(File.basename(file.url), file.url) if file
#     html << upload_column_field(object, method, options)
#     html << extended_error_message_on(object, method, options)
# 
#     extended_input(html, 'file')
#   end
# 
#   def extended_upload_image_field(object, method, options = {})
#     label_text = options.delete(:label)
# 
#     object_self = case object
#     when String, Symbol
#       instance_variable_get("@#{object.sub(/\[\]$/, '')}") rescue nil
#     else
#       object
#     end
# 
#     image = object_self ? object_self.send(method) : nil
#     version = options.delete(:preview_version)
#     image = image.send(version) if image && version
# 
#     html = extended_label(object, method, label_text)
#     html << image_tag(image.url) if image
#     html << upload_column_field(object, method, options)
#     html << extended_error_message_on(object, method, options)
# 
#     extended_input(html, 'file')
#   end
# 
# 
# #   def extended_radio_button(object, label, method, tag_value, options = {})
# #     label = extended_label(object, label, method)
# #     input = object.radio_button(method, tag_value, options)
# #     #errors = error_message_on(object.object_name, method)
# #
# #     #fixing wrong label's for attribute to value of input's id attributr
# #     label.sub!(/(for=["'])[^"']*(["'])/, '\1' + /id=["']([^"']*)["']/.match(input)[1] + '\2')
# #
# #     extended_input(input + label, :radio_button)
# #   end
# #
# #   def extended_radio_select(object, method, choices, checked, options = {}, html_options = {})
# #     choices = choices.to_a if choices.is_a? Hash
# #
# #     inputs = choices.collect do |choice|
# #       label = extended_label(object, choice.first, method)
# #       input = object.radio_button(method, choice.last, choice.last === checked ? options.merge(:checked => true) : options)
# #
# #       #fixing wrong label's for attribute to value of input's id attributr
# #       label.sub!(/(for=["'])[^"']*(["'])/, '\1' + /id=["']([^"']*)["']/.match(input)[1] + '\2')
# #
# #       input + label
# #     end.join("\n")
# #
# #     errors = error_message_on(object.object_name, method)
# #
# #     extended_input(errors + inputs, :radio_button)
# #   end
# 
# #   def extended_collection_select(object, label, method, collection, value_method, text_method, options = {}, html_options = {})
# #     label = extended_label(object, label, method)
# #     input = object.collection_select(method, collection, value_method, text_method, options, html_options)
# #     errors = error_message_on(object.object_name, method)
# #
# #     extended_input(errors + label + input, :select)
# #   end
# #
# #   def extended_upload_column_field(object, label, method, options = {})
# #     label = extended_label(object, label, method)
# #     input = object.upload_column_field(method, options)
# #     errors = error_message_on(object.object_name, method)
# #
# #     extended_input(errors + label + input, :text)
# #   end
# 
# 
# 
#   def remote_form_for(record_or_name_or_array, *args, &proc)
#     options = args.extract_options!
#     
#     if options[:html] && options[:html][:multipart]
#       @_multipart_remote_form_for_id = (@_multipart_remote_form_for_id || 0) + 1
#       target = "upload_frame_#{@_multipart_remote_form_for_id}"
# 
#       options[:html] ||= {}
#       options[:html][:method] = :post
#       #options[:html][:multipart] = true
#       options[:html][:target] = target
# 
#       options[:html][:onsubmit] = (options[:html][:onsubmit] ? options[:html][:onsubmit] + "; " : "") + 'this.insert(\'<input type="hidden" name="format" value="js" />\');'
#       
#       concat "<iframe id=\"#{target}\" name=\"#{target}\" style=\"width:1px;height:1px;border:0px;display:none;\" src=\"about:blank\"></iframe>", proc.binding
#       args << options
#       form_for(record_or_name_or_array, options, &proc)
#     else
#       old_remote_form_for = ActionView::Helpers::PrototypeHelper.instance_method(:remote_form_for).bind(self)
#       args << options
#       old_remote_form_for.call(record_or_name_or_array, *args, &proc)
#     end
#   end

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

  def extended_input(content, klass, options = {})
    content_tag(:div, content, :class => "field #{klass}Field")
  end
end

ActionView::Helpers::FormBuilder.class_eval do
  %w(extended_text_field extended_file_field extended_text_area extended_password_field extended_upload_image_field extended_upload_file_field).each do |selector|
    self.field_helpers << selector
    class_eval %Q{
      def #{selector}(method, options = {})
        @template.send(#{selector.inspect}, @object_name, method, objectify_options(options))
      end
    }, __FILE__, __LINE__
  end
  # 
  # self.field_helpers << 'extended_check_box'
  # 
  # def extended_check_box(method, options = {}, checked_value = '1', unchecked_value = '0')
  #   @template.extended_check_box(@object_name, method, objectify_options(options), checked_value, unchecked_value)
  # end
end
