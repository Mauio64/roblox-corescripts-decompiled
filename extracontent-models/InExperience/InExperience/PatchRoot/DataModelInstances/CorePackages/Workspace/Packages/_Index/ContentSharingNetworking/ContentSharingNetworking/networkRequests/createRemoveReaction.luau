local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: API_URL (copy)
	return t1.roduxNetworking.POST({
		Name = "RemoveReaction"
	}, function(p1, t2: {[any]: any}) -- line: 17
		-- upvalues: API_URL (copy)
		return p1(API_URL):path("posts-api"):path("v1"):path("content-posts"):path("removeReaction"):body(t2)
	end)
end
