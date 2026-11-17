local parent = script:FindFirstAncestor("Groups").Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local InputHandlers = require(parent.InputHandlers)
local Responsive = require(parent.Responsive)

require(script.Parent.SettingsTextInputFieldView)

local NavigateBack = FocusNavigationUtils.FocusNavigationEventNameEnum.NavigateBack
local navigateBacks = {
	[Enum.KeyCode.ButtonB] = NavigateBack,
	[Enum.KeyCode.Escape] = NavigateBack
}

local function useSettingsTextInputFieldViewModel(data)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(data.value)
	local draft, v = React.useBinding(data.value)
	local v2 = React.useCallback(function(p: string)
		setState2(p)

		v(p)
	end, { v })
	local v3 = utf8.len(state2)
	local hasError = v3 == nil or v3 == 0 or data.maxLength < v3
	local canSave = not hasError and state2 ~= data.value

	local v4 = useLocalization({
		save = "CommonUI.Controls.Action.Confirm",
		cancel = "CommonUI.Controls.Action.Cancel"
	})

	local onOpen = React.useCallback(function()
		v2(data.value)
		setState(true)
	end, { data.value, v2 })

	local onDraftChanged = React.useCallback(function(value: string)
		local v5 = utf8.len(value)

		if v5 and data.maxLength < v5 then
			value = string.sub(value, 1, utf8.offset(value, data.maxLength + 1) - 1)
		end

		v2(value)
	end, { data.maxLength, v2 })

	local onCancel = React.useCallback(function()
		setState(false)
	end, {})

	local onSave = React.useCallback(function()
		if state and canSave then
			data.onChange(state2)
			setState(false)
		end
	end, { state, canSave, state2, data.onChange })

	local eventHandlers = React.useMemo(function()
		return {
			[NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onCancel()
					object:cancel()
				end)
			}
		}
	end, { onCancel })

	local v5 = FocusNavigationUtils.useFocusRoot({
		surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isFocusable = state,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers
	})

	local inputRef, dialogRef = ReactFocusNavigation.useDefaultFocusBehavior(v5)
	local hideCloseButton = Responsive.usePreferredInput() == Responsive.Input.Directional

	return {
		title = data.title,
		value = data.value,
		description = data.description,
		isEditing = state,
		draft = draft,
		hasError = hasError,
		canSave = canSave,
		saveText = v4.save,
		cancelText = v4.cancel,
		remainingCharacters = data.maxLength - (v3 or 0),
		hideCloseButton = hideCloseButton,
		dialogRef = dialogRef,
		inputRef = inputRef,
		onOpen = onOpen,
		onCancel = onCancel,
		onDraftChanged = onDraftChanged,
		onSave = onSave,
		LayoutOrder = data.LayoutOrder,
		testId = data.testId or "--settings-text-input-field"
	}
end

return useSettingsTextInputFieldViewModel
