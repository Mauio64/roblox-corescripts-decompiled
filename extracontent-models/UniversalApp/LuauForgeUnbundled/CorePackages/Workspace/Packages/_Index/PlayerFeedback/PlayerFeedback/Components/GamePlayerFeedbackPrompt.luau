local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/UIBlox")
local inlinePrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/AppBlox").InlinePrompt
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/Localization").Hooks.useLocalization
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/RobloxAppHooks")
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/RoactServiceTags")
local useRoactService = RobloxAppHooks.useRoactService
local appEventIngestService = RoactServiceTags.AppEventIngestService
local PlayerFeedbackEvents = require("@game/CorePackages/Workspace/Packages/_Index/PlayerFeedback/PlayerFeedback/Analytics/Events/PlayerFeedbackEvents")
local getFFlagEdpPlayerFeedbackPromptTitleOnly = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/SharedFlags").GetFFlagEdpPlayerFeedbackPromptTitleOnly
local images = UIBlox.App.ImageSet.Images
local standardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local buttonType = UIBlox.App.Button.Enum.ButtonType

local function GamePlayerFeedbackPrompt(props)
	local v5 = useLocalization({
		buttonLabelKey = "PlayerFeedbacks.VoteForm.PromptBanner.GiveFeedbackButton",
		messageKey = "PlayerFeedbacks.VoteForm.PromptBanner.Message",
		titleKey = "PlayerFeedbacks.VoteForm.PromptBanner.Title",
		titleOnlyKey = getFFlagEdpPlayerFeedbackPromptTitleOnly() and "PlayerFeedbacks.VoteForm.PromptBanner.TitleOnly" or nil
	})

	local v6 = useRoactService(appEventIngestService)
	local v7 = React.useCallback(function()
		PlayerFeedbackEvents.ClickPlayerFeedbackPromptCta(v6, props.placeId)
		props.onButtonClick()
	end, { v6, props.placeId, props.onButtonClick })

	local v8 = React.useCallback(function()
		PlayerFeedbackEvents.DismissPlayerFeedbackPrompt(v6, props.placeId)
		props.onDimiss()
	end, { v6, props.placeId, props.onDimiss })

	React.useEffect(function()
		PlayerFeedbackEvents.PlayerFeedbackPromptMounted(v6, props.placeId)
	end, { v6, props.placeId })

	local createElement = React.createElement
	local v10 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = 0,
		LayoutOrder = 0
	}
	local v11 = if props.width then UDim2.new(0, props.width, 0, 0) else UDim2.new(1, 0, 0, 0)
	v10.Size = v11
	v10.LayoutOrder = props.LayoutOrder

	local createElement2 = React.createElement
	local v15 = if not getFFlagEdpPlayerFeedbackPromptTitleOnly() then images["icons/menu/platformChatOff"] else nil
	local v16 = if getFFlagEdpPlayerFeedbackPromptTitleOnly() then v5.titleOnlyKey else v5.titleKey
	local v17 = if not getFFlagEdpPlayerFeedbackPromptTitleOnly() then v5.messageKey else nil
	return createElement("Frame", v10, {
		InlinePrompt = createElement2(inlinePrompt, {
			iconImage = v15,
			titleMessage = v16,
			sublineMessage = v17,
			buttonProps = {
				text = v5.buttonLabelKey,
				buttonType = buttonType.Secondary,
				standardSize = standardButtonSize.XSmall,
				onActivated = v7
			},
			showDismiss = true,
			onDismiss = v8,
			backgroundTransparency = props.backgroundTransparency,
			backgroundColor3 = props.backgroundColor3
		})
	})
end

return GamePlayerFeedbackPrompt
