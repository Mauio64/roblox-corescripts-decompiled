local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/InputHandlers")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactFocusNavigation")

local dialog = Foundation.Dialog
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useLocalization = Localization.Hooks.useLocalization

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local v5 = {
	continue = "Feature.Moments.Action.Continue",
	cancel = "Feature.Moments.Action.Cancel",
	dialogTitle = "Feature.Moments.Title.EDPMomentIPReportInstructions",
	dialogBody = "Feature.Moments.Body.EDPMomentIPReportInstructions"
}

local function EdpVideoIpReportDialog(p2)
	local v6 = useLocalization(v5)
	local onCancel = p2.onCancel
	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onCancel()
					object:cancel()
				end)
			}
		}
	end, { onCancel })
	local v8 = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = v7
	})

	return React.createElement(dialog.Root, {
		ref = v8,
		disablePortal = false,
		hasBackdrop = true,
		onClose = p2.onCancel,
		size = Foundation.Enums.DialogSize.Medium,
		testId = "moments-edp-video-ip-report-dialog"
	}, {
		DialogTitle = React.createElement(dialog.Title, {
			text = v6.dialogTitle,
			LayoutOrder = 1
		}),
		DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
			DialogText = React.createElement(dialog.Text, { Text = v6.dialogBody })
		}),
		DialogActions = React.createElement(dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v6.continue,
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					onActivated = p2.onContinue,
					testId = "moments-edp-video-ip-report-continue"
				},
				{
					text = v6.cancel,
					variant = Foundation.Enums.ButtonVariant.Standard,
					onActivated = p2.onCancel,
					testId = "moments-edp-video-ip-report-cancel"
				}
			}
		})
	})
end

return EdpVideoIpReportDialog
