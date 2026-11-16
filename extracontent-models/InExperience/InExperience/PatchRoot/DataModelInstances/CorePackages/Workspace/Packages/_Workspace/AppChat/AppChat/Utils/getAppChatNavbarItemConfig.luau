local parent = script:FindFirstAncestor("AppChat").Parent

local Foundation = require(parent.Foundation)

local UniversalAppPolicy = require(parent.UniversalAppPolicy)

return function()
	local getCanSeeChatTerminology = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology

	local udim = UDim2.new(0, 0, 0, 0)
	local label = getCanSeeChatTerminology() and "CommonUI.Features.Label.Chat" or "Feature.Squads.Label.Party"
	local icon

	if getCanSeeChatTerminology() then
		icon = Foundation.Enums.IconName.SpeechBubbleAlignCenter
	else
		icon = Foundation.Enums.IconName.TwoPeopleSpeechBubble
	end

	return { label = label, icon = icon, badgeOffset = udim }
end
