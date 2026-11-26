local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize

local buttonVariant = Foundation.Enums.ButtonVariant

local function ArchiveGameDialog(props)
	local v5 = useLocalization({
		archiveGame = LocalizationStrings.ARCHIVE_GAME_ARCHIVE,
		cancel = LocalizationStrings.ARCHIVE_GAME_CANCEL,
		description = LocalizationStrings.ARCHIVE_GAME_DESCRIPTION,
		title = LocalizationStrings.ARCHIVE_GAME_TITLE
	})

	local testId = props.testId or "archive-game-dialog"
	local v6 = React.useCallback(function()
		props.onArchive()
	end, { props.onArchive })
	local v7 = React.useCallback(function()
		props.onCancel()
	end, { props.onCancel })

	local v8 = React.useMemo(function()
		return {
			LayoutOrder = 3,
			actions = {
				{
					text = v5.archiveGame,
					variant = buttonVariant.Standard,
					onActivated = v6
				},
				{ text = v5.cancel, variant = buttonVariant.Standard, onActivated = v7 }
			}
		}
	end, { v6, v7 })

	if props.isOpen == false then
		return nil
	end

	return React.createElement(dialog.Root, {
		disablePortal = props.disablePortal == true,
		hasBackdrop = props.hasBackdrop == nil or props.hasBackdrop,
		size = dialogSize.Small,
		testId = testId
	}, {
		Title = React.createElement(dialog.Title, {
			LayoutOrder = 1,
			text = props.title or v5.title
		}),
		Content = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
			Description = React.createElement(dialog.Text, {
				Text = props.description or v5.description
			})
		}),
		Actions = React.createElement(dialog.Actions, v8)
	})
end

return ArchiveGameDialog
