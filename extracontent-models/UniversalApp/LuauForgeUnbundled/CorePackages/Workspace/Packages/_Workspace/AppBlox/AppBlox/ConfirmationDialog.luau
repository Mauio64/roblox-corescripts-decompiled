local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Localization").Hooks.useLocalization
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/InputHandlers")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/ReactFocusNavigation")
local dialog = Foundation.Dialog
local buttonVariant = Foundation.Enums.ButtonVariant
local orientation = Foundation.Enums.Orientation
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags")
local fFlagLuaAppPlayButtonPrivatePT = SharedFlags.FFlagLuaAppPlayButtonPrivatePT
local fFlagAppBloxConfirmationDialogFocusNav = SharedFlags.FFlagAppBloxConfirmationDialogFocusNav
local fFlagAppBloxConfirmationDialogBackCloses = SharedFlags.FFlagAppBloxConfirmationDialogBackCloses
local fFlagSplitPaneUnsavedDialogAlertStyle = SharedFlags.FFlagSplitPaneUnsavedDialogAlertStyle

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").FFlagEnableSplitPane

return function(props)
	local v5 = useLocalization({
		confirmButtonText = "CommonUI.Controls.Action.Confirm",
		cancelButtonText = "CommonUI.Controls.Action.Cancel"
	})
	local v6, v7

	if fFlagAppBloxConfirmationDialogFocusNav then
		local v8

		if fFlagAppBloxConfirmationDialogBackCloses then
			v8 = props.onClose or props.onCancel
		else
			v8 = props.onCancel
		end

		local v9 = React.useMemo(function()
			return {
				[focusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(function(object)
						v8()
						object:cancel()
					end)
				}
			}
		end, { v8 })

		v6, v7 = useDefaultFocusBehavior((useFocusRoot({
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
			isAutoFocusRoot = true,
			shouldRestoreFocus = false,
			eventMap = navigateBacks,
			eventHandlers = v9
		})))
	end

	local v8

	if fFlagLuaAppPlayButtonPrivatePT then
		local v9 = {
			variant = buttonVariant.Emphasis,
			text = props.confirmButtonText or v5.confirmButtonText,
			onActivated = props.onConfirm,
			ref = v6
		}

		local v11 = if fFlagSplitPaneUnsavedDialogAlertStyle and props.cancelButtonVariant then props.cancelButtonVariant else buttonVariant.Standard
		local v10 = {
			variant = v11,
			text = props.cancelButtonText or v5.cancelButtonText,
			onActivated = props.onCancel,
			ref = 0
		}

		local v12 = if props.hideConfirmButton then v6 else nil
		v10.ref = v12

		v8 = props.hideConfirmButton and { v10 } or { v9, v10 }
	end

	local createElement = React.createElement
	local root = dialog.Root
	local v9 = {
		hasBackdrop = not fFlagEnableSplitPane or props.hasBackdrop == nil or props.hasBackdrop,
		disablePortal = props.disablePortal,
		size = 0,
		ref = 0,
		onClose = 0
	}
	local v10 = if fFlagLuaAppPlayButtonPrivatePT then props.size else nil
	v9.size = v10
	v9.ref = v7
	local v11

	if (fFlagEnableSplitPane or fFlagAppBloxConfirmationDialogBackCloses) and props.onClose ~= nil then
		v11 = props.onClose
	elseif props.showCloseButton then
		v11 = props.onCancel
	end

	v9.onClose = v11

	local v12 = {
		DialogTitle = React.createElement(dialog.Title, { text = props.title }),
		DialogContent = React.createElement(dialog.Content, nil, {
			DialogText = React.createElement(dialog.Text, { Text = props.body })
		}),
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local actions = dialog.Actions
	local v14 = if fFlagLuaAppPlayButtonPrivatePT and props.orientButtonsVertically then orientation.Vertical else nil
	local v13 = { orientation = v14, actions = 0 }

	if not fFlagLuaAppPlayButtonPrivatePT then
		v8 = { nil, nil }
		local v15 = {
			variant = buttonVariant.Emphasis,
			text = props.confirmButtonText or v5.confirmButtonText,
			onActivated = props.onConfirm,
			ref = v6
		}

		local v17 = if fFlagSplitPaneUnsavedDialogAlertStyle and props.cancelButtonVariant then props.cancelButtonVariant else buttonVariant.Standard
		v8[1], v8[2] = v15, {
	variant = v17,
	text = props.cancelButtonText or v5.cancelButtonText,
	onActivated = props.onCancel
}
	end

	v13.actions = v8
	v12.DialogActions = createElement2(actions, v13)
	return createElement(root, v9, v12)
end
