local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)

require(script.Parent.Parent.networkingSquadTypes)

return function(p1) -- line: 5
	-- upvalues: SQUAD_URL (copy)
	local v3 = p1.roduxNetworking.POST({
		Name = "LeaveSquad"
	}, function(p2, p3) -- line: 10
		-- upvalues: SQUAD_URL (copy)
		return p2(SQUAD_URL):path("group-up"):path("v1"):path("leave"):body({
			groupUpId = p3.squadId
		})
	end)

	if p1.useMockedResponse then
		v3.Mock.clear()
		v3.Mock.reply(function() -- line: 19
			return {
				responseBody = {}
			}
		end)
	end

	return v3
end
