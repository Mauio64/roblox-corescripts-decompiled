local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local parent = PhoneUpsell.Parent
local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RoactUtils2 = require(parent.RoactUtils)
local useDispatch = RoactUtils2.Hooks.RoactRodux.useDispatch
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForCountryCodeList = SharedFlags.FFlagUseSignalsForCountryCodeList
local AuthCommon = require(parent.AuthCommon)
local GetCountryCodeListStore = AuthCommon.Stores.GetCountryCodeListStore

require(parent.LuauPolyfill)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local EventStreamConstants = require(PhoneUpsell.DuplicateAnalytics.EventStreamConstants)
local RoactAnalyticsAuthEvents = require(PhoneUpsell.DuplicateAnalytics.RoactAnalyticsAuthEvents)
local debounce = require(PhoneUpsell.Utils.debounce)
local mergeProps = require(PhoneUpsell.Utils.mergeProps)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local PhoneVerificationUpsellState = require(PhoneUpsell.Components.PhoneVerificationUpsellState)
local Constants = require(PhoneUpsell.Constants)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local SetPhoneNumber = require(PhoneUpsell.Thunks.SetPhoneNumber)
local VerifyPhoneCode = require(PhoneUpsell.Thunks.VerifyPhoneCode)
local ResendPhoneCode = require(PhoneUpsell.Thunks.ResendPhoneCode)
local ContactImporter = require(parent.ContactImporter)
local SetIsPhoneVerified = ContactImporter.Actions.SetIsPhoneVerified

local GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix = require(PhoneUpsell.Utils.GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix)

local RoactAppExperiment = require(parent.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local SharedFlags2 = require(parent.SharedFlags)
local GetFStringAndroidPhoneVerificationLayer = SharedFlags2.GetFStringAndroidPhoneVerificationLayer
local SharedFlags3 = require(parent.SharedFlags)
local GetFStringIOSPhoneVerificationLayer = SharedFlags3.GetFStringIOSPhoneVerificationLayer
local GetFFlagPhoneUseParentSizeForScreenSize = require(PhoneUpsell.Flags.GetFFlagPhoneUseParentSizeForScreenSize)
local SharedFlags4 = require(parent.SharedFlags)
local GetFFlagAddMorePhoneUpsellEvents = SharedFlags4.GetFFlagAddMorePhoneUpsellEvents

local IdentityProtocol = require(parent.IdentityProtocol)
local identityProtocol = IdentityProtocol.IdentityProtocol

local v = { name = "United States", code = "US", prefix = "1", localizedName = "United States" }

local function fn() end

local v2 = {
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
	alwaysShowAddPhoneLegalText = false,
	requireAddPhoneLegalTextCheckbox = false,
	closeUpsell = fn,
	showWebpage = function(_) end
}

local function usePhoneVerificationUpsellProps(p)
	local v3 = mergeProps(v2, p)
	local v4

	if FFlagUseSignalsForCountryCodeList then
		v4 = useSignalState(GetCountryCodeListStore(false).getCountryCodeList)
	else
		v4 = useSelector(function(p2)
			return p2.CountryCodeList
		end)
	end

	local v5 = useDispatch()

	local v6 = useRoactService(RoactNetworking)
	local v7 = useRoactService(RoactAnalyticsAuthEvents)

	local v8, v9, isOTPInputTypeEnabled, isPhoneNumberTextTypeEnabled = useUserExperiment(
		{ GetFStringAndroidPhoneVerificationLayer(), GetFStringIOSPhoneVerificationLayer() },
		function(p2)
			local v8 = p2[GetFStringAndroidPhoneVerificationLayer()] or {}
			local v9 = p2[GetFStringIOSPhoneVerificationLayer()] or {}
			return
				v8.IsAutofillPhoneNumberEnabled,
				v8.IsAutofillSMSOtpEnabled,
				v9.IsAutofillSMSOtpEnabled,
				v9.IsAutofillPhoneNumberEnabled
		end
	)

	local useState = React.useState
	local v10

	if v3.entryConfig then
		v10 = PhoneVerificationUpsellState.Entry
	else
		v10 = PhoneVerificationUpsellState.AddPhone
	end

	local state, setState = useState(v10)

	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState(v)
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState("")
	local state6, setState6 = React.useState("")
	local state7, setState7 = React.useState("")
	local state8, setState8 = React.useState("")
	local state9, _ = React.useState(false)
	local state10, setState9 = React.useState(false)
	local state11, setState10 = React.useState(false)
	local state12, setState11 = React.useState(false)
	local state13, setState12 = React.useState(0)
	local state14, setState13 = React.useState(Vector2.new(400, 400))
	local ref = React.useRef(false)

	local v11 = useLocalization({
		verifyingKey = "Feature.VerificationUpsell.Label.Verifying",
		invalidPhoneFormatKey = "Feature.VerificationUpsell.Response.ErrorPhoneFormatInvalid",
		invalidPhoneNumberKey = "Feature.VerificationUpsell.Response.InvalidPhoneNumberError",
		invalidVerificationCodeKey = "Feature.VerificationUpsell.Message.InvalidSmsCode",
		tooManyAccountsKey = "Feature.VerificationUpsell.Response.PhoneHasTooManyAssociatedAccounts",
		tooManyAttemptsKey = "Feature.VerificationUpsell.Response.TooManyAttemptsTryAgainLater",
		genericErrorKey = "Feature.VerificationUpsell.Response.ErrorTryAgain"
	})

	local onScreenKeyboardVisibleChangedConnection = nil

	React.useEffect(function()
		if not state4 and v4 and #v4 > 0 then
			for _, v12 in v4 do
				if v12.isDefault then
					setState3(v12)
				end
			end

			setState4(true)
		end
	end, { v4, state4 })

	React.useEffect(function()
		return function()
			ref.current = state10
		end
	end, { state10 })

	local function fn2() -- 2 equivalent calls inferred from this helper
		local default = identityProtocol.default
		default:supportsGetPhoneNumber():andThen(function(flag: boolean?)
			print("PhoneVerification: Autofill phone number supported: {}!", flag)

			if not flag then
				return
			end

			v7.reportModalActionWithSection(v3.eventContext, "phoneAutofillEligible", "autofill", v3.origin, state)

			local phoneNumber = default:getPhoneNumber()

			if not phoneNumber then
				return
			end

			phoneNumber:andThen(function(p2: string?)
				if not p2 or p2 == "" then
					v7.reportModalActionWithSection(v3.eventContext, "phoneAutofillNull", "autofill", v3.origin, state)

					return
				end

				local v12, v13 = GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix(p2, state3.prefix)

				if v12 == v.prefix then
					v7.reportModalActionWithSection(
						v3.eventContext,
						"phoneAutofillUSFound",
						"autofill",
						v3.origin,
						state
					)
				end

				setState2(v13)

				v7.reportModalActionWithSection(v3.eventContext, "phoneAutofillSuccess", "autofill", v3.origin, state)
			end)
		end)
	end

	React.useEffect(function()
		onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function()
			setState11(UserInputService.OnScreenKeyboardVisible)
			setState12(UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0)
		end)
		local reportModalShownWithSection = v7.reportModalShownWithSection
		local eventContext = v3.eventContext
		local origin = v3.origin
		local v12

		if GetFFlagAddMorePhoneUpsellEvents() then
			v12 = state
		else
			v12 = PhoneVerificationUpsellState.AddPhone
		end

		reportModalShownWithSection(eventContext, origin, v12)

		if v8 then
			fn2() -- inferred equivalent call
		end

		return function()
			if onScreenKeyboardVisibleChangedConnection then
				onScreenKeyboardVisibleChangedConnection:Disconnect()
			end

			onScreenKeyboardVisibleChangedConnection = nil

			if not ref.current then
				v3.onCancelled()
			end
		end
	end, {})

	local screenSize = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local function handlePhoneErrors(errorCode: number?) -- 3 equivalent calls inferred from this helper
		if errorCode == 2 then
			return v11.invalidPhoneFormatKey
		elseif errorCode == 6 then
			return v11.tooManyAttemptsKey
		elseif errorCode == 7 then
			return v11.invalidVerificationCodeKey
		elseif errorCode == 8 then
			return v11.invalidPhoneNumberKey
		elseif errorCode == 9 then
			return v11.tooManyAccountsKey
		end

		return v11.genericErrorKey
	end

	local function fn3(p2, code, prefix, state15) -- 1 equivalent call inferred from this helper
		return v5(SetPhoneNumber(p2, code, prefix, state15, nil))
	end

	local function fn4() -- 1 equivalent call inferred from this helper
		local default = identityProtocol.default
		default:supportsGetSMSOTP():andThen(function(flag: boolean?)
			print("PhoneVerification: Autofill OTP supported: {}!", flag)

			if flag then
				v7.reportModalActionWithSection(v3.eventContext, "codeAutofillEligible", "autofill", v3.origin, state)

				local smsotp = default:getSMSOTP()

				if smsotp then
					smsotp:andThen(function(p2: string?)
						if p2 and p2 ~= "" then
							setState5(p2)
							setState6(p2)
							v7.reportModalActionWithSection(
								v3.eventContext,
								"codeAutofillSuccess",
								"autofill",
								v3.origin,
								state
							)
						end
					end)
				end
			end
		end)
	end

	local function fn5(p2, state15) -- 1 equivalent call inferred from this helper
		return v5(VerifyPhoneCode(p2, state15))
	end

	local function handleVerifyPhone()
		setState10(true)
		local v12 = fn5(v6, state6) -- inferred equivalent call

		if v12 then
			v12:andThen(function()
				setState9(true)
			end):catch(function(p2)
				if p2 then
					v7.reportModalShownWithSectionAndError(
						v3.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v3.origin,
						PhoneVerificationUpsellState.VerifyPhone,
						p2.ErrorCode
					)

					setState8(handlePhoneErrors(p2.ErrorCode)) -- inferred equivalent call
				else
					v7.reportModalShownWithSectionAndError(
						v3.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v3.origin,
						PhoneVerificationUpsellState.VerifyPhone,
						""
					)

					setState8(v11.genericErrorKey)
				end

				setState10(false)
			end)
		end

		v7.reportInteractWithActionAndSection(
			v3.eventContext,
			"",
			"",
			v3.origin,
			EventStreamConstants.Button.AutoSubmit,
			PhoneVerificationUpsellState.VerifyPhone
		)
	end

	local function fn6(p2) -- 1 equivalent call inferred from this helper
		return v5(ResendPhoneCode(p2))
	end

	local function fn7(p2)
		if not state11 then
			setState7("")
			setState2(p2.Text)
		end
	end

	local function fn8()
		v7.reportInteractWithActionAndSection(
			v3.eventContext,
			EventStreamConstants.Field.CountryPrefix,
			EventStreamConstants.ActionType.Focus,
			v3.origin,
			"",
			PhoneVerificationUpsellState.AddPhone
		)
	end

	local function fn9()
		v7.reportInteractWithActionAndSection(
			v3.eventContext,
			EventStreamConstants.Field.PhoneNumber,
			EventStreamConstants.ActionType.Focus,
			v3.origin,
			"",
			PhoneVerificationUpsellState.AddPhone
		)

		if not v3.shouldAutofillAndroidPhoneNumberAtLaunch then
			fn2() -- inferred equivalent call
		end
	end

	local v12 = debounce(function(p2)
		setState6(p2)
	end, 0.5)

	local function fn10(p2)
		local v13 = string.sub(p2.Text, 1, 6)

		if v13 ~= state5 then
			setState8("")
		end

		setState5(v13)
		v12(v13)
	end

	local function fn11()
		v7.reportInteractWithActionAndSection(
			v3.eventContext,
			EventStreamConstants.Field.VerificationCode,
			EventStreamConstants.ActionType.Focus,
			v3.origin,
			"",
			PhoneVerificationUpsellState.VerifyPhone
		)
	end

	React.useEffect(function()
		if string.len(state6) == 6 then
			handleVerifyPhone()
		end
	end, { state6 })

	local function fn12(p2) -- 1 equivalent call inferred from this helper
		return v5(SetIsPhoneVerified(p2))
	end

	React.useEffect(function()
		if state10 then
			fn12({ isPhoneVerified = true }) -- inferred equivalent call
			v7.reportModalShownWithSection(v3.eventContext, v3.origin, PhoneVerificationUpsellState.Success)

			v3.onSuccess()
		end
	end, { state10 })

	local v13 = {
		phoneUpsellState = state,
		screenSize = 0,
		setParentSize = 0,
		handleCloseClick = 0,
		proceedToAddPhone = 0,
		countryCode = 0,
		setCountryCode = 0,
		phoneNumber = 0,
		addPhoneErrorMessage = 0,
		isDisabled = 0,
		onPhoneNumberTextChange = 0,
		handleSetPhone = 0,
		navigateToSMSTerms = 0,
		navigateToPrivacy = 0,
		onPhoneInputFocus = 0,
		onCountryCodeSelectorClick = 0,
		isKeyboardShowing = 0,
		onScreenKeyboardHeight = 0,
		code = 0,
		verifyPhoneErrorMessage = 0,
		onCodeTextChange = 0,
		handleResendCode = 0,
		returnToAddPhone = 0,
		onCodeInputFocus = 0,
		isLoading = 0,
		verifyingKey = 0,
		isOTPInputTypeEnabled = 0,
		isPhoneNumberTextTypeEnabled = 0
	}

	if GetFFlagPhoneUseParentSizeForScreenSize() then
		screenSize = state14
	end

	v13.screenSize = screenSize
	v13.setParentSize = setState13

	function v13.handleCloseClick()
		v7.reportModalDismissedWithSection(v3.eventContext, v3.origin, state)
		v3.closeUpsell()
	end

	function v13.proceedToAddPhone()
		setState(PhoneVerificationUpsellState.AddPhone)
		v7.reportInteractWithActionAndSection(
			v3.eventContext,
			"",
			"",
			v3.origin,
			EventStreamConstants.Button.Continue,
			PhoneVerificationUpsellState.Entry
		)
	end
	v13.countryCode = state3
	v13.setCountryCode = setState3
	v13.phoneNumber = state2
	v13.addPhoneErrorMessage = state7
	v13.isDisabled = state11
	v13.onPhoneNumberTextChange = fn7

	function v13.handleSetPhone()
		setState10(true)
		local v14 = fn3(v6, state3.code, state3.prefix, state2) -- inferred equivalent call

		if v14 then
			v14:andThen(function()
				setState(PhoneVerificationUpsellState.VerifyPhone)
				setState10(false)
				v7.reportModalShownWithSection(v3.eventContext, v3.origin, PhoneVerificationUpsellState.VerifyPhone)

				if v9 then
					fn4() -- inferred equivalent call
				end
			end):catch(function(p2)
				if p2 then
					if p2.PhoneRegexFailed then
						v7.reportModalShownWithSectionAndError(
							v3.eventContext,
							EventStreamConstants.Field.ErrorMessage,
							v3.origin,
							PhoneVerificationUpsellState.AddPhone,
							""
						)

						setState7(v11.invalidPhoneFormatKey)
					else
						v7.reportModalShownWithSectionAndError(
							v3.eventContext,
							EventStreamConstants.Field.ErrorMessage,
							v3.origin,
							PhoneVerificationUpsellState.AddPhone,
							p2.ErrorCode
						)

						setState7(handlePhoneErrors(p2.ErrorCode)) -- inferred equivalent call
					end
				else
					v7.reportModalShownWithSectionAndError(
						v3.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v3.origin,
						PhoneVerificationUpsellState.AddPhone,
						""
					)

					setState7(v11.genericErrorKey)
				end

				setState10(false)
			end)
		end

		v7.reportInteractWithActionAndSection(
			v3.eventContext,
			"",
			"",
			v3.origin,
			EventStreamConstants.Button.Continue,
			PhoneVerificationUpsellState.AddPhone
		)
	end

	function v13.navigateToSMSTerms()
		if not state11 then
			v7.reportModalActionWithSection(
				v3.eventContext,
				EventStreamConstants.Field.TermsOfService,
				"",
				v3.origin,
				state
			)

			v3.showWebpage(Constants.TERMS_OF_SERVICE_URL)
		end
	end

	function v13.navigateToPrivacy()
		if not state11 then
			v7.reportModalActionWithSection(
				v3.eventContext,
				EventStreamConstants.Field.PrivacyPolicy,
				"",
				v3.origin,
				state
			)

			v3.showWebpage(Constants.PRIVACY_POLICY_URL)
		end
	end
	v13.onPhoneInputFocus = fn9
	v13.onCountryCodeSelectorClick = fn8
	v13.isKeyboardShowing = state12
	v13.onScreenKeyboardHeight = state13
	v13.code = state5
	v13.verifyPhoneErrorMessage = state8
	v13.onCodeTextChange = fn10

	function v13.handleResendCode()
		setState8("")
		local v14 = fn6(v6) -- inferred equivalent call

		if v14 then
			v14:andThen(function() end):catch(function(p2)
				if p2 then
					v7.reportModalShownWithSectionAndError(
						v3.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v3.origin,
						PhoneVerificationUpsellState.VerifyPhone,
						p2.ErrorCode
					)

					setState8(handlePhoneErrors(p2.ErrorCode)) -- inferred equivalent call
				else
					v7.reportModalShownWithSectionAndError(
						v3.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v3.origin,
						PhoneVerificationUpsellState.VerifyPhone,
						""
					)

					setState8(v11.genericErrorKey)
				end
			end)
		end

		v7.reportInteractWithActionAndSection(
			v3.eventContext,
			"",
			"",
			v3.origin,
			EventStreamConstants.Button.ResendCode,
			PhoneVerificationUpsellState.VerifyPhone
		)
	end

	function v13.returnToAddPhone()
		setState(PhoneVerificationUpsellState.AddPhone)
		v7.reportInteractWithActionAndSection(
			v3.eventContext,
			"",
			"",
			v3.origin,
			EventStreamConstants.Button.ChangePhoneNumber,
			PhoneVerificationUpsellState.VerifyPhone
		)
	end
	v13.onCodeInputFocus = fn11
	v13.isLoading = state9
	v13.verifyingKey = v11.verifyingKey
	v13.isOTPInputTypeEnabled = isOTPInputTypeEnabled
	v13.isPhoneNumberTextTypeEnabled = isPhoneNumberTextTypeEnabled
	return v13
end

return usePhoneVerificationUpsellProps
