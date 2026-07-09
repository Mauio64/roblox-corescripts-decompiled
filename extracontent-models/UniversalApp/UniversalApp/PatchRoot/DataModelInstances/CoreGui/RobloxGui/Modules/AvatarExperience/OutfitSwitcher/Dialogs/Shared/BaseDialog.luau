local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Dialog = Foundation.Dialog
local FoundationText = Foundation.Text
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local function BaseDialog(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), ButtonVariant (copy), Dialog (copy), DialogSize (copy), FoundationText (copy)
	local v10 = React.useMemo(function() -- line: 22
		-- upvalues: t1 (copy), ButtonVariant (copy)
		return {
			{
				text = t1.cancelButtonText,
				variant = ButtonVariant.Standard,
				onActivated = t1.onClose
			},
			{
				text = t1.confirmButtonText,
				variant = ButtonVariant.Emphasis,
				onActivated = t1.onConfirm
			}
		}
	end, {
		t1.cancelButtonText,
		t1.onClose,
		t1.confirmButtonText,
		t1.onConfirm
	})

	return React.createElement("TextButton", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		Selectable = false,
		[React.Event.Activated] = t1.onClose
	}, React.createElement(Dialog.Root, {
		hasBackdrop = false,
		onClose = nil,
		size = DialogSize.Medium
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = t1.titleText
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 2,
			tag = "col gap-medium size-full-0"
		}, {
			Body = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
				LayoutOrder = 1,
				Text = t1.bodyText
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = v10
		})
	}))
end

return BaseDialog
