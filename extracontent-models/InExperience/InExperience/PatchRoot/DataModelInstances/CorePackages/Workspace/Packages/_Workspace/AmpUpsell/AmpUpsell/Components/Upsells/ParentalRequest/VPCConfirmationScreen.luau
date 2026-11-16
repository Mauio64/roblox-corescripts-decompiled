local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local UIBlox = require(parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Cryo = require(parent.Cryo)

local GetFFlagEnableVPCUpsellFoundationDialogHardening = require(AmpUpsell.Flags.GetFFlagEnableVPCUpsellFoundationDialogHardening)
local GetShouldUseFoundationUIVPCUpsell = require(AmpUpsell.Flags.GetShouldUseFoundationUIVPCUpsell)

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local function selectScreenSize(p)
	return p.ScreenSize
end

local function VPCConfirmationScreen(props)
	local onAck = props.onAck
	local screenSize = useSelector(selectScreenSize)
	local messageStrings = props.messageStrings
	local parentEmails = props.parentEmails
	local disablePortal

	if props.disablePortal then
		disablePortal = props.disablePortal
	else
		disablePortal = false
	end

	local v

	if props.isInExperienceEntry then
		v = props.isInExperienceEntry
	else
		v = false
	end

	local shouldUseFoundationUIVPCUpsell = GetShouldUseFoundationUIVPCUpsell(v)
	local v2

	if #parentEmails == 1 then
		v2 = useLocalization(Cryo.Dictionary.join(messageStrings, {
			bodyText = {
				messageStrings.oneParentBody,
				parentEmail = parentEmails[1]
			}
		}))
	else
		v2 = useLocalization(Cryo.Dictionary.join(messageStrings, {
			bodyText = messageStrings.multipleParentsBody
		}))
	end

	if shouldUseFoundationUIVPCUpsell then
		return React.createElement(Dialog.Root, {
			size = DialogSize.Small,
			onClose = props.onClose or onAck,
			disablePortal = disablePortal,
			hasBackdrop = GetFFlagEnableVPCUpsellFoundationDialogHardening() and true or false
		}, {
			DialogTitle = React.createElement(Dialog.Title, { text = v2.title }),
			DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
				DialogText = React.createElement(Dialog.Text, { Text = v2.bodyText })
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{ text = v2.buttonText, variant = ButtonVariant.Standard, onActivated = onAck }
				}
			})
		})
	end

	return React.createElement(InteractiveAlert, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = screenSize,
		title = v2.title,
		bodyText = v2.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.PrimarySystem,
					props = { onActivated = onAck, text = v2.buttonText }
				}
			}
		}
	})
end

return VPCConfirmationScreen
