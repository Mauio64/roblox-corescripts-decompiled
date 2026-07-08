local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local usePhoneVerificationUpsellProps = require(PhoneUpsell.Components.usePhoneVerificationUpsellProps)
local React = require(PhoneUpsellParent.React)
local Roact = require(PhoneUpsellParent.Roact)

require(PhoneUpsellParent.LuauPolyfill)

local mergeProps = require(PhoneUpsell.Utils.mergeProps)
local PhoneVerificationUpsellState = require(PhoneUpsell.Components.PhoneVerificationUpsellState)
local EntryView = require(PhoneUpsell.Components.EntryView)
local AddPhoneView = require(PhoneUpsell.Components.AddPhoneView)
local VerifyPhoneView = require(PhoneUpsell.Components.VerifyPhoneView)
local PhoneVerificationStatusOverlay = require(PhoneUpsell.Components.PhoneVerificationStatusOverlay)
local Foundation = require(PhoneUpsellParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell = require(PhoneUpsell.Flags.GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell)
local GetFFlagPhoneUseParentSizeForScreenSize = require(PhoneUpsell.Flags.GetFFlagPhoneUseParentSizeForScreenSize)
local GetFFlagDisableVerifyPhoneViewOnSuccess = require(PhoneUpsell.Flags.GetFFlagDisableVerifyPhoneViewOnSuccess)
local GetFFlagFixIosOtpAutofill = require(PhoneUpsell.Flags.GetFFlagFixIosOtpAutofill)
local FFlagHomePhoneVerificationUpsellNewCopy = require(PhoneUpsellParent.SharedFlags).FFlagHomePhoneVerificationUpsellNewCopy

local function v20() -- line: 107
end

local t1 = {
	origin = "",
	eventContext = "",
	addPhoneTitleKey = "Feature.VerificationUpsell.Action.AddPhone",
	addPhoneDescriptionKey = "Feature.VerificationUpsell.Description.VerificationCodeSmsFeesMayApply",
	extraButtonTextKey = "",
	shouldAutofillAndroidPhoneNumberAtLaunch = false,
	isOTPInputTypeEnabled = false,
	isPhoneNumberTextTypeEnabled = false,
	alwaysShowAddPhoneLegalText = false,
	requireAddPhoneLegalTextCheckbox = false,
	onSuccess = v20,
	onFailure = v20,
	onCancelled = v20,
	onExtraButtonClick = v20,
	closeUpsell = v20,
	showWebpage = function(_) -- line: 125
	end
}

local function UpsellContainer(t2: {[any]: any}) -- line: 128
	-- upvalues: mergeProps (copy), t1 (copy), usePhoneVerificationUpsellProps (copy), React (copy), Loading (copy), IconSize (copy), GetFFlagPhoneUseParentSizeForScreenSize (copy), Roact (copy), PhoneVerificationUpsellState (copy), EntryView (copy), AddPhoneView (copy), GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell (copy), FFlagHomePhoneVerificationUpsellNewCopy (copy), VerifyPhoneView (copy), GetFFlagDisableVerifyPhoneViewOnSuccess (copy), GetFFlagFixIosOtpAutofill (copy), PhoneVerificationStatusOverlay (copy)
	local v25 = mergeProps(t1, t2)
	local v26 = usePhoneVerificationUpsellProps(v25)
	local v27 = React.createElement(Loading, {
		size = IconSize.Large,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})

	return React.createElement(if not GetFFlagPhoneUseParentSizeForScreenSize() then React.Fragment else "Frame", if not GetFFlagPhoneUseParentSizeForScreenSize() then nil else {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Change.AbsoluteSize] = function(p2) -- line: 145
			-- upvalues: v26 (copy)
			v26.setParentSize(p2.AbsoluteSize)
		end
	}, {
		Entry = v26.phoneUpsellState == PhoneVerificationUpsellState.Entry and (v25.entryConfig and React.createElement(EntryView, {
			screenSize = v26.screenSize,
			onClose = v26.handleCloseClick,
			titleKey = v25.entryConfig.titleKey,
			descriptionKey = v25.entryConfig.descriptionKey,
			buttonKey = v25.entryConfig.buttonKey,
			onButtonClick = v26.proceedToAddPhone,
			extraButtonKey = v25.entryConfig.extraButtonConfig.extraButtonKey,
			onExtraButtonClick = v25.entryConfig.extraButtonConfig.onExtraButtonClick
		})),
		AddPhone = v26.phoneUpsellState == PhoneVerificationUpsellState.AddPhone and React.createElement(AddPhoneView, {
			screenSize = v26.screenSize,
			countryCode = v26.countryCode,
			setCountryCode = v26.setCountryCode,
			phoneNumber = v26.phoneNumber,
			errorMessage = v26.addPhoneErrorMessage,
			isDisabled = v26.isDisabled,
			onPhoneNumberTextChange = v26.onPhoneNumberTextChange,
			onSetPhoneNumber = v26.handleSetPhone,
			onClose = v26.handleCloseClick,
			onTermsOfUseClick = v26.navigateToSMSTerms,
			onPrivacyPolicyClick = v26.navigateToPrivacy,
			onPhoneInputFocus = v26.onPhoneInputFocus,
			onCountryCodeSelectorClick = v26.onCountryCodeSelectorClick,
			isKeyboardShowing = v26.isKeyboardShowing,
			keyboardHeight = v26.onScreenKeyboardHeight,
			usePhoneNumberTextType = GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell() and v26.isPhoneNumberTextTypeEnabled,
			titleKey = v25.addPhoneTitleKey,
			descriptionKey = v25.addPhoneDescriptionKey,
			buttonKey = v25.addPhoneButtonKey,
			legalTextKey = v25.addPhoneLegalTextKey,
			extraButtonKey = v25.extraButtonTextKey,
			onExtraButtonClick = v25.onExtraButtonClick,
			alwaysShowLegalText = v25.alwaysShowAddPhoneLegalText,
			requireLegalTextCheckbox = v25.requireAddPhoneLegalTextCheckbox,
			disableLegalText = v25.disableLegalText,
			shouldShowVerificationText = if not FFlagHomePhoneVerificationUpsellNewCopy then nil else v25.shouldShowVerificationText
		}),
		VerifyPhone = v26.phoneUpsellState == PhoneVerificationUpsellState.VerifyPhone and React.createElement(VerifyPhoneView, {
			screenSize = v26.screenSize,
			phoneNumber = v26.phoneNumber,
			prefix = v26.countryCode.prefix,
			code = v26.code,
			errorMessage = v26.verifyPhoneErrorMessage,
			isDisabled = if not GetFFlagDisableVerifyPhoneViewOnSuccess() then nil else v26.isDisabled,
			onCodeTextChange = v26.onCodeTextChange,
			onResendPhoneCode = v26.handleResendCode,
			onClose = v26.handleCloseClick,
			returnToAddPhone = v26.returnToAddPhone,
			onCodeInputFocus = v26.onCodeInputFocus,
			isKeyboardShowing = v26.isKeyboardShowing,
			keyboardHeight = v26.onScreenKeyboardHeight,
			useOTPInputType = if not GetFFlagFixIosOtpAutofill() then v25.isOTPInputTypeEnabled else v26.isOTPInputTypeEnabled,
			extraButtonKey = v25.verifyPhoneExtraButtonKey,
			onExtraButtonClick = v25.onVerifyPhoneExtraButtonClick
		}),
		LoadingOverlay = v26.isLoading and React.createElement(PhoneVerificationStatusOverlay, {
			image = v27,
			text = v26.verifyingKey
		})
	})
end

return UpsellContainer
