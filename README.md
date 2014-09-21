# Fbwish

Ruby Gem to automate facebook like &amp; comment on the birthday wishes using Graph API.

If you have alot of friends in your facebook network & when they wish you on your birthday, it's pretty cumbersome to reply to each one of them. So, we try to post a status message saying "Thank you all for the wishes !" instead, but that's not so programmery(Yeah, I just made that up). This gem helps you in automating all those likes & comments using facebook's graph API (using ruby gem koala).

## Installation

Add this line to your application's Gemfile:

    gem 'fbwish'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fbwish

## Usage

Getting your facebook access token

1. Goto [Graph API Explorer](https://developers.facebook.com/tools/explorer)
2. Click `Get Access Token`
3. Make sure only `publish_actions` & `read_stream` is checked under **Extended Permissions** tab. Also nothing should be checked under **User Data Permissions** tab.
4. Click `Get Access Token` button.
5. Allow access when a popup is displayed.
6. Copy the generated access token.

#### Final step
```ruby
require('fbwish')
wisher = Fbwish::Wisher.new({
    # A valid ruby regular expression based on the wishes you've received.
    matcher: /(happy)|(birthday)|(b[\']?day)|(B[\']?DAY)|(hbd)/i,
    # Set of replies that you'd like to wish
    replies: ["Thank you :D", "Thanks :D", "Thx a lot :-)", "Hey, thx !!! :-)","Thnk U !!!", "Hey Thanks ! :D "],
    access_token: "PASTE YOUR ACCESS TOKEN HERE",
    # Number of people who wished you on your birthday, you'll know this
    # on your timeline when facebook says "foo, bar & 254 others wished you"
    wish_count: 256
})
wisher.wish_em_all! # Sit back & relax ;-)
```

## Contributing

1. Fork it ( https://github.com/mudassir0909/fbwish/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
=======
fbwish
======
