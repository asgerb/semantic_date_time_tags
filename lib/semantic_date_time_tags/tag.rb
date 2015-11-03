require 'action_view'
require 'i18n'

module SemanticDateTimeTags
  class Tag

    include ActionView::Helpers::DateHelper
    include ActionView::Helpers::TagHelper

    attr_accessor :obj
    attr_accessor :options
    attr_accessor :output_buffer

    # =====================================================================

    def initialize obj, options={}
      @obj = obj
      @options = options.tap{ |opts| opts.delete(:scope) }
    end

    # ---------------------------------------------------------------------

    def to_html
      raise NotImplementedError
    end

    # ---------------------------------------------------------------------

    def dom_classes
      [
        'semantic',
        type_class,
        current_date_class,
        current_year_class,
        whole_hour_class,
        whole_minute_class,
        options[:class]
      ].flatten.reject(&:blank?)
    end

    def type_class
      obj.class.to_s.underscore
    end

    def current_date_class
      return unless [::Date,::DateTime].any?{ |c| obj.instance_of? c }
      'current_date' if obj.today?
    end

    def current_year_class
      return unless [::Date,::DateTime].any?{ |c| obj.instance_of? c }
      'current_year' if obj.year == ::Date.today.year
    end

    def whole_hour_class
      return unless [::Time,::DateTime].any?{ |c| obj.instance_of? c }
      'whole_hour' unless obj.min > 0
    end

    def whole_minute_class
      return unless [::Time,::DateTime].any?{ |c| obj.instance_of? c }
      'whole_minute' unless obj.sec > 0
    end

    private # =============================================================

    def format_string
      I18n.t(scope)[format]
    end

    def format
      options.fetch :format, :full
    end

    def localized_obj
      I18n.l obj, format: format
    end

    def tag_name
      options.fetch :tag_name, :time
    end

  end
end
