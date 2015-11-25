require_relative 'lib/hoegaathetmet'

# Create instance of DoodlePoll class and execute command
class HoeGaat
  include Cinch::Plugin

  match(/hoe (.*)/)

  def execute(msg, query)
    begin
      hoe = HoeGaatHetMet.new(query)
      msg.reply("#{hoe.name} is current #{hoe.headline}") if hoe
    rescue NoMethodError
      msg.reply("Nobody found with name: #{query}")
    end
  end
end