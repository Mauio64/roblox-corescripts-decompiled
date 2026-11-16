local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local Dialog = Foundation.Dialog
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function StopAssistantResponseDialog(p)
	local v = useLocalization({
		cancel = LocalizationStrings.CHAT_STOP_CONFIRMATION_CANCEL,
		description = LocalizationStrings.CHAT_STOP_CONFIRMATION_DESCRIPTION,
		stop = LocalizationStrings.CHAT_STOP_CONFIRMATION_ACTION,
		title = LocalizationStrings.CHAT_STOP_CONFIRMATION_TITLE
	})

	local onCancel = p.onCancel
	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onCancel()
					object:cancel()
				end)
			}
		}
	end, { onCancel })
	local ref, ref2 = useDefaultFocusBehavior((useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers
	})))

	local v2 = React.useMemo(function()
		return {
			LayoutOrder = 3,
			actions = {
				{ text = v.stop, variant = ButtonVariant.Alert, onActivated = p.onConfirm },
				{
					text = v.cancel,
					variant = ButtonVariant.Standard,
					onActivated = onCancel,
					ref = ref
				}
			}
		}
	end, { v.cancel, v.stop, onCancel, p.onConfirm, ref })

	return React.createElement(Dialog.Root, {
		ref = ref2,
		disablePortal = false,
		hasBackdrop = true,
		size = DialogSize.Small,
		testId = "stop-assistant-response-dialog"
	}, {
		Title = React.createElement(Dialog.Title, { LayoutOrder = 1, text = v.title }),
		Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			Description = React.createElement(Dialog.Text, { Text = v.description })
		}),
		Actions = React.createElement(Dialog.Actions, v2)
	})
end

return StopAssistantResponseDialog
