local parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Foundation = require(parent.Foundation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local Dialog = Foundation.Dialog
local ButtonVariant = Foundation.Enums.ButtonVariant
local Orientation = Foundation.Enums.Orientation
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonPrivatePT = SharedFlags.FFlagLuaAppPlayButtonPrivatePT
local FFlagAppBloxConfirmationDialogFocusNav = SharedFlags.FFlagAppBloxConfirmationDialogFocusNav
local FFlagAppBloxConfirmationDialogBackCloses = SharedFlags.FFlagAppBloxConfirmationDialogBackCloses
local FFlagSplitPaneUnsavedDialogAlertStyle = SharedFlags.FFlagSplitPaneUnsavedDialogAlertStyle

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableSplitPane = SharedFlags2.FFlagEnableSplitPane

return function(props)
	local v = useLocalization({
		confirmButtonText = "CommonUI.Controls.Action.Confirm",
		cancelButtonText = "CommonUI.Controls.Action.Cancel"
	})
	local ref, ref2

	if FFlagAppBloxConfirmationDialogFocusNav then
		local v2

		if FFlagAppBloxConfirmationDialogBackCloses then
			v2 = props.onClose or props.onCancel
		else
			v2 = props.onCancel
		end

		local eventHandlers = React.useMemo(function()
			return {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(function(object)
						v2()
						object:cancel()
					end)
				}
			}
		end, { v2 })

		ref, ref2 = useDefaultFocusBehavior((useFocusRoot({
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
			isAutoFocusRoot = true,
			shouldRestoreFocus = false,
			eventMap = navigateBacks,
			eventHandlers = eventHandlers
		})))
	end

	local actions2

	if FFlagLuaAppPlayButtonPrivatePT then
		local v2 = {
			variant = ButtonVariant.Emphasis,
			text = props.confirmButtonText or v.confirmButtonText,
			onActivated = props.onConfirm,
			ref = ref
		}
		local variant

		if FFlagSplitPaneUnsavedDialogAlertStyle and props.cancelButtonVariant then
			variant = props.cancelButtonVariant
		else
			variant = ButtonVariant.Standard
		end

		local v3 = {
			variant = variant,
			text = props.cancelButtonText or v.cancelButtonText,
			onActivated = props.onCancel,
			ref = 0
		}
		local ref3

		if props.hideConfirmButton then
			ref3 = ref
		end

		v3.ref = ref3

		actions2 = props.hideConfirmButton and { v3 } or { v2, v3 }
	end

	local createElement = React.createElement
	local root = Dialog.Root
	local v2 = {
		hasBackdrop = not FFlagEnableSplitPane or props.hasBackdrop == nil or props.hasBackdrop,
		disablePortal = props.disablePortal,
		size = 0,
		ref = 0,
		onClose = 0
	}
	local size

	if FFlagLuaAppPlayButtonPrivatePT then
		size = props.size
	end

	v2.size = size
	v2.ref = ref2
	local onClose

	if (FFlagEnableSplitPane or FFlagAppBloxConfirmationDialogBackCloses) and props.onClose ~= nil then
		onClose = props.onClose
	elseif props.showCloseButton then
		onClose = props.onCancel
	end

	v2.onClose = onClose

	local v3 = {
		DialogTitle = React.createElement(Dialog.Title, { text = props.title }),
		DialogContent = React.createElement(Dialog.Content, nil, {
			DialogText = React.createElement(Dialog.Text, { Text = props.body })
		}),
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local actions = Dialog.Actions
	local orientation

	if FFlagLuaAppPlayButtonPrivatePT and props.orientButtonsVertically then
		orientation = Orientation.Vertical
	end

	local v4 = { orientation = orientation, actions = 0 }

	if not FFlagLuaAppPlayButtonPrivatePT then
		actions2 = { nil, nil }
		local v5 = {
			variant = ButtonVariant.Emphasis,
			text = props.confirmButtonText or v.confirmButtonText,
			onActivated = props.onConfirm,
			ref = ref
		}
		local variant

		if FFlagSplitPaneUnsavedDialogAlertStyle and props.cancelButtonVariant then
			variant = props.cancelButtonVariant
		else
			variant = ButtonVariant.Standard
		end

		actions2[1], actions2[2] = v5, {
	variant = variant,
	text = props.cancelButtonText or v.cancelButtonText,
	onActivated = props.onCancel
}
	end

	v4.actions = actions2
	v3.DialogActions = createElement2(actions, v4)
	return createElement(root, v2, v3)
end
