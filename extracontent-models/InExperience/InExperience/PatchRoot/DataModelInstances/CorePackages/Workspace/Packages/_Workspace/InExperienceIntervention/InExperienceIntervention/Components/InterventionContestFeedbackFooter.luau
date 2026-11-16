local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local parent = InExperienceIntervention.Parent
local InterventionShared = require(parent.InterventionShared)
local Constants = InterventionShared.Utils.Constants
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)

local useStyle = UIBlox.Core.Style.useStyle
local Text = Foundation.Text
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local FillBehavior = Foundation.Enums.FillBehavior
local View = Foundation.View
local Images = UIBlox.App.ImageSet.Images

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local NotificationModalsManager = require(parent.NotificationModalsManager)
local iconsactionsaccept = Images["icons/actions/accept"]
local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

function getDynamicViewTagForTranslatedText(value, value2, p): boolean | string
	local v = string.len(value) + string.len(value2)

	return Constants.MAX_CHARACTERS_IN_SHORT_LINE <= v
		and p < Constants.SMALL_SCREEN_THRESHOLD
		and "align-x-center align-y-center col flex-fill"
		or Constants.MAX_CHARACTERS_IN_LONG_LINE <= v and "align-x-center align-y-center col flex-fill"
		or "align-x-center align-y-center row"
end

function InterventionFeedbackFooter(props)
	local v = useLocalization(Constants.localizationKeys)
	local v2 = useLayerCollector()
	local dynamicViewTagForTranslatedText = getDynamicViewTagForTranslatedText(
		v.MistakeText,
		v.LetUsKnowLinkText,
		v2.absoluteSize.X
	)

	local v3 = useStyle()

	local function handleMistakeActivated()
		props.onDismiss()
		NotificationModalsManager.SetUIBloxToast({
			iconImage = iconsactionsaccept,
			toastTitle = v.TakeALookText,
			toastSubtitle = v.FeedbackHelpsText,
			sequenceNumber = DateTime.now().UnixTimestamp,
			iconColorStyle = { Color = v3.Tokens.Color.System.Success.Color3, Transparency = 0 }
		})

		InExperienceInterventionAnalytics.sendAnalyticsEvent(
			InExperienceInterventionAnalytics.Constants.EventTypes.AppealClicked,
			props.interventionType,
			props.renderTimestamp,
			props.eventId,
			props.violatingChatLine,
			props.duration
		)
	end

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		tag = dynamicViewTagForTranslatedText,
		Wraps = true
	}, {
		MistakeTextLabelFrame = React.createElement(
			View,
			{
				LayoutOrder = 1,
				Size = UDim2.new(0.5, 0, 0, Constants.TIMEOUT_INLINE_HEIGHT),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1
			},
			{
				MistakeTextLabel = React.createElement(Text, {
					Text = v.MistakeText,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					tag = "padding-small text-align-x-center size-1200-900",
					AutomaticSize = Enum.AutomaticSize.X
				})
			}
		),
		LinkFrame = React.createElement(
			View,
			{
				LayoutOrder = 2,
				Size = UDim2.new(0.5, 0, 0, Constants.TIMEOUT_INLINE_HEIGHT),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.X
			},
			{
				Button = React.createElement(Button, {
					text = v.LetUsKnowLinkText,
					variant = ButtonVariant.Text,
					onActivated = handleMistakeActivated,
					size = ButtonSize.Small,
					fillBehavior = FillBehavior.Fill
				})
			}
		)
	})
end

return InterventionFeedbackFooter
