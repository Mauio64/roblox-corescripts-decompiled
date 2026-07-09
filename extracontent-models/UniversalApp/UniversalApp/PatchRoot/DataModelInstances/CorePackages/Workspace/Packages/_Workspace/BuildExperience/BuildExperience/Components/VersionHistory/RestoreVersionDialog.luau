local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local function RestoreVersionDialog(t1: {[any]: any}) -- line: 23
	-- upvalues: React (copy), ButtonVariant (copy), Dialog (copy), DialogSize (copy)
	local v9 = t1.testId or "restore-version-dialog"
	local v10 = React.useCallback(function() -- line: 25
		-- upvalues: t1 (copy)
		t1.onRestore()
	end, { t1.onRestore })
	local v11 = React.useCallback(function() -- line: 28
		-- upvalues: t1 (copy)
		t1.onCancel()
	end, { t1.onCancel })
	local v12 = React.useMemo(function() -- line: 32
		-- upvalues: ButtonVariant (copy), v10 (copy), v11 (copy)
		return {
			LayoutOrder = 3,
			actions = {
				{
					text = "Restore",
					variant = ButtonVariant.Emphasis,
					onActivated = v10
				},
				{
					text = "Cancel",
					variant = ButtonVariant.Standard,
					onActivated = v11
				}
			}
		}
	end, {
		v10,
		v11
	})

	if t1.isOpen == false then
		return nil
	end

	return React.createElement(Dialog.Root, {
		disablePortal = false,
		hasBackdrop = true,
		size = DialogSize.Small,
		testId = v9
	}, {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = t1.title
		}),
		Content = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			Description = React.createElement(Dialog.Text, {
				Text = t1.description
			})
		}),
		Actions = React.createElement(Dialog.Actions, v12)
	})
end

return RestoreVersionDialog
