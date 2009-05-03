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

  def object
    ActionView::Helpers::InstanceTag.new(@object_name, @method, @template_object, @options[:object]).object
  end

  def label
    # calling label which is defined in ActionView::Helpers::FormHelper
    super(@object_name, @method, @label == true ? I18n.t(@method, :scope => @object_name) : @label)
  end

  def control
    (self.respond_to?(@type) ? self : @template_object).send(@type, @object_name, @method, @options.merge(:object => object))
  end

  def errors
    error_messages_on(object, @method)
  end

  def to_str
    if @type == :check_box
      "#{control}#{label if @label}#{errors unless @options[:no_errors]}"
    else
      "#{label if @label}#{control}#{errors unless @options[:no_errors]}"
    end
  end
  alias to_s to_str

  def submit(object_name, method, options)
    value = options.delete(:value)
    options.delete(:object)
    if value.nil?
      submit_tag(I18n.t(object.new_record? ? 'create' : 'save', :scope => @object_name), options)
    else
      submit_tag(value, options)
    end
  end
end
