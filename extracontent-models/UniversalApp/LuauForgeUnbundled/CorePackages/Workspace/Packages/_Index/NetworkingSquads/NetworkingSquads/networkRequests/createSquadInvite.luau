local HttpService = game:GetService("HttpService")

local SQUAD_URL = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/SQUAD_URL")
require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkingSquadTypes")

return function(p2)
	local v5 = nil
	local post = p2.roduxNetworking.POST("SquadInvite", function(callback, data)
		if p2.useMockedResponse then
			v5 = {
				responseBody = {
					channelUpgraded = false,
					parentChannelId = data.parentChannelId,
					results = {
						{
							userId = 3447631062,
							resultStatus = {
								resultType = "success",
								message = "message"
							}
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

	if p2.useMockedResponse then
		post.Mock.clear()
		post.Mock.reply(function()
			return v5
		end)
	end

	return post
end
