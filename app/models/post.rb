class Post
    include Mongoid::Document
    store_in collection: "edx2"
    field :response, type: String
    field :user, type: String
    field :votes, type: String
   field :rank, type: Integer
   field :verbs, type: Array
   field :adjs, type: Array
   field :nouns, type: Array
   
    
     embeds_many :comments, class_name: "Comment"
     embeds_many :concepts, class_name: "Concept"
      paginates_per 5
end