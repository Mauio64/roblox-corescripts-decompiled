local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)
require(script.Parent.Parent.networkingSquadTypes)

return function(p)
	local v = nil
	local post = p.roduxNetworking.POST("JoinSquad", function(callback, data)
		if p.useMockedResponse then
			v = {
				responseBody = {
					groupUp = {
						groupUpId = data.squadId,
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

		return callback(SQUAD_URL):path("group-up"):path("v1"):path("join"):body({
			groupUpId = data.squadId,
			leaveExisting = data.leaveExisting,
			squadLocation = data.squadLocation
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
