local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Localization").Hooks.useLocalization
local vpcErrorScreenStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/LocalizationStrings").vpcErrorScreenStrings

local getRetryBehaviorFromErrorCodeAndRetryNum = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/VPCErrorUtils").getRetryBehaviorFromErrorCodeAndRetryNum
local getStringsFromErrorCodeAndRetryNum = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/VPCErrorUtils").getStringsFromErrorCodeAndRetryNum
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactUtils").Hooks.RoactRodux.useSelector
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Cryo")
local vpcRetryBehaviorEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Enums").VPCRetryBehaviorEnum

local GetFFlagEnableVPCUpsellFoundationDialogHardening = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableVPCUpsellFoundationDialogHardening")
local GetShouldUseFoundationUIVPCUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetShouldUseFoundationUIVPCUpsell")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Foundation")
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function VPCErrorScreen(props)
	local errorCode = props.errorCode
	local v5 = props.onRetryAmp
	local onRetryVPC = props.onRetryVPC
	local onCancel = props.onCancel
	local onSuccess = props.onSuccess
	local retryNum = props.retryNum
	local v6 = useSelector(selectScreenSize)
	local v7 = if props.disablePortal then props.disablePortal else false
	local v8 = if props.isInExperienceEntry then props.isInExperienceEntry else false
	local v9 = GetShouldUseFoundationUIVPCUpsell(v8)

	local retryBehaviorFromErrorCodeAndRetryNum = getRetryBehaviorFromErrorCodeAndRetryNum(
		errorCode,
		retryNum
	)
	local stringsFromErrorCodeAndRetryNum = getStringsFromErrorCodeAndRetryNum(errorCode, retryNum)

	local v10 = useLocalization(Cryo.Dictionary.join(vpcErrorScreenStrings, {
		titleText = stringsFromErrorCodeAndRetryNum.title,
		bodyText = stringsFromErrorCodeAndRetryNum.body
	}))

	local v11 = {}
	local v12 = {}

	if
		retryBehaviorFromErrorCodeAndRetryNum == vpcRetryBehaviorEnum.RetryVPC
		or retryBehaviorFromErrorCodeAndRetryNum == vpcRetryBehaviorEnum.RetryAMP
	then
		if retryBehaviorFromErrorCodeAndRetryNum == vpcRetryBehaviorEnum.RetryVPC then
			v5 = onRetryVPC
		end

		if v9 then
			v12 = {
				{
					text = v10.cancelButton,
					variant = buttonVariant.Standard,
					onActivated = onCancel
				},
				{
					text = v10.retryButton,
					variant = buttonVariant.Emphasis,
					onActivated = v5
				}
			}
		else
			v11 = {
				{
					buttonType = buttonType.Secondary,
					props = { onActivated = onCancel, text = v10.cancelButton }
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = v5, text = v10.retryButton }
				}
			}
		end
	elseif retryBehaviorFromErrorCodeAndRetryNum == vpcRetryBehaviorEnum.Success then
		if v9 then
			v12 = {
				{
					text = v10.okButton,
					variant = buttonVariant.Standard,
					onActivated = onSuccess
				}
			}
		else
			v11 = {
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = onSuccess, text = v10.okButton }
				}
			}
		end
	elseif v9 then
		v12 = {
			{
				text = v10.okButton,
				variant = buttonVariant.Standard,
				onActivated = onCancel
			}
		}
	else
		v11 = {
			{
				buttonType = buttonType.PrimarySystem,
				props = { onActivated = onCancel, text = v10.okButton }
			}
		}
	end

	if v9 then
		return React.createElement(dialog.Root, {
			size = dialogSize.Small,
			onClose = props.onClose or onCancel,
			disablePortal = v7,
			hasBackdrop = GetFFlagEnableVPCUpsellFoundationDialogHardening() and true or false
		}, {
			DialogTitle = React.createElement(dialog.Title, { text = v10.titleText }),
			DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
				DialogText = React.createElement(dialog.Text, { Text = v10.bodyText })
			}),
			DialogActions = React.createElement(dialog.Actions, {
				LayoutOrder = 3,
				actions = v12
			})
		})
	end

	return React.createElement(interactiveAlert, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = v6,
		title = v10.titleText,
		bodyText = v10.bodyText,
		buttonStackInfo = { buttons = v11 }
	})
end

return VPCErrorScreen
