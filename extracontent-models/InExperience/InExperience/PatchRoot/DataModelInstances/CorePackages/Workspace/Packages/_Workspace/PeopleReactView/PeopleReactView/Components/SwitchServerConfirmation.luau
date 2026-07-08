local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
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

local function SwitchServerConfirmation(t1: {[any]: any}) -- line: 26
	-- upvalues: useLocalization (copy), Constants (copy), React (copy), LaunchGame (copy), default (copy), Dialog (copy), DialogSize (copy), EnumsOrientation (copy), ButtonVariant (copy)
	local v16 = useLocalization({
		title = Constants.PEOPLEPAGE.SWITCH_SERVER_CONFIRMATION.TITLE,
		body = Constants.PEOPLEPAGE.SWITCH_SERVER_CONFIRMATION.BODY,
		confirm = Constants.PEOPLEPAGE.SWITCH_SERVER_CONFIRMATION.CONFIRM,
		cancel = Constants.PEOPLEPAGE.SWITCH_SERVER_CONFIRMATION.CANCEL
	})
	local v17 = React.useCallback(function() -- line: 34
		-- upvalues: t1 (copy), LaunchGame (copy), Constants (copy), default (copy)
		t1.onClose()
		LaunchGame(tostring(game.PlaceId), Constants.PEOPLEPAGE.PAGE_ID, {
			gameIdToExclude = tostring(game.JobId)
		}, default, Constants.PEOPLEPAGE.SOURCE)
	end, {
		t1.onClose,
		game.PlaceId,
		game.JobId
	})

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		disablePortal = false,
		size = DialogSize.Small,
		onClose = t1.onClose
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v16.title
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			DialogText = React.createElement(Dialog.Text, {
				Text = v16.body
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			orientation = EnumsOrientation.Vertical,
			actions = {
				{
					text = v16.confirm,
					variant = ButtonVariant.Emphasis,
					onActivated = v17
				},
				{
					text = v16.cancel,
					variant = ButtonVariant.Standard,
					onActivated = t1.onClose
				}
			}
		})
	})
end

return React.memo(SwitchServerConfirmation)
