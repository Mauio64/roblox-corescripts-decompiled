local PlayerFeedback = script:FindFirstAncestor("PlayerFeedback")
local parent = PlayerFeedback.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local AppBlox = require(parent.AppBlox)
local InlinePrompt = AppBlox.InlinePrompt
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RoactServiceTags = require(parent.RoactServiceTags)
local useRoactService = RobloxAppHooks.useRoactService
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local PlayerFeedbackEvents = require(PlayerFeedback.Analytics.Events.PlayerFeedbackEvents)
local SharedFlags = require(parent.SharedFlags)
local GetFFlagEdpPlayerFeedbackPromptTitleOnly = SharedFlags.GetFFlagEdpPlayerFeedbackPromptTitleOnly
local Images = UIBlox.App.ImageSet.Images
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local function GamePlayerFeedbackPrompt(props)
	local v = useLocalization({
		buttonLabelKey = "PlayerFeedbacks.VoteForm.PromptBanner.GiveFeedbackButton",
		messageKey = "PlayerFeedbacks.VoteForm.PromptBanner.Message",
		titleKey = "PlayerFeedbacks.VoteForm.PromptBanner.Title",
		titleOnlyKey = GetFFlagEdpPlayerFeedbackPromptTitleOnly() and "PlayerFeedbacks.VoteForm.PromptBanner.TitleOnly" or nil
	})

	local v2 = useRoactService(AppEventIngestService)
	local onActivated = React.useCallback(function()
		PlayerFeedbackEvents.ClickPlayerFeedbackPromptCta(v2, props.placeId)
		props.onButtonClick()
	end, { v2, props.placeId, props.onButtonClick })

	local onDismiss = React.useCallback(function()
		PlayerFeedbackEvents.DismissPlayerFeedbackPrompt(v2, props.placeId)
		props.onDimiss()
	end, { v2, props.placeId, props.onDimiss })

	React.useEffect(function()
		PlayerFeedbackEvents.PlayerFeedbackPromptMounted(v2, props.placeId)
	end, { v2, props.placeId })

	local createElement = React.createElement
	local v3 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = 0,
		LayoutOrder = 0
	}
	local size

	if props.width then
		size = UDim2.new(0, props.width, 0, 0)
	else
		size = UDim2.new(1, 0, 0, 0)
	end

	v3.Size = size
	v3.LayoutOrder = props.LayoutOrder

	local createElement2 = React.createElement
	local iconImage

	if not GetFFlagEdpPlayerFeedbackPromptTitleOnly() then
		iconImage = Images["icons/menu/platformChatOff"]
	end

	local titleMessage

	if GetFFlagEdpPlayerFeedbackPromptTitleOnly() then
		titleMessage = v.titleOnlyKey
	else
		titleMessage = v.titleKey
	end

	local sublineMessage

	if not GetFFlagEdpPlayerFeedbackPromptTitleOnly() then
		sublineMessage = v.messageKey
	end

	return createElement("Frame", v3, {
		InlinePrompt = createElement2(InlinePrompt, {
			iconImage = iconImage,
			titleMessage = titleMessage,
			sublineMessage = sublineMessage,
			buttonProps = {
				text = v.buttonLabelKey,
				buttonType = ButtonType.Secondary,
				standardSize = StandardButtonSize.XSmall,
				onActivated = onActivated
			},
			showDismiss = true,
			onDismiss = onDismiss,
			backgroundTransparency = props.backgroundTransparency,
			backgroundColor3 = props.backgroundColor3
		})
	})
end

return GamePlayerFeedbackPrompt
