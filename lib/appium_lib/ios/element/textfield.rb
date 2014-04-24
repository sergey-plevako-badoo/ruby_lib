# encoding: utf-8
module Appium
  module Ios
    # Get an array of textfield texts.
    # Does not respect implicit wait because we're using execute_script.
    # @return [Array<String>]
    def textfields
      find_2_eles_attr :textfield, :secure, :text
    end

    # Get an array of textfield elements.
    # @return [Array<Textfield>]
    def e_textfields
      xpaths '//UIATextField | //UIASecureTextField'
    end

    # Get the first textfield element.
    # @return [Textfield]
    def first_textfield
      xpath '//UIATextField | //UIASecureTextField'
    end

    # Get the last textfield element.
    # @return [Textfield]
    def last_textfield
      xpath '//UIATextField[last()] | //UIASecureTextField[last()]'
    end

    # Get the first textfield that matches text.
    # @param text [String, Integer] the text to match exactly. If int then the textfield at that index is returned.
    # @return [Textfield]
    def textfield text
      # Don't use ele_index because that only works on one element type.
      # iOS needs to combine textfield and secure to match Android.
      if text.is_a? Numeric
        index = text
        raise "#{index} is not a valid xpath index. Must be >= 1" if index <= 0
        return xpath("//UIATextField[#{index}] | //UIASecureTextField[#{index}]")
      end

      textfield_include text
    end

    # Get the first textfield that includes text.
    # @param text [String] the text the textfield must include
    # @return [Textfield]
    def textfield_include text
      value = text.downcase
      attr = 'value' # not 'text'

      xpath "//UIATextField[contains(translate(@#{attr},'#{value.upcase}','#{value}'), '#{value}')] | " +
            "//UIASecureTextField[contains(translate(@#{attr},'#{value.upcase}', '#{value}'), '#{value}')]"
    end

    # Get the first textfield that exactly matches text.
    # @param text [String] the text the textfield must exactly match
    # @return [Textfield]
    def textfield_exact text
      attr = 'value'
      xpath "//UIATextField[@#{attr}='#{text}'] | //UIASecureTextField[@#{attr}='#{text}']"
    end

    # Get the first textfield that exactly matches name
    # https://github.com/appium/ruby_lib/issues/100
    # @return [Element]
    def textfield_named target_name
      result = find_element :name, target_name
      return result if result.tag_name == 'UIATextField'
      result = result.find_element :name, target_name
      raise "Name #{target_name} didn't match a textfield" if result.tag_name != 'UIATextField'
      result
    end
  end # module Ios
end # module Appium