local CALL_URL = require(script.Parent.Parent.CALL_URL)

require(script.Parent.Parent.networkingCallTypes)

return function(p1) -- line: 5
	-- upvalues: CALL_URL (copy)
	return (p1.roduxNetworking.GET({
		Name = "GetSuggestedCallees"
	}, function(p2) -- line: 8
		-- upvalues: CALL_URL (copy)
		return p2(CALL_URL):path("call"):path("v1"):path("get-suggested-callees")
	end))
end
