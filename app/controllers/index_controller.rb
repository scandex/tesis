class IndexController < ApplicationController
	#before_action :verify_request_type
        def home
        #@post = Post.all.page params[:page]
        @concept = Concept.all.order('count DESC')
        
        
        @verbs = get_verbs
        @adjs = get_adjs
        @nouns=get_nouns
        #@post= get_post(nil,nil,nil,nil,params[:s1],params[:s2],params[:s3])
        @post=  Kaminari.paginate_array(get_post(nil,nil,nil,nil,1,1,1)).page params[:page]
        #render :partial => "post", :layout => false
        end
        
        def rpost
        	case request.method_symbol
			when :post
        		@concept = Concept.all.order('count DESC')
        		@verbs = get_verbs
        		@adjs = get_adjs
        		@nouns=get_nouns
        		#@post= get_post(nil,nil,nil,nil,params[:s1],params[:s2],params[:s3])
    			@post=  Kaminari.paginate_array(get_post(params[:con],params[:verb],params[:adj],params[:noun],params[:s1].to_f,params[:s2].to_f,params[:s3].to_f)).page params[:page]
        		render :partial => "post", :layout => false
        	when :get
        		@concept = Concept.all.order('count DESC')
        		@verbs = get_verbs
        		@adjs = get_adjs
        		@nouns=get_nouns
        		#@post= get_post(nil,nil,nil,nil,params[:s1],params[:s2],params[:s3])
    			@post=  Kaminari.paginate_array(get_post(params[:con],params[:verb],params[:adj],params[:noun],params[:s1].to_f,params[:s2].to_f,params[:s3].to_f)).page params[:page]
        		render :home
        	end
        end
        
        def get_verbs
            db = Mongoid::Clients.default
            collection = db["concepts2"]
            col = collection.aggregate([ 
                 
		{
			"$project"=> {
				"verbs"=> "$verbs"
			}
		},

	
		{
			"$unwind"=> "$verbs"
		},

		
		{
			"$project"=> {
				"_id"=>"$verbs._id" 
			}
		},

		
		{
			"$group"=> {
				"_id"=> "$_id",
				"count"=> {"$sum"=> 1}
			}
		},

	
		{
			"$sort"=> {
				"count"=>-1
			}
		},

	])
	results = col.map { |attrs| Word.instantiate(attrs) }
	return results
        end
        def get_adjs
                db = Mongoid::Clients.default
            collection = db["concepts2"]
            col = collection.aggregate([ 
                 
		{
			"$project"=> {
				"verbs"=> "$adjs"
			}
		},

	
		{
			"$unwind"=> "$verbs"
		},

		
		{
			"$project"=> {
				"_id"=>"$verbs._id" 
			}
		},

		
		{
			"$group"=> {
				"_id"=> "$_id",
				"count"=> {"$sum"=> 1}
			}
		},

	
		{
			"$sort"=> {
				"count"=>-1
			}
		},

	])
	results = col.map { |attrs| Word.instantiate(attrs) }
	return results
        end
        def get_nouns
                 db = Mongoid::Clients.default
            collection = db["concepts2"]
            col = collection.aggregate([ 
                 
		{
			"$project"=> {
				"verbs"=> "$nouns"
			}
		},

	
		{
			"$unwind"=> "$verbs"
		},

		
		{
			"$project"=> {
				"_id"=>"$verbs._id" 
			}
		},

		
		{
			"$group"=> {
				"_id"=> "$_id",
				"count"=> {"$sum"=> 1}
			}
		},

	
		{
			"$sort"=> {
				"count"=>-1
			}
		},

	])
	results = col.map { |attrs| Word.instantiate(attrs) }
	return results
        end
        
        def get_post(concepts,verbs,adjs,nouns,v,a,n)
        	
            db = Mongoid::Clients.default
            collection = db["edx2"]
            stages=[]
            tmp =[]
            unless concepts.nil?
            	concepts.each do |i|
            		tmp<< {"concepts.concepto"=> i}
            	end
            	#stages<<{}
            end
            unless verbs.nil? 
            	verbs.each do |i|
            		tmp<< {"verbs"=> i}
            	end
            end
            unless adjs.nil? 
            	adjs.each do |i|
            		tmp<< {"adjs"=> i}
            	end
            end
            unless nouns.nil? 
            	nouns.each do |i|
            		tmp<< {"nouns"=> i}
            	end
            end
            
            unless tmp.empty?
            	if params[:check].nil?
            	 stages<<{"$match"=>{"$or"=> tmp}}
            	else
            	stages<<{"$match"=>{"$and"=> tmp}}
            	end
            end
            stages<<
            {
			"$project"=> {
				"_id"=>1,
				"response"=>1, 
				"rank"=> {"$add"=>[{"$multiply"=>["$vweight",v]},{"$multiply"=>["$aweight",a]},{"$multiply"=>["$nweight",n]}]}
			}
		}
		stages<<
		{
			"$sort"=> {
				"rank"=> -1
			}
		}
        col = collection.aggregate(stages)
        results = col.map { |attrs| Post2.instantiate(attrs) }
	    return results
        end
end