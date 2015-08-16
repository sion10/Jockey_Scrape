class Race
  include Mongoid::Document
  field :distance, type: String
  field :date, type: String
  field :racenumber, type: Integer
  field :rank, type: String
  field :number, type: String
  field :horse, type: String
  field :jockey, type: String
  field :trainer, type: String
  field :actualweight, type: Integer
  field :horseweight, type: Integer
  field :draw, type: String
  field :lbw, type: String
  field :finishtime, type: String
  field :odd, type: Float
end
