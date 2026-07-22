local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local function RestoreVersionDialog(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), LocalizationStrings (copy), ButtonVariant (copy), Dialog (copy), DialogSize (copy)
	local v11 = t1.testId or "restore-version-dialog"
	local v12 = React.useCallback(function() -- line: 26
		-- upvalues: t1 (copy)
		t1.onRestore()
	end, { t1.onRestore })
	local v13 = React.useCallback(function() -- line: 29
		-- upvalues: t1 (copy)
		t1.onCancel()
	end, { t1.onCancel })
	local v14 = React.useMemo(function() -- line: 33
		-- upvalues: LocalizationStrings (copy), ButtonVariant (copy), v12 (copy), v13 (copy)
		return {
			LayoutOrder = 3,
			actions = {
				{
					text = LocalizationStrings.VERSION_HISTORY_RESTORE,
					variant = ButtonVariant.Emphasis,
					onActivated = v12
				},
				{
					text = LocalizationStrings.VERSION_HISTORY_CANCEL,
					variant = ButtonVariant.Standard,
					onActivated = v13
				}
			}
		}
	end, {
		v12,
		v13
	})

	if t1.isOpen == false then
		return nil
	end

	return React.createElement(Dialog.Root, {
		disablePortal = false,
		hasBackdrop = true,
		size = DialogSize.Small,
		testId = v11
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
		Actions = React.createElement(Dialog.Actions, v14)
	})
end

return RestoreVersionDialog
