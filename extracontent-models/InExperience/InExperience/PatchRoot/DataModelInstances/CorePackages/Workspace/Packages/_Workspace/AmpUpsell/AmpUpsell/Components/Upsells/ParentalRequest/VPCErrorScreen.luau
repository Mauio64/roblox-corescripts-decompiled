local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(AmpUpsell.Common.LocalizationStrings)
local vpcErrorScreenStrings = LocalizationStrings.vpcErrorScreenStrings

local VPCErrorUtils = require(AmpUpsell.Common.VPCErrorUtils)
local getRetryBehaviorFromErrorCodeAndRetryNum = VPCErrorUtils.getRetryBehaviorFromErrorCodeAndRetryNum
local VPCErrorUtils2 = require(AmpUpsell.Common.VPCErrorUtils)
local getStringsFromErrorCodeAndRetryNum = VPCErrorUtils2.getStringsFromErrorCodeAndRetryNum
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local UIBlox = require(parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Cryo = require(parent.Cryo)
local Enums = require(AmpUpsell.Common.Enums)
local VPCRetryBehaviorEnum = Enums.VPCRetryBehaviorEnum

local GetFFlagEnableVPCUpsellFoundationDialogHardening = require(AmpUpsell.Flags.GetFFlagEnableVPCUpsellFoundationDialogHardening)
local GetShouldUseFoundationUIVPCUpsell = require(AmpUpsell.Flags.GetShouldUseFoundationUIVPCUpsell)

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local function selectScreenSize(p)
	return p.ScreenSize
end

local function VPCErrorScreen(props)
	local errorCode = props.errorCode
	local onActivated = props.onRetryAmp
	local onRetryVPC = props.onRetryVPC
	local onCancel = props.onCancel
	local onSuccess = props.onSuccess
	local retryNum = props.retryNum
	local screenSize = useSelector(selectScreenSize)
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

	local retryBehaviorFromErrorCodeAndRetryNum = getRetryBehaviorFromErrorCodeAndRetryNum(errorCode, retryNum)
	local stringsFromErrorCodeAndRetryNum = getStringsFromErrorCodeAndRetryNum(errorCode, retryNum)

	local v2 = useLocalization(Cryo.Dictionary.join(vpcErrorScreenStrings, {
		titleText = stringsFromErrorCodeAndRetryNum.title,
		bodyText = stringsFromErrorCodeAndRetryNum.body
	}))

	local buttons = {}
	local actions = {}

	if
		retryBehaviorFromErrorCodeAndRetryNum == VPCRetryBehaviorEnum.RetryVPC
		or retryBehaviorFromErrorCodeAndRetryNum == VPCRetryBehaviorEnum.RetryAMP
	then
		if retryBehaviorFromErrorCodeAndRetryNum == VPCRetryBehaviorEnum.RetryVPC then
			onActivated = onRetryVPC
		end

		if shouldUseFoundationUIVPCUpsell then
			actions = {
				{ text = v2.cancelButton, variant = ButtonVariant.Standard, onActivated = onCancel },
				{
					text = v2.retryButton,
					variant = ButtonVariant.Emphasis,
					onActivated = onActivated
				}
			}
		else
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = { onActivated = onCancel, text = v2.cancelButton }
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = { onActivated = onActivated, text = v2.retryButton }
				}
			}
		end
	elseif retryBehaviorFromErrorCodeAndRetryNum == VPCRetryBehaviorEnum.Success then
		if shouldUseFoundationUIVPCUpsell then
			actions = {
				{ text = v2.okButton, variant = ButtonVariant.Standard, onActivated = onSuccess }
			}
		else
			buttons = {
				{
					buttonType = ButtonType.PrimarySystem,
					props = { onActivated = onSuccess, text = v2.okButton }
				}
			}
		end
	elseif shouldUseFoundationUIVPCUpsell then
		actions = {
			{ text = v2.okButton, variant = ButtonVariant.Standard, onActivated = onCancel }
		}
	else
		buttons = {
			{
				buttonType = ButtonType.PrimarySystem,
				props = { onActivated = onCancel, text = v2.okButton }
			}
		}
	end

	if shouldUseFoundationUIVPCUpsell then
		return React.createElement(Dialog.Root, {
			size = DialogSize.Small,
			onClose = props.onClose or onCancel,
			disablePortal = disablePortal,
			hasBackdrop = GetFFlagEnableVPCUpsellFoundationDialogHardening() and true or false
		}, {
			DialogTitle = React.createElement(Dialog.Title, { text = v2.titleText }),
			DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
				DialogText = React.createElement(Dialog.Text, { Text = v2.bodyText })
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				actions = actions
			})
		})
	end

	return React.createElement(InteractiveAlert, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = screenSize,
		title = v2.titleText,
		bodyText = v2.bodyText,
		buttonStackInfo = { buttons = buttons }
	})
end

return VPCErrorScreen
