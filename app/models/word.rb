class Word
    include Mongoid::Document
    field :id, type: String
    field :count, type: Integer
end