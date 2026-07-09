local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)

require(script.Parent.Parent.networkingSquadTypes)

return function(p1) -- line: 5
	-- upvalues: SQUAD_URL (copy)
	local roduxNetworking = p1.roduxNetworking
	local t1 = nil
	local v5 = roduxNetworking.POST({
		Name = "JoinSquad"
	}, function(p2, p3) -- line: 11
		-- upvalues: p1 (copy), t1 (ref), SQUAD_URL (copy)
		if p1.useMockedResponse then
			t1 = {
				responseBody = {
					groupUp = {
						initiatorId = 3447631062,
						groupUpId = p3.squadId,
						createdAtTime = tostring(os.clock() * 1000),
						updatedAtTime = tostring(os.clock() * 1000),
						parentChannelId = p3.parentChannelId,
						members = {
							{
								userId = 3447631062,
								rank = 0
							},
							{
								userId = 2591622000,
								rank = 1
							},
							{
								userId = 3447649029,
								rank = 2
							},
							{
								userId = 3447641701,
								rank = 3
							},
							{
								userId = 3447635964,
								rank = 4
							},
							{
								userId = 3447642362,
								rank = 5
							}
						}
					}
				}
			}
		end

		return p2(SQUAD_URL):path("group-up"):path("v1"):path("join"):body({
			groupUpId = p3.squadId,
			leaveExisting = p3.leaveExisting,
			squadLocation = p3.squadLocation
		})
	end)

	if p1.useMockedResponse then
		v5.Mock.clear()
		v5.Mock.reply(function() -- line: 62
			-- upvalues: t1 (ref)
			return t1
		end)
	end

	return v5
end
