local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local Foundation = require(CorePackages.Packages.Foundation)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local v9 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)
local Url = require(Modules.LuaApp.Http.Url)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local Toggle = Foundation.Toggle
local View = Foundation.View
local FoundationText = Foundation.Text

return function() -- line: 20
	-- upvalues: useDispatch (copy), useLocalization (copy), React (copy), Url (copy), HttpService (copy), v9 (copy), CloseCentralOverlay (copy), Dialog (copy), DialogSize (copy), View (copy), FoundationText (copy), Toggle (copy), InputSize (copy), ButtonVariant (copy)
	local v18 = useDispatch()
	local v19 = useLocalization({
		header = "Notifications.DesktopPushNotificationPrompts.Heading.EnablePrompt",
		description = "Notifications.DesktopPushNotificationPrompts.Description.EnablePrompt",
		switchLabel = "Notifications.DesktopPushNotificationPrompts.Label.GetNotifications",
		buttonText = "Notifications.DesktopPushNotificationPrompts.Action.OK"
	})
	local v20, v21 = React.useState(false)
	local v22 = React.useCallback(function(p1) -- line: 32
		-- upvalues: v21 (copy)
		v21(p1)
	end, {})
	local v23 = React.useCallback(function() -- line: 36
		-- upvalues: v20 (copy), Url (copy), HttpService (copy), v9 (copy)
		local t1 = {
			aggregatedDesktopNotifications = not v20 and "Disabled" or "Enabled"
		}
		local t2 = {
			Method = "POST",
			Url = Url.APIS_URL .. "user-settings-api/v2/user-settings",
			Body = HttpService:JSONEncode(t1),
			Headers = {
				["Content-Type"] = "application/json"
			}
		}

		spawn(function() -- line: 50
			-- upvalues: HttpService (copy), t2 (copy), v9 (copy)
			HttpService:RequestInternal(t2):Start(function(p2, p3) -- line: 52
				-- upvalues: v9 (copy)
				if not p2 then
					v9:error("Error updating user notification preferences. Status code: " .. tostring(p3.StatusCode))

					return
				end

				if p3.StatusCode < 200 or p3.StatusCode >= 300 then
					v9:error("Error updating user notification preferences. Status code: " .. tostring(p3.StatusCode))

					return
				end

				v9:info("Successfully updated user notification preferences.")
			end)
		end)
	end, { v20 })
	local v24 = React.useCallback(function() -- line: 70
		-- upvalues: v23 (copy), v18 (copy), CloseCentralOverlay (copy)
		v23()

		return v18(CloseCentralOverlay())
	end, {
		v18,
		v23
	})

	return React.createElement(Dialog.Root, {
		size = DialogSize.Medium
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v19.header
		}),
		DialogText = React.createElement(Dialog.Text, {
			LayoutOrder = 2,
			Text = v19.description
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 3
		}, { React.createElement(View, {
			tag = "row size-full-0 auto-y padding-medium bg-shift-100 radius-medium"
		}, {
			Text = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "fill auto-y",
				Text = v19.switchLabel,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			Toggle = React.createElement(Toggle, {
				label = "",
				LayoutOrder = 2,
				isChecked = v20,
				size = InputSize.Medium,
				onActivated = v22
			})
		}) }),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 4,
			actions = {{
				variant = ButtonVariant.Emphasis,
				text = v19.buttonText,
				onActivated = v24
			}}
		})
	})
end
