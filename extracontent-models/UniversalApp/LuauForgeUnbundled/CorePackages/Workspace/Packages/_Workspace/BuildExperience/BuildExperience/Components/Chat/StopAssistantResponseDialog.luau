local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ReactFocusNavigation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local dialog = Foundation.Dialog
local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function StopAssistantResponseDialog(p2)
	local v5 = useLocalization({
		cancel = LocalizationStrings.CHAT_STOP_CONFIRMATION_CANCEL,
		description = LocalizationStrings.CHAT_STOP_CONFIRMATION_DESCRIPTION,
		stop = LocalizationStrings.CHAT_STOP_CONFIRMATION_ACTION,
		title = LocalizationStrings.CHAT_STOP_CONFIRMATION_TITLE
	})

	local onCancel = p2.onCancel
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onCancel()
					object:cancel()
				end)
			}
		}
	end, { onCancel })
	local v8, v9 = useDefaultFocusBehavior((useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false,
		eventMap = navigateBacks,
		eventHandlers = v6
	})))

	local v10 = React.useMemo(function()
		return {
			LayoutOrder = 3,
			actions = {
				{
					text = v5.stop,
					variant = buttonVariant.Alert,
					onActivated = p2.onConfirm
				},
				{
					text = v5.cancel,
					variant = buttonVariant.Standard,
					onActivated = onCancel,
					ref = v8
				}
			}
		}
	end, { v5.cancel, v5.stop, onCancel, p2.onConfirm, v8 })

	return React.createElement(dialog.Root, {
		ref = v9,
		disablePortal = false,
		hasBackdrop = true,
		size = dialogSize.Small,
		testId = "stop-assistant-response-dialog"
	}, {
		Title = React.createElement(dialog.Title, { LayoutOrder = 1, text = v5.title }),
		Content = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
			Description = React.createElement(dialog.Text, { Text = v5.description })
		}),
		Actions = React.createElement(dialog.Actions, v10)
	})
end

return StopAssistantResponseDialog
