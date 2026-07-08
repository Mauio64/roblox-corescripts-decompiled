local CALL_URL = require(script.Parent.Parent.CALL_URL)

require(script.Parent.Parent.networkingCallTypes)

return function(p1) -- line: 5
	-- upvalues: CALL_URL (copy)
	return (p1.roduxNetworking.GET({
		Name = "GetCallHistory"
	}, function(p2, p3) -- line: 10
		-- upvalues: CALL_URL (copy)
		return p2(CALL_URL):path("call"):path("v1"):path("get-call-history"):queryArgs({
			universeId = if not p3 then nil else p3.universeId,
			limit = if not p3 then nil else p3.limit,
			cursor = if not p3 then nil else p3.cursor
		})
	end))
end
