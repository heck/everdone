require 'everdone'

require 'minitest/autorun'

require 'everdone/enmlformatter.rb'

class EnmlFormatterTest < MiniTest::Unit::TestCase
    def setup
        @targ = Everdone::EnmlFormatter.new
    end

    def test_text
        # assert_equal "Hello World!", @main.hello
        added_text = "this is some text"
        @targ.text(added_text)
        assert_equal added_text, @targ.body
    end

    def test_rawtext_todoist_crap
        @targ.rawtext("Itâ€™s")
        assert_match "It's", @targ.body
    end

    def check_url_good(url_text)
        @targ.rawtext(url_text)
        assert_match "<a href='#{url_text}'>#{url_text}</a>", @targ.body
        @targ.clear
    end

    def check_url_bad(url_text)
        @targ.rawtext(url_text)
        refute_match "<a href=", @targ.body
        @targ.clear
    end

    def test_rawtext_url_links
        # the good
        check_url_good "http://www.google.com"
        check_url_good "https://www.google.com"
        check_url_good "http://code.tutsplus.com/tutorials/8-regular-expressions-you-should-know--net-6149"
        check_url_good "http://jira.nmwco.com:8080"
        check_url_good "http://jira.nmwco.com:8080/browse/LOC-6847"
        check_url_good "http://jira.nmwco.com:8080/browse/LOC-6847?filter=14192"
        check_url_good "https://d1x0mwiac2rqwt.cloudfront.net/fec77b1148704f78bdf87a49d0a6e6b3/as/2014-03-18_Performance_log_Olson%2C_Erik.docx"
        # the bad
        check_url_bad "www.google.com"
        check_url_bad "google.com"
        check_url_bad "Knopf@NetMotionWireless.com"
    end

    TESTING_DATETIME_FORMAT = "%a %e %b %Y %H:%M:%S %z"
    def test_datetimeToString
        assert_equal "Mon 10 Mar 2014 08:45", Everdone::EnmlFormatter.datetimeToString("Mon 10 Mar 2014 15:45:01 +0000", TESTING_DATETIME_FORMAT)
    end
end
