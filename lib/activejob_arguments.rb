require 'activejob_arguments/version'

module ActivejobArguments
  module ClassAndMethodArguments
    def serialize_argument(argument)
      case argument
      when Class, Module
        {
          '_aj_type' => 'Class',
          'value' => argument.name
        }
      when Symbol
        {
          '_aj_type' => 'Symbol',
          'value' => argument.to_s
        }
      when Time # https://github.com/rails/rails/blob/11581afc01927565d57dd0e0156e983f92f8c2e0/activejob/lib/active_job/serializers/time_serializer.rb
        {
          '_aj_type' => 'Time',
          'value' => argument.iso8601(6)
        }
      when DateTime # https://github.com/rails/rails/blob/11581afc01927565d57dd0e0156e983f92f8c2e0/activejob/lib/active_job/serializers/date_time_serializer.rb
        {
          '_aj_type' => 'DateTime',
          'value' => argument.iso8601(6)
        }
      else
        super
      end
    end


    def deserialize_argument(argument)
      if argument.is_a? Hash
        return super unless argument['_aj_type'].present?
        case argument['_aj_type']
        when 'Class'
          argument['value'].constantize
        when 'Symbol'
          argument['value'].to_sym
        when 'Time'
          DateTime.iso8601(argument['value'])
        when 'DateTime'
          DateTime.iso8601(argument['value'])
        else
          super
        end
      else
        super
      end
    end
  end
end

require 'active_job/arguments'
require 'global_id'

# Fixes ActiveJob::Arguments so that we can serialize classes and symbols
# We should be able to convert this to custom serializers when these changes are released
# And Time and DateTime will be built-in
# https://github.com/rails/rails/blob/f5ac08180fbe3f4d9378f34e173f4ce1f8fc1a78/activejob/lib/active_job/serializers.rb#L50-L53

module ActiveJob
  Arguments.send :extend, ActivejobArguments::ClassAndMethodArguments
end
