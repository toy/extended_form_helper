ActiveRecord::Base.establish_connection :adapter  => 'sqlite3', :database => ':memory:'

class CreateSchema < ActiveRecord::Migration
  def self.up
    create_table :shapes, :force => true do |t|
      t.string :type
    end
  end
end

CreateSchema.suppress_messages { CreateSchema.migrate(:up) }

class Shape < ActiveRecord::Base
  def name
    'shape'
  end
end
class Ellipse < Shape
  def name
    'ellipse'
  end
end
class Circle < Ellipse
  def name
    'circle'
  end
end
