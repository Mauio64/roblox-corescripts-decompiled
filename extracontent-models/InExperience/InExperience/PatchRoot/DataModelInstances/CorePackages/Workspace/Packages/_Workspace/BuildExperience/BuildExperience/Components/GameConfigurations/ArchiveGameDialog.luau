local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize

local ButtonVariant = Foundation.Enums.ButtonVariant

local function ArchiveGameDialog(props)
	local v = useLocalization({
		archiveGame = LocalizationStrings.ARCHIVE_GAME_ARCHIVE,
		cancel = LocalizationStrings.ARCHIVE_GAME_CANCEL,
		description = LocalizationStrings.ARCHIVE_GAME_DESCRIPTION,
		title = LocalizationStrings.ARCHIVE_GAME_TITLE
	})

	local testId = props.testId or "archive-game-dialog"
	local onActivated = React.useCallback(function()
		props.onArchive()
	end, { props.onArchive })
	local onActivated2 = React.useCallback(function()
		props.onCancel()
	end, { props.onCancel })

	local v2 = React.useMemo(function()
		return {
			LayoutOrder = 3,
			actions = {
				{
					text = v.archiveGame,
					variant = ButtonVariant.Standard,
					onActivated = onActivated
				},
				{ text = v.cancel, variant = ButtonVariant.Standard, onActivated = onActivated2 }
			}
		}
	end, { onActivated, onActivated2 })

	if props.isOpen == false then
		return nil
	end

	return React.createElement(Dialog.Root, {
		disablePortal = props.disablePortal == true,
		hasBackdrop = props.hasBackdrop == nil or props.hasBackdrop,
		size = DialogSize.Small,
		testId = testId
	}, {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = props.title or v.title
		}),
		Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			Description = React.createElement(Dialog.Text, {
				Text = props.description or v.description
			})
		}),
		Actions = React.createElement(Dialog.Actions, v2)
	})
end

return ArchiveGameDialog
