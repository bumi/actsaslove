module Railslove
  module ActsAsLove
    module Controller
      def self.included(base)
        base.alias_method_chain :process, :love
      end
  
      def process_with_love(request, response, *args, &block)
        result = process_without_love(request, response, *args, &block)
        give_some_love_to(response) if !request.xhr? && response.content_type && response.content_type.include?('html') && response.body && response.headers['Status'] && response.headers['Status'].include?('200')
        result
      end
  
      def give_some_love_to(response)
        if response.body =~ /<\/head>/im
          love = %q(
<style type="text/css">
body {
  background-image:url(http://railslove.com/img/heart.png);
}
body * {
  background-image:url(http://railslove.com/img/heart.png);
}
</style>
\1
)
          response.body.sub!(/(<\/head>)/im, love)
          response.headers["Content-Length"] = response.body.size
        end
      end
    end
  end
end