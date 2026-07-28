local InterventionShared = script:FindFirstAncestor("InterventionShared")
local InterventionSharedParent = InterventionShared.Parent
local Players = game:GetService("Players")
local TelemetryService = game:GetService("TelemetryService")
local VRService = game:GetService("VRService")
local React = require(InterventionSharedParent.React)
local Foundation = require(InterventionSharedParent.Foundation)
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local FocusNavigableSurfaceIdentifierEnum = require(InterventionSharedParent.FocusNavigationUtils).FocusNavigableSurfaceIdentifierEnum
local Images = require(InterventionSharedParent.FoundationImages).Images
local Constants = require(InterventionShared.Utils.Constants)
local NotificationModalsManager = require(InterventionSharedParent.NotificationModalsManager)
local useLocalization = require(InterventionSharedParent.Localization).Hooks.useLocalization
local useInterventionFocusRoot = require(InterventionShared.Hooks.useInterventionFocusRoot)
local useInterventionPlacement = require(InterventionShared.Hooks.useInterventionPlacement)
local v22 = Images["icons/actions/accept"]
local t1 = {
	eventName = "InExpAvatarViolationReportMistake",
	throttlingPercentage = 10000,
	description = "Fired when user clicks on the report mistake button on the avatar kick warning dialog",
	backends = { "EventIngest" },
	lastUpdated = {
		2026,
		6,
		8
	}
}

local function sendReportMistakeAnalytics(t2: {[any]: any}) -- line: 48
	-- upvalues: Players (copy), TelemetryService (copy), t1 (copy)
	local v27 = (not Players.LocalPlayer or not Players.LocalPlayer.UserId) and "0" or tostring(Players.LocalPlayer.UserId)

	TelemetryService:LogEvent(t1, {
		customFields = {
			avatar_entity_id = t2.avatarEntityId or "",
			user_id = v27,
			violation_type = t2.violationType or "",
			place_id = t2.placeId or tostring(game.PlaceId),
			timestamp = DateTime.now().UnixTimestampMillis
		}
	})
end
local function TemporaryAvatarKickWarningDialog(t3: {[any]: any}) -- line: 72
	-- upvalues: useLocalization (copy), Constants (copy), useTokens (copy), useInterventionPlacement (copy), useInterventionFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), React (copy), sendReportMistakeAnalytics (copy), NotificationModalsManager (copy), v22 (copy), Dialog (copy), DialogSize (copy), VRService (copy), View (copy), FoundationText (copy), ButtonVariant (copy), ButtonSize (copy)
	local v29 = useLocalization(Constants.localizationKeys)
	local v30 = useTokens()
	local v31 = useInterventionPlacement()
	local v32 = useInterventionFocusRoot({
		isAutoFocusRoot = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ModerationOverlay
	})
	local v33 = React.useCallback(function() -- line: 82
		-- upvalues: sendReportMistakeAnalytics (copy), t3 (copy), NotificationModalsManager (copy), v22 (copy), v29 (copy), v30 (copy)
		sendReportMistakeAnalytics(t3)
		t3.onDismiss()
		NotificationModalsManager.SetUIBloxToast({
			iconImage = v22,
			toastTitle = v29.Thanks,
			toastSubtitle = v29.FeedbackHelpsText,
			sequenceNumber = DateTime.now().UnixTimestamp,
			iconColorStyle = {
				Color = v30.Color.System.Success.Color3,
				Transparency = v30.Color.System.Success.Transparency
			}
		})
	end, {
		t3,
		v30,
		v29.FeedbackHelpsText,
		v29.Thanks
	})

	return React.createElement(Dialog.Root, {
		hasCloseButton = false,
		size = DialogSize.Medium,
		hasBackdrop = not VRService.VREnabled,
		disablePortal = v31 ~= Constants.InterventionPlacementType.InExperience,
		ref = v32
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v29.AvatarKickWarningTitle
		}),
		DialogContent = React.createElement(Dialog.Content, nil, {
			Body = React.createElement(View, {
				tag = "col gap-medium size-full-0 auto-y"
			}, {
				BodyText = React.createElement(FoundationText, {
					tag = "auto-xy text-body-medium text-wrap text-align-x-left content-default",
					LayoutOrder = 1,
					Text = v29.AvatarKickWarningDescription
				})
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			actions = {
				{
					variant = ButtonVariant.Emphasis,
					size = ButtonSize.Medium,
					text = v29.OkText,
					onActivated = t3.onDismiss,
					width = UDim.new(1, 0)
				},
				{
					variant = ButtonVariant.Utility,
					size = ButtonSize.Medium,
					text = v29.ReportMistakeText,
					onActivated = v33,
					width = UDim.new(1, 0)
				}
			}
		})
	})
end

return React.memo(TemporaryAvatarKickWarningDialog)
