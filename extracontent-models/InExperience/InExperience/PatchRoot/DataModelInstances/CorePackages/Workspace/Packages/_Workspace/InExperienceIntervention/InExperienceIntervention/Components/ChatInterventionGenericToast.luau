local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local parent = InExperienceIntervention.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Images = UIBlox.App.ImageSet.Images
local useTokens = Foundation.Hooks.useTokens
local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)
local Toast = UIBlox.App.Dialog.Toast

local defineFastInt = game:DefineFastInt("InExperienceInterventionToastDuration", 5)

function ChatNudgeToast(props)
	local ref = React.useRef(DateTime.now().UnixTimestampMillis)
	local v = useTokens()

	local function onAppeared()
		ref.current = DateTime.now().UnixTimestampMillis
		InExperienceInterventionAnalytics.sendAnalyticsEvent(
			props.toastAppearEventName,
			props.interventionType,
			ref.current,
			props.eventId,
			props.violatingChatLine,
			props.remainingDurationSec
		)
	end

	local function onTouchSwipeUp()
		InExperienceInterventionAnalytics.sendAnalyticsEvent(
			props.toastDismissEventName,
			props.interventionType,
			ref.current,
			props.eventId,
			props.violatingChatLine,
			props.remainingDurationSec
		)
	end

	return React.createElement(
		"ScreenGui",
		{
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ResetOnSpawn = false,
			DisplayOrder = 7
		},
		{
			Toast = React.createElement(Toast, {
				toastContent = {
					toastTitle = props.toastTitle,
					iconColorStyle = {
						Color = props.iconColor or v.Color.System.Warning.Color3,
						Transparency = 0
					},
					iconImage = Images["icons/status/error_large"],
					iconSize = Vector2.new(36, 36),
					onAppeared = onAppeared,
					toastSubtitle = props.toastBody,
					sequenceNumber = DateTime.now().UnixTimestamp,
					onTouchSwipeUp = onTouchSwipeUp
				},
				duration = defineFastInt
			})
		}
	)
end

return ChatNudgeToast
