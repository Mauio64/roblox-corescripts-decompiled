local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RoactUtils").Hooks.RoactRodux.useDispatch
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SignalsReact").useSignalState
local fFlagUseSignalsForCountryCodeList = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SharedFlags").FFlagUseSignalsForCountryCodeList
local getCountryCodeListStore = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/AuthCommon").Stores.GetCountryCodeListStore

require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/LuauPolyfill")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RoactServiceTags").RoactNetworking
local EventStreamConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/DuplicateAnalytics/EventStreamConstants")
local RoactAnalyticsAuthEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/DuplicateAnalytics/RoactAnalyticsAuthEvents")
local debounce = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Utils/debounce")
local mergeProps = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Utils/mergeProps")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RobloxAppHooks").useRoactService

local PhoneVerificationUpsellState = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/PhoneVerificationUpsellState")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Constants")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Localization").Hooks.useLocalization

local SetPhoneNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Thunks/SetPhoneNumber")
local ResendPhoneCode = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Thunks/ResendPhoneCode")
local VerifyPhoneCode = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Thunks/VerifyPhoneCode")
local setIsPhoneVerified = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/ContactImporter").Actions.SetIsPhoneVerified

local GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Utils/GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix")

local useUserExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RoactAppExperiment").useUserExperiment
local getFStringAndroidPhoneVerificationLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SharedFlags").GetFStringAndroidPhoneVerificationLayer
local getFStringIOSPhoneVerificationLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SharedFlags").GetFStringIOSPhoneVerificationLayer
local GetFFlagPhoneUseParentSizeForScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Flags/GetFFlagPhoneUseParentSizeForScreenSize")
local getFFlagAddMorePhoneUpsellEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SharedFlags").GetFFlagAddMorePhoneUpsellEvents

local identityProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/IdentityProtocol").IdentityProtocol

local v5 = {
	name = "United States",
	code = "US",
	prefix = "1",
	localizedName = "United States"
}

local function fn() end

local v6 = {
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
	showWebpage = function(p2) end
}

local function usePhoneVerificationUpsellProps(p2)
	local v7 = mergeProps(v6, p2)
	local v8

	if fFlagUseSignalsForCountryCodeList then
		v8 = useSignalState(getCountryCodeListStore(false).getCountryCodeList)
	else
		v8 = useSelector(function(p3)
			return p3.CountryCodeList
		end)
	end

	local v9 = useDispatch()

	local v10 = useRoactService(roactNetworking)
	local v11 = useRoactService(RoactAnalyticsAuthEvents)

	local v12, v13, v14, v15 = useUserExperiment(
		{ getFStringAndroidPhoneVerificationLayer(), getFStringIOSPhoneVerificationLayer() },
		function(p3)
			local v16 = p3[getFStringAndroidPhoneVerificationLayer()] or {}
			local v17 = p3[getFStringIOSPhoneVerificationLayer()] or {}
			return
				v16.IsAutofillPhoneNumberEnabled,
				v16.IsAutofillSMSOtpEnabled,
				v17.IsAutofillSMSOtpEnabled,
				v17.IsAutofillPhoneNumberEnabled
		end
	)

	local useState = React.useState
	local v16 = if v7.entryConfig then PhoneVerificationUpsellState.Entry else PhoneVerificationUpsellState.AddPhone
	local state, setState = useState(v16)

	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState(v5)
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState("")
	local state6, setState6 = React.useState("")
	local state7, setState7 = React.useState("")
	local state8, setState8 = React.useState("")
	local state9, setState9 = React.useState(false)
	local state10, setState10 = React.useState(false)
	local state11, setState11 = React.useState(false)
	local state12, setState12 = React.useState(false)
	local state13, setState13 = React.useState(0)
	local state14, setState14 = React.useState(Vector2.new(400, 400))
	local ref = React.useRef(false)

	local v17 = useLocalization({
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
		if not state4 and v8 and #v8 > 0 then
			for k, v18 in v8 do
				if v18.isDefault then
					setState3(v18)
				end
			end

			setState4(true)
		end
	end, { v8, state4 })

	React.useEffect(function()
		return function()
			ref.current = state10
		end
	end, { state10 })

	React.useEffect(function()
		onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function()
			setState12(UserInputService.OnScreenKeyboardVisible)
			setState13(UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0)
		end)
		local reportModalShownWithSection = v11.reportModalShownWithSection
		local eventContext = v7.eventContext
		local origin = v7.origin
		local v18 = if getFFlagAddMorePhoneUpsellEvents() then state else PhoneVerificationUpsellState.AddPhone
		reportModalShownWithSection(eventContext, origin, v18)

		if v12 then
			local default = identityProtocol.default
			default:supportsGetPhoneNumber():andThen(function(p3)
				print("PhoneVerification: Autofill phone number supported: {}!", p3)

				if not p3 then
					return
				end

				v11.reportModalActionWithSection(
					v7.eventContext,
					"phoneAutofillEligible",
					"autofill",
					v7.origin,
					state
				)

				local phoneNumber = default:getPhoneNumber()

				if not phoneNumber then
					return
				end

				phoneNumber:andThen(function(p4)
					if not p4 or p4 == "" then
						v11.reportModalActionWithSection(
							v7.eventContext,
							"phoneAutofillNull",
							"autofill",
							v7.origin,
							state
						)

						return
					end

					local v19, v20 = GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix(p4, state3.prefix)

					if v19 == v5.prefix then
						v11.reportModalActionWithSection(
							v7.eventContext,
							"phoneAutofillUSFound",
							"autofill",
							v7.origin,
							state
						)
					end

					setState2(v20)

					v11.reportModalActionWithSection(
						v7.eventContext,
						"phoneAutofillSuccess",
						"autofill",
						v7.origin,
						state
					)
				end)
			end)
		end

		return function()
			if onScreenKeyboardVisibleChangedConnection then
				onScreenKeyboardVisibleChangedConnection:Disconnect()
			end

			onScreenKeyboardVisibleChangedConnection = nil

			if not ref.current then
				v7.onCancelled()
			end
		end
	end, {})

	local v18 = useSelector(function(p3)
		return p3.ScreenSize
	end)

	local function handlePhoneErrors(p3)
		if p3 == 2 then
			return v17.invalidPhoneFormatKey
		elseif p3 == 6 then
			return v17.tooManyAttemptsKey
		elseif p3 == 7 then
			return v17.invalidVerificationCodeKey
		elseif p3 == 8 then
			return v17.invalidPhoneNumberKey
		elseif p3 == 9 then
			return v17.tooManyAccountsKey
		end

		return v17.genericErrorKey
	end

	local function handleVerifyPhone()
		setState11(true)
		local v19 = v9(ResendPhoneCode(v10, state6))

		if v19 then
			v19:andThen(function()
				setState10(true)
			end):catch(function(p3)
				if p3 then
					v11.reportModalShownWithSectionAndError(
						v7.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v7.origin,
						PhoneVerificationUpsellState.VerifyPhone,
						p3.ErrorCode
					)

					local errorCode = p3.ErrorCode
					local v21

					if errorCode == 2 then
						v21 = v17.invalidPhoneFormatKey
					elseif errorCode == 6 then
						v21 = v17.tooManyAttemptsKey
					elseif errorCode == 7 then
						v21 = v17.invalidVerificationCodeKey
					elseif errorCode == 8 then
						v21 = v17.invalidPhoneNumberKey
					else
						v21 = if errorCode == 9 then v17.tooManyAccountsKey else v17.genericErrorKey
					end

					setState8(v21)
				else
					v11.reportModalShownWithSectionAndError(
						v7.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v7.origin,
						PhoneVerificationUpsellState.VerifyPhone,
						""
					)

					setState8(v17.genericErrorKey)
				end

				setState11(false)
			end)
		end

		v11.reportInteractWithActionAndSection(
			v7.eventContext,
			"",
			"",
			v7.origin,
			EventStreamConstants.Button.AutoSubmit,
			PhoneVerificationUpsellState.VerifyPhone
		)
	end

	local function fn2(p3)
		if not state11 then
			setState7("")
			setState2(p3.Text)
		end
	end

	local function fn3()
		v11.reportInteractWithActionAndSection(
			v7.eventContext,
			EventStreamConstants.Field.CountryPrefix,
			EventStreamConstants.ActionType.Focus,
			v7.origin,
			"",
			PhoneVerificationUpsellState.AddPhone
		)
	end

	local function fn4()
		v11.reportInteractWithActionAndSection(
			v7.eventContext,
			EventStreamConstants.Field.PhoneNumber,
			EventStreamConstants.ActionType.Focus,
			v7.origin,
			"",
			PhoneVerificationUpsellState.AddPhone
		)

		if not v7.shouldAutofillAndroidPhoneNumberAtLaunch then
			local default = identityProtocol.default
			default:supportsGetPhoneNumber():andThen(function(p3)
				print("PhoneVerification: Autofill phone number supported: {}!", p3)

				if not p3 then
					return
				end

				v11.reportModalActionWithSection(
					v7.eventContext,
					"phoneAutofillEligible",
					"autofill",
					v7.origin,
					state
				)

				local phoneNumber = default:getPhoneNumber()

				if not phoneNumber then
					return
				end

				phoneNumber:andThen(function(p4)
					if not p4 or p4 == "" then
						v11.reportModalActionWithSection(
							v7.eventContext,
							"phoneAutofillNull",
							"autofill",
							v7.origin,
							state
						)

						return
					end

					local v19, v20 = GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix(p4, state3.prefix)

					if v19 == v5.prefix then
						v11.reportModalActionWithSection(
							v7.eventContext,
							"phoneAutofillUSFound",
							"autofill",
							v7.origin,
							state
						)
					end

					setState2(v20)

					v11.reportModalActionWithSection(
						v7.eventContext,
						"phoneAutofillSuccess",
						"autofill",
						v7.origin,
						state
					)
				end)
			end)
		end
	end

	local v19 = debounce(function(p3)
		setState6(p3)
	end, 0.5)

	local function fn5(p3)
		local v20 = string.sub(p3.Text, 1, 6)

		if v20 ~= state5 then
			setState8("")
		end

		setState5(v20)
		v19(v20)
	end

	local function fn6()
		v11.reportInteractWithActionAndSection(
			v7.eventContext,
			EventStreamConstants.Field.VerificationCode,
			EventStreamConstants.ActionType.Focus,
			v7.origin,
			"",
			PhoneVerificationUpsellState.VerifyPhone
		)
	end

	React.useEffect(function()
		if string.len(state6) == 6 then
			handleVerifyPhone()
		end
	end, { state6 })

	React.useEffect(function()
		if state10 then
			v9(setIsPhoneVerified({ isPhoneVerified = true }))
			v11.reportModalShownWithSection(v7.eventContext, v7.origin, PhoneVerificationUpsellState.Success)

			v7.onSuccess()
		end
	end, { state10 })

	local v20 = {
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
		v18 = state14
	end

	v20.screenSize = v18
	v20.setParentSize = setState14

	function v20.handleCloseClick()
		v11.reportModalDismissedWithSection(v7.eventContext, v7.origin, state)
		v7.closeUpsell()
	end

	function v20.proceedToAddPhone()
		setState(PhoneVerificationUpsellState.AddPhone)
		v11.reportInteractWithActionAndSection(
			v7.eventContext,
			"",
			"",
			v7.origin,
			EventStreamConstants.Button.Continue,
			PhoneVerificationUpsellState.Entry
		)
	end
	v20.countryCode = state3
	v20.setCountryCode = setState3
	v20.phoneNumber = state2
	v20.addPhoneErrorMessage = state7
	v20.isDisabled = state11
	v20.onPhoneNumberTextChange = fn2

	function v20.handleSetPhone()
		setState11(true)
		local v19 = v9(SetPhoneNumber(v10, state3.code, state3.prefix, state2, nil))

		if v19 then
			v19:andThen(function()
				setState(PhoneVerificationUpsellState.VerifyPhone)
				setState11(false)
				v11.reportModalShownWithSection(v7.eventContext, v7.origin, PhoneVerificationUpsellState.VerifyPhone)

				if v13 then
					local default = identityProtocol.default
					default:supportsGetSMSOTP():andThen(function(p3)
						print("PhoneVerification: Autofill OTP supported: {}!", p3)

						if p3 then
							v11.reportModalActionWithSection(
								v7.eventContext,
								"codeAutofillEligible",
								"autofill",
								v7.origin,
								state
							)

							local smsotp = default:getSMSOTP()

							if smsotp then
								smsotp:andThen(function(p4)
									if p4 and p4 ~= "" then
										setState5(p4)
										setState6(p4)
										v11.reportModalActionWithSection(
											v7.eventContext,
											"codeAutofillSuccess",
											"autofill",
											v7.origin,
											state
										)
									end
								end)
							end
						end
					end)
				end
			end):catch(function(p3)
				if p3 then
					if p3.PhoneRegexFailed then
						v11.reportModalShownWithSectionAndError(
							v7.eventContext,
							EventStreamConstants.Field.ErrorMessage,
							v7.origin,
							PhoneVerificationUpsellState.AddPhone,
							""
						)

						setState7(v17.invalidPhoneFormatKey)
					else
						v11.reportModalShownWithSectionAndError(
							v7.eventContext,
							EventStreamConstants.Field.ErrorMessage,
							v7.origin,
							PhoneVerificationUpsellState.AddPhone,
							p3.ErrorCode
						)

						local errorCode = p3.ErrorCode
						local v21

						if errorCode == 2 then
							v21 = v17.invalidPhoneFormatKey
						elseif errorCode == 6 then
							v21 = v17.tooManyAttemptsKey
						elseif errorCode == 7 then
							v21 = v17.invalidVerificationCodeKey
						elseif errorCode == 8 then
							v21 = v17.invalidPhoneNumberKey
						else
							v21 = if errorCode == 9 then v17.tooManyAccountsKey else v17.genericErrorKey
						end

						setState7(v21)
					end
				else
					v11.reportModalShownWithSectionAndError(
						v7.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v7.origin,
						PhoneVerificationUpsellState.AddPhone,
						""
					)

					setState7(v17.genericErrorKey)
				end

				setState11(false)
			end)
		end

		v11.reportInteractWithActionAndSection(
			v7.eventContext,
			"",
			"",
			v7.origin,
			EventStreamConstants.Button.Continue,
			PhoneVerificationUpsellState.AddPhone
		)
	end

	function v20.navigateToSMSTerms()
		if not state11 then
			v11.reportModalActionWithSection(
				v7.eventContext,
				EventStreamConstants.Field.TermsOfService,
				"",
				v7.origin,
				state
			)

			v7.showWebpage(Constants.TERMS_OF_SERVICE_URL)
		end
	end

	function v20.navigateToPrivacy()
		if not state11 then
			v11.reportModalActionWithSection(
				v7.eventContext,
				EventStreamConstants.Field.PrivacyPolicy,
				"",
				v7.origin,
				state
			)

			v7.showWebpage(Constants.PRIVACY_POLICY_URL)
		end
	end
	v20.onPhoneInputFocus = fn4
	v20.onCountryCodeSelectorClick = fn3
	v20.isKeyboardShowing = state12
	v20.onScreenKeyboardHeight = state13
	v20.code = state5
	v20.verifyPhoneErrorMessage = state8
	v20.onCodeTextChange = fn5

	function v20.handleResendCode()
		setState8("")
		local v19 = v9(VerifyPhoneCode(v10))

		if v19 then
			v19:andThen(function() end):catch(function(p3)
				if p3 then
					v11.reportModalShownWithSectionAndError(
						v7.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v7.origin,
						PhoneVerificationUpsellState.VerifyPhone,
						p3.ErrorCode
					)

					local errorCode = p3.ErrorCode
					local v21

					if errorCode == 2 then
						v21 = v17.invalidPhoneFormatKey
					elseif errorCode == 6 then
						v21 = v17.tooManyAttemptsKey
					elseif errorCode == 7 then
						v21 = v17.invalidVerificationCodeKey
					elseif errorCode == 8 then
						v21 = v17.invalidPhoneNumberKey
					else
						v21 = if errorCode == 9 then v17.tooManyAccountsKey else v17.genericErrorKey
					end

					setState8(v21)
				else
					v11.reportModalShownWithSectionAndError(
						v7.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v7.origin,
						PhoneVerificationUpsellState.VerifyPhone,
						""
					)

					setState8(v17.genericErrorKey)
				end
			end)
		end

		v11.reportInteractWithActionAndSection(
			v7.eventContext,
			"",
			"",
			v7.origin,
			EventStreamConstants.Button.ResendCode,
			PhoneVerificationUpsellState.VerifyPhone
		)
	end

	function v20.returnToAddPhone()
		setState(PhoneVerificationUpsellState.AddPhone)
		v11.reportInteractWithActionAndSection(
			v7.eventContext,
			"",
			"",
			v7.origin,
			EventStreamConstants.Button.ChangePhoneNumber,
			PhoneVerificationUpsellState.VerifyPhone
		)
	end
	v20.onCodeInputFocus = fn6
	v20.isLoading = state9
	v20.verifyingKey = v17.verifyingKey
	v20.isOTPInputTypeEnabled = v14
	v20.isPhoneNumberTextTypeEnabled = v15
	return v20
end

return usePhoneVerificationUpsellProps
