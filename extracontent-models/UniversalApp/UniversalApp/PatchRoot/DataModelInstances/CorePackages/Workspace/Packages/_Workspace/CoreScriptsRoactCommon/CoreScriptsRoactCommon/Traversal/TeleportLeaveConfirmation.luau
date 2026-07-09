local Parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local React = require(Parent.React)
local TeleportBack = require(script.Parent.TeleportBack)
local TraversalTelemetry = require(script.Parent.TraversalTelemetry)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local EnumsOrientation = Foundation.Enums.Orientation
local useLocalization = Localization.Hooks.useLocalization

local function TeleportLeaveConfirmation(t1: {[any]: any}, p1) -- line: 40
	-- upvalues: useLocalization (copy), React (copy), TraversalTelemetry (copy), TeleportBack (copy), Dialog (copy), DialogSize (copy), EnumsOrientation (copy), ButtonVariant (copy)
	local v15 = useLocalization({
		leaveHeader = "CoreScripts.InGameMenu.Traversal.LeaveHeader",
		leaveContinueAction = "CoreScripts.InGameMenu.Actions.Continue",
		leaveCancelAction = "CoreScripts.InGameMenu.Cancel",
		leaveBody = {
			"CoreScripts.InGameMenu.Traversal.LeaveBody",
			PREVIOUS_EXPERIENCE = t1.teleportName
		}
	})
	local v16 = React.useCallback(function() -- line: 54
		-- upvalues: TraversalTelemetry (copy), t1 (copy), TeleportBack (copy)
		TraversalTelemetry.sendTeleportConfirmationActions({
			event_type = "confirm",
			source = t1.source
		})
		TeleportBack(t1.placeId)
	end, {
		TeleportBack,
		t1.placeId
	})

	return React.createElement(Dialog.Root, {
		size = DialogSize.Small,
		onClose = function(p2) -- line: 65
			-- upvalues: TraversalTelemetry (copy), t1 (copy)
			TraversalTelemetry.sendTeleportConfirmationActions({
				event_type = "cancel",
				source = t1.source
			})

			if t1.onClose then
				t1.onClose(p2)
			end
		end,
		hasBackdrop = t1.hasBackdrop == nil or t1.hasBackdrop,
		ref = p1
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			testId = "--foundation-dialog--title",
			text = v15.leaveHeader
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			DialogText = React.createElement(Dialog.Text, {
				Text = v15.leaveBody
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			orientation = EnumsOrientation.Vertical,
			actions = {
				{
					testId = "--teleport-leave-continue",
					text = v15.leaveContinueAction,
					variant = ButtonVariant.Emphasis,
					onActivated = v16
				},
				{
					testId = "--teleport-leave-cancel",
					text = v15.leaveCancelAction,
					variant = ButtonVariant.Standard,
					onActivated = function() -- line: 105
						-- upvalues: TraversalTelemetry (copy), t1 (copy)
						TraversalTelemetry.sendTeleportConfirmationActions({
							event_type = "cancel",
							source = t1.source
						})
						t1.onCancel()
					end
				}
			}
		})
	})
end

return React.memo(React.forwardRef(TeleportLeaveConfirmation))
