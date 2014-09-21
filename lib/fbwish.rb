require "fbwish/version"
require "koala"

module Fbwish
  def initialize(options={})
    required_options = [:access_token, :matcher, :replies]
    unspecified_options = options.keys.reject{ |key| options[key] }

    unless unspecified_options.empty?
      raise ArgumentError("Following options are required: #{unspecified_options.join(', ')}")
    end

    self.graph = Koala::Facebook::API.new(options[:access_token])
    self.matcher = options[:matcher]
    self.replies = options[:replies]
  end

  def wish_em_all!
    wishes = nil

    1.upto(13) do |idx|
      wishes = wishes.next_page rescue graph.get_connections('me', 'feed')

      wishes.each do |wish|
        like_and_comment(wish)
      end
    end
  end

  private
    def like(wish)
      graph.put_like(wish['id'])
    end

    def comment(wish, replies)
      # If it is an array pick random else pick itself(assuming it is a string)
      reply = replies.is_a?(Array) ?
              replies[rand(replies.length-1)] :
              replies
      graph.put_comment(wish['id'], reply)
    end

    def like_and_comment(wish)
      if matcher.is_a?(Object)
        matcher.each do |locale, regex|
          if regex.match(wish['message'])
            like(wish)
            comment(wish, replies[locale])
          end
        end
      else
        if matcher.match(wish['message'])
          like(wish)
          comment(wish, replies)
        end
      end
    end
end