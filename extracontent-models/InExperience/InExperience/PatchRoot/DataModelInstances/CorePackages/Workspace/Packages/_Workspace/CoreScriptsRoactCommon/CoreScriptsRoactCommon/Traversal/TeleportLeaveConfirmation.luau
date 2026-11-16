local parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local TeleportBack = require(script.Parent.TeleportBack)
local TraversalTelemetry = require(script.Parent.TraversalTelemetry)

local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local Orientation = Foundation.Enums.Orientation
local useLocalization = Localization.Hooks.useLocalization

local function TeleportLeaveConfirmation(props, ref)
	local v = useLocalization({
		leaveHeader = "CoreScripts.InGameMenu.Traversal.LeaveHeader",
		leaveBody = {
			"CoreScripts.InGameMenu.Traversal.LeaveBody",
			PREVIOUS_EXPERIENCE = props.teleportName
		},
		leaveContinueAction = "CoreScripts.InGameMenu.Actions.Continue",
		leaveCancelAction = "CoreScripts.InGameMenu.Cancel"
	})

	local onActivated = React.useCallback(function()
		TraversalTelemetry.sendTeleportConfirmationActions({
			source = props.source,
			event_type = "confirm"
		})

		TeleportBack(props.placeId)
	end, { TeleportBack, props.placeId })

	return React.createElement(Dialog.Root, {
		size = DialogSize.Small,
		onClose = function(p)
			TraversalTelemetry.sendTeleportConfirmationActions({
				source = props.source,
				event_type = "cancel"
			})

			if props.onClose then
				props.onClose(p)
			end
		end,
		hasBackdrop = props.hasBackdrop == nil or props.hasBackdrop,
		ref = ref
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v.leaveHeader,
			testId = "--foundation-dialog--title"
		}),
		DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			DialogText = React.createElement(Dialog.Text, { Text = v.leaveBody })
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			orientation = Orientation.Vertical,
			LayoutOrder = 3,
			actions = {
				{
					text = v.leaveContinueAction,
					variant = ButtonVariant.Emphasis,
					onActivated = onActivated,
					testId = "--teleport-leave-continue"
				},
				{
					text = v.leaveCancelAction,
					variant = ButtonVariant.Standard,
					onActivated = function()
						TraversalTelemetry.sendTeleportConfirmationActions({
							source = props.source,
							event_type = "cancel"
						})

						props.onCancel()
					end,
					testId = "--teleport-leave-cancel"
				}
			}
		})
	})
end

return React.memo(React.forwardRef(TeleportLeaveConfirmation))
