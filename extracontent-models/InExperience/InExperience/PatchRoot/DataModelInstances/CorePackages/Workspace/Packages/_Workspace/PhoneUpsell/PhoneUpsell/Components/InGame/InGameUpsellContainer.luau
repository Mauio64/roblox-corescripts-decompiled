local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local usePhoneVerificationUpsellProps = require(PhoneUpsell.Components.usePhoneVerificationUpsellProps)
local React = require(PhoneUpsellParent.React)
local Roact = require(PhoneUpsellParent.Roact)

require(PhoneUpsellParent.LuauPolyfill)

local mergeProps = require(PhoneUpsell.Utils.mergeProps)
local PhoneVerificationUpsellState = require(PhoneUpsell.Components.PhoneVerificationUpsellState)
local InGameEntryView = require(PhoneUpsell.Components.InGame.InGameEntryView)
local InGameAddPhoneView = require(PhoneUpsell.Components.InGame.InGameAddPhoneView)
local InGameVerifyPhoneView = require(PhoneUpsell.Components.InGame.InGameVerifyPhoneView)
local GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell = require(PhoneUpsell.Flags.GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell)
local GetFFlagPhoneUseParentSizeForScreenSize = require(PhoneUpsell.Flags.GetFFlagPhoneUseParentSizeForScreenSize)
local GetFFlagFixIosOtpAutofill = require(PhoneUpsell.Flags.GetFFlagFixIosOtpAutofill)

local function v14() -- line: 85
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
	onSuccess = v14,
	onFailure = v14,
	onCancelled = v14,
	onExtraButtonClick = v14,
	closeUpsell = v14,
	showWebpage = function(_) -- line: 103
	end
}

local function InGameUpsellContainer(t2: {[any]: any}) -- line: 106
	-- upvalues: mergeProps (copy), t1 (copy), usePhoneVerificationUpsellProps (copy), React (copy), GetFFlagPhoneUseParentSizeForScreenSize (copy), Roact (copy), PhoneVerificationUpsellState (copy), InGameEntryView (copy), InGameAddPhoneView (copy), GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell (copy), InGameVerifyPhoneView (copy), GetFFlagFixIosOtpAutofill (copy)
	local v19 = mergeProps(t1, t2)
	local v20 = usePhoneVerificationUpsellProps(v19)

	return React.createElement(if not GetFFlagPhoneUseParentSizeForScreenSize() then React.Fragment else "Frame", if not GetFFlagPhoneUseParentSizeForScreenSize() then nil else {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Change.AbsoluteSize] = function(p2) -- line: 117
			-- upvalues: v20 (copy)
			v20.setParentSize(p2.AbsoluteSize)
		end
	}, {
		Entry = v20.phoneUpsellState == PhoneVerificationUpsellState.Entry and (v19.entryConfig and React.createElement(InGameEntryView, {
			screenSize = v20.screenSize,
			onClose = v20.handleCloseClick,
			titleKey = v19.entryConfig.titleKey,
			descriptionKey = v19.entryConfig.descriptionKey,
			buttonKey = v19.entryConfig.buttonKey,
			onButtonClick = v20.proceedToAddPhone,
			extraButtonKey = v19.entryConfig.extraButtonConfig.extraButtonKey,
			onExtraButtonClick = v19.closeUpsell,
			countryCode = v20.countryCode,
			onTermsOfUseClick = v20.navigateToSMSTerms,
			onPrivacyPolicyClick = v20.navigateToPrivacy,
			legalTextKey = v19.entryConfig.legalTextKey
		})),
		AddPhone = v20.phoneUpsellState == PhoneVerificationUpsellState.AddPhone and React.createElement(InGameAddPhoneView, {
			extraButtonKey = "Feature.VerificationUpsell.Action.NotNow",
			screenSize = v20.screenSize,
			countryCode = v20.countryCode,
			setCountryCode = v20.setCountryCode,
			phoneNumber = v20.phoneNumber,
			errorMessage = v20.addPhoneErrorMessage,
			isDisabled = v20.isDisabled,
			onPhoneNumberTextChange = v20.onPhoneNumberTextChange,
			onSetPhoneNumber = v20.handleSetPhone,
			onClose = v20.handleCloseClick,
			onCountryCodeSelectorClick = v20.onCountryCodeSelectorClick,
			isKeyboardShowing = v20.isKeyboardShowing,
			keyboardHeight = v20.onScreenKeyboardHeight,
			titleKey = v19.addPhoneTitleKey,
			buttonKey = v19.addPhoneButtonKey,
			onExtraButtonClick = v19.closeUpsell,
			usePhoneNumberTextType = GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell() and v20.isPhoneNumberTextTypeEnabled,
			descriptionKey = v19.addPhoneDescriptionKey,
			legalTextKey = v19.addPhoneLegalTextKey,
			onPhoneInputFocus = v20.onPhoneInputFocus
		}),
		VerifyPhone = v20.phoneUpsellState == PhoneVerificationUpsellState.VerifyPhone and React.createElement(InGameVerifyPhoneView, {
			extraButtonKey = "Feature.VerificationUpsell.Action.EditPhoneNumber",
			screenSize = v20.screenSize,
			phoneNumber = v20.phoneNumber,
			prefix = v20.countryCode.prefix,
			code = v20.code,
			errorMessage = v20.verifyPhoneErrorMessage,
			onCodeTextChange = v20.onCodeTextChange,
			onResendPhoneCode = v20.handleResendCode,
			onClose = v20.handleCloseClick,
			returnToAddPhone = v20.returnToAddPhone,
			onCodeInputFocus = v20.onCodeInputFocus,
			isKeyboardShowing = v20.isKeyboardShowing,
			keyboardHeight = v20.onScreenKeyboardHeight,
			useOTPInputType = if not GetFFlagFixIosOtpAutofill() then v19.isOTPInputTypeEnabled else v20.isOTPInputTypeEnabled,
			onExtraButtonClick = v20.returnToAddPhone
		})
	})
end

return InGameUpsellContainer
