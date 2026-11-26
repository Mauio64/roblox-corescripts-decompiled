local usePhoneVerificationUpsellProps = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/usePhoneVerificationUpsellProps")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Roact")

require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/LuauPolyfill")
local mergeProps = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Utils/mergeProps")

local PhoneVerificationUpsellState = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/PhoneVerificationUpsellState")
local InGameEntryView = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/InGame/InGameEntryView")
local InGameAddPhoneView = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/InGame/InGameAddPhoneView")
local InGameVerifyPhoneView = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/InGame/InGameVerifyPhoneView")

local GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Flags/GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell")
local GetFFlagPhoneUseParentSizeForScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Flags/GetFFlagPhoneUseParentSizeForScreenSize")
local GetFFlagFixIosOtpAutofill = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Flags/GetFFlagFixIosOtpAutofill")

local function fn() end

local v5 = {
	onSuccess = fn,
	onFailure = fn,
	onCancelled = fn,
	origin = "",
	eventContext = "",
	addPhoneTitleKey = "Feature.VerificationUpsell.Action.AddPhone",
	addPhoneDescriptionKey = "Feature.VerificationUpsell.Description.VerificationCodeSmsFeesMayApply",
	extraButtonTextKey = "",
	onExtraButtonClick = fn,
	shouldAutofillAndroidPhoneNumberAtLaunch = false,
	isOTPInputTypeEnabled = false,
	isPhoneNumberTextTypeEnabled = false,
	alwaysShowAddPhoneLegalText = false,
	requireAddPhoneLegalTextCheckbox = false,
	closeUpsell = fn,
	showWebpage = function(p2) end
}

local function InGameUpsellContainer(p2)
	local v6 = mergeProps(v5, p2)

	local v7 = usePhoneVerificationUpsellProps(v6)

	local createElement = React.createElement
	local v8 = GetFFlagPhoneUseParentSizeForScreenSize() and "Frame" or React.Fragment
	local v9

	if GetFFlagPhoneUseParentSizeForScreenSize() then
		v9 = {
			["BackgroundTransparency"] = nil,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}
		v9[Roact.Change.AbsoluteSize] = function(p3)
			v7.setParentSize(p3.AbsoluteSize)
		end
	end

	local v10 = {
		Entry = v7.phoneUpsellState == PhoneVerificationUpsellState.Entry and v6.entryConfig and React.createElement(InGameEntryView, {
			screenSize = v7.screenSize,
			onClose = v7.handleCloseClick,
			titleKey = v6.entryConfig.titleKey,
			descriptionKey = v6.entryConfig.descriptionKey,
			buttonKey = v6.entryConfig.buttonKey,
			onButtonClick = v7.proceedToAddPhone,
			extraButtonKey = v6.entryConfig.extraButtonConfig.extraButtonKey,
			onExtraButtonClick = v6.closeUpsell,
			countryCode = v7.countryCode,
			onTermsOfUseClick = v7.navigateToSMSTerms,
			onPrivacyPolicyClick = v7.navigateToPrivacy,
			legalTextKey = v6.entryConfig.legalTextKey
		}),
		AddPhone = 0,
		VerifyPhone = 0
	}
	local v12

	if v7.phoneUpsellState == PhoneVerificationUpsellState.AddPhone then
		v12 = React.createElement(InGameAddPhoneView, {
			screenSize = v7.screenSize,
			countryCode = v7.countryCode,
			setCountryCode = v7.setCountryCode,
			phoneNumber = v7.phoneNumber,
			errorMessage = v7.addPhoneErrorMessage,
			isDisabled = v7.isDisabled,
			onPhoneNumberTextChange = v7.onPhoneNumberTextChange,
			onSetPhoneNumber = v7.handleSetPhone,
			onClose = v7.handleCloseClick,
			onCountryCodeSelectorClick = v7.onCountryCodeSelectorClick,
			isKeyboardShowing = v7.isKeyboardShowing,
			keyboardHeight = v7.onScreenKeyboardHeight,
			titleKey = v6.addPhoneTitleKey,
			buttonKey = v6.addPhoneButtonKey,
			extraButtonKey = "Feature.VerificationUpsell.Action.NotNow",
			onExtraButtonClick = v6.closeUpsell,
			usePhoneNumberTextType = GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell() and v7.isPhoneNumberTextTypeEnabled,
			descriptionKey = v6.addPhoneDescriptionKey,
			legalTextKey = v6.addPhoneLegalTextKey,
			onPhoneInputFocus = v7.onPhoneInputFocus
		})
	else
		v12 = false
	end

	v10.AddPhone = v12
	local v13

	if v7.phoneUpsellState == PhoneVerificationUpsellState.VerifyPhone then
		local createElement2 = React.createElement
		local v15 = {
			screenSize = v7.screenSize,
			phoneNumber = v7.phoneNumber,
			prefix = v7.countryCode.prefix,
			code = v7.code,
			errorMessage = v7.verifyPhoneErrorMessage,
			onCodeTextChange = v7.onCodeTextChange,
			onResendPhoneCode = v7.handleResendCode,
			onClose = v7.handleCloseClick,
			returnToAddPhone = v7.returnToAddPhone,
			onCodeInputFocus = v7.onCodeInputFocus,
			isKeyboardShowing = v7.isKeyboardShowing,
			keyboardHeight = v7.onScreenKeyboardHeight,
			useOTPInputType = 0,
			extraButtonKey = "Feature.VerificationUpsell.Action.EditPhoneNumber",
			onExtraButtonClick = 0
		}
		local v16 = if GetFFlagFixIosOtpAutofill() then v7.isOTPInputTypeEnabled else v6.isOTPInputTypeEnabled
		v15.useOTPInputType = v16

		v15.onExtraButtonClick = v7.returnToAddPhone
		v13 = createElement2(InGameVerifyPhoneView, v15)
	else
		v13 = false
	end

	v10.VerifyPhone = v13
	return createElement(v8, v9, v10)
end

return InGameUpsellContainer
