local Parent = script:FindFirstAncestor("Moments").Parent
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local React = require(Parent.React)
local Dialog = Foundation.Dialog
local useLocalization = Localization.Hooks.useLocalization
local t1 = {
	title = "Feature.Moments.Label.MomentUnavailable",
	body = "Feature.Moments.Label.MomentUnavailableDefault",
	ok = "Feature.Moments.Action.Ok"
}

local function MomentUnavailableDialog(t2: {[any]: any}) -- line: 22
	-- upvalues: useLocalization (copy), t1 (copy), React (copy), Dialog (copy), Foundation (copy)
	local v10 = useLocalization(t1)

	return React.createElement(Dialog.Root, {
		disablePortal = false,
		hasBackdrop = true,
		size = Foundation.Enums.DialogSize.Medium
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v10.title
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			DialogText = React.createElement(Dialog.Text, {
				Text = v10.body
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {{
				text = v10.ok,
				variant = Foundation.Enums.ButtonVariant.Standard,
				onActivated = t2.onDismiss
			}}
		})
	})
end

return MomentUnavailableDialog
