local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
require(parent.ReactFocusNavigation)

local countChars = require(AppChat.Utils.countChars)
local isOverLength = require(AppChat.Utils.isOverLength)
require(script.Parent.InputDialogView)

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useInputDialogViewModel(data)
	local state, setState = React.useState(data.inputText or "")
	local maxCharacters = data.maxCharacters
	local v = countChars(state)
	local overLength = isOverLength(state, maxCharacters, data.maxUtf16Units)
	local isLoading = data.isLoading

	local onModalClose = data.onModalClose
	local onActivated = data.onActivated

	local onCancel = React.useCallback(function()
		if not isLoading and onModalClose then
			onModalClose()
		end
	end, { onModalClose, isLoading })

	local onConfirm = React.useCallback(function()
		if overLength or isLoading then
			return
		end

		if not (onActivated and onActivated({ InputBox = state })) and onModalClose then
			onModalClose()
		end
	end, { onActivated, onModalClose, state, overLength, isLoading })

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

	local dialogRef = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers
	})

	return {
		titleText = data.titleText,
		cancelText = data.cancelText,
		confirmText = data.confirmText,
		placeholderText = data.placeholderText,
		warningText = data.warningText,
		text = state,
		counterText = `{v}/{maxCharacters}`,
		isOverLimit = overLength,
		isLoading = isLoading,
		onTextChanged = setState,
		onConfirm = onConfirm,
		onCancel = onCancel,
		dialogRef = dialogRef
	}
end

return useInputDialogViewModel
