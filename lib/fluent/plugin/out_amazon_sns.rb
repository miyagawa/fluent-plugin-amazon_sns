require "aws-sdk-sns"

module Fluent
  class AmazonSNSOutput < BufferedOutput
    Fluent::Plugin.register_output('amazon_sns', self)

    include SetTagKeyMixin
    config_set_default :include_tag_key, false

    include SetTimeKeyMixin
    config_set_default :include_time_key, true

    config_param :aws_access_key_id, :string, default: nil
    config_param :aws_secret_access_key, :string, default: nil, secret: true
    config_param :aws_region, :string, default: ENV['AWS_REGION'] || ENV['AWS_DEFAULT_REGION'] || 'us-east-1'
    config_param :aws_proxy_uri, :string, default: ENV['HTTP_PROXY']

    config_param :subject_key, :string, default: nil
    config_param :subject, :string, default: nil

    config_param :topic_name, :string, default: nil
    config_param :topic_map_tag, :bool, default: false
    config_param :remove_tag_prefix, :string, default: nil
    config_param :topic_map_key, :string, default: nil

    def configure(conf)
      super

      @topic_generator = case
                         when @topic_name
                           ->(tag, record){ @topic_name }
                         when @topic_map_key
                           ->(tag, record){ record[@topic_map_key] }
                         when @topic_map_tag
                           ->(tag, record){ tag.gsub(/^#{@remove_tag_prefix}(\.)?/, '') }
                         else
                           raise Fluent::ConfigError, "no one way specified to decide target"
                         end
    end

    def start
      super

      options = {}
      [:access_key_id, :secret_access_key, :region].each do |key|
        options[key] = instance_variable_get "@aws_#{key}"
      end
      options[:http_proxy] = @aws_proxy_uri

      sns_client = Aws::SNS::Client.new(options)
      @sns = Aws::SNS::Resource.new(client: sns_client)
      @topics = get_topics
    end

    def shutdown
      super
    end

    def format(tag, time, record)
      [tag, time, record].to_msgpack
    end

    def write(chunk)
      chunk.msgpack_each do |tag, time, record|
        record["time"] = Time.at(time).localtime
        subject = record.delete(@subject_key) || @subject  || 'Fluent-Notification'
        topic = @topic_generator.call(tag, record)
        topic = topic.gsub(/\./, '-') if topic # SNS doesn't allow .
        if @topics[topic]
          @topics[topic].publish(message: record.to_json, subject: subject)
        else
          $log.error "Could not find topic '#{topic}' on SNS"
        end
      end
    end

    def get_topics
      @sns.topics.inject({}) do |product, topic|
        product[topic.arn.split(/:/).last] = topic
        product
      end
    end
  end
end
