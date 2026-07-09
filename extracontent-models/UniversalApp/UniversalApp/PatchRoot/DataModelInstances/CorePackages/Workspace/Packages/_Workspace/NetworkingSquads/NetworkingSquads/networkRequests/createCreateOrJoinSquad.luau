local Parent = script:FindFirstAncestor("NetworkingSquads").Parent
local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)

require(script.Parent.Parent.networkingSquadTypes)

local FFlagEnableScheduledSquads = require(Parent.SharedFlags).FFlagEnableScheduledSquads

return function(p1) -- line: 10
	-- upvalues: SQUAD_URL (copy), FFlagEnableScheduledSquads (copy)
	local roduxNetworking = p1.roduxNetworking
	local t1 = nil
	local v7 = roduxNetworking.POST({
		Name = "CreateOrJoinSquad"
	}, function(p2, p3) -- line: 16
		-- upvalues: p1 (copy), t1 (ref), SQUAD_URL (copy), FFlagEnableScheduledSquads (copy)
		if p1.useMockedResponse then
			t1 = {
				responseBody = {
					groupUp = {
						groupUpId = "20000000-0000-0000-0000-000000000000",
						initiatorId = 3447631062,
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

		return p2(SQUAD_URL):path("group-up"):path("v1"):path("join-or-create-for-channel"):body({
			parentChannelId = p3.parentChannelId,
			leaveExisting = p3.leaveExisting,
			squadLocation = p3.squadLocation,
			partyAttemptId = p3.partyAttemptId,
			scheduledGroupUpId = if not FFlagEnableScheduledSquads then nil else p3.scheduledSquadId
		})
	end)

	if p1.useMockedResponse then
		v7.Mock.clear()
		v7.Mock.reply(function() -- line: 69
			-- upvalues: t1 (ref)
			return t1
		end)
	end

	return v7
end
