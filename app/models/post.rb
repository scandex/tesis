class Post
    include Mongoid::Document
    store_in collection: "edx2"
    field :response, type: String
    field :user, type: String
    field :votes, type: String
   field :rank, type: Integer
    
     embeds_many :comments, class_name: "Comment"
      paginates_per 5
end