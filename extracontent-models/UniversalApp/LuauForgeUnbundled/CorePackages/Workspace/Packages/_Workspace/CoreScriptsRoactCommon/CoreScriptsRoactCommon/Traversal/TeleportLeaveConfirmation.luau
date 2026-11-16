local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/React")

local TeleportBack = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/TeleportBack")
local TraversalTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/TraversalTelemetry")

local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant
local orientation = Foundation.Enums.Orientation
local useLocalization = Localization.Hooks.useLocalization

local function TeleportLeaveConfirmation(props, p2)
	local v5 = useLocalization({
		leaveHeader = "CoreScripts.InGameMenu.Traversal.LeaveHeader",
		leaveBody = {
			"CoreScripts.InGameMenu.Traversal.LeaveBody",
			PREVIOUS_EXPERIENCE = props.teleportName
		},
		leaveContinueAction = "CoreScripts.InGameMenu.Actions.Continue",
		leaveCancelAction = "CoreScripts.InGameMenu.Cancel"
	})

	local v6 = React.useCallback(function()
		TraversalTelemetry.sendTeleportConfirmationActions({
			source = props.source,
			event_type = "confirm"
		})

		TeleportBack(props.placeId)
	end, { TeleportBack, props.placeId })

	return React.createElement(dialog.Root, {
		size = dialogSize.Small,
		onClose = function(p3)
			TraversalTelemetry.sendTeleportConfirmationActions({
				source = props.source,
				event_type = "cancel"
			})

			if props.onClose then
				props.onClose(p3)
			end
		end,
		hasBackdrop = props.hasBackdrop == nil or props.hasBackdrop,
		ref = p2
	}, {
		DialogTitle = React.createElement(dialog.Title, {
			text = v5.leaveHeader,
			testId = "--foundation-dialog--title"
		}),
		DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
			DialogText = React.createElement(dialog.Text, { Text = v5.leaveBody })
		}),
		DialogActions = React.createElement(dialog.Actions, {
			orientation = orientation.Vertical,
			LayoutOrder = 3,
			actions = {
				{
					text = v5.leaveContinueAction,
					variant = buttonVariant.Emphasis,
					onActivated = v6,
					testId = "--teleport-leave-continue"
				},
				{
					text = v5.leaveCancelAction,
					variant = buttonVariant.Standard,
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
