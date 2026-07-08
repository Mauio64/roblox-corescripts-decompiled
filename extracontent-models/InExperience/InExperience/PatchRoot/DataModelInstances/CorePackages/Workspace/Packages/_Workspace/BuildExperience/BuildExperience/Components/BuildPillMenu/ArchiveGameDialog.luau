local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local function ArchiveGameDialog(t1: {[any]: any}) -- line: 29
	-- upvalues: React (copy), ButtonVariant (copy), Dialog (copy), DialogSize (copy)
	local v9 = t1.testId or "archive-game-dialog"
	local v10 = React.useCallback(function() -- line: 31
		-- upvalues: t1 (copy)
		t1.onArchive()
	end, { t1.onArchive })
	local v11 = React.useCallback(function() -- line: 34
		-- upvalues: t1 (copy)
		t1.onCancel()
	end, { t1.onCancel })
	local v12 = React.useMemo(function() -- line: 38
		-- upvalues: ButtonVariant (copy), v10 (copy), v11 (copy)
		return {
			LayoutOrder = 3,
			actions = {
				{
					text = "Archive",
					variant = ButtonVariant.Alert,
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
		disablePortal = t1.disablePortal == true,
		hasBackdrop = t1.hasBackdrop == nil or t1.hasBackdrop,
		size = DialogSize.Small,
		testId = v9
	}, {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = t1.title or "Archive Game"
		}),
		Content = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			Description = React.createElement(Dialog.Text, {
				Text = t1.description or "Archiving your game will remove it from Build. You can access and restore your archived games from Creator Hub or Roblox Studio."
			})
		}),
		Actions = React.createElement(Dialog.Actions, v12)
	})
end

return ArchiveGameDialog
