local SQUAD_URL = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/SQUAD_URL")
require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkingSquadTypes")

return function(p2)
	local v5 = nil
	local get = p2.roduxNetworking.GET("GetSquadActive", function(callback, p3)
		if p2.useMockedResponse then
			v5 = {
				responseBody = { groupUp = p3.mockedSquad }
			}
		end

		return callback(SQUAD_URL):path("group-up"):path("v1"):path("active-status")
	end)

	if p2.useMockedResponse then
		get.Mock.clear()
		get.Mock.reply(function()
			return v5
		end)
	end

	return get
end
