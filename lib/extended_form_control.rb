class ExtendedFormControl
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormTagHelper
  include ExtendedFormHelper

  def initialize(type, object_name, method, template_object, options)
    @type, @object_name, @method, @template_object, @options = type, object_name, method, template_object, options
    @label = @options.delete(:label)
    @class = @options.delete(:class)
    @before = @options.delete(:before)
    @after = @options.delete(:after)
    if @hint = @options.delete(:hint)
      if control =~ /value="[^"]/
        @hint_hidden = true
      else
        @options[:style] = "display: none; #{@options[:style]}"
      end
      @options[:onBlur] = "if(this.value==''){document.getElementById('#{hint_id}').style.display='';document.getElementById('#{control_id}').style.display='none';}; #{@options[:onBlur]}"
    end
  end

  def extended_control
    klass = %w(control)
    klass << @type.to_s.camelize(:lower)
    klass << @class if @class

    div_open = tag(:div, {:class => klass.join(' ')}, true)
    div_close = '</div>'

    if block_given?
      @template_object.concat div_open
      yield self
      @template_object.concat div_close
    else
      "#{div_open}#{@before}#{to_str}#{@after}#{div_close}"
    end
  end

  def i18n_label_string
    scopes = [@object_name]
    if klass = object && object.class
      while klass && ![ActiveRecord::Base, Object].include?(klass)
        scopes << klass.name.underscore
        klass = klass.superclass
      end
    end
    scopes.uniq!
    scopes.each do |scope|
      label = I18n.t(@method, :scope => scope, :default => '')
      return label if label.present?
    end
    scopes.map do |scope|
      I18n.t(@method, :scope => scope)
    end.join('; ')
  end

  def label
    # calling label which is defined in ActionView::Helpers::FormHelper
    super(@object_name, @method, @label == true ? i18n_label_string : @label)
  end

  def control
    (self.respond_to?(@type) ? self : @template_object).send(@type, @object_name, @method, @options.merge(:object => object))
  end

  def errors
    error_messages_on(object, @method)
  end

  def hint
    if @hint
      options = {
        :id => hint_id,
        :class => 'hint',
        :onFocus => "document.getElementById('#{hint_id}').style.display='none';document.getElementById('#{control_id}').style.display='';document.getElementById('#{control_id}').focus();",
      }
      options[:style] = 'display: none;' if @hint_hidden
      text_field_tag(nil, @hint, options)
    end
  end

  def to_str
    if @type == :check_box
      "#{control}#{label if @label}#{errors unless @options[:no_errors]}"
    else
      "#{label if @label}#{hint}#{control}#{errors unless @options[:no_errors]}"
    end
  end
  alias to_s to_str

protected

  def instance_tag
    ActionView::Helpers::InstanceTag.new(@object_name, @method, @template_object, @options[:object])
  end

  def object
    instance_tag.object
  end

  def submit(object_name, method, options)
    value = options.delete(:value)
    options.delete(:object)
    if value.nil?
      submit_tag(I18n.t(object.new_record? ? 'create' : 'save', :scope => @object_name), options)
    else
      submit_tag(value, options)
    end
  end

  def control_id
    instance_tag.send(:tag_id)
  end

  def hint_id
    "#{control_id}__hint"
  end

end
