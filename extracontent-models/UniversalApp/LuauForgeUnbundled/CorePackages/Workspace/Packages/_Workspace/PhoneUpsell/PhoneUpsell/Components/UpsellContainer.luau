local usePhoneVerificationUpsellProps = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/usePhoneVerificationUpsellProps")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Roact")

require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/LuauPolyfill")
local mergeProps = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Utils/mergeProps")

local PhoneVerificationUpsellState = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/PhoneVerificationUpsellState")
local EntryView = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/EntryView")
local AddPhoneView = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/AddPhoneView")
local VerifyPhoneView = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/VerifyPhoneView")
local PhoneVerificationStatusOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/PhoneVerificationStatusOverlay")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Flags/GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell")
local GetFFlagPhoneUseParentSizeForScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Flags/GetFFlagPhoneUseParentSizeForScreenSize")
local GetFFlagDisableVerifyPhoneViewOnSuccess = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Flags/GetFFlagDisableVerifyPhoneViewOnSuccess")
local GetFFlagFixIosOtpAutofill = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Flags/GetFFlagFixIosOtpAutofill")

local fFlagHomePhoneVerificationUpsellNewCopy = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SharedFlags").FFlagHomePhoneVerificationUpsellNewCopy

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

local function UpsellContainer(p2)
	local v6 = mergeProps(v5, p2)

	local v7 = usePhoneVerificationUpsellProps(v6)

	local element = React.createElement(loading, {
		size = iconSize.Large,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})

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
		Entry = v7.phoneUpsellState == PhoneVerificationUpsellState.Entry and v6.entryConfig and React.createElement(EntryView, {
			screenSize = v7.screenSize,
			onClose = v7.handleCloseClick,
			titleKey = v6.entryConfig.titleKey,
			descriptionKey = v6.entryConfig.descriptionKey,
			buttonKey = v6.entryConfig.buttonKey,
			onButtonClick = v7.proceedToAddPhone,
			extraButtonKey = v6.entryConfig.extraButtonConfig.extraButtonKey,
			onExtraButtonClick = v6.entryConfig.extraButtonConfig.onExtraButtonClick
		}),
		AddPhone = 0,
		VerifyPhone = 0,
		LoadingOverlay = 0
	}
	local v12

	if v7.phoneUpsellState == PhoneVerificationUpsellState.AddPhone then
		local createElement2 = React.createElement
		local v14 = {
			screenSize = v7.screenSize,
			countryCode = v7.countryCode,
			setCountryCode = v7.setCountryCode,
			phoneNumber = v7.phoneNumber,
			errorMessage = v7.addPhoneErrorMessage,
			isDisabled = v7.isDisabled,
			onPhoneNumberTextChange = v7.onPhoneNumberTextChange,
			onSetPhoneNumber = v7.handleSetPhone,
			onClose = v7.handleCloseClick,
			onTermsOfUseClick = v7.navigateToSMSTerms,
			onPrivacyPolicyClick = v7.navigateToPrivacy,
			onPhoneInputFocus = v7.onPhoneInputFocus,
			onCountryCodeSelectorClick = v7.onCountryCodeSelectorClick,
			isKeyboardShowing = v7.isKeyboardShowing,
			keyboardHeight = v7.onScreenKeyboardHeight,
			usePhoneNumberTextType = GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell() and v7.isPhoneNumberTextTypeEnabled,
			titleKey = v6.addPhoneTitleKey,
			descriptionKey = v6.addPhoneDescriptionKey,
			buttonKey = v6.addPhoneButtonKey,
			legalTextKey = v6.addPhoneLegalTextKey,
			extraButtonKey = v6.extraButtonTextKey,
			onExtraButtonClick = v6.onExtraButtonClick,
			alwaysShowLegalText = v6.alwaysShowAddPhoneLegalText,
			requireLegalTextCheckbox = v6.requireAddPhoneLegalTextCheckbox,
			disableLegalText = v6.disableLegalText,
			shouldShowVerificationText = 0
		}

		local v15 = if fFlagHomePhoneVerificationUpsellNewCopy then v6.shouldShowVerificationText else nil
		v14.shouldShowVerificationText = v15
		v12 = createElement2(AddPhoneView, v14)
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
			isDisabled = 0,
			onCodeTextChange = 0,
			onResendPhoneCode = 0,
			onClose = 0,
			returnToAddPhone = 0,
			onCodeInputFocus = 0,
			isKeyboardShowing = 0,
			keyboardHeight = 0,
			useOTPInputType = 0,
			extraButtonKey = 0,
			onExtraButtonClick = 0
		}
		local v16 = if GetFFlagDisableVerifyPhoneViewOnSuccess() then v7.isDisabled else nil
		v15.isDisabled = v16

		v15.onCodeTextChange = v7.onCodeTextChange
		v15.onResendPhoneCode = v7.handleResendCode
		v15.onClose = v7.handleCloseClick
		v15.returnToAddPhone = v7.returnToAddPhone
		v15.onCodeInputFocus = v7.onCodeInputFocus
		v15.isKeyboardShowing = v7.isKeyboardShowing
		v15.keyboardHeight = v7.onScreenKeyboardHeight
		local v17 = if GetFFlagFixIosOtpAutofill() then v7.isOTPInputTypeEnabled else v6.isOTPInputTypeEnabled
		v15.useOTPInputType = v17

		v15.extraButtonKey = v6.verifyPhoneExtraButtonKey
		v15.onExtraButtonClick = v6.onVerifyPhoneExtraButtonClick
		v13 = createElement2(VerifyPhoneView, v15)
	else
		v13 = false
	end

	v10.VerifyPhone = v13

	v10.LoadingOverlay = v7.isLoading
		and React.createElement(PhoneVerificationStatusOverlay, { image = element, text = v7.verifyingKey })
	return createElement(v8, v9, v10)
end

return UpsellContainer
