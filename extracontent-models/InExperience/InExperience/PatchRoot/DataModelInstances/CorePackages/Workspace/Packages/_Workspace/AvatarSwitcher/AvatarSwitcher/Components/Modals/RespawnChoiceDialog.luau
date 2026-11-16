local SessionService = game:GetService("SessionService")

local parent = script:FindFirstAncestor("AvatarSwitcher").Parent

local Foundation = require(parent.Foundation)
local Orientation = Foundation.Enums.Orientation
local Dialog = Foundation.Dialog
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local function RespawnChoiceDialog(props)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v = useLocalization({
		headerText = "Feature.AvatarSwitcher.Heading.RespawnToSwitch",
		contentText = "Feature.AvatarSwitcher.Label.RespawnLater",
		respawnText = "Feature.AvatarSwitcher.Action.Respawn",
		respawnLaterText = "Feature.AvatarSwitcher.Action.RespawnLater"
	})

	React.useEffect(function()
		addUnifiedEventLogging(
			ref,
			{
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
				surface = UnifiedLoggingSurface.IN_EXPERIENCE_AVATAR_SWITCHER,
				elementName = "CONFIRM_SWITCH_AVATAR_BUTTON"
			},
			{
				sessionTagName = SessionService:GetSessionTag("level2a")
			}
		)
		addUnifiedEventLogging(
			ref2,
			{
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
				surface = UnifiedLoggingSurface.IN_EXPERIENCE_AVATAR_SWITCHER,
				elementName = "DEFER_SWITCH_AVATAR_BUTTON"
			},
			{
				sessionTagName = SessionService:GetSessionTag("level2a")
			}
		)
	end, {})

	return React.createElement(
		Dialog.Root,
		{
			disablePortal = false,
			size = DialogSize.Small,
			hasBackdrop = true,
			onClose = props.onClose
		},
		{
			DialogTitle = React.createElement(Dialog.Title, { text = v.headerText }),
			DialogContent = React.createElement(Dialog.Content, nil, {
				DialogText = React.createElement(Dialog.Text, { Text = v.contentText })
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				orientation = Orientation.Vertical,
				actions = {
					{
						text = v.respawnText,
						variant = ButtonVariant.Emphasis,
						onActivated = props.onConfirm,
						ref = ref
					},
					{
						text = v.respawnLaterText,
						variant = ButtonVariant.Standard,
						onActivated = props.onDefer,
						ref = ref2
					}
				}
			})
		}
	)
end

return RespawnChoiceDialog
