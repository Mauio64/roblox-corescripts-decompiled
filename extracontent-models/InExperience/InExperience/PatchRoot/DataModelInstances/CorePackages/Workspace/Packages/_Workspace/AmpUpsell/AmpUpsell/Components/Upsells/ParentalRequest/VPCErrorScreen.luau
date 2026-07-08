local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local React = require(AmpUpsellParent.React)
local useLocalization = require(AmpUpsellParent.Localization).Hooks.useLocalization
local vpcErrorScreenStrings = require(AmpUpsell.Common.LocalizationStrings).vpcErrorScreenStrings
local getRetryBehaviorFromErrorCodeAndRetryNum = require(AmpUpsell.Common.VPCErrorUtils).getRetryBehaviorFromErrorCodeAndRetryNum
local getStringsFromErrorCodeAndRetryNum = require(AmpUpsell.Common.VPCErrorUtils).getStringsFromErrorCodeAndRetryNum
local useSelector = require(AmpUpsellParent.RoactUtils).Hooks.RoactRodux.useSelector
local UIBlox = require(AmpUpsellParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Cryo = require(AmpUpsellParent.Cryo)
local VPCRetryBehaviorEnum = require(AmpUpsell.Common.Enums).VPCRetryBehaviorEnum
local GetFFlagEnableVPCUpsellFoundationDialogHardening = require(AmpUpsell.Flags.GetFFlagEnableVPCUpsellFoundationDialogHardening)
local GetShouldUseFoundationUIVPCUpsell = require(AmpUpsell.Flags.GetShouldUseFoundationUIVPCUpsell)
local Foundation = require(AmpUpsellParent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local function selectScreenSize(p1) -- line: 37
	return p1.ScreenSize
end
local function VPCErrorScreen(t1: {[any]: any}) -- line: 41
	-- upvalues: useSelector (copy), selectScreenSize (copy), GetShouldUseFoundationUIVPCUpsell (copy), getRetryBehaviorFromErrorCodeAndRetryNum (copy), getStringsFromErrorCodeAndRetryNum (copy), useLocalization (copy), Cryo (copy), vpcErrorScreenStrings (copy), VPCRetryBehaviorEnum (copy), ButtonVariant (copy), ButtonType (copy), React (copy), Dialog (copy), DialogSize (copy), GetFFlagEnableVPCUpsellFoundationDialogHardening (copy), InteractiveAlert (copy)
	local errorCode = t1.errorCode
	local onRetryAmp = t1.onRetryAmp
	local onRetryVPC = t1.onRetryVPC
	local onCancel = t1.onCancel
	local onSuccess = t1.onSuccess
	local retryNum = t1.retryNum
	local v30 = useSelector(selectScreenSize)
	local v31 = not not t1.disablePortal and t1.disablePortal
	local v32 = not not t1.isInExperienceEntry and t1.isInExperienceEntry
	local v33 = GetShouldUseFoundationUIVPCUpsell(v32)
	local v34 = getRetryBehaviorFromErrorCodeAndRetryNum(errorCode, retryNum)
	local v35 = getStringsFromErrorCodeAndRetryNum(errorCode, retryNum)
	local v36 = useLocalization(Cryo.Dictionary.join(vpcErrorScreenStrings, {
		titleText = v35.title,
		bodyText = v35.body
	}))
	local t2 = {}
	local t3 = {}

	if v34 == VPCRetryBehaviorEnum.RetryVPC or v34 == VPCRetryBehaviorEnum.RetryAMP then
		local v39 = if v34 ~= VPCRetryBehaviorEnum.RetryVPC then onRetryAmp else onRetryVPC

		if v33 then
			t3 = {
				{
					text = v36.cancelButton,
					variant = ButtonVariant.Standard,
					onActivated = onCancel
				},
				{
					text = v36.retryButton,
					variant = ButtonVariant.Emphasis,
					onActivated = v39
				}
			}
		else
			t2 = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = onCancel,
						text = v36.cancelButton
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = v39,
						text = v36.retryButton
					}
				}
			}
		end
	elseif v34 == VPCRetryBehaviorEnum.Success then
		if v33 then
			t3 = {{
				text = v36.okButton,
				variant = ButtonVariant.Standard,
				onActivated = onSuccess
			}}
		else
			t2 = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = onSuccess,
					text = v36.okButton
				}
			}}
		end
	elseif v33 then
		t3 = {{
			text = v36.okButton,
			variant = ButtonVariant.Standard,
			onActivated = onCancel
		}}
	else
		t2 = {{
			buttonType = ButtonType.PrimarySystem,
			props = {
				onActivated = onCancel,
				text = v36.okButton
			}
		}}
	end

	if v33 then
		return React.createElement(Dialog.Root, {
			size = DialogSize.Small,
			onClose = onCancel,
			disablePortal = v31,
			hasBackdrop = not not GetFFlagEnableVPCUpsellFoundationDialogHardening()
		}, {
			DialogTitle = React.createElement(Dialog.Title, {
				text = v36.titleText
			}),
			DialogContent = React.createElement(Dialog.Content, {
				LayoutOrder = 2
			}, {
				DialogText = React.createElement(Dialog.Text, {
					Text = v36.bodyText
				})
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				actions = t3
			})
		})
	end

	return React.createElement(InteractiveAlert, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = v30,
		title = v36.titleText,
		bodyText = v36.bodyText,
		buttonStackInfo = {
			buttons = t2
		}
	})
end

return VPCErrorScreen
