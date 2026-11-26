local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/TransientUIOverlay/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TransientUIOverlay/React")

local buttonVariant = Foundation.Enums.ButtonVariant
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local foundationProvider = Foundation.FoundationProvider
local orientation = Foundation.Enums.Orientation
local usePreferences = Foundation.Hooks.usePreferences

require("@game/CorePackages/Workspace/Packages/_Index/TransientUIOverlay/TransientUIOverlay/Types")

local GetTransientUIOverlayStore = require("@game/CorePackages/Workspace/Packages/_Index/TransientUIOverlay/TransientUIOverlay/Stores/GetTransientUIOverlayStore")

local function TransientDialog(props)
	local v5 = usePreferences()

	local v6 = {}
	local primaryActionText = props.primaryActionText
	local onPrimaryActivated = props.onPrimaryActivated

	if primaryActionText ~= nil and onPrimaryActivated ~= nil then
		table.insert(v6, {
			text = primaryActionText,
			variant = buttonVariant.Emphasis,
			onActivated = function()
				GetTransientUIOverlayStore(false).clearDialog()
				onPrimaryActivated()
			end
		})
	end

	table.insert(v6, {
		text = props.secondaryActionText,
		variant = buttonVariant.Standard,
		onActivated = function()
			GetTransientUIOverlayStore(false).clearDialog()
			props.onSecondaryActivated()
		end
	})

	local createElement = React.createElement
	local root = dialog.Root
	local v7 = {
		disablePortal = false,
		hasBackdrop = true,
		onClose = props.onClose ~= nil and function()
			GetTransientUIOverlayStore(false).clearDialog()
			props.onClose()
		end or nil,
		size = dialogSize.Small,
		testId = "transient-ui-dialog"
	}

	local v8 = {
		Title = React.createElement(dialog.Title, {
			text = props.title,
			LayoutOrder = 1
		}),
		Content = 0,
		Actions = 0
	}

	local v9 = if props.body ~= nil then React.createElement(dialog.Content, {
		LayoutOrder = 2
	}, {
		Body = React.createElement(dialog.Text, { Text = props.body, LayoutOrder = 1 })
	}) else nil
	v8.Content = v9

	v8.Actions = React.createElement(dialog.Actions, {
		orientation = orientation.Horizontal,
		LayoutOrder = 3,
		actions = v6
	})
	local element = createElement(root, v7, v8)

	if props.colorMode == nil then
		return element
	end

	return (React.createElement("Folder", nil, {
		Provider = React.createElement(foundationProvider, {
			colorMode = props.colorMode,
			device = props.device,
			preferences = {
				preferredTextSize = v5.preferredTextSize,
				preferredTransparency = v5.preferredTransparency,
				reducedMotion = v5.reducedMotion
			}
		}, { Dialog = element })
	}))
end

return TransientDialog
