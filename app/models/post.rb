class Post
    include Mongoid::Document
    store_in collection: "Copy(1)_of_edx2"
    field :response, type: String
    field :user, type: String
    field :votes, type: String
   field :rank, type: Integer
   field :verbs, type: Array
   field :adjs, type: Array
   field :nouns, type: Array
   field :v_profile, type: Array
   field :a_profile, type: Array
   field :n_profile, type: Array
   
    
     embeds_many :comments, class_name: "Comment"
     embeds_many :concepts, class_name: "Concept2"
      #paginates_per 5
end