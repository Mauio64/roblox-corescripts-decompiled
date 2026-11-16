local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local parent = PhoneUpsell.Parent

local usePhoneVerificationUpsellProps = require(PhoneUpsell.Components.usePhoneVerificationUpsellProps)

local React = require(parent.React)
local Roact = require(parent.Roact)

require(parent.LuauPolyfill)
local mergeProps = require(PhoneUpsell.Utils.mergeProps)

local PhoneVerificationUpsellState = require(PhoneUpsell.Components.PhoneVerificationUpsellState)
local EntryView = require(PhoneUpsell.Components.EntryView)
local AddPhoneView = require(PhoneUpsell.Components.AddPhoneView)
local VerifyPhoneView = require(PhoneUpsell.Components.VerifyPhoneView)
local PhoneVerificationStatusOverlay = require(PhoneUpsell.Components.PhoneVerificationStatusOverlay)

local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading

local GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell = require(PhoneUpsell.Flags.GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell)
local GetFFlagPhoneUseParentSizeForScreenSize = require(PhoneUpsell.Flags.GetFFlagPhoneUseParentSizeForScreenSize)
local GetFFlagDisableVerifyPhoneViewOnSuccess = require(PhoneUpsell.Flags.GetFFlagDisableVerifyPhoneViewOnSuccess)
local GetFFlagFixIosOtpAutofill = require(PhoneUpsell.Flags.GetFFlagFixIosOtpAutofill)

local SharedFlags = require(parent.SharedFlags)
local FFlagHomePhoneVerificationUpsellNewCopy = SharedFlags.FFlagHomePhoneVerificationUpsellNewCopy

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

local function UpsellContainer(p)
	local v2 = mergeProps(v, p)

	local v3 = usePhoneVerificationUpsellProps(v2)

	local element = React.createElement(Loading, {
		size = IconSize.Large,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})

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
		Entry = v3.phoneUpsellState == PhoneVerificationUpsellState.Entry and v2.entryConfig and React.createElement(EntryView, {
			screenSize = v3.screenSize,
			onClose = v3.handleCloseClick,
			titleKey = v2.entryConfig.titleKey,
			descriptionKey = v2.entryConfig.descriptionKey,
			buttonKey = v2.entryConfig.buttonKey,
			onButtonClick = v3.proceedToAddPhone,
			extraButtonKey = v2.entryConfig.extraButtonConfig.extraButtonKey,
			onExtraButtonClick = v2.entryConfig.extraButtonConfig.onExtraButtonClick
		}),
		AddPhone = 0,
		VerifyPhone = 0,
		LoadingOverlay = 0
	}
	local addPhone

	if v3.phoneUpsellState == PhoneVerificationUpsellState.AddPhone then
		local createElement2 = React.createElement
		local v7 = {
			screenSize = v3.screenSize,
			countryCode = v3.countryCode,
			setCountryCode = v3.setCountryCode,
			phoneNumber = v3.phoneNumber,
			errorMessage = v3.addPhoneErrorMessage,
			isDisabled = v3.isDisabled,
			onPhoneNumberTextChange = v3.onPhoneNumberTextChange,
			onSetPhoneNumber = v3.handleSetPhone,
			onClose = v3.handleCloseClick,
			onTermsOfUseClick = v3.navigateToSMSTerms,
			onPrivacyPolicyClick = v3.navigateToPrivacy,
			onPhoneInputFocus = v3.onPhoneInputFocus,
			onCountryCodeSelectorClick = v3.onCountryCodeSelectorClick,
			isKeyboardShowing = v3.isKeyboardShowing,
			keyboardHeight = v3.onScreenKeyboardHeight,
			usePhoneNumberTextType = GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell() and v3.isPhoneNumberTextTypeEnabled,
			titleKey = v2.addPhoneTitleKey,
			descriptionKey = v2.addPhoneDescriptionKey,
			buttonKey = v2.addPhoneButtonKey,
			legalTextKey = v2.addPhoneLegalTextKey,
			extraButtonKey = v2.extraButtonTextKey,
			onExtraButtonClick = v2.onExtraButtonClick,
			alwaysShowLegalText = v2.alwaysShowAddPhoneLegalText,
			requireLegalTextCheckbox = v2.requireAddPhoneLegalTextCheckbox,
			disableLegalText = v2.disableLegalText,
			shouldShowVerificationText = 0
		}
		local shouldShowVerificationText

		if FFlagHomePhoneVerificationUpsellNewCopy then
			shouldShowVerificationText = v2.shouldShowVerificationText
		end

		v7.shouldShowVerificationText = shouldShowVerificationText
		addPhone = createElement2(AddPhoneView, v7)
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
		local isDisabled

		if GetFFlagDisableVerifyPhoneViewOnSuccess() then
			isDisabled = v3.isDisabled
		end

		v7.isDisabled = isDisabled

		v7.onCodeTextChange = v3.onCodeTextChange
		v7.onResendPhoneCode = v3.handleResendCode
		v7.onClose = v3.handleCloseClick
		v7.returnToAddPhone = v3.returnToAddPhone
		v7.onCodeInputFocus = v3.onCodeInputFocus
		v7.isKeyboardShowing = v3.isKeyboardShowing
		v7.keyboardHeight = v3.onScreenKeyboardHeight
		local useOTPInputType

		if GetFFlagFixIosOtpAutofill() then
			useOTPInputType = v3.isOTPInputTypeEnabled
		else
			useOTPInputType = v2.isOTPInputTypeEnabled
		end

		v7.useOTPInputType = useOTPInputType

		v7.extraButtonKey = v2.verifyPhoneExtraButtonKey
		v7.onExtraButtonClick = v2.onVerifyPhoneExtraButtonClick
		verifyPhone = createElement2(VerifyPhoneView, v7)
	else
		verifyPhone = false
	end

	v6.VerifyPhone = verifyPhone

	v6.LoadingOverlay = v3.isLoading
		and React.createElement(PhoneVerificationStatusOverlay, {
			image = element,
			text = v3.verifyingKey
		})
	return createElement(v4, v5, v6)
end

return UpsellContainer
