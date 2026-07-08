local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local Players = game:GetService("Players")
local Constants = require(SquadsCore.Common.Constants)
local RealtimeDelivery = require(SquadsCoreParent.RealtimeDelivery)
local FFlagEnablePartyNudgeAfterJoin = require(SquadsCoreParent.SharedFlags).FFlagEnablePartyNudgeAfterJoin

local function useOneToOnePartyNudgeStartPartyRejected(p1) -- line: 13
	-- upvalues: FFlagEnablePartyNudgeAfterJoin (copy), RealtimeDelivery (copy), Constants (copy), Players (copy)
	if FFlagEnablePartyNudgeAfterJoin then
		RealtimeDelivery.useRealtimeNamespace(Constants.PARTY_NUDGE_RTN_NAMESPACE, function(p2) -- line: 15
			-- upvalues: Players (copy), Constants (copy), p1 (copy)
			if Players.LocalPlayer and (p2.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE and p2.inviteeId == Players.LocalPlayer.UserId and p2.status == Constants.START_PARTY_REJECTED_STATUS) then
				p1(p2)
			end
		end, { p1 })
	end
end

return useOneToOnePartyNudgeStartPartyRejected
