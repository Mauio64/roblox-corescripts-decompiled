local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)
require(script.Parent.Parent.networkingSquadTypes)

return function(p)
	local v = nil
	local get = p.roduxNetworking.GET("GetSquadFromSquadId", function(callback, p2)
		if p.useMockedResponse then
			v = {
				responseBody = { groupUp = p2.mockedSquad }
			}
		end

		return callback(SQUAD_URL):path("group-up"):path("v1"):path("status"):queryArgs({
			groupUpId = p2.squadId
		})
	end)

	if p.useMockedResponse then
		get.Mock.clear()
		get.Mock.reply(function()
			return v
		end)
	end

	return get
end
