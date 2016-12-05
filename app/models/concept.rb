class Concept
    include Mongoid::Document
    field :id, type: String
    field :concepto, type: String
    
    store_in collection: "concepts2"
    
end