require "fbwish/version"
require "koala"

module Fbwish
  class Wisher

    attr_accessor :graph, :matcher, :replies, :wish_count, :verbose

    def initialize(options={})
      required_options = [:access_token, :matcher, :replies, :wish_count]
      unspecified_options = required_options.reject{ |key| options[key] }

      unless unspecified_options.empty?
        raise ArgumentError, "Following options are required: #{unspecified_options.join(', ')}"
      end

      self.graph = Koala::Facebook::API.new(options[:access_token])
      self.matcher = options[:matcher]
      self.replies = options[:replies]
      self.wish_count = options[:wish_count]
      self.verbose = options[:verbose] || false
    end

    def wish_em_all!
      wishes = nil
      iteration_count = (wish_count.to_f / 25).ceil

      1.upto(iteration_count) do |idx|
        wishes = wishes.next_page rescue graph.get_connections('me', 'feed')

        wishes.each do |wish|
          like_and_comment(wish)
        end
      end
    end

    def should_log?
      verbose
    end

    private
      def like_and_comment(wish)
        did_reply = false

        if matcher.is_a?(Hash)
          matcher.each do |locale, regex|
            did_reply = reply_if_match_found(regex, wish, replies[locale])
            break if did_reply
          end
        else
          reply_if_match_found(matcher, wish, replies)
        end
      end

      def reply_if_match_found(regex, wish, replies)
        if regex.match(wish['message'])
          like(wish)
          my_reply = comment(wish, replies)
          log_result(wish, my_reply) if should_log?

          true
        else
          log_failure(wish) if should_log?

          false
        end
      end

      def like(wish)
        graph.put_like(wish['id'])
      end

      def comment(wish, replies)
        # If it is an array pick random else pick itself(assuming it is a string)
        reply = replies.is_a?(Array) ?
                replies[rand(replies.length-1)] :
                replies
        reply = "#{wisher(wish)}: " + reply
        graph.put_comment(wish['id'], reply)

        return reply
      end

      def wisher(wish)
        wish['from']['name']
      end

      def log_result(wish, reply)
        puts "Liked & replied '#{reply}' to '#{wisher(wish)}'"
      end

      def log_failure(wish)
        puts "#{wisher(wish)}'s wish '#{wish["message"]}' did not match the pattern, Hence ignored."
      end
  end
end