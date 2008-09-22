module ExtendedFormHelper
  # ==== Example
  #   extended_submit_tag('hello')
  #   # <div class="submitField field">
  #   #   <input name="commit" type="submit" value="hello" />
  #   # </div>
  def extended_submit_tag(value = 'Save changes', options = {})
    extended_input(submit_tag(value, options), 'submit')
  end

  # ==== Examples
  #   extended_text_field(:obj, :column)
  #   # <div class="textField field">
  #   #   <input id="obj_column" name="obj[column]" size="30" type="text" value="qwerty" />
  #   # </div>
  #
  #   extended_text_field(:obj, :column, :label => 'hello')
  #   # <div class="textField field">
  #   #   <label for="obj_column">hello</label>
  #   #   <input id="obj_column" name="obj[column]" size="30" type="text" value="qwerty" />
  #   # </div>
  def extended_text_field(object, method, options = {})
    label_text = options.delete(:label)

    html = extended_label(object, method, label_text)
    html << text_field(object, method, options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, 'text')
  end

  # ==== Examples
  #   extended_file_field(:obj, :column)
  #   # <div class="fileField field">
  #   #   <input id="obj_column" name="obj[column]" size="30" type="file" />
  #   # </div>
  #
  #   extended_file_field(:obj, :column, :label => 'hello')
  #   # <div class="fileField field">
  #   #   <label for="obj_column">hello</label>
  #   #   <input id="obj_column" name="obj[column]" size="30" type="file" />
  #   # </div>
  def extended_file_field(object, method, options = {})
    label_text = options.delete(:label)

    html = extended_label(object, method, label_text)
    html << file_field(object, method, options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, 'file')
  end

  # ==== Examples
  #   extended_text_area(:obj, :column)
  #   # <div class="textAreaField field">
  #   #   <textarea cols="40" id="obj_column" name="obj[column]" rows="20">qwerty</textarea>
  #   # </div>
  #
  #   extended_text_area(:obj, :column, :label => 'hello')
  #   # <div class="textAreaField field">
  #   #   <label for="obj_column">hello</label>
  #   #   <textarea cols="40" id="obj_column" name="obj[column]" rows="20">qwerty</textarea>
  #   # </div>
  def extended_text_area(object, method, options = {})
    label_text = options.delete(:label)

    html = extended_label(object, method, label_text)
    html << text_area(object, method, options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, 'textArea')
  end

  # By default will not insert password
  # ==== Examples
  #   extended_password_field(:obj, :column)
  #   # <div class="passwordField field">
  #   #   <input id="obj_column" name="obj[column]" size="30" type="password" value="" />
  #   # </div>
  #
  #   extended_password_field(:obj, :column, :label => 'hello')
  #   # <div class="passwordField field">
  #   #   <label for="obj_column">hello</label>
  #   #   <input id="obj_column" name="obj[column]" size="30" type="password" value="" />
  #   # </div>
  #
  #   extended_password_field(:obj, :column, :value => 'asdfgh')
  #   # <div class="passwordField field">
  #   #   <input id="obj_column" name="obj[column]" size="30" type="password" value="asdfgh" />
  #   # </div>
  def extended_password_field(object, method, options = {})
    label_text = options.delete(:label)

    options[:value] = '' unless options[:value]

    html = extended_label(object, method, label_text)
    html << password_field(object, method, options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, 'password')
  end

  # ==== Examples
  #   extended_check_box(:obj, :column)
  #   # <div class="checkBoxField field">
  #   #   <input id="obj_column" name="obj[column]" type="checkbox" value="1" />
  #   #   <input name="obj[column]" type="hidden" value="0" />
  #   # </div>
  #
  #   extended_check_box(:obj, :column, :label => 'hello')
  #   # <div class="checkBoxField field">
  #   #   <input id="obj_column" name="obj[column]" type="checkbox" value="1" />
  #   #   <input name="obj[column]" type="hidden" value="0" />
  #   #   <label for="obj_column">hello</label>
  #   # </div>
  def extended_check_box(object, method, options = {}, checked_value = '1', unchecked_value = '0')
    label_text = options.delete(:label)

    html = check_box(object, method, options, checked_value, unchecked_value)
    html << extended_label(object, method, label_text)
    html << extended_error_message_on(object, method, options)

    extended_input(html, 'checkBox')
  end

  # :preview_version sets thumbnail type to show (if skipped or invalid main version is used)
  # ==== Examples
  #   extended_upload_image_field(:obj, :column)
  #   # <div class="fileField imageUploadField field">
  #   #   <img alt="Qwerty" src="/images/tmp/asdfgh.jpg" />
  #   #   <input id="obj_column" name="obj[column]" size="30" type="file" />
  #   #   <input id="obj_column_temp" name="obj[column_temp]" type="hidden" value="asdfgh.jpg" />
  #   # </div>
  #
  #   extended_upload_image_field(:obj, :column, :label => 'hello')
  #   # <div class="fileField imageUploadField field">
  #   #   <label for="obj_column">hello</label>
  #   #   <img alt="Qwerty" src="/images/tmp/asdfgh.jpg" />
  #   #   <input id="obj_column" name="obj[column]" size="30" type="file" />
  #   #   <input id="obj_column_temp" name="obj[column_temp]" type="hidden" value="asdfgh.jpg" />
  #   # </div>
  #
  #   extended_upload_image_field(:obj, :column, :preview_version => :small)
  #   # <div class="fileField imageUploadField field">
  #   #   <img alt="Qwerty" src="/images/tmp/asdfgh-small.jpg" />
  #   #   <input id="obj_column" name="obj[column]" size="30" type="file" />
  #   #   <input id="obj_column_temp" name="obj[column_temp]" type="hidden" value="asdfgh.jpg" />
  #   # </div>
  def extended_upload_image_field(object, method, options = {})
    label_text = options.delete(:label)

    object_self = extended_object_get_self(object, options)

    image = object_self ? object_self.send(method) : nil
    version = options.delete(:preview_version)
    image = image.send(version) if image && version

    html = extended_label(object, method, label_text)
    html << image_tag(image.url) if image
    html << upload_column_field(object, method, options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, %w(file imageUpload))
  end

  # ==== Examples
  #   extended_upload_file_field(:obj, :column)
  #   # <div class="fileField fileUploadField field">
  #   #   <a href="/files/asdfgh.doc">asdfgh.doc</a>
  #   #   <input id="obj_column" name="obj[column]" size="30" type="file" />
  #   #   <input id="obj_column_temp" name="obj[column_temp]" type="hidden" value="asdfgh" />
  #   # </div>
  #
  #   extended_upload_file_field(:obj, :column, :label => 'hello')
  #   # <div class="fileField fileUploadField field">
  #   #   <label for="obj_column">hello</label>
  #   #   <a href="/files/asdfgh.doc">asdfgh.doc</a>
  #   #   <input id="obj_column" name="obj[column]" size="30" type="file" />
  #   #   <input id="obj_column_temp" name="obj[column_temp]" type="hidden" value="asdfgh" />
  #   # </div>
  def extended_upload_file_field(object, method, options = {})
    label_text = options.delete(:label)

    object_self = extended_object_get_self(object, options)

    file = object_self ? object_self.send(method) : nil

    html = extended_label(object, method, label_text)
    html << link_to(File.basename(file.url), file.url) if file
    html << upload_column_field(object, method, options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, %w(file fileUpload))
  end

  def extended_date_select(object, method, options = {}, html_options = {})
    label_text = options.delete(:label)

    html = extended_label(object, method, label_text)
    html << date_select(object, method, options, html_options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, 'date')
  end

  def extended_time_select(object, method, options = {}, html_options = {})
    label_text = options.delete(:label)

    html = extended_label(object, method, label_text)
    html << time_select(object, method, options, html_options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, 'time')
  end

  def extended_datetime_select(object, method, options = {}, html_options = {})
    label_text = options.delete(:label)

    html = extended_label(object, method, label_text)
    html << datetime_select(object, method, options, html_options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, 'dateTime')
  end

  def extended_collection_select(object, method, collection, value_method, text_method, options = {}, html_options = {})
    label_text = options.delete(:label)

    html = extended_label(object, method, label_text)
    html << collection_select(object, method, collection, value_method, text_method, options, html_options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, 'select')
  end

  def extended_select(object, method, choices, options = {}, html_options = {})
    label_text = options.delete(:label)

    html = extended_label(object, method, label_text)
    html << select(object, method, choices, options, html_options)
    html << extended_error_message_on(object, method, options)

    extended_input(html, 'select')
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
  
  def extended_object_get_self(object, options = {})
    options[:object] || case object
      when String, Symbol
        instance_variable_get("@#{object.to_s.sub(/\[\]$/, '')}") rescue nil
      else
        object
    end
  end
end

# All methods are implemented for +form_for+ version usage
class ActionView::Helpers::FormBuilder
  %w(extended_text_field extended_text_area extended_password_field extended_file_field extended_upload_image_field extended_upload_file_field).each do |selector|
    self.field_helpers << selector
    class_eval %Q{
      def #{selector}(method, options = {})
        @template.#{selector}(@object_name, method, objectify_options(options))
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

  %w(date time datetime).each do |type|
    self.field_helpers << "extended_#{type}_select"
    class_eval %Q{
      def extended_#{type}_select(method, options = {}, html_options = {})
        @template.extended_#{type}_select(@object_name, method, objectify_options(options), html_options)
      end
    }, __FILE__, __LINE__
  end

  self.field_helpers << 'extended_collection_select'
  def extended_collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
    @template.extended_collection_select(@object_name, method, collection, value_method, text_method, objectify_options(options), html_options)
  end

  self.field_helpers << 'extended_select'
  def extended_select(method, choices, options = {}, html_options = {})
    @template.extended_select(@object_name, method, choices, objectify_options(options), html_options)
  end

end
