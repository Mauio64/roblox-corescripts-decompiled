local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

return function(t1: {[any]: any}) -- line: 12
	-- upvalues: API_URL (copy)
	return t1.roduxNetworking.POST({
		Name = "DeletePost"
	}, function(p1, t2: {[any]: any}) -- line: 15
		-- upvalues: API_URL (copy)
		return p1(API_URL):path("posts-api"):path("v1"):path("content-posts"):path("delete"):id(t2.postId):body({})
	end)
end
