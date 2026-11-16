local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)
require(script.Parent.Parent.networkingSquadTypes)

return function(p)
	local post = p.roduxNetworking.POST("LeaveSquad", function(callback, p2)
		return callback(SQUAD_URL):path("group-up"):path("v1"):path("leave"):body({
			groupUpId = p2.squadId
		})
	end)

	if p.useMockedResponse then
		post.Mock.clear()
		post.Mock.reply(function()
			return { responseBody = {} }
		end)
	end

	return post
end
