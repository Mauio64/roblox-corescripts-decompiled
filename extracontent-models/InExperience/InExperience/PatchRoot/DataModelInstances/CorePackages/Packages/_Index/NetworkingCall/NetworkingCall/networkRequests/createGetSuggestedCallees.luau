local CALL_URL = require(script.Parent.Parent.CALL_URL)
require(script.Parent.Parent.networkingCallTypes)

return function(p)
	return (p.roduxNetworking.GET({ Name = "GetSuggestedCallees" }, function(callback)
		return callback(CALL_URL):path("call"):path("v1"):path("get-suggested-callees")
	end))
end
