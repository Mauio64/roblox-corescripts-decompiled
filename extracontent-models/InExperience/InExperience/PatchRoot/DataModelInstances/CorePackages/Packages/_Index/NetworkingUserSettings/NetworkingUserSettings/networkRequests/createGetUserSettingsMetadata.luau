local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

require(ParentParent.Types.networkRequestsTypes)

return function(p1) -- line: 5
	-- upvalues: API_URL (copy)
	return p1.roduxNetworking.GET(script, function(p2) -- line: 8
		-- upvalues: API_URL (copy)
		return p2(API_URL):path("user-settings-api"):path("v1"):path("user-settings"):path("metadata")
	end)
end
