local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local InExperienceInterventionParent = InExperienceIntervention.Parent
local Constants = require(InExperienceInterventionParent.InterventionShared).Utils.Constants
local React = require(InExperienceInterventionParent.React)
local UIBlox = require(InExperienceInterventionParent.UIBlox)
local Foundation = require(InExperienceInterventionParent.Foundation)
local useStyle = UIBlox.Core.Style.useStyle
local FoundationText = Foundation.Text
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local FillBehavior = Foundation.Enums.FillBehavior
local View = Foundation.View
local Images = UIBlox.App.ImageSet.Images
local useLocalization = require(InExperienceInterventionParent.Localization).Hooks.useLocalization
local NotificationModalsManager = require(InExperienceInterventionParent.NotificationModalsManager)
local v17 = Images["icons/actions/accept"]
local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

function getDynamicViewTagForTranslatedText(p1, p2, p3) -- line: 33
	-- upvalues: Constants (copy)
	local s1 = "align-x-center align-y-center row"
	local v24 = string.len(p1) + string.len(p2)

	if v24 >= Constants.MAX_CHARACTERS_IN_SHORT_LINE and p3 < Constants.SMALL_SCREEN_THRESHOLD or v24 >= Constants.MAX_CHARACTERS_IN_LONG_LINE then
		s1 = "align-x-center align-y-center col flex-fill"
	end

	return s1
end
function InterventionFeedbackFooter(t1: {[any]: any}) -- line: 45
	-- upvalues: useLocalization (copy), Constants (copy), useLayerCollector (copy), useStyle (copy), NotificationModalsManager (copy), v17 (copy), InExperienceInterventionAnalytics (copy), React (copy), View (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy), FillBehavior (copy)
	local v26 = useLocalization(Constants.localizationKeys)
	local v27 = useLayerCollector()
	local v28 = getDynamicViewTagForTranslatedText(v26.MistakeText, v26.LetUsKnowLinkText, v27.absoluteSize.X)
	local v29 = useStyle()

	local function handleMistakeActivated() -- line: 55
		-- upvalues: t1 (copy), NotificationModalsManager (copy), v17 (copy), v26 (copy), v29 (copy), InExperienceInterventionAnalytics (copy)
		t1.onDismiss()
		NotificationModalsManager.SetUIBloxToast({
			iconImage = v17,
			toastTitle = v26.TakeALookText,
			toastSubtitle = v26.FeedbackHelpsText,
			sequenceNumber = DateTime.now().UnixTimestamp,
			iconColorStyle = {
				Transparency = 0,
				Color = v29.Tokens.Color.System.Success.Color3
			}
		})
		InExperienceInterventionAnalytics.sendAnalyticsEvent(InExperienceInterventionAnalytics.Constants.EventTypes.AppealClicked, t1.interventionType, t1.renderTimestamp, t1.eventId, t1.violatingChatLine, t1.duration)
	end

	return React.createElement(View, {
		BackgroundTransparency = 1,
		Wraps = true,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		tag = v28
	}, {
		MistakeTextLabelFrame = React.createElement(View, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(0.5, 0, 0, Constants.TIMEOUT_INLINE_HEIGHT),
			AutomaticSize = Enum.AutomaticSize.X
		}, {
			MistakeTextLabel = React.createElement(FoundationText, {
				tag = "padding-small text-align-x-center size-1200-900",
				Text = v26.MistakeText,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				AutomaticSize = Enum.AutomaticSize.X
			})
		}),
		LinkFrame = React.createElement(View, {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(0.5, 0, 0, Constants.TIMEOUT_INLINE_HEIGHT),
			AutomaticSize = Enum.AutomaticSize.X
		}, {
			Button = React.createElement(Button, {
				text = v26.LetUsKnowLinkText,
				variant = ButtonVariant.Text,
				onActivated = handleMistakeActivated,
				size = ButtonSize.Small,
				fillBehavior = FillBehavior.Fill
			})
		})
	})
end

return InterventionFeedbackFooter
