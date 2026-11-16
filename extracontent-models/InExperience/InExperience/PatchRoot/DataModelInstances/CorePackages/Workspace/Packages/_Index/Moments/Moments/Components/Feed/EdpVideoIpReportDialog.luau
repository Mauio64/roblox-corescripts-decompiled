local parent = script:FindFirstAncestor("Moments").Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local InputHandlers = require(parent.InputHandlers)
local Localization = require(parent.Localization)
local React = require(parent.React)
require(parent.ReactFocusNavigation)

local Dialog = Foundation.Dialog
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useLocalization = Localization.Hooks.useLocalization

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local v = {
	continue = "Feature.Moments.Action.Continue",
	cancel = "Feature.Moments.Action.Cancel",
	dialogTitle = "Feature.Moments.Title.EDPMomentIPReportInstructions",
	dialogBody = "Feature.Moments.Body.EDPMomentIPReportInstructions"
}

local function EdpVideoIpReportDialog(p)
	local v2 = useLocalization(v)
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
	local ref = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers
	})

	return React.createElement(Dialog.Root, {
		ref = ref,
		disablePortal = false,
		hasBackdrop = true,
		onClose = p.onCancel,
		size = Foundation.Enums.DialogSize.Medium,
		testId = "moments-edp-video-ip-report-dialog"
	}, {
		DialogTitle = React.createElement(Dialog.Title, { text = v2.dialogTitle, LayoutOrder = 1 }),
		DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			DialogText = React.createElement(Dialog.Text, { Text = v2.dialogBody })
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v2.continue,
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					onActivated = p.onContinue,
					testId = "moments-edp-video-ip-report-continue"
				},
				{
					text = v2.cancel,
					variant = Foundation.Enums.ButtonVariant.Standard,
					onActivated = p.onCancel,
					testId = "moments-edp-video-ip-report-cancel"
				}
			}
		})
	})
end

return EdpVideoIpReportDialog
