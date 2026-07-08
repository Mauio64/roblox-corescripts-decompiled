local RoduxPresence = script:FindFirstAncestor("RoduxPresence")
local RoduxPresenceParent = RoduxPresence.Parent
local Rodux = require(RoduxPresenceParent.Rodux)
local Cryo = require(RoduxPresenceParent.Cryo)
local Actions = RoduxPresence.Actions
local ReceivedUserPresence = require(Actions.ReceivedUserPresence)
local PresenceModel = require(RoduxPresence.Models.PresenceModel)
local t1 = {}

return function(p1) -- line: 12
	-- upvalues: Rodux (copy), t1 (copy), ReceivedUserPresence (copy), PresenceModel (copy), Cryo (copy)
	local presenceNetworking = p1.presenceNetworking

	return Rodux.createReducer(t1, {
		[ReceivedUserPresence.name] = function(p2, p3) -- line: 16
			-- upvalues: PresenceModel (copy), Cryo (copy)
			local userId = p3.payload.userId
			local payload = p3.payload

			assert(PresenceModel.isValid(payload))

			return Cryo.Dictionary.join(p2, {
				[userId] = PresenceModel.format(payload)
			})
		end,
		[presenceNetworking.GetPresencesFromUserIds.Succeeded.name] = function(p4, p5) -- line: 27
			-- upvalues: PresenceModel (copy), Cryo (copy)
			local userPresences = p5.responseBody.userPresences
			local t2 = {}

			for _, v in ipairs(userPresences) do
				t2[tostring(v.userId)] = PresenceModel.format(v)
			end

			return Cryo.Dictionary.join(p4, t2)
		end
	})
end
