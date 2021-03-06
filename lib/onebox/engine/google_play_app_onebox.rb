# frozen_string_literal: true

module Onebox
  module Engine
    class GooglePlayAppOnebox
      include Engine
      include LayoutSupport
      include HTML

      DEFAULTS = {
        MAX_DESCRIPTION_CHARS: 500
      }

      matches_regexp Regexp.new("^https?://play\\.(?:(?:\\w)+\\.)?(google)\\.com(?:/)?/store/apps/")
      always_https

      private

      def data
        price = raw.css("meta[itemprop=price]").first["content"] rescue "Free"
        result = {
          link: link,
          title: raw.css("meta[property='og:title']").first["content"].gsub(" - Apps on Google Play", ""),
          image: ::Onebox::Helpers.normalize_url_for_output(raw.css("meta[property='og:image']").first["content"]),
          description: raw.css("meta[name=description]").first["content"][0..DEFAULTS[:MAX_DESCRIPTION_CHARS]].chop + "...",
          price: price
        }
        if result[:price] == "0"
          result[:price] = "Free"
        end
        result
      end
    end
  end
end
