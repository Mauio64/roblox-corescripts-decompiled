local HttpService = game:GetService("HttpService")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/bundled/fvl")
local Foundation = require(CorePackages.Packages.Foundation)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local v5 = require("@luauforge/bundled/hFQ").CoreLogger:new("NotificationsModal")
local module2 = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local toggle = Foundation.Toggle
local view = Foundation.View
local text = Foundation.Text

return function()
	local v6 = useDispatch()

	local v7 = useLocalization({
		header = "Notifications.DesktopPushNotificationPrompts.Heading.EnablePrompt",
		description = "Notifications.DesktopPushNotificationPrompts.Description.EnablePrompt",
		switchLabel = "Notifications.DesktopPushNotificationPrompts.Label.GetNotifications",
		buttonText = "Notifications.DesktopPushNotificationPrompts.Action.OK"
	})

	local state, setState = React.useState(false)

	local v8 = React.useCallback(function(p2)
		setState(p2)
	end, {})

	local v9 = React.useCallback(function()
		local v11 = {
			Url = module2.APIS_URL .. "user-settings-api/v2/user-settings",
			Method = "POST",
			Body = HttpService:JSONEncode({
				aggregatedDesktopNotifications = state and "Enabled" or "Disabled"
			}),
			Headers = { ["Content-Type"] = "application/json" }
		}

		spawn(function()
			HttpService:RequestInternal(v11):Start(function(p2, p3)
				if not p2 then
					v5:error("Error updating user notification preferences. Status code: " .. tostring(p3.StatusCode))
				elseif p3.StatusCode < 200 or p3.StatusCode >= 300 then
					v5:error("Error updating user notification preferences. Status code: " .. tostring(p3.StatusCode))
				else
					v5:info("Successfully updated user notification preferences.")
				end
			end)
		end)
	end, { state })

	local v10 = React.useCallback(function()
		v9()
		return v6(module())
	end, { v6, v9 })

	return React.createElement(dialog.Root, { size = dialogSize.Medium }, {
		DialogTitle = React.createElement(dialog.Title, {
			text = v7.header,
			LayoutOrder = 1
		}),
		DialogText = React.createElement(dialog.Text, {
			Text = v7.description,
			LayoutOrder = 2
		}),
		DialogContent = React.createElement(dialog.Content, { LayoutOrder = 3 }, {
			React.createElement(
				view,
				{
					tag = "row size-full-0 auto-y padding-medium bg-shift-100 radius-medium"
				},
				{
					Text = React.createElement(text, {
						LayoutOrder = 1,
						Text = v7.switchLabel,
						TextXAlignment = Enum.TextXAlignment.Left,
						tag = "fill auto-y"
					}),
					Toggle = React.createElement(toggle, {
						label = "",
						LayoutOrder = 2,
						isChecked = state,
						size = inputSize.Medium,
						onActivated = v8
					})
				}
			)
		}),
		DialogActions = React.createElement(dialog.Actions, {
			actions = {
				{
					variant = buttonVariant.Emphasis,
					text = v7.buttonText,
					onActivated = v10
				}
			},
			LayoutOrder = 4
		})
	})
end
