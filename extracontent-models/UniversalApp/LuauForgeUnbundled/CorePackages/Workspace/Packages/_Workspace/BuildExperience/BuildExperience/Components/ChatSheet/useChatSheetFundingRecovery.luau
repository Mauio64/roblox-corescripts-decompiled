local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useChatSessionCore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")
local useCreatorCreditChatUpsellViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildChatPage/useCreatorCreditChatUpsellViewModel")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildPillMenuPageHost")

local function useChatSheetFundingRecovery(data, p2, p3, p4, p5)
	local state, setState = React.useState(false)
	local v5 = React.useCallback(function()
		local current = data.textBoxRef.current

		if current ~= nil then
			current.releaseFocus()
		end

		setState(true)
	end, { data.textBoxRef })
	local v6 = React.useCallback(function()
		setState(false)
	end, {})
	React.useEffect(function()
		setState(false)
	end, { p3, p5 })
	local fundingFailure = data.fundingFailure
	local v8 = {
		namedTier = p2 and p2.selectedId == "advanced" and not (p2.internalTesting and p2.internalTesting.isSelected) and "advanced" or "default",
		isAssistantResponding = data.isAssistantResponding,
		outOfCreditsPromptFailureCount = 0,
		outOfCreditsPromptFailureReason = 0,
		onOpenCreatorCreditPage = 0
	}
	local v9 = if fundingFailure then fundingFailure.count else nil
	v8.outOfCreditsPromptFailureCount = v9
	local v10 = if fundingFailure then fundingFailure.reason else nil
	v8.outOfCreditsPromptFailureReason = v10

	if p3 == nil then
		v5 = nil
	end

	v8.onOpenCreatorCreditPage = v5
	return {
		card = useCreatorCreditChatUpsellViewModel(v8),
		page = state and p3 ~= nil and {
			activePage = { type = "creator-credit" },
			target = {
				universeId = p3,
				placeId = p4,
				sessionId = p5,
				isNewGameTarget = false
			},
			onClose = v6
		} or nil
	}
end

return useChatSheetFundingRecovery
