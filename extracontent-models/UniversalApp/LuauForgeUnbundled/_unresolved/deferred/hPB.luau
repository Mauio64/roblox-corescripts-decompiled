local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant
local notificationTypeList = GuiService:GetNotificationTypeList()

local fFlagMacMenuBarContentUpdates = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagMacMenuBarContentUpdates()
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

return function()
	local v5 = useAppPolicy(function(p2): boolean
		if fFlagMacMenuBarContentUpdates then
			return p2.getDevicePreferencesPersistentPresenceVariant() == "mac"
		end

		return false
	end)

	local v6 = useLocalization({
		header = "Notifications.DesktopPushNotificationPrompts.Heading.SystemTrayPrompt",
		description = fFlagMacMenuBarContentUpdates and v5 and "Notifications.DesktopPushNotificationPrompts.Description.MenuBarPrompt" or "Notifications.DesktopPushNotificationPrompts.Description.SystemTrayPrompt",
		buttonText = "Notifications.DesktopPushNotificationPrompts.Action.OK"
	})

	local v7 = React.useCallback(function()
		GuiService:BroadcastNotification("", notificationTypeList.NATIVE_EXIT)
	end, {})

	return React.createElement(dialog.Root, { size = dialogSize.Medium }, {
		DialogTitle = React.createElement(dialog.Title, {
			text = v6.header,
			LayoutOrder = 1
		}),
		DialogText = React.createElement(dialog.Text, {
			Text = v6.description,
			LayoutOrder = 2
		}),
		DialogActions = React.createElement(dialog.Actions, {
			actions = {
				{
					variant = buttonVariant.Emphasis,
					text = v6.buttonText,
					onActivated = v7
				}
			},
			LayoutOrder = 3
		})
	})
end
