local SessionService = game:GetService("SessionService")
local Parent = script:FindFirstAncestor("AvatarSwitcher").Parent
local Foundation = require(Parent.Foundation)
local Dialog = Foundation.Dialog
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize
local EnumsOrientation = Foundation.Enums.Orientation
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local AvatarExperienceAnalytics = require(Parent.AvatarExperienceAnalytics)
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local UnifiedLoggingSurface = require(Parent.AvatarExperienceNavigation).Enums.UnifiedLoggingSurface

local function RespawnLaterDialog(t1: {[any]: any}) -- line: 30
	-- upvalues: React (copy), useLocalization (copy), addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), SessionService (copy), Dialog (copy), DialogSize (copy), EnumsOrientation (copy), ButtonVariant (copy)
	local v16 = React.useRef(nil)
	local v17 = useLocalization({
		headerText = "Feature.AvatarSwitcher.Heading.RespawnToSwitch",
		contentText = "Feature.AvatarSwitcher.Message.RespawnNotAllowed",
		continueText = "Feature.AvatarSwitcher.Action.OK"
	})

	React.useEffect(function() -- line: 39
		-- upvalues: addUnifiedEventLogging (copy), v16 (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), SessionService (copy)
		addUnifiedEventLogging(v16, {
			elementName = "DEFER_SWITCH_AVATAR_RESPAWN_DISABLED_BUTTON",
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
			text = v17.headerText
		}),
		DialogContent = React.createElement(Dialog.Content, nil, {
			DialogText = React.createElement(Dialog.Text, {
				Text = v17.contentText
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			orientation = EnumsOrientation.Vertical,
			actions = {{
				text = v17.continueText,
				variant = ButtonVariant.Emphasis,
				onActivated = t1.onDefer,
				ref = v16
			}}
		})
	})
end

return RespawnLaterDialog
