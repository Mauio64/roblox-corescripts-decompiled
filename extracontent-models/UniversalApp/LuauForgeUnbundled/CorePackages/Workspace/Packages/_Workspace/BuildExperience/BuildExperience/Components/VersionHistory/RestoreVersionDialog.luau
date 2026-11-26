local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize

local buttonVariant = Foundation.Enums.ButtonVariant
local fFlagEnableTeamTestLua = SharedFlags.FFlagEnableTeamTestLua

local function RestoreVersionDialog(props)
	local v5 = useLocalization({
		cancel = LocalizationStrings.VERSION_HISTORY_CANCEL,
		revert = LocalizationStrings.CHAT_REVERT_CONFIRMATION_ACTION,
		restore = LocalizationStrings.VERSION_HISTORY_RESTORE
	})

	local cancel = v5.cancel
	local revert = v5.revert
	local restore = v5.restore
	local v6 = React.useCallback(function()
		if props.isLoading then
			return
		end

		props.onRestore()
	end, { props.isLoading, props.onRestore })
	local v7 = React.useCallback(function()
		if props.isLoading then
			return
		end

		props.onCancel()
	end, { props.isLoading, props.onCancel })

	local v8 = React.useMemo(function()
		return {
			LayoutOrder = 3,
			actions = {
				{
					text = if fFlagEnableTeamTestLua then revert else restore,
					variant = buttonVariant.Emphasis,
					isDisabled = props.isLoading,
					isLoading = props.isLoading,
					onActivated = v6
				},
				{
					text = cancel,
					variant = buttonVariant.Standard,
					isDisabled = props.isLoading,
					onActivated = v7
				}
			}
		}
	end, { cancel, v6, v7, props.isLoading, restore, revert })

	if props.isOpen == false then
		return nil
	end

	return React.createElement(
		dialog.Root,
		{
			disablePortal = false,
			hasBackdrop = true,
			size = dialogSize.Small,
			testId = "restore-version-dialog"
		},
		{
			Title = React.createElement(dialog.Title, {
				LayoutOrder = 1,
				text = props.title
			}),
			Content = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
				Description = React.createElement(dialog.Text, {
					Text = props.description
				})
			}),
			Actions = React.createElement(dialog.Actions, v8)
		}
	)
end

return RestoreVersionDialog
