local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/InputHandlers")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactFocusNavigation")

local useLocalization = Localization.Hooks.useLocalization

local dialog = Foundation.Dialog
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local v5 = {
	title = "Feature.Moments.Label.DeleteCommentTitle",
	body = "Feature.Moments.Label.DeleteCommentBody",
	delete = "Feature.Moments.Action.Delete",
	cancel = "Feature.Moments.Action.Cancel"
}

local function CommentDeleteConfirmationDialog(props)
	local v6 = useLocalization(v5)
	local onCancel = props.onCancel
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
		size = Foundation.Enums.DialogSize.Medium,
		hasBackdrop = true,
		testId = `moments-comment-delete-dialog-{props.commentId}`
	}, {
		DialogTitle = React.createElement(dialog.Title, {
			text = v6.title,
			LayoutOrder = 1
		}),
		DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
			DialogText = React.createElement(dialog.Text, { Text = v6.body })
		}),
		DialogActions = React.createElement(dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v6.delete,
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					onActivated = props.onConfirm,
					testId = `moments-comment-delete-confirm-{props.commentId}`
				},
				{
					text = v6.cancel,
					variant = Foundation.Enums.ButtonVariant.Standard,
					onActivated = props.onCancel,
					testId = `moments-comment-delete-cancel-{props.commentId}`
				}
			}
		})
	})
end

return CommentDeleteConfirmationDialog
