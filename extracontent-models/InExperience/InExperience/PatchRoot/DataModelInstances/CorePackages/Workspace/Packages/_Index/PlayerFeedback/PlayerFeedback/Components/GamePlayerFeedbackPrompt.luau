local PlayerFeedback = script:FindFirstAncestor("PlayerFeedback")
local PlayerFeedbackParent = PlayerFeedback.Parent
local React = require(PlayerFeedbackParent.React)
local UIBlox = require(PlayerFeedbackParent.UIBlox)
local InlinePrompt = require(PlayerFeedbackParent.AppBlox).InlinePrompt
local useLocalization = require(PlayerFeedbackParent.Localization).Hooks.useLocalization
local RobloxAppHooks = require(PlayerFeedbackParent.RobloxAppHooks)
local RoactServiceTags = require(PlayerFeedbackParent.RoactServiceTags)
local useRoactService = RobloxAppHooks.useRoactService
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local PlayerFeedbackEvents = require(PlayerFeedback.Analytics.Events.PlayerFeedbackEvents)
local GetFFlagEdpPlayerFeedbackPromptTitleOnly = require(PlayerFeedbackParent.SharedFlags).GetFFlagEdpPlayerFeedbackPromptTitleOnly
local Images = UIBlox.App.ImageSet.Images
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local function GamePlayerFeedbackPrompt(t1: {[any]: any}) -- line: 26
	-- upvalues: useLocalization (copy), GetFFlagEdpPlayerFeedbackPromptTitleOnly (copy), useRoactService (copy), AppEventIngestService (copy), React (copy), PlayerFeedbackEvents (copy), InlinePrompt (copy), Images (copy), ButtonType (copy), StandardButtonSize (copy)
	local v18 = useLocalization({
		buttonLabelKey = "PlayerFeedbacks.VoteForm.PromptBanner.GiveFeedbackButton",
		messageKey = "PlayerFeedbacks.VoteForm.PromptBanner.Message",
		titleKey = "PlayerFeedbacks.VoteForm.PromptBanner.Title",
		titleOnlyKey = if not GetFFlagEdpPlayerFeedbackPromptTitleOnly() then nil else "PlayerFeedbacks.VoteForm.PromptBanner.TitleOnly"
	})
	local v19 = useRoactService(AppEventIngestService)
	local v20 = React.useCallback(function() -- line: 36
		-- upvalues: PlayerFeedbackEvents (copy), v19 (copy), t1 (copy)
		PlayerFeedbackEvents.ClickPlayerFeedbackPromptCta(v19, t1.placeId)
		t1.onButtonClick()
	end, {
		v19,
		t1.placeId,
		t1.onButtonClick
	})
	local v21 = React.useCallback(function() -- line: 41
		-- upvalues: PlayerFeedbackEvents (copy), v19 (copy), t1 (copy)
		PlayerFeedbackEvents.DismissPlayerFeedbackPrompt(v19, t1.placeId)
		t1.onDimiss()
	end, {
		v19,
		t1.placeId,
		t1.onDimiss
	})

	React.useEffect(function() -- line: 46
		-- upvalues: PlayerFeedbackEvents (copy), v19 (copy), t1 (copy)
		PlayerFeedbackEvents.PlayerFeedbackPromptMounted(v19, t1.placeId)
	end, {
		v19,
		t1.placeId
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = if not t1.width then UDim2.new(1, 0, 0, 0) else UDim2.new(0, t1.width, 0, 0),
		LayoutOrder = t1.LayoutOrder
	}, {
		InlinePrompt = React.createElement(InlinePrompt, {
			showDismiss = true,
			iconImage = if not GetFFlagEdpPlayerFeedbackPromptTitleOnly() then Images["icons/menu/platformChatOff"] else nil,
			titleMessage = if not GetFFlagEdpPlayerFeedbackPromptTitleOnly() then v18.titleKey else v18.titleOnlyKey,
			sublineMessage = if not GetFFlagEdpPlayerFeedbackPromptTitleOnly() then v18.messageKey else nil,
			buttonProps = {
				text = v18.buttonLabelKey,
				buttonType = ButtonType.Secondary,
				standardSize = StandardButtonSize.XSmall,
				onActivated = v20
			},
			onDismiss = v21,
			backgroundTransparency = t1.backgroundTransparency,
			backgroundColor3 = t1.backgroundColor3
		})
	})
end

return GamePlayerFeedbackPrompt
