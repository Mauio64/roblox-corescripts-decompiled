local SQUAD_URL = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/SQUAD_URL")
require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkingSquadTypes")

return function(p2)
	local v5 = nil
	local post = p2.roduxNetworking.POST("CreateOrJoinSquad", function(callback, data)
		if p2.useMockedResponse then
			v5 = {
				responseBody = {
					groupUp = {
						groupUpId = "20000000-0000-0000-0000-000000000000",
						initiatorId = 3447631062,
						createdAtTime = tostring(os.clock() * 1000),
						updatedAtTime = tostring(os.clock() * 1000),
						parentChannelId = data.parentChannelId,
						members = {
							{ userId = 3447631062, rank = 0 },
							{ userId = 2591622000, rank = 1 },
							{ userId = 3447649029, rank = 2 },
							{ userId = 3447641701, rank = 3 },
							{ userId = 3447635964, rank = 4 },
							{ userId = 3447642362, rank = 5 }
						}
					}
				}
			}
		end

		return callback(SQUAD_URL):path("group-up"):path("v1"):path("join-or-create-for-channel"):body({
			parentChannelId = data.parentChannelId,
			leaveExisting = data.leaveExisting,
			squadLocation = data.squadLocation,
			partyAttemptId = data.partyAttemptId,
			scheduledGroupUpId = data.scheduledSquadId
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
