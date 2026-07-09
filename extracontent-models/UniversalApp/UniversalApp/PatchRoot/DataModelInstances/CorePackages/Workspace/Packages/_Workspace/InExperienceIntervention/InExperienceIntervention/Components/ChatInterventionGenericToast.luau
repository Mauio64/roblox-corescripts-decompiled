local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local InExperienceInterventionParent = InExperienceIntervention.Parent
local React = require(InExperienceInterventionParent.React)
local UIBlox = require(InExperienceInterventionParent.UIBlox)
local Foundation = require(InExperienceInterventionParent.Foundation)
local Images = UIBlox.App.ImageSet.Images
local useTokens = Foundation.Hooks.useTokens
local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)
local Toast = UIBlox.App.Dialog.Toast
local v10 = game:DefineFastInt("InExperienceInterventionToastDuration", 5)

function ChatNudgeToast(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), useTokens (copy), InExperienceInterventionAnalytics (copy), Toast (copy), Images (copy), v10 (copy)
	local v12 = React.useRef(DateTime.now().UnixTimestampMillis)
	local v13 = useTokens()

	return React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		DisplayOrder = 7,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		Toast = React.createElement(Toast, {
			toastContent = {
				toastTitle = t1.toastTitle,
				iconColorStyle = {
					Transparency = 0,
					Color = v13.Color.System.Warning.Color3
				},
				iconImage = Images["icons/status/error_large"],
				iconSize = Vector2.new(36, 36),
				onAppeared = function() -- line: 28
					-- upvalues: v12 (copy), InExperienceInterventionAnalytics (copy), t1 (copy)
					v12.current = DateTime.now().UnixTimestampMillis
					InExperienceInterventionAnalytics.sendAnalyticsEvent(t1.toastAppearEventName, t1.interventionType, v12.current, t1.eventId, t1.violatingChatLine, t1.remainingDurationSec)
				end,
				toastSubtitle = t1.toastBody,
				sequenceNumber = DateTime.now().UnixTimestamp,
				onTouchSwipeUp = function() -- line: 40
					-- upvalues: InExperienceInterventionAnalytics (copy), t1 (copy), v12 (copy)
					InExperienceInterventionAnalytics.sendAnalyticsEvent(t1.toastDismissEventName, t1.interventionType, v12.current, t1.eventId, t1.violatingChatLine, t1.remainingDurationSec)
				end
			},
			duration = v10
		})
	})
end

return ChatNudgeToast
