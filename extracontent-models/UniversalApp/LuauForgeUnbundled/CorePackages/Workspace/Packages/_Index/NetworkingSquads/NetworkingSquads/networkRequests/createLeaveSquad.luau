local SQUAD_URL = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/SQUAD_URL")
require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkingSquadTypes")

return function(p2)
	local post = p2.roduxNetworking.POST("LeaveSquad", function(callback, p3)
		return callback(SQUAD_URL):path("group-up"):path("v1"):path("leave"):body({
			groupUpId = p3.squadId
		})
	end)

	if p2.useMockedResponse then
		post.Mock.clear()
		post.Mock.reply(function()
			return { responseBody = {} }
		end)
	end

	return post
end
