local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local NotificationTypeList = GuiService:GetNotificationTypeList()
local v10 = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagMacMenuBarContentUpdates()
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy

return function() -- line: 15
	-- upvalues: useAppPolicy (copy), v10 (copy), useLocalization (copy), React (copy), GuiService (copy), NotificationTypeList (copy), Dialog (copy), DialogSize (copy), ButtonVariant (copy)
	local v12 = useAppPolicy(function(p1) -- line: 16
		-- upvalues: v10 (copy)
		if v10 then
			return p1.getDevicePreferencesPersistentPresenceVariant() == "mac"
		end

		return false
	end)
	local v13 = useLocalization({
		header = "Notifications.DesktopPushNotificationPrompts.Heading.SystemTrayPrompt",
		buttonText = "Notifications.DesktopPushNotificationPrompts.Action.OK",
		description = (not v10 or not v12) and "Notifications.DesktopPushNotificationPrompts.Description.SystemTrayPrompt" or "Notifications.DesktopPushNotificationPrompts.Description.MenuBarPrompt"
	})
	local v14 = React.useCallback(function() -- line: 31
		-- upvalues: GuiService (copy), NotificationTypeList (copy)
		GuiService:BroadcastNotification("", NotificationTypeList.NATIVE_EXIT)
	end, {})

	return React.createElement(Dialog.Root, {
		size = DialogSize.Medium
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v13.header
		}),
		DialogText = React.createElement(Dialog.Text, {
			LayoutOrder = 2,
			Text = v13.description
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {{
				variant = ButtonVariant.Emphasis,
				text = v13.buttonText,
				onActivated = v14
			}}
		})
	})
end
