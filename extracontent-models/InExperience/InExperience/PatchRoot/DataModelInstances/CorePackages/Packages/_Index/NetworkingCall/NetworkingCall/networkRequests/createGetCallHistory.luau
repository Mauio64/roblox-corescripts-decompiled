local CALL_URL = require(script.Parent.Parent.CALL_URL)
require(script.Parent.Parent.networkingCallTypes)

return function(p)
	return (p.roduxNetworking.GET({ Name = "GetCallHistory" }, function(callback, data)
		local path = callback(CALL_URL):path("call"):path("v1"):path("get-call-history")
		local universeId

		if data then
			universeId = data.universeId
		end

		local limit

		if data then
			limit = data.limit
		end

		local cursor

		if data then
			cursor = data.cursor
		end

		return path:queryArgs({ universeId = universeId, limit = limit, cursor = cursor })
	end))
end
