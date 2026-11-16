local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy")

return function()
	local getCanSeeChatTerminology = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology

	local udim = UDim2.new(0, 0, 0, 0)
	local v5 = getCanSeeChatTerminology() and "CommonUI.Features.Label.Chat" or "Feature.Squads.Label.Party"

	local v6 = if getCanSeeChatTerminology() then Foundation.Enums.IconName.SpeechBubbleAlignCenter else Foundation.Enums.IconName.TwoPeopleSpeechBubble

	return { label = v5, icon = v6, badgeOffset = udim }
end
