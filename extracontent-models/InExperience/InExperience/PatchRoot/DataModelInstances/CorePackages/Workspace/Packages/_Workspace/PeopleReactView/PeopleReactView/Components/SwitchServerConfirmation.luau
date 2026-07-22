local GuiService = game:GetService("GuiService")
local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local RunService = game:GetService("RunService")
local Foundation = require(PeopleReactViewParent.Foundation)
local Localization = require(PeopleReactViewParent.Localization)
local React = require(PeopleReactViewParent.React)
local Constants = require(PeopleReactView.Constants)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local EnumsOrientation = Foundation.Enums.Orientation
local useLocalization = Localization.Hooks.useLocalization
local LaunchGame = require(PeopleReactViewParent.GameLaunch).LaunchGame
local default = require(PeopleReactViewParent.ExperienceService).GameProtocol.default
local SwitchServerTelemetry = require(PeopleReactView.Telemetry.SwitchServerTelemetry)

local function SwitchServerConfirmation(t1: {[any]: any}) -- line: 33
	-- upvalues: useLocalization (copy), Constants (copy), GuiService (copy), RunService (copy), React (copy), SwitchServerTelemetry (copy), LaunchGame (copy), default (copy), Dialog (copy), DialogSize (copy), EnumsOrientation (copy), ButtonVariant (copy)
	local v19 = useLocalization({
		title = Constants.PEOPLEPAGE.SWITCH_SERVER_CONFIRMATION.TITLE,
		body = Constants.PEOPLEPAGE.SWITCH_SERVER_CONFIRMATION.BODY,
		confirm = Constants.PEOPLEPAGE.SWITCH_SERVER_CONFIRMATION.CONFIRM,
		cancel = Constants.PEOPLEPAGE.SWITCH_SERVER_CONFIRMATION.CANCEL
	})
	local v20 = React.useCallback(function() -- line: 50
		-- upvalues: SwitchServerTelemetry (copy), t1 (copy), LaunchGame (copy), Constants (copy), default (copy), GuiService (copy), RunService (copy)
		SwitchServerTelemetry.sendSwitchServerConfirmationActions({
			event_type = "confirm"
		})
		t1.setSwitchServerConfirmationOpen(false)
		LaunchGame(tostring(game.PlaceId), Constants.PEOPLEPAGE.PAGE_ID, {
			gameIdToExclude = tostring(game.JobId)
		}, default, Constants.PEOPLEPAGE.SOURCE)
		GuiService.SelectedCoreObject = nil
		RunService.RenderStepped:Wait()
		RunService.RenderStepped:Wait()
		game:Shutdown()
	end, {
		t1.setSwitchServerConfirmationOpen,
		game.PlaceId,
		game.JobId
	})
	local v21 = React.useCallback(function() -- line: 66
		-- upvalues: SwitchServerTelemetry (copy), t1 (copy)
		SwitchServerTelemetry.sendSwitchServerConfirmationActions({
			event_type = "cancel"
		})
		t1.setSwitchServerConfirmationOpen(false)
	end, { t1.setSwitchServerConfirmationOpen })

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		disablePortal = false,
		size = DialogSize.Small,
		onClose = v21
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v19.title
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			DialogText = React.createElement(Dialog.Text, {
				Text = v19.body
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			orientation = EnumsOrientation.Vertical,
			actions = {
				{
					text = v19.confirm,
					variant = ButtonVariant.Emphasis,
					onActivated = v20
				},
				{
					text = v19.cancel,
					variant = ButtonVariant.Standard,
					onActivated = v21
				}
			}
		})
	})
end

return React.memo(SwitchServerConfirmation)
