local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
require(BuildExperience.Chat.useChatSessionCore)
require(BuildExperience.Components.ModelPicker.ModelPickerTypes)
local useCreatorCreditChatUpsellViewModel = require(BuildExperience.Components.BuildChatPage.useCreatorCreditChatUpsellViewModel)
require(BuildExperience.Components.BuildPillMenu.BuildPillMenuPageHost)

local function useChatSheetFundingRecovery(data, p, universeId: number?, placeId: number?, sessionId: string?)
	local state, setState = React.useState(false)
	local onOpenCreatorCreditPage = React.useCallback(function()
		local current = data.textBoxRef.current

		if current ~= nil then
			current.releaseFocus()
		end

		setState(true)
	end, { data.textBoxRef })
	local onClose = React.useCallback(function()
		setState(false)
	end, {})
	React.useEffect(function()
		setState(false)
	end, { universeId, sessionId })
	local fundingFailure = data.fundingFailure
	local v = {
		namedTier = p and p.selectedId == "advanced" and not (p.internalTesting and p.internalTesting.isSelected) and "advanced" or "default",
		isAssistantResponding = data.isAssistantResponding,
		outOfCreditsPromptFailureCount = 0,
		outOfCreditsPromptFailureReason = 0,
		onOpenCreatorCreditPage = 0
	}
	local outOfCreditsPromptFailureCount

	if fundingFailure then
		outOfCreditsPromptFailureCount = fundingFailure.count
	end

	v.outOfCreditsPromptFailureCount = outOfCreditsPromptFailureCount
	local outOfCreditsPromptFailureReason

	if fundingFailure then
		outOfCreditsPromptFailureReason = fundingFailure.reason
	end

	v.outOfCreditsPromptFailureReason = outOfCreditsPromptFailureReason

	if universeId == nil then
		onOpenCreatorCreditPage = nil
	end

	v.onOpenCreatorCreditPage = onOpenCreatorCreditPage
	return {
		card = useCreatorCreditChatUpsellViewModel(v),
		page = state and universeId ~= nil and {
			activePage = { type = "creator-credit" },
			target = {
				universeId = universeId,
				placeId = placeId,
				sessionId = sessionId,
				isNewGameTarget = false
			},
			onClose = onClose
		} or nil
	}
end

return useChatSheetFundingRecovery
