# Fluent::Plugin::AmazonSns

Fluent output plugin to send messages to Amazon SNS.

## Requirements

| fluent-plugin-amazon_sns | Fluentd     | Ruby   |
|--------------------------|------------ |--------|
| >= 0.1.0                 | >= v0.14.15 | >= 2.1 |
| < 0.1.0                  | >= v0.10.0  | >= 1.9 |

## Installation

    gem install fluent-plugin-amazon_sns

## Usage

```
<match sns.**>
  type amazon_sns

  flush_interval 1s

  # Optional add a {time} attribute to the record at the time of emit
  add_time_key true

  # Optional if you have AWS_* environment variables set up (via IAM Role etc.)
  aws_access_key_id AWS_ACCESS_KEY_ID
  aws_secret_access_key AWS_SECRET_ACCESS_KEY
  aws_region AWS_REGION # (e.g. ap-northeast-1)

  # One of the following options must be enabled to map topics

  ## 1) Fixed string
  topic_name MyTopic

  ## 2) Map fluent tags
  ## sns.App.MyTopic -> 'App-MyTopic'
  topic_map_tag true
  remove_tag_prefix sns

  ## 3) Map fluent message key
  ## maps 'topic' key in the message
  topic_map_key topic

  # SNS Message Subject, either fixed string or map message key
  subject SUBJECT_STRING
  subject_key SUBJECT_KEY

</match>
```

## Difference with fluent-plugin-sns

* Topic names are dynamically configurable, rather than static
* Buffered output 

## Contributing

1. Fork it ( http://github.com/<my-github-username>/fluent-plugin-amazon_sns/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Author

Tatsuhiko Miyagawa

The code is heavily inspired by: [ixixi/fluent-plugin-sns](https://github.com/ixixi/fluent-plugin-sns) and [norikra/fluent-plugin-norikra](https://github.com/norikra/fluent-plugin-norikra).
