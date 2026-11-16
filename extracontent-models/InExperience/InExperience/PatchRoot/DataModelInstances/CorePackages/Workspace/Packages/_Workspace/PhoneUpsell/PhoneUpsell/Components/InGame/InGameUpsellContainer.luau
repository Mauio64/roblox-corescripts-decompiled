local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local parent = PhoneUpsell.Parent

local usePhoneVerificationUpsellProps = require(PhoneUpsell.Components.usePhoneVerificationUpsellProps)

local React = require(parent.React)
local Roact = require(parent.Roact)

require(parent.LuauPolyfill)
local mergeProps = require(PhoneUpsell.Utils.mergeProps)

local PhoneVerificationUpsellState = require(PhoneUpsell.Components.PhoneVerificationUpsellState)
local InGameEntryView = require(PhoneUpsell.Components.InGame.InGameEntryView)
local InGameAddPhoneView = require(PhoneUpsell.Components.InGame.InGameAddPhoneView)
local InGameVerifyPhoneView = require(PhoneUpsell.Components.InGame.InGameVerifyPhoneView)

local GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell = require(PhoneUpsell.Flags.GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell)
local GetFFlagPhoneUseParentSizeForScreenSize = require(PhoneUpsell.Flags.GetFFlagPhoneUseParentSizeForScreenSize)
local GetFFlagFixIosOtpAutofill = require(PhoneUpsell.Flags.GetFFlagFixIosOtpAutofill)

local function fn() end

local v = {
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
	showWebpage = function(_) end
}

local function InGameUpsellContainer(p)
	local v2 = mergeProps(v, p)

	local v3 = usePhoneVerificationUpsellProps(v2)

	local createElement = React.createElement
	local v4 = GetFFlagPhoneUseParentSizeForScreenSize() and "Frame" or React.Fragment
	local v5

	if GetFFlagPhoneUseParentSizeForScreenSize() then
		v5 = {
			["BackgroundTransparency"] = nil,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}
		v5[Roact.Change.AbsoluteSize] = function(p2)
			v3.setParentSize(p2.AbsoluteSize)
		end
	end

	local v6 = {
		Entry = v3.phoneUpsellState == PhoneVerificationUpsellState.Entry and v2.entryConfig and React.createElement(InGameEntryView, {
			screenSize = v3.screenSize,
			onClose = v3.handleCloseClick,
			titleKey = v2.entryConfig.titleKey,
			descriptionKey = v2.entryConfig.descriptionKey,
			buttonKey = v2.entryConfig.buttonKey,
			onButtonClick = v3.proceedToAddPhone,
			extraButtonKey = v2.entryConfig.extraButtonConfig.extraButtonKey,
			onExtraButtonClick = v2.closeUpsell,
			countryCode = v3.countryCode,
			onTermsOfUseClick = v3.navigateToSMSTerms,
			onPrivacyPolicyClick = v3.navigateToPrivacy,
			legalTextKey = v2.entryConfig.legalTextKey
		}),
		AddPhone = 0,
		VerifyPhone = 0
	}
	local addPhone

	if v3.phoneUpsellState == PhoneVerificationUpsellState.AddPhone then
		addPhone = React.createElement(InGameAddPhoneView, {
			screenSize = v3.screenSize,
			countryCode = v3.countryCode,
			setCountryCode = v3.setCountryCode,
			phoneNumber = v3.phoneNumber,
			errorMessage = v3.addPhoneErrorMessage,
			isDisabled = v3.isDisabled,
			onPhoneNumberTextChange = v3.onPhoneNumberTextChange,
			onSetPhoneNumber = v3.handleSetPhone,
			onClose = v3.handleCloseClick,
			onCountryCodeSelectorClick = v3.onCountryCodeSelectorClick,
			isKeyboardShowing = v3.isKeyboardShowing,
			keyboardHeight = v3.onScreenKeyboardHeight,
			titleKey = v2.addPhoneTitleKey,
			buttonKey = v2.addPhoneButtonKey,
			extraButtonKey = "Feature.VerificationUpsell.Action.NotNow",
			onExtraButtonClick = v2.closeUpsell,
			usePhoneNumberTextType = GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell() and v3.isPhoneNumberTextTypeEnabled,
			descriptionKey = v2.addPhoneDescriptionKey,
			legalTextKey = v2.addPhoneLegalTextKey,
			onPhoneInputFocus = v3.onPhoneInputFocus
		})
	else
		addPhone = false
	end

	v6.AddPhone = addPhone
	local verifyPhone

	if v3.phoneUpsellState == PhoneVerificationUpsellState.VerifyPhone then
		local createElement2 = React.createElement
		local v7 = {
			screenSize = v3.screenSize,
			phoneNumber = v3.phoneNumber,
			prefix = v3.countryCode.prefix,
			code = v3.code,
			errorMessage = v3.verifyPhoneErrorMessage,
			onCodeTextChange = v3.onCodeTextChange,
			onResendPhoneCode = v3.handleResendCode,
			onClose = v3.handleCloseClick,
			returnToAddPhone = v3.returnToAddPhone,
			onCodeInputFocus = v3.onCodeInputFocus,
			isKeyboardShowing = v3.isKeyboardShowing,
			keyboardHeight = v3.onScreenKeyboardHeight,
			useOTPInputType = 0,
			extraButtonKey = "Feature.VerificationUpsell.Action.EditPhoneNumber",
			onExtraButtonClick = 0
		}
		local useOTPInputType

		if GetFFlagFixIosOtpAutofill() then
			useOTPInputType = v3.isOTPInputTypeEnabled
		else
			useOTPInputType = v2.isOTPInputTypeEnabled
		end

		v7.useOTPInputType = useOTPInputType

		v7.onExtraButtonClick = v3.returnToAddPhone
		verifyPhone = createElement2(InGameVerifyPhoneView, v7)
	else
		verifyPhone = false
	end

	v6.VerifyPhone = verifyPhone
	return createElement(v4, v5, v6)
end

return InGameUpsellContainer
