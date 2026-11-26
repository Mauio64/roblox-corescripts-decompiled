local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InputHandlers")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")

local countChars = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/countChars")
local isOverLength = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/isOverLength")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Common/InputDialog/InputDialogView")

local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useInputDialogViewModel(data)
	local state, setState = React.useState(data.inputText or "")
	local maxCharacters = data.maxCharacters
	local v5 = countChars(state)
	local v6 = isOverLength(state, maxCharacters, data.maxUtf16Units)
	local isLoading = data.isLoading

	local onModalClose = data.onModalClose
	local onActivated = data.onActivated

	local v7 = React.useCallback(function()
		if not isLoading and onModalClose then
			onModalClose()
		end
	end, { onModalClose, isLoading })

	local v8 = React.useCallback(function()
		if v6 or isLoading then
			return
		end

		if not (onActivated and onActivated({ InputBox = state })) and onModalClose then
			onModalClose()
		end
	end, { onActivated, onModalClose, state, v6, isLoading })

	local v9 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					v7()
					object:cancel()
				end)
			}
		}
	end, { v7 })

	local v10 = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = v9
	})

	return {
		titleText = data.titleText,
		cancelText = data.cancelText,
		confirmText = data.confirmText,
		placeholderText = data.placeholderText,
		warningText = data.warningText,
		text = state,
		counterText = `{v5}/{maxCharacters}`,
		isOverLimit = v6,
		isLoading = isLoading,
		onTextChanged = setState,
		onConfirm = v8,
		onCancel = v7,
		dialogRef = v10
	}
end

return useInputDialogViewModel
