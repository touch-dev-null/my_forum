require 'rails_helper'

module MyForum
  RSpec.describe PostsHelper, type: :helper do
    describe 'Youtube' do
      it 'should parse youtube links' do
        {
          'some text https://www.youtube.com/watch?v=HX-Jz3GESM0 text'  => "some text <iframe width='560' height='315' src='https://www.youtube.com/embed/HX-Jz3GESM0' frameborder='0' allowfullscreen></iframe> text",
          'some text https://www.youtube.com/watch?v=IEmU6Oqpx7E text'  => "some text <iframe width='560' height='315' src='https://www.youtube.com/embed/IEmU6Oqpx7E' frameborder='0' allowfullscreen></iframe> text",
          'some text http://youtu.be/croRTTsFtdw'                       => "some text <iframe width='560' height='315' src='https://www.youtube.com/embed/croRTTsFtdw' frameborder='0' allowfullscreen></iframe>",
          'http://www.youtube.com/watch?v=TsDbnX_YgU4#ws'               => "<iframe width='560' height='315' src='https://www.youtube.com/embed/TsDbnX_YgU4' frameborder='0' allowfullscreen></iframe>#ws"

        }.each do |text, formatted_text|
          expect(format_bbcode(text.dup)).to eq formatted_text
        end
      end

    end

    def emoticons_list
      []
    end
  end
end
