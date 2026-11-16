local RoduxPresence = script:FindFirstAncestor("RoduxPresence")
local parent = RoduxPresence.Parent
local Rodux = require(parent.Rodux)
local Cryo = require(parent.Cryo)

local Actions = RoduxPresence.Actions
local ReceivedUserPresence = require(Actions.ReceivedUserPresence)

local PresenceModel = require(RoduxPresence.Models.PresenceModel)

local v = {}
return function(p)
	local presenceNetworking = p.presenceNetworking

	return Rodux.createReducer(v, {
		[ReceivedUserPresence.name] = function(p2, p3)
			local userId = p3.payload.userId
			local payload = p3.payload

			assert(PresenceModel.isValid(payload))

			return Cryo.Dictionary.join(p2, { [userId] = PresenceModel.format(payload) })
		end,
		[presenceNetworking.GetPresencesFromUserIds.Succeeded.name] = function(p2, p3)
			local userPresences = p3.responseBody.userPresences

			local values = {}

			for _, userPresence in ipairs(userPresences) do
				values[tostring(userPresence.userId)] = PresenceModel.format(userPresence)
			end

			return Cryo.Dictionary.join(p2, values)
		end
	})
end
