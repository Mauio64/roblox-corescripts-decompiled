local RoduxPresence = script:FindFirstAncestor("RoduxPresence")
local RoduxPresenceParent = RoduxPresence.Parent
local Cryo = require(RoduxPresenceParent.Cryo)
local getDeepValue = require(RoduxPresence.getDeepValue)
local Actions = RoduxPresence.Actions
local ReceivedUserPresence = require(Actions.ReceivedUserPresence)

return function(p1, p2, p3) -- line: 10
	-- upvalues: getDeepValue (copy), Cryo (copy), ReceivedUserPresence (copy)
	local presenceNetworking = p3.presenceNetworking

	local function handlePresenceModel(p4, p5) -- line: 13
		-- upvalues: p1 (copy), getDeepValue (copy), p2 (copy), Cryo (copy)
		local v14 = p4[p1]
		local str = tostring(p5.userId)
		local v16 = getDeepValue(p4, string.format("byUserId.%s.%s", str, p2))

		if v16 and v14[v16] then
			local str2 = tostring(v16)

			v14 = Cryo.Dictionary.join(v14, {
				[str2] = Cryo.List.removeValue(v14[str2], str)
			})
		end

		local v18 = v14[p5[p2]]

		if not v18 or not table.find(v18, str) then
			return Cryo.Dictionary.join(v14, {
				[tostring(p5[p2])] = Cryo.List.join(v18 or {}, { str })
			})
		end

		return v14
	end

	return function(p6, p7) -- line: 36
		-- upvalues: ReceivedUserPresence (copy), handlePresenceModel (copy), presenceNetworking (copy), p1 (copy)
		assert(p6, "state should not be nil")

		if p7.type == ReceivedUserPresence.name then
			return handlePresenceModel(p6, p7.payload)
		end

		if p7.type == presenceNetworking.GetPresencesFromUserIds.Succeeded.name then
			local userPresences = p7.responseBody.userPresences
			local v22 = p6[p1]

			for _, v in ipairs(userPresences) do
				v22 = handlePresenceModel(p6, v)
			end

			return v22
		end

		return p6[p1]
	end
end
