require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/models'

module Spec
  module Matchers
    def have_same_dom(expected)
      Matcher.new :have_same_dom, expected do |expected|
        def clean_white_spece(s)
          s.strip.gsub(/>\s+</, '><')
        end

        match do |actual|
          expected_dom = HTML::Document.new(clean_white_spece(expected)).root
          actual_dom   = HTML::Document.new(clean_white_spece(actual)).root
          expected_dom == actual_dom
        end
      end
    end
  end
end

module FormForTesting
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::RecordIdentificationHelper

  def polymorphic_path(record_or_hash_or_array, options = {})
    [record_or_hash_or_array, options].inspect
  end

  def url_for(options = {})
    options.inspect
  end

  def protect_against_forgery?
    false
  end
end

module HelperTesting
  include ExtendedFormHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper

  def output_buffer
    @output_buffer ||= ''
  end
  def output_buffer=(output_buffer)
    @output_buffer = output_buffer
  end

  def content_before
    '<span>before</span>'
  end

  def content_after
    '<span>after</span>'
  end
end

describe ExtendedFormHelper do
  include HelperTesting

  before do
    @errors = mock('errors', :on => nil)
    @obj = stub_model(Shape, :errors => @errors)
    I18n.backend.store_translations('en', {:obj => {:name => 'i18n text column label'}})
  end

  describe "with direct object sending" do
    describe "rendering e_control" do
      it "should render" do
        def trigger_a(object_name, method, options)
          '<div>i am trigger</div>'
        end
        e_control(:trigger_a, :obj, :name).
        should have_same_dom(%q{
          <div class="control triggerA">
            <div>i am trigger</div>
          </div>
        })
      end

      it "should render with block" do
        e_control(:trigger_b, :obj, :name) do |f|
          concat content_before
          concat '<div>i am trigger</div>'
          concat content_after
        end.
        should have_same_dom(%q{
          <div class="control triggerB">
            <span>before</span>
            <div>i am trigger</div>
            <span>after</span>
          </div>
        })
      end
    end

    describe "i18n label" do
      include FormForTesting

      before do
        I18n.backend.store_translations('en', {
          :shape => {:name => 'Shape name', :volume => 'Shape volume', :save => 'Save'},
          :ellipse => {:name => 'Ellipse name', :radiuses => 'Ellipse radiuses'},
          :circle => {:name => 'Circle name', :radius => 'Circle radius'},
          :baloon => {:name => 'Balloon name', :radius => 'Balloon radius'},
        })
      end

      it "should get labels for shape" do
        form_for(stub_model(Shape)) do |f|
          f.e_text_field(:name, :label => true) do |c|
            c.i18n_label_string.should == 'Shape name'
          end
          f.e_text_field(:volume, :label => true) do |c|
            c.i18n_label_string.should == 'Shape volume'
          end
          f.e_text_field(:radiuses, :label => true) do |c|
            c.i18n_label_string.should =~ /^translation missing/
          end
          f.e_text_field(:radius, :label => true) do |c|
            c.i18n_label_string.should =~ /^translation missing/
          end
          f.e_submit do |c|
            c.to_s.should have_same_dom(%q{<input name="commit" type="submit" value="Save" />})
          end
        end
      end

      it "should get labels for ellipse" do
        form_for(stub_model(Ellipse)) do |f|
          f.e_text_field(:name, :label => true) do |c|
            c.i18n_label_string.should == 'Ellipse name'
          end
          f.e_text_field(:volume, :label => true) do |c|
            c.i18n_label_string.should == 'Shape volume'
          end
          f.e_text_field(:radiuses, :label => true) do |c|
            c.i18n_label_string.should == 'Ellipse radiuses'
          end
          f.e_text_field(:radius, :label => true) do |c|
            c.i18n_label_string.should =~ /^translation missing/
          end
          f.e_submit do |c|
            c.to_s.should have_same_dom(%q{<input name="commit" type="submit" value="Save" />})
          end
        end
      end

      it "should get labels for ellipse" do
        form_for(stub_model(Circle)) do |f|
          f.e_text_field(:name, :label => true) do |c|
            c.i18n_label_string.should == 'Circle name'
          end
          f.e_text_field(:volume, :label => true) do |c|
            c.i18n_label_string.should == 'Shape volume'
          end
          f.e_text_field(:radiuses, :label => true) do |c|
            c.i18n_label_string.should == 'Ellipse radiuses'
          end
          f.e_text_field(:radius, :label => true) do |c|
            c.i18n_label_string.should == 'Circle radius'
          end
          f.e_submit do |c|
            c.to_s.should have_same_dom(%q{<input name="commit" type="submit" value="Save" />})
          end
        end
      end

      it "should use object_name first" do
        @baloon = stub_model(Circle)
        form_for(:baloon) do |f|
          f.e_text_field(:name, :label => true) do |c|
            c.i18n_label_string.should == 'Balloon name'
          end
          f.e_text_field(:volume, :label => true) do |c|
            c.i18n_label_string.should == 'Shape volume'
          end
          f.e_text_field(:radiuses, :label => true) do |c|
            c.i18n_label_string.should == 'Ellipse radiuses'
          end
          f.e_text_field(:radius, :label => true) do |c|
            c.i18n_label_string.should == 'Balloon radius'
          end
          f.e_submit do |c|
            c.to_s.should have_same_dom(%q{<input name="commit" type="submit" value="Save" />})
          end
        end
      end
    end

    describe "rendering e_text_field" do
      it "should render simple form" do
        e_text_field(:obj, :name).
        should have_same_dom(%q{
          <div class="control textField">
            <input id="obj_name" name="obj[name]" size="30" type="text" value="shape" />
          </div>
        })
      end

      it "should render with before and after" do
        e_text_field(:obj, :name, :before => content_before, :after => content_after).
        should have_same_dom(%q{
          <div class="control textField">
            <span>before</span>
            <input id="obj_name" name="obj[name]" size="30" type="text" value="shape" />
            <span>after</span>
          </div>
        })
      end

      it "should render with block" do
        e_text_field(:obj, :name) do |f|
          concat content_before
          concat f
          concat content_after
        end.
        should have_same_dom(%q{
          <div class="control textField">
            <span>before</span>
            <input id="obj_name" name="obj[name]" size="30" type="text" value="shape" />
            <span>after</span>
          </div>
        })
      end

      it "should assign class to div" do
        e_text_field(:obj, :name, :class => 'specialClass').
        should have_same_dom(%q{
          <div class="control textField specialClass">
            <input id="obj_name" name="obj[name]" size="30" type="text" value="shape" />
          </div>
        })
      end

      it "should create label" do
        e_text_field(:obj, :name, :label => 'text column label').
        should have_same_dom(%q{
          <div class="control textField">
            <label for="obj_name">text column label</label>
            <input id="obj_name" name="obj[name]" size="30" type="text" value="shape" />
          </div>
        })
      end

      it "should get label from I18n" do
        e_text_field(:obj, :name, :label => true).
        should have_same_dom(%q{
          <div class="control textField">
            <label for="obj_name">i18n text column label</label>
            <input id="obj_name" name="obj[name]" size="30" type="text" value="shape" />
          </div>
        })
      end

      it "should show error" do
        @errors.stub!(:on).and_return('error')
        e_text_field(:obj, :name).
        should have_same_dom(%q{
          <div class="control textField">
            <div class="fieldWithErrors">
              <input id="obj_name" name="obj[name]" size="30" type="text" value="shape" />
            </div>
            <div class="formError">error</div>
          </div>
        })
      end

      it "should show errors" do
        @errors.stub!(:on).and_return(['error a', 'error b'])
        e_text_field(:obj, :name).
        should have_same_dom(%q{
          <div class="control textField">
            <div class="fieldWithErrors">
              <input id="obj_name" name="obj[name]" size="30" type="text" value="shape" />
            </div>
            <ul class="formErrors">
              <li class="formError">error a</li>
              <li class="formError">error b</li>
            </ul>
          </div>
        })
      end
    end

    describe "rendering e_text_area" do
      it "should render" do
        e_text_area(:obj, :name, :class => 'specialClass', :label => true) do |f|
          concat content_before
          concat f
          concat content_after
        end.
        should have_same_dom(%q{
          <div class="control textArea specialClass">
            <span>before</span>
            <label for="obj_name">i18n text column label</label>
            <textarea id="obj_name" name="obj[name]" cols="40" rows="20">shape</textarea>
            <span>after</span>
          </div>
        })
      end
    end

    describe "rendering e_password_field" do
      it "should render without value" do
        e_password_field(:obj, :name, :class => 'specialClass', :label => true) do |f|
          concat content_before
          concat f
          concat content_after
        end.
        should have_same_dom(%q{
          <div class="control passwordField specialClass">
            <span>before</span>
            <label for="obj_name">i18n text column label</label>
            <input id="obj_name" name="obj[name]" size="30" type="password" value="" />
            <span>after</span>
          </div>
        })
      end

      it "should render with value when it is set to true" do
        e_password_field(:obj, :name, :value => true).
        should have_same_dom(%q{
          <div class="control passwordField">
            <input id="obj_name" name="obj[name]" size="30" type="password" value="shape" />
          </div>
        })
      end

      it "should render with value when it is set" do
        e_password_field(:obj, :name, :value => 'pass').
        should have_same_dom(%q{
          <div class="control passwordField">
            <input id="obj_name" name="obj[name]" size="30" type="password" value="pass" />
          </div>
        })
      end
    end

    describe "rendering e_file_field" do
      it "should render" do
        e_file_field(:obj, :name, :class => 'specialClass', :label => true) do |f|
          concat content_before
          concat f
          concat content_after
        end.
        should have_same_dom(%q{
          <div class="control fileField specialClass">
            <span>before</span>
            <label for="obj_name">i18n text column label</label>
            <input id="obj_name" name="obj[name]" size="30" type="file" />
            <span>after</span>
          </div>
        })
      end
    end

    describe "rendering e_check_box" do
      it "should render" do
        e_check_box(:obj, :name, :class => 'specialClass', :label => true) do |f|
          concat content_before
          concat f
          concat content_after
        end.
        should have_same_dom(%q{
          <div class="control checkBox specialClass">
            <span>before</span>
            <input name="obj[name]" type="hidden" value="0" />
            <input id="obj_name" name="obj[name]" type="checkbox" value="1" />
            <label for="obj_name">i18n text column label</label>
            <span>after</span>
          </div>
        })
      end
    end

    describe "rendering e_submit" do
      before do
        I18n.backend.store_translations('en', {:obj => {:create => 'create', :save => 'save'}})
      end

      it "should get text from I18n obj.create without arguments when object is new" do
        @obj.stub!(:new_record?).and_return(true)
        e_submit(:obj).
        should have_same_dom(%q{
          <div class="control submit">
            <input name="commit" type="submit" value="create" />
          </div>
        })
      end

      it "should get text from I18n obj.save without arguments when object is not new" do
        @obj.stub!(:new_record?).and_return(false)
        e_submit(:obj).
        should have_same_dom(%q{
          <div class="control submit">
            <input name="commit" type="submit" value="save" />
          </div>
        })
      end

      it "should assign class to div" do
        @obj.stub!(:new_record?).and_return(false)
        e_submit(:obj, nil, :class => 'coolSubmitButton').
        should have_same_dom(%q{
          <div class="control submit coolSubmitButton">
            <input name="commit" type="submit" value="save" />
          </div>
        })
      end

      it "should accept options also as second argument" do
        @obj.stub!(:new_record?).and_return(false)
        e_submit(:obj, :class => 'coolSubmitButton').
        should have_same_dom(%q{
          <div class="control submit coolSubmitButton">
            <input name="commit" type="submit" value="save" />
          </div>
        })
      end
    end
  end

  describe "with form_for" do
    include FormForTesting

    it "should call e_control" do
      self.should_receive(:e_control).with(:trigger_a, :obj, "name", hash_including(:object)).and_return('')
      form_for(:obj) do |f|
        concat f.e_control(:trigger_a, 'name')
      end
    end

    %w(e_text_field e_text_area e_password_field e_file_field e_check_box).each do |helper|
      it "should call #{helper}" do
        self.should_receive(helper.to_sym).with(:obj, "name", hash_including(:object)).and_return('')
        form_for(:obj) do |f|
          concat f.send(helper, 'name')
        end
      end
    end

    describe "calling e_submit" do
      it "should call without arguments" do
        self.should_receive(:e_submit).with(:obj, nil, hash_including(:object)).and_return('')
        form_for(:obj) do |f|
          concat f.e_submit
        end
      end

      it "should call with options" do
        self.should_receive(:e_submit).with(:obj, nil, hash_including(:object, :class => 'superSubmit')).and_return('')
        form_for(:obj) do |f|
          concat f.e_submit(:class => 'superSubmit')
        end
      end

      it "should call with string and options" do
        self.should_receive(:e_submit).with(:obj, 'hello', hash_including(:object, :class => 'superSubmit')).and_return('')
        form_for(:obj) do |f|
          concat f.e_submit('hello', :class => 'superSubmit')
        end
      end
    end

    it "should call error_messages_on" do
      self.should_receive(:error_messages_on).with(:obj, "name", {}).and_return('')
      form_for(:obj) do |f|
        concat f.error_messages_on('name')
      end
    end
  end
end
