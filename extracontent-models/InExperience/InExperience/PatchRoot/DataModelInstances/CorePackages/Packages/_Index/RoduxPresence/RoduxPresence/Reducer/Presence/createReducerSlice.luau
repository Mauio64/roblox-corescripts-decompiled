local RoduxPresence = script:FindFirstAncestor("RoduxPresence")
local parent = RoduxPresence.Parent
local Cryo = require(parent.Cryo)

local getDeepValue = require(RoduxPresence.getDeepValue)

local Actions = RoduxPresence.Actions
local ReceivedUserPresence = require(Actions.ReceivedUserPresence)

return function(p, p2, p3)
	local presenceNetworking = p3.presenceNetworking

	local function handlePresenceModel(p4, p5)
		local joined = p4[p]
		local userId = tostring(p5.userId)

		local deepValue = getDeepValue(p4, string.format("byUserId.%s.%s", userId, p2))

		if deepValue and joined[deepValue] then
			local v = tostring(deepValue)
			joined = Cryo.Dictionary.join(joined, {
				[v] = Cryo.List.removeValue(joined[v], userId)
			})
		end

		local v = joined[p5[p2]]

		if v and table.find(v, userId) then
			return joined
		end

		return Cryo.Dictionary.join(joined, {
			[tostring(p5[p2])] = Cryo.List.join(v or {}, { userId })
		})
	end

	return function(p4, data)
		assert(p4, "state should not be nil")

		if data.type == ReceivedUserPresence.name then
			return handlePresenceModel(p4, data.payload)
		end

		if data.type ~= presenceNetworking.GetPresencesFromUserIds.Succeeded.name then
			return p4[p]
		end

		local userPresences = data.responseBody.userPresences

		local v = p4[p]

		for _, userPresence in ipairs(userPresences) do
			v = handlePresenceModel(p4, userPresence)
		end

		return v
	end
end
