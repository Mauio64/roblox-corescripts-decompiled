local HttpService = game:GetService("HttpService")

local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)
require(script.Parent.Parent.networkingSquadTypes)

return function(p)
	local v = nil
	local post = p.roduxNetworking.POST("SquadInvite", function(callback, data)
		if p.useMockedResponse then
			v = {
				responseBody = {
					channelUpgraded = false,
					parentChannelId = data.parentChannelId,
					results = {
						{
							userId = 3447631062,
							resultStatus = { resultType = "success", message = "message" }
						}
					}
				}
			}
		end

		return callback(SQUAD_URL):path("group-up"):path("v1"):path("invite"):body({
			groupUpId = data.squadId,
			invitedUserIds = data.invitedUserIds,
			parentChannelId = data.parentChannelId,
			isReparented = data.isReparented,
			requestId = HttpService:GenerateGUID()
		})
	end)

	if p.useMockedResponse then
		post.Mock.clear()
		post.Mock.reply(function()
			return v
		end)
	end

	return post
end
