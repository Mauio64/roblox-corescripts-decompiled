local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local Players = game:GetService("Players")

local Constants = require(SquadsCore.Common.Constants)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local SharedFlags = require(parent.SharedFlags)

local FFlagEnablePartyNudgeAfterJoin = SharedFlags.FFlagEnablePartyNudgeAfterJoin

local function useOneToOnePartyNudgeStartPartyRejected(callback)
	if FFlagEnablePartyNudgeAfterJoin then
		RealtimeDelivery.useRealtimeNamespace(Constants.PARTY_NUDGE_RTN_NAMESPACE, function(data)
			if
				Players.LocalPlayer
				and data.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE
				and data.inviteeId == Players.LocalPlayer.UserId
				and data.status == Constants.START_PARTY_REJECTED_STATUS
			then
				callback(data)
			end
		end, { callback })
	end
end

return useOneToOnePartyNudgeStartPartyRejected
