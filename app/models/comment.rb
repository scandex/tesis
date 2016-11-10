class Comment
    include Mongoid::Document
    store_in collection: "edx2"
    field :response, type: String
    field :user, type: String
    field :votes, type: String
    field :comments, type: String
    embedded_in :post, :inverse_of => :comments
end