local Players = game:GetService("Players")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RealtimeDelivery")
local fFlagEnablePartyNudgeAfterJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SharedFlags").FFlagEnablePartyNudgeAfterJoin

local function useOneToOnePartyNudgeStartPartyRejected(callback)
	if fFlagEnablePartyNudgeAfterJoin then
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
