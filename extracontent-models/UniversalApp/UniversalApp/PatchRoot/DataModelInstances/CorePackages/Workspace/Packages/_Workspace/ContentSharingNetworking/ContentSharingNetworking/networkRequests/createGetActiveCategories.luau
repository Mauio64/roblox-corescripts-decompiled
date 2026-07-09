local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

return function(t1: {[any]: any}) -- line: 4
	-- upvalues: API_URL (copy)
	return t1.roduxNetworking.GET({
		Name = "GetPostsByUserId"
	}, function(p1) -- line: 7
		-- upvalues: API_URL (copy)
		return p1(API_URL):path("posts-api"):path("v1"):path("content-posts"):path("getActiveCategories")
	end)
end
