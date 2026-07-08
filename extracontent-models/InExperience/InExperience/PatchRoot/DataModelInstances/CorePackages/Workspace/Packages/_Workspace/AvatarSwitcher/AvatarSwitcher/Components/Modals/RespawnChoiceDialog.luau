local SessionService = game:GetService("SessionService")
local Parent = script:FindFirstAncestor("AvatarSwitcher").Parent
local Foundation = require(Parent.Foundation)
local EnumsOrientation = Foundation.Enums.Orientation
local Dialog = Foundation.Dialog
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local AvatarExperienceAnalytics = require(Parent.AvatarExperienceAnalytics)
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local UnifiedLoggingSurface = require(Parent.AvatarExperienceNavigation).Enums.UnifiedLoggingSurface

local function RespawnChoiceDialog(t1: {[any]: any}) -- line: 31
	-- upvalues: React (copy), useLocalization (copy), addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), SessionService (copy), Dialog (copy), DialogSize (copy), EnumsOrientation (copy), ButtonVariant (copy)
	local v16 = React.useRef(nil)
	local v17 = React.useRef(nil)
	local v18 = useLocalization({
		headerText = "Feature.AvatarSwitcher.Heading.RespawnToSwitch",
		contentText = "Feature.AvatarSwitcher.Label.RespawnLater",
		respawnText = "Feature.AvatarSwitcher.Action.Respawn",
		respawnLaterText = "Feature.AvatarSwitcher.Action.RespawnLater"
	})

	React.useEffect(function() -- line: 42
		-- upvalues: addUnifiedEventLogging (copy), v16 (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), SessionService (copy), v17 (copy)
		addUnifiedEventLogging(v16, {
			elementName = "CONFIRM_SWITCH_AVATAR_BUTTON",
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = UnifiedLoggingSurface.IN_EXPERIENCE_AVATAR_SWITCHER
		}, {
			sessionTagName = SessionService:GetSessionTag("level2a")
		})
		addUnifiedEventLogging(v17, {
			elementName = "DEFER_SWITCH_AVATAR_BUTTON",
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = UnifiedLoggingSurface.IN_EXPERIENCE_AVATAR_SWITCHER
		}, {
			sessionTagName = SessionService:GetSessionTag("level2a")
		})
	end, {})

	return React.createElement(Dialog.Root, {
		disablePortal = false,
		hasBackdrop = true,
		size = DialogSize.Small,
		onClose = t1.onClose
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v18.headerText
		}),
		DialogContent = React.createElement(Dialog.Content, nil, {
			DialogText = React.createElement(Dialog.Text, {
				Text = v18.contentText
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			orientation = EnumsOrientation.Vertical,
			actions = {
				{
					text = v18.respawnText,
					variant = ButtonVariant.Emphasis,
					onActivated = t1.onConfirm,
					ref = v16
				},
				{
					text = v18.respawnLaterText,
					variant = ButtonVariant.Standard,
					onActivated = t1.onDefer,
					ref = v17
				}
			}
		})
	})
end

return RespawnChoiceDialog
