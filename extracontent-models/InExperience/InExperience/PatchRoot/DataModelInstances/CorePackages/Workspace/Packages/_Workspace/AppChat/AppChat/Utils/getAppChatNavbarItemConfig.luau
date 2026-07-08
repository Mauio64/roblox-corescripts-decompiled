local Parent = script:FindFirstAncestor("AppChat").Parent
local Foundation = require(Parent.Foundation)
local GetFFlagIsSquadEnabled = require(Parent.SharedFlags).GetFFlagIsSquadEnabled
local ArgoPartyExperimentation = require(Parent.SocialExperiments).ArgoPartyExperimentation
local UniversalAppPolicy = require(Parent.UniversalAppPolicy)

return function() -- line: 11
	-- upvalues: UniversalAppPolicy (copy), ArgoPartyExperimentation (copy), GetFFlagIsSquadEnabled (copy), Foundation (copy)
	local getCanSeeChatTerminology = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology
	local uDim2 = UDim2.new(0, 0, 0, 0)
	local v8 = if not ArgoPartyExperimentation.getIsRenameEnabled() then not GetFFlagIsSquadEnabled() and "CommonUI.Features.Label.Chat" or "Feature.Squads.Label.Party" else not getCanSeeChatTerminology() and "Feature.Squads.Label.Party" or "CommonUI.Features.Label.Chat"
	local v9 = if not ArgoPartyExperimentation.getIsRenameEnabled() then {
		on = "icons/menu/2-person-with-bubble-on",
		off = "icons/menu/2-person-with-bubble"
	} else Foundation.Enums.IconName.SpeechBubbleAlignCenter

	return {
		label = v8,
		icon = v9,
		badgeOffset = uDim2
	}
end
