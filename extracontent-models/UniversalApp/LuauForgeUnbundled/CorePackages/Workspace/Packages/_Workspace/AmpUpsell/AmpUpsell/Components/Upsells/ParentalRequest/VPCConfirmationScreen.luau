local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Localization").Hooks.useLocalization
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactUtils").Hooks.RoactRodux.useSelector
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Cryo")

local GetFFlagEnableVPCUpsellFoundationDialogHardening = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableVPCUpsellFoundationDialogHardening")
local GetShouldUseFoundationUIVPCUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetShouldUseFoundationUIVPCUpsell")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Foundation")
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function VPCConfirmationScreen(props)
	local onAck = props.onAck
	local v5 = useSelector(selectScreenSize)
	local messageStrings = props.messageStrings
	local parentEmails = props.parentEmails
	local v6 = if props.disablePortal then props.disablePortal else false
	local v7 = if props.isInExperienceEntry then props.isInExperienceEntry else false
	local v8 = GetShouldUseFoundationUIVPCUpsell(v7)
	local v9

	if #parentEmails == 1 then
		v9 = useLocalization(Cryo.Dictionary.join(messageStrings, {
			bodyText = {
				messageStrings.oneParentBody,
				parentEmail = parentEmails[1]
			}
		}))
	else
		v9 = useLocalization(Cryo.Dictionary.join(messageStrings, {
			bodyText = messageStrings.multipleParentsBody
		}))
	end

	if v8 then
		return React.createElement(dialog.Root, {
			size = dialogSize.Small,
			onClose = props.onClose or onAck,
			disablePortal = v6,
			hasBackdrop = GetFFlagEnableVPCUpsellFoundationDialogHardening() and true or false
		}, {
			DialogTitle = React.createElement(dialog.Title, { text = v9.title }),
			DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
				DialogText = React.createElement(dialog.Text, { Text = v9.bodyText })
			}),
			DialogActions = React.createElement(dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = v9.buttonText,
						variant = buttonVariant.Standard,
						onActivated = onAck
					}
				}
			})
		})
	end

	return React.createElement(interactiveAlert, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = v5,
		title = v9.title,
		bodyText = v9.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = onAck, text = v9.buttonText }
				}
			}
		}
	})
end

return VPCConfirmationScreen
