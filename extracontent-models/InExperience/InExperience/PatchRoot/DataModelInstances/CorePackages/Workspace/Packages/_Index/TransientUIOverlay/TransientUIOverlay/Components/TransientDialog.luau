local TransientUIOverlay = script:FindFirstAncestor("TransientUIOverlay")
local parent = TransientUIOverlay.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local FoundationProvider = Foundation.FoundationProvider
local Orientation = Foundation.Enums.Orientation
local usePreferences = Foundation.Hooks.usePreferences

require(TransientUIOverlay.Types)

local GetTransientUIOverlayStore = require(TransientUIOverlay.Stores.GetTransientUIOverlayStore)

local function TransientDialog(props)
	local v = usePreferences()

	local actions = {}
	local primaryActionText = props.primaryActionText
	local onPrimaryActivated = props.onPrimaryActivated

	if primaryActionText ~= nil and onPrimaryActivated ~= nil then
		table.insert(actions, {
			text = primaryActionText,
			variant = ButtonVariant.Emphasis,
			onActivated = function()
				GetTransientUIOverlayStore(false).clearDialog()
				onPrimaryActivated()
			end
		})
	end

	table.insert(actions, {
		text = props.secondaryActionText,
		variant = ButtonVariant.Standard,
		onActivated = function()
			GetTransientUIOverlayStore(false).clearDialog()
			props.onSecondaryActivated()
		end
	})

	local createElement = React.createElement
	local root = Dialog.Root
	local v2 = {
		disablePortal = false,
		hasBackdrop = true,
		onClose = props.onClose ~= nil and function()
			GetTransientUIOverlayStore(false).clearDialog()
			props.onClose()
		end or nil,
		size = DialogSize.Small,
		testId = "transient-ui-dialog"
	}

	local v3 = {
		Title = React.createElement(Dialog.Title, { text = props.title, LayoutOrder = 1 }),
		Content = 0,
		Actions = 0
	}
	local content

	if props.body ~= nil then
		content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			Body = React.createElement(Dialog.Text, { Text = props.body, LayoutOrder = 1 })
		})
	end

	v3.Content = content

	v3.Actions = React.createElement(Dialog.Actions, {
		orientation = Orientation.Horizontal,
		LayoutOrder = 3,
		actions = actions
	})
	local element = createElement(root, v2, v3)

	if props.colorMode == nil then
		return element
	end

	return (React.createElement("Folder", nil, {
		Provider = React.createElement(FoundationProvider, {
			colorMode = props.colorMode,
			device = props.device,
			preferences = {
				preferredTextSize = v.preferredTextSize,
				preferredTransparency = v.preferredTransparency,
				reducedMotion = v.reducedMotion
			}
		}, { Dialog = element })
	}))
end

return TransientDialog
