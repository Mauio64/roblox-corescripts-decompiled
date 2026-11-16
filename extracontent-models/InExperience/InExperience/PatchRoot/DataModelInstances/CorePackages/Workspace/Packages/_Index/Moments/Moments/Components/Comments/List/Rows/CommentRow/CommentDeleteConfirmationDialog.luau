local parent = script:FindFirstAncestor("Moments").Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local InputHandlers = require(parent.InputHandlers)
local Localization = require(parent.Localization)
local React = require(parent.React)
require(parent.ReactFocusNavigation)

local useLocalization = Localization.Hooks.useLocalization

local Dialog = Foundation.Dialog
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local v = {
	title = "Feature.Moments.Label.DeleteCommentTitle",
	body = "Feature.Moments.Label.DeleteCommentBody",
	delete = "Feature.Moments.Action.Delete",
	cancel = "Feature.Moments.Action.Cancel"
}

local function CommentDeleteConfirmationDialog(props)
	local v2 = useLocalization(v)
	local onCancel = props.onCancel
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
		size = Foundation.Enums.DialogSize.Medium,
		hasBackdrop = true,
		testId = `moments-comment-delete-dialog-{props.commentId}`
	}, {
		DialogTitle = React.createElement(Dialog.Title, { text = v2.title, LayoutOrder = 1 }),
		DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			DialogText = React.createElement(Dialog.Text, { Text = v2.body })
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v2.delete,
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					onActivated = props.onConfirm,
					testId = `moments-comment-delete-confirm-{props.commentId}`
				},
				{
					text = v2.cancel,
					variant = Foundation.Enums.ButtonVariant.Standard,
					onActivated = props.onCancel,
					testId = `moments-comment-delete-cancel-{props.commentId}`
				}
			}
		})
	})
end

return CommentDeleteConfirmationDialog
