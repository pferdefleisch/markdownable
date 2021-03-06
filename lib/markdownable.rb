require 'redcarpet'
require 'markdownable/version'

module Markdownable
  module ClassMethods
    def markdownable(*fields)
      fields.each do |field|
        define_method "#{field}_markdown" do
          renderer = Redcarpet::Render::HTML.new(:hard_wrap => true)
          markdown = Redcarpet::Markdown.new(renderer,
                                       :autolink => true,
                                       :lax_html_blocks => true)
          text = self.send(field)
          markdown.render(text) unless text.nil?
        end
      end
    end
  end

  def self.included(receiver)
    receiver.extend ClassMethods
  end
end

if defined? ActiveRecord::Base
  ActiveRecord::Base.send :include, Markdownable
end
