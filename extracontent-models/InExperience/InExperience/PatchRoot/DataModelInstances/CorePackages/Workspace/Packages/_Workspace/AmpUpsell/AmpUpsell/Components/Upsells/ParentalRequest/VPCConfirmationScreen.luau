local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local React = require(AmpUpsellParent.React)
local useLocalization = require(AmpUpsellParent.Localization).Hooks.useLocalization
local useSelector = require(AmpUpsellParent.RoactUtils).Hooks.RoactRodux.useSelector
local UIBlox = require(AmpUpsellParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Cryo = require(AmpUpsellParent.Cryo)
local GetFFlagEnableVPCUpsellFoundationDialogHardening = require(AmpUpsell.Flags.GetFFlagEnableVPCUpsellFoundationDialogHardening)
local GetShouldUseFoundationUIVPCUpsell = require(AmpUpsell.Flags.GetShouldUseFoundationUIVPCUpsell)
local Foundation = require(AmpUpsellParent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local function selectScreenSize(p1) -- line: 27
	return p1.ScreenSize
end
local function VPCConfirmationScreen(t1: {[any]: any}) -- line: 31
	-- upvalues: useSelector (copy), selectScreenSize (copy), GetShouldUseFoundationUIVPCUpsell (copy), useLocalization (copy), Cryo (copy), React (copy), Dialog (copy), DialogSize (copy), GetFFlagEnableVPCUpsellFoundationDialogHardening (copy), ButtonVariant (copy), InteractiveAlert (copy), ButtonType (copy)
	local onAck = t1.onAck
	local v21 = useSelector(selectScreenSize)
	local messageStrings = t1.messageStrings
	local parentEmails = t1.parentEmails
	local v24 = not not t1.disablePortal and t1.disablePortal
	local v25 = not not t1.isInExperienceEntry and t1.isInExperienceEntry
	local v26 = GetShouldUseFoundationUIVPCUpsell(v25)
	local v27 = if #parentEmails ~= 1 then useLocalization(Cryo.Dictionary.join(messageStrings, {
		bodyText = messageStrings.multipleParentsBody
	})) else useLocalization(Cryo.Dictionary.join(messageStrings, {
		bodyText = {
			messageStrings.oneParentBody,
			parentEmail = parentEmails[1]
		}
	}))

	if v26 then
		return React.createElement(Dialog.Root, {
			size = DialogSize.Small,
			onClose = onAck,
			disablePortal = v24,
			hasBackdrop = not not GetFFlagEnableVPCUpsellFoundationDialogHardening()
		}, {
			DialogTitle = React.createElement(Dialog.Title, {
				text = v27.title
			}),
			DialogContent = React.createElement(Dialog.Content, {
				LayoutOrder = 2
			}, {
				DialogText = React.createElement(Dialog.Text, {
					Text = v27.bodyText
				})
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				actions = {{
					text = v27.buttonText,
					variant = ButtonVariant.Standard,
					onActivated = onAck
				}}
			})
		})
	end

	return React.createElement(InteractiveAlert, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = v21,
		title = v27.title,
		bodyText = v27.bodyText,
		buttonStackInfo = {
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = onAck,
					text = v27.buttonText
				}
			}}
		}
	})
end

return VPCConfirmationScreen
