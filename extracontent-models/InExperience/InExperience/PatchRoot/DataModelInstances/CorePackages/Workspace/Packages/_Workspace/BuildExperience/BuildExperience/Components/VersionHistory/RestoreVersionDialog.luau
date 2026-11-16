local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize

local ButtonVariant = Foundation.Enums.ButtonVariant
local FFlagEnableTeamTestLua = SharedFlags.FFlagEnableTeamTestLua

local function RestoreVersionDialog(props)
	local v = useLocalization({
		cancel = LocalizationStrings.VERSION_HISTORY_CANCEL,
		revert = LocalizationStrings.CHAT_REVERT_CONFIRMATION_ACTION,
		restore = LocalizationStrings.VERSION_HISTORY_RESTORE
	})

	local cancel = v.cancel
	local revert = v.revert
	local restore = v.restore
	local onActivated = React.useCallback(function()
		if props.isLoading then
			return
		end

		props.onRestore()
	end, { props.isLoading, props.onRestore })
	local onActivated2 = React.useCallback(function()
		if props.isLoading then
			return
		end

		props.onCancel()
	end, { props.isLoading, props.onCancel })

	local v2 = React.useMemo(function()
		local text

		if FFlagEnableTeamTestLua then
			text = revert
		else
			text = restore
		end

		return {
			LayoutOrder = 3,
			actions = {
				{
					text = text,
					variant = ButtonVariant.Emphasis,
					isDisabled = props.isLoading,
					isLoading = props.isLoading,
					onActivated = onActivated
				},
				{
					text = cancel,
					variant = ButtonVariant.Standard,
					isDisabled = props.isLoading,
					onActivated = onActivated2
				}
			}
		}
	end, { cancel, onActivated, onActivated2, props.isLoading, restore, revert })

	if props.isOpen == false then
		return nil
	end

	return React.createElement(
		Dialog.Root,
		{
			disablePortal = false,
			hasBackdrop = true,
			size = DialogSize.Small,
			testId = "restore-version-dialog"
		},
		{
			Title = React.createElement(Dialog.Title, { LayoutOrder = 1, text = props.title }),
			Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
				Description = React.createElement(Dialog.Text, { Text = props.description })
			}),
			Actions = React.createElement(Dialog.Actions, v2)
		}
	)
end

return RestoreVersionDialog
