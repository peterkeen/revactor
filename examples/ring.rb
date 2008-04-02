require 'revactor'

NCHILDREN = 5
NAROUND = 5

class RingNode
  extend Actorize
  
  def initialize(next_node)
    loop do
      Actor.receive do |filter|
        filter.when(Object) do |msg|
          puts "#{Actor.current} got #{msg}"
          next_node << msg
        end
      end
    end
  end
end

next_node = Actor.current
NCHILDREN.times { next_node = RingNode.spawn(next_node) }

next_node << NAROUND

loop do
  Actor.receive do |filter|
    filter.when(Object) do |n|
      exit if n.zero?
      next_node << n - 1
    end
  end
end