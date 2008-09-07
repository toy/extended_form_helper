require File.dirname(__FILE__) + '/spec_helper'

module FieldHelperMethods
  def have_form_with_field_div(*types)
    klasses = types.to_a.map{ |type| ".#{type}Field" }
    have_tag('form > div%s' % klasses.join) do
      yield
    end
  end
  def have_field_div(*types)
    klasses = types.to_a.map{ |type| ".#{type}Field" }
    have_tag('div%s' % klasses.join) do
      yield
    end
  end
  def with_label
    with_tag('label[for=obj_column]', 'hello')
  end
  def without_label
    without_tag('label')
  end
  def with_error
    with_tag('div.formError', 'error')
  end
  def without_error
    without_tag('div.formError')
  end
end

describe ExtendedFormHelper do
  include ExtendedFormHelper
  include ActionView::Helpers::ActiveRecordHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::DateHelper
  include FieldHelperMethods

  before do
    @obj = mock('obj', :column => 'qwerty', :object_name => 'obj', :to_s => 'obj')
    @errors = mock('errors', :on => nil)
    @obj.stub!(:errors).and_return(@errors)
  end

  it "should return submit_tag" do
    html = extended_submit_tag('hello')
    html.should have_field_div('submit') do
      with_tag('input[name=commit][value=hello][type=submit]')
    end
  end

  it "should return text_field" do
    html = extended_text_field(:obj, :column)
    html.should have_field_div('text') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=qwerty][type=text]')
      without_error
    end
  end
  it "should return text_field with label" do
    html = extended_text_field(:obj, :column, :label => 'hello')
    html.should have_field_div('text') do
      with_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=qwerty][type=text]')
      without_error
    end
  end
  it "should return text_field with error" do
    @errors.stub!(:on).and_return('error')
    html = extended_text_field(:obj, :column)
    html.should have_field_div('text') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=qwerty][type=text]')
      with_error
    end
  end

  it "should return file_field" do
    html = extended_file_field(:obj, :column)
    html.should have_field_div('file') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      without_error
    end
  end
  it "should return file_field with label" do
    html = extended_file_field(:obj, :column, :label => 'hello')
    html.should have_field_div('file') do
      with_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      without_error
    end
  end
  it "should return file_field with error" do
    @errors.stub!(:on).and_return('error')
    html = extended_file_field(:obj, :column)
    html.should have_field_div('file') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_error
    end
  end

  it "should return text_area" do
    html = extended_text_area(:obj, :column)
    html.should have_field_div('textArea') do
      without_label
      with_tag('textarea#obj_column[name=\'obj[column]\']', 'qwerty')
      without_error
    end
  end
  it "should return text_area with label" do
    html = extended_text_area(:obj, :column, :label => 'hello')
    html.should have_field_div('textArea') do
      with_label
      with_tag('textarea#obj_column[name=\'obj[column]\']', 'qwerty')
      without_error
    end
  end
  it "should return text_area with error" do
    @errors.stub!(:on).and_return('error')
    html = extended_text_area(:obj, :column)
    html.should have_field_div('textArea') do
      without_label
      with_tag('textarea#obj_column[name=\'obj[column]\']', 'qwerty')
      with_error
    end
  end

  it "should return password_field (with blank value)" do
    html = extended_password_field(:obj, :column)
    html.should have_field_div('password') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=][type=password]')
      without_error
    end
  end
  it "should return password_field (with blank value) with label" do
    html = extended_password_field(:obj, :column, :label => 'hello')
    html.should have_field_div('password') do
      with_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=][type=password]')
      without_error
    end
  end
  it "should return password_field (with blank value) with error" do
    @errors.stub!(:on).and_return('error')
    html = extended_password_field(:obj, :column)
    html.should have_field_div('password') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=][type=password]')
      with_error
    end
  end
  it "should return password_field (with value)" do
    html = extended_password_field(:obj, :column, :value => 'asdfgh')
    html.should have_field_div('password') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=asdfgh][type=password]')
      without_error
    end
  end

  it "should return check_box" do
    html = extended_check_box(:obj, :column)
    html.should have_field_div('checkBox') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=1][type=checkbox]')
      with_tag('input[name=\'obj[column]\'][value=0][type=hidden]')
      without_error
    end
  end
  it "should return check_box with label" do
    html = extended_check_box(:obj, :column, :label => 'hello')
    html.should have_field_div('checkBox') do
      with_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=1][type=checkbox]')
      with_tag('input[name=\'obj[column]\'][value=0][type=hidden]')
      without_error
    end
  end
  it "should return check_box with error" do
    @errors.stub!(:on).and_return('error')
    html = extended_check_box(:obj, :column)
    html.should have_field_div('checkBox') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=1][type=checkbox]')
      with_tag('input[name=\'obj[column]\'][value=0][type=hidden]')
      with_error
    end
  end
  it "should return checked check_box" do
    @obj.stub!(:column).and_return(true)
    html = extended_check_box(:obj, :column)
    html.should have_field_div('checkBox') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=1][type=checkbox][checked=checked]')
      with_tag('input[name=\'obj[column]\'][value=0][type=hidden]')
      without_error
    end
  end

  include ActionView::Helpers::AssetTagHelper
  include UploadColumnHelper
  it "should return upload_column_field for image" do
    @obj.stub!(:column).and_return(nil)
    @obj.stub!(:column_temp).and_return('')
    html = extended_upload_image_field(:obj, :column)
    html.should have_field_div('file', 'imageUpload') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_tag('input#obj_column_temp[name=\'obj[column_temp]\'][type=hidden][value=]')
      without_error
    end
  end
  it "should return upload_column_field for image with label" do
    @obj.stub!(:column).and_return(nil)
    @obj.stub!(:column_temp).and_return('')
    html = extended_upload_image_field(:obj, :column, :label => 'hello')
    html.should have_field_div('file', 'imageUpload') do
      with_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_tag('input#obj_column_temp[name=\'obj[column_temp]\'][type=hidden][value=]')
      without_error
    end
  end
  it "should return upload_column_field for image with error" do
    @errors.stub!(:on).and_return('error')
    @obj.stub!(:column).and_return(nil)
    @obj.stub!(:column_temp).and_return('')
    html = extended_upload_image_field(:obj, :column)
    html.should have_field_div('file', 'imageUpload') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_tag('input#obj_column_temp[name=\'obj[column_temp]\'][type=hidden][value=]')
      with_error
    end
  end
  it "should return upload_column_field for image with image" do
    @obj.stub!(:column).and_return(mock('image', :a => mock('thumbnail', :url => '/images/qwerty')))
    @obj.stub!(:column_temp).and_return('qwerty')
    html = extended_upload_image_field(:obj, :column, :preview_version => :a)
    html.should have_field_div('file', 'imageUpload') do
      without_label
      with_tag('img[src=/images/qwerty][alt=Qwerty]')
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_tag('input#obj_column_temp[name=\'obj[column_temp]\'][type=hidden][value=qwerty]')
      without_error
    end
  end

  include ActionView::Helpers::UrlHelper
  it "should return upload_column_field for file" do
    @obj.stub!(:column).and_return(nil)
    @obj.stub!(:column_temp).and_return('')
    html = extended_upload_file_field(:obj, :column)
    html.should have_field_div('file', 'fileUpload') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_tag('input#obj_column_temp[name=\'obj[column_temp]\'][type=hidden][value=]')
      without_error
    end
  end
  it "should return upload_column_field for file with label" do
    @obj.stub!(:column).and_return(nil)
    @obj.stub!(:column_temp).and_return('')
    html = extended_upload_file_field(:obj, :column, :label => 'hello')
    html.should have_field_div('file', 'fileUpload') do
      with_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_tag('input#obj_column_temp[name=\'obj[column_temp]\'][type=hidden][value=]')
      without_error
    end
  end
  it "should return upload_column_field for file with error" do
    @errors.stub!(:on).and_return('error')
    @obj.stub!(:column).and_return(nil)
    @obj.stub!(:column_temp).and_return('')
    html = extended_upload_file_field(:obj, :column)
    html.should have_field_div('file', 'fileUpload') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_tag('input#obj_column_temp[name=\'obj[column_temp]\'][type=hidden][value=]')
      with_error
    end
  end
  it "should return upload_column_field for file with link to file" do
    @obj.stub!(:column).and_return(mock('file', :url => '/files/qwerty'))
    @obj.stub!(:column_temp).and_return('qwerty')
    html = extended_upload_file_field(:obj, :column)
    html.should have_field_div('file', 'fileUpload') do
      without_label
      with_tag('a[href=/files/qwerty]')
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_tag('input#obj_column_temp[name=\'obj[column_temp]\'][type=hidden][value=qwerty]')
      without_error
    end
  end

  it "should return date_select" do
    @obj.stub!(:column).and_return(Time.now)
    html = extended_date_select(:obj, :column)
    # html.should have_field_div('date') do
    #   without_label
    #   with_tag('input#obj_column[name=\'obj[column]\'][value=qwerty][type=text]')
    #   without_error
    # end
  end
  # it "should return text_field with label" do
  #   html = extended_text_field(:obj, :column, :label => 'hello')
  #   html.should have_field_div('text') do
  #     with_label
  #     with_tag('input#obj_column[name=\'obj[column]\'][value=qwerty][type=text]')
  #     without_error
  #   end
  # end
  # it "should return text_field with error" do
  #   @errors.stub!(:on).and_return('error')
  #   html = extended_text_field(:obj, :column)
  #   html.should have_field_div('text') do
  #     without_label
  #     with_tag('input#obj_column[name=\'obj[column]\'][value=qwerty][type=text]')
  #     with_error
  #   end
  # end

end

describe ExtendedFormHelper, 'with form_for' do
  include ExtendedFormHelper
  include ActionView::Helpers::ActiveRecordHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::TextHelper
  include FieldHelperMethods

  def url_for(options = {})
    options.inspect
  end
  def protect_against_forgery?
    false
  end

  before do
    @obj = mock('obj', :column => 'qwerty', :object_name => 'obj', :to_s => 'obj', :id => 1)
    @errors = mock('errors', :on => nil)
    @obj.stub!(:errors).and_return(@errors)
    @controller = mock('Controller', :url_for => 'http://example.com')
  end

  it "should return submit" do
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_submit('Save it!')
    end
    _erbout.should have_form_with_field_div('submit') do
      without_label
      with_tag('input#obj_submit[name=\'commit\'][value=Save it!][type=submit]')
      without_error
    end
  end

  it "should return text_field" do
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_text_field(:column)
    end
    _erbout.should have_form_with_field_div('text') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=qwerty][type=text]')
      without_error
    end
  end
  it "should return text_field with label" do
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_text_field(:column, :label => 'hello')
    end
    _erbout.should have_form_with_field_div('text') do
      with_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=qwerty][type=text]')
      without_error
    end
  end
  it "should return text_field with error" do
    @errors.stub!(:on).and_return('error')
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_text_field(:column)
    end
    _erbout.should have_form_with_field_div('text') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=qwerty][type=text]')
      with_error
    end
  end

  it "should return file_field" do
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_file_field(:column)
    end
    _erbout.should have_form_with_field_div('file') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      without_error
    end
  end
  it "should return file_field with label" do
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_file_field(:column, :label => 'hello')
    end
    _erbout.should have_form_with_field_div('file') do
      with_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      without_error
    end
  end
  it "should return file_field with error" do
    @errors.stub!(:on).and_return('error')
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_file_field(:column)
    end
    _erbout.should have_form_with_field_div('file') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_error
    end
  end

  it "should return text_area" do
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_text_area(:column)
    end
    _erbout.should have_form_with_field_div('textArea') do
      without_label
      with_tag('textarea#obj_column[name=\'obj[column]\']', 'qwerty')
      without_error
    end
  end
  it "should return text_area with label" do
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_text_area(:column, :label => 'hello')
    end
    _erbout.should have_form_with_field_div('textArea') do
      with_label
      with_tag('textarea#obj_column[name=\'obj[column]\']', 'qwerty')
      without_error
    end
  end
  it "should return text_area with error" do
    @errors.stub!(:on).and_return('error')
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_text_area(:column)
    end
    _erbout.should have_form_with_field_div('textArea') do
      without_label
      with_tag('textarea#obj_column[name=\'obj[column]\']', 'qwerty')
      with_error
    end
  end

  it "should return password_field (with blank value)" do
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_password_field(:column)
    end
    _erbout.should have_form_with_field_div('password') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=][type=password]')
      without_error
    end
  end
  it "should return password_field (with blank value) with label" do
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_password_field(:column, :label => 'hello')
    end
    _erbout.should have_form_with_field_div('password') do
      with_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=][type=password]')
      without_error
    end
  end
  it "should return password_field (with blank value) with error" do
    @errors.stub!(:on).and_return('error')
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_password_field(:column)
    end
    _erbout.should have_form_with_field_div('password') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=][type=password]')
      with_error
    end
  end
  it "should return password_field (with value)" do
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_password_field(:column, :value => 'asdfgh')
    end
    _erbout.should have_form_with_field_div('password') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=asdfgh][type=password]')
      without_error
    end
  end

  it "should return check_box" do
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_check_box(:column)
    end
    _erbout.should have_form_with_field_div('checkBox') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=1][type=checkbox]')
      with_tag('input[name=\'obj[column]\'][value=0][type=hidden]')
      without_error
    end
  end
  it "should return check_box with label" do
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_check_box(:column, :label => 'hello')
    end
    _erbout.should have_form_with_field_div('checkBox') do
      with_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=1][type=checkbox]')
      with_tag('input[name=\'obj[column]\'][value=0][type=hidden]')
      without_error
    end
  end
  it "should return check_box with error" do
    @errors.stub!(:on).and_return('error')
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_check_box(:column)
    end
    _erbout.should have_form_with_field_div('checkBox') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=1][type=checkbox]')
      with_tag('input[name=\'obj[column]\'][value=0][type=hidden]')
      with_error
    end
  end
  it "should return checked check_box" do
    @obj.stub!(:column).and_return(true)
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_check_box(:column)
    end
    _erbout.should have_form_with_field_div('checkBox') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][value=1][type=checkbox][checked=checked]')
      with_tag('input[name=\'obj[column]\'][value=0][type=hidden]')
      without_error
    end
  end

  include ActionView::Helpers::AssetTagHelper
  include UploadColumnHelper
  it "should return upload_column_field for image" do
    @obj.stub!(:column).and_return(nil)
    @obj.stub!(:column_temp).and_return('')
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_upload_image_field(:column)
    end
    _erbout.should have_field_div('file', 'imageUpload') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_tag('input#obj_column_temp[name=\'obj[column_temp]\'][type=hidden][value=]')
      without_error
    end
  end
  it "should return upload_column_field for image with label" do
    @obj.stub!(:column).and_return(nil)
    @obj.stub!(:column_temp).and_return('')
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_upload_image_field(:column, :label => 'hello')
    end
    _erbout.should have_field_div('file', 'imageUpload') do
      with_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_tag('input#obj_column_temp[name=\'obj[column_temp]\'][type=hidden][value=]')
      without_error
    end
  end
  it "should return upload_column_field for image with error" do
    @errors.stub!(:on).and_return('error')
    @obj.stub!(:column).and_return(nil)
    @obj.stub!(:column_temp).and_return('')
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_upload_image_field(:column)
    end
    _erbout.should have_field_div('file', 'imageUpload') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_tag('input#obj_column_temp[name=\'obj[column_temp]\'][type=hidden][value=]')
      with_error
    end
  end
  it "should return upload_column_field for image with image" do
    @obj.stub!(:column).and_return(mock('image', :a => mock('thumbnail', :url => '/images/qwerty')))
    @obj.stub!(:column_temp).and_return('qwerty')
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_upload_image_field(:column, :preview_version => :a)
    end
    _erbout.should have_field_div('file', 'imageUpload') do
      without_label
      with_tag('img[src=/images/qwerty][alt=Qwerty]')
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_tag('input#obj_column_temp[name=\'obj[column_temp]\'][type=hidden][value=qwerty]')
      without_error
    end
  end

  include ActionView::Helpers::UrlHelper
  it "should return upload_column_field for file" do
    @obj.stub!(:column).and_return(nil)
    @obj.stub!(:column_temp).and_return('')
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_upload_file_field(:column)
    end
    _erbout.should have_field_div('file', 'fileUpload') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_tag('input#obj_column_temp[name=\'obj[column_temp]\'][type=hidden][value=]')
      without_error
    end
  end
  it "should return upload_column_field for file with label" do
    @obj.stub!(:column).and_return(nil)
    @obj.stub!(:column_temp).and_return('')
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_upload_file_field(:column, :label => 'hello')
    end
    _erbout.should have_field_div('file', 'fileUpload') do
      with_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_tag('input#obj_column_temp[name=\'obj[column_temp]\'][type=hidden][value=]')
      without_error
    end
  end
  it "should return upload_column_field for file with error" do
    @errors.stub!(:on).and_return('error')
    @obj.stub!(:column).and_return(nil)
    @obj.stub!(:column_temp).and_return('')
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_upload_file_field(:column)
    end
    _erbout.should have_field_div('file', 'fileUpload') do
      without_label
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_tag('input#obj_column_temp[name=\'obj[column_temp]\'][type=hidden][value=]')
      with_error
    end
  end
  it "should return upload_column_field for file with link to file" do
    @obj.stub!(:column).and_return(mock('file', :url => '/files/qwerty'))
    @obj.stub!(:column_temp).and_return('qwerty')
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_upload_file_field(:column)
    end
    _erbout.should have_field_div('file', 'fileUpload') do
      without_label
      with_tag('a[href=/files/qwerty]')
      with_tag('input#obj_column[name=\'obj[column]\'][type=file]')
      with_tag('input#obj_column_temp[name=\'obj[column_temp]\'][type=hidden][value=qwerty]')
      without_error
    end
  end

  it "should return date_select" do
    @obj.stub!(:column).and_return(Time.now)
    _erbout = ''
    form_for(:obj) do |f|
      _erbout << f.extended_date_select(:column)
    end
    # _erbout.should have_form_with_field_div('text') do
    #   without_label
    #   with_tag('input#obj_column[name=\'obj[column]\'][value=qwerty][type=text]')
    #   without_error
    # end
  end

end
