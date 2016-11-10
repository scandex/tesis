class Post2
    include Mongoid::Document
    field :id, type: String
    field :response, type: String
   field :rank, type: Integer
    
    
      paginates_per 5
end