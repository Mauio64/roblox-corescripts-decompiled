local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local UserInputService = game:GetService("UserInputService")
local React = require(PhoneUpsellParent.React)
local useSelector = require(PhoneUpsellParent.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(PhoneUpsellParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSignalState = require(PhoneUpsellParent.SignalsReact).useSignalState
local FFlagUseSignalsForCountryCodeList = require(PhoneUpsellParent.SharedFlags).FFlagUseSignalsForCountryCodeList
local GetCountryCodeListStore = require(PhoneUpsellParent.AuthCommon).Stores.GetCountryCodeListStore

require(PhoneUpsellParent.LuauPolyfill)

local RoactNetworking = require(PhoneUpsellParent.RoactServiceTags).RoactNetworking
local EventStreamConstants = require(PhoneUpsell.DuplicateAnalytics.EventStreamConstants)
local RoactAnalyticsAuthEvents = require(PhoneUpsell.DuplicateAnalytics.RoactAnalyticsAuthEvents)
local debounce = require(PhoneUpsell.Utils.debounce)
local mergeProps = require(PhoneUpsell.Utils.mergeProps)
local useRoactService = require(PhoneUpsellParent.RobloxAppHooks).useRoactService
local PhoneVerificationUpsellState = require(PhoneUpsell.Components.PhoneVerificationUpsellState)
local Constants = require(PhoneUpsell.Constants)
local useLocalization = require(PhoneUpsellParent.Localization).Hooks.useLocalization
local SetPhoneNumber = require(PhoneUpsell.Thunks.SetPhoneNumber)
local VerifyPhoneCode = require(PhoneUpsell.Thunks.VerifyPhoneCode)
local ResendPhoneCode = require(PhoneUpsell.Thunks.ResendPhoneCode)
local SetIsPhoneVerified = require(PhoneUpsellParent.ContactImporter).Actions.SetIsPhoneVerified
local GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix = require(PhoneUpsell.Utils.GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix)
local useUserExperiment = require(PhoneUpsellParent.RoactAppExperiment).useUserExperiment
local GetFStringAndroidPhoneVerificationLayer = require(PhoneUpsellParent.SharedFlags).GetFStringAndroidPhoneVerificationLayer
local GetFStringIOSPhoneVerificationLayer = require(PhoneUpsellParent.SharedFlags).GetFStringIOSPhoneVerificationLayer
local GetFFlagPhoneUseParentSizeForScreenSize = require(PhoneUpsell.Flags.GetFFlagPhoneUseParentSizeForScreenSize)
local GetFFlagAddMorePhoneUpsellEvents = require(PhoneUpsellParent.SharedFlags).GetFFlagAddMorePhoneUpsellEvents
local IdentityProtocol = require(PhoneUpsellParent.IdentityProtocol).IdentityProtocol
local t1 = {
	name = "United States",
	code = "US",
	prefix = "1",
	localizedName = "United States"
}

local function v31() -- line: 117
end

local t2 = {
	origin = "",
	eventContext = "",
	addPhoneTitleKey = "Feature.VerificationUpsell.Action.AddPhone",
	addPhoneDescriptionKey = "Feature.VerificationUpsell.Description.VerificationCodeSmsFeesMayApply",
	extraButtonTextKey = "",
	shouldAutofillAndroidPhoneNumberAtLaunch = false,
	alwaysShowAddPhoneLegalText = false,
	requireAddPhoneLegalTextCheckbox = false,
	onSuccess = v31,
	onFailure = v31,
	onCancelled = v31,
	onExtraButtonClick = v31,
	closeUpsell = v31,
	showWebpage = function(_) -- line: 133
	end
}

local function usePhoneVerificationUpsellProps(t3: {[any]: any}) -- line: 136
	-- upvalues: mergeProps (copy), t2 (copy), FFlagUseSignalsForCountryCodeList (copy), useSignalState (copy), GetCountryCodeListStore (copy), useSelector (copy), useDispatch (copy), SetPhoneNumber (copy), VerifyPhoneCode (copy), ResendPhoneCode (copy), SetIsPhoneVerified (copy), useRoactService (copy), RoactNetworking (copy), RoactAnalyticsAuthEvents (copy), useUserExperiment (copy), GetFStringAndroidPhoneVerificationLayer (copy), GetFStringIOSPhoneVerificationLayer (copy), React (copy), PhoneVerificationUpsellState (copy), t1 (copy), useLocalization (copy), IdentityProtocol (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), UserInputService (copy), GetFFlagAddMorePhoneUpsellEvents (copy), EventStreamConstants (copy), Constants (copy), debounce (copy), GetFFlagPhoneUseParentSizeForScreenSize (copy)
	local v36 = mergeProps(t2, t3)
	local v37 = if not FFlagUseSignalsForCountryCodeList then useSelector(function(p2) -- line: 141
		return p2.CountryCodeList
	end) else useSignalState(GetCountryCodeListStore(false).getCountryCodeList)
	local v38 = useDispatch()
	local v39 = useRoactService(RoactNetworking)
	local v40 = useRoactService(RoactAnalyticsAuthEvents)
	local v41, v42, v43, v44 = useUserExperiment({
		GetFStringAndroidPhoneVerificationLayer(),
		GetFStringIOSPhoneVerificationLayer()
	}, function(p3) -- line: 164
		-- upvalues: GetFStringAndroidPhoneVerificationLayer (copy), GetFStringIOSPhoneVerificationLayer (copy)
		local v90 = p3[GetFStringAndroidPhoneVerificationLayer()] or {}
		local v91 = p3[GetFStringIOSPhoneVerificationLayer()] or {}

		return v90.IsAutofillPhoneNumberEnabled, v90.IsAutofillSMSOtpEnabled, v91.IsAutofillSMSOtpEnabled, v91.IsAutofillPhoneNumberEnabled
	end)
	local v45, v46 = React.useState(if not v36.entryConfig then PhoneVerificationUpsellState.AddPhone else PhoneVerificationUpsellState.Entry)
	local v47, v48 = React.useState("")
	local v49, v50 = React.useState(t1)
	local v51, v52 = React.useState(false)
	local v53, v54 = React.useState("")
	local v55, v56 = React.useState("")
	local v57, v58 = React.useState("")
	local v59, v60 = React.useState("")
	local v61, _ = React.useState(false)
	local v63, v64 = React.useState(false)
	local v65, v66 = React.useState(false)
	local v67, v68 = React.useState(false)
	local v69, v70 = React.useState(0)
	local v71, v72 = React.useState(Vector2.new(400, 400))
	local v73 = React.useRef(false)
	local v74 = useLocalization({
		verifyingKey = "Feature.VerificationUpsell.Label.Verifying",
		invalidPhoneFormatKey = "Feature.VerificationUpsell.Response.ErrorPhoneFormatInvalid",
		invalidPhoneNumberKey = "Feature.VerificationUpsell.Response.InvalidPhoneNumberError",
		invalidVerificationCodeKey = "Feature.VerificationUpsell.Message.InvalidSmsCode",
		tooManyAccountsKey = "Feature.VerificationUpsell.Response.PhoneHasTooManyAssociatedAccounts",
		tooManyAttemptsKey = "Feature.VerificationUpsell.Response.TooManyAttemptsTryAgainLater",
		genericErrorKey = "Feature.VerificationUpsell.Response.ErrorTryAgain"
	})
	local connection = nil

	React.useEffect(function() -- line: 205
		-- upvalues: v51 (copy), v37 (copy), v50 (copy), v52 (copy)
		if not v51 and (v37 and #v37 > 0) then
			for _, v93 in v37 do
				if v93.isDefault then
					v50(v93)
				end
			end

			v52(true)
		end
	end, {
		v37,
		v51
	})
	React.useEffect(function() -- line: 303
		-- upvalues: v73 (copy), v63 (copy)
		return function() -- line: 304
			-- upvalues: v73 (copy), v63 (copy)
			v73.current = v63
		end
	end, { v63 })
	React.useEffect(function() -- line: 309
		-- upvalues: connection (ref), UserInputService (copy), v68 (copy), v70 (copy), v40 (copy), v36 (copy), GetFFlagAddMorePhoneUpsellEvents (copy), v45 (copy), PhoneVerificationUpsellState (copy), v41 (copy), IdentityProtocol (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v49 (copy), t1 (copy), v48 (copy), v73 (copy)
		connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function() -- line: 311
			-- upvalues: v68 (copy), UserInputService (copy), v70 (copy)
			v68(UserInputService.OnScreenKeyboardVisible)
			v70(UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0)
		end)
		v40.reportModalShownWithSection(v36.eventContext, v36.origin, if not GetFFlagAddMorePhoneUpsellEvents() then PhoneVerificationUpsellState.AddPhone else v45)

		if v41 then
			local default = IdentityProtocol.default

			default:supportsGetPhoneNumber():andThen(function(b1: boolean?) -- line: 219
				-- upvalues: v40 (copy), v36 (copy), v45 (copy), default (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v49 (copy), t1 (copy), v48 (copy)
				print("PhoneVerification: Autofill phone number supported: {}!", b1)

				if not b1 then
					return
				end

				v40.reportModalActionWithSection(v36.eventContext, "phoneAutofillEligible", "autofill", v36.origin, v45)

				local v120 = default:getPhoneNumber()

				if not v120 then
					return
				end

				v120:andThen(function(s1: string?) -- line: 235
					-- upvalues: GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v49 (copy), t1 (copy), v40 (copy), v36 (copy), v45 (copy), v48 (copy)
					if s1 and s1 ~= "" then
						local v138, v139 = GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix(s1, v49.prefix)

						if v138 == t1.prefix then
							v40.reportModalActionWithSection(v36.eventContext, "phoneAutofillUSFound", "autofill", v36.origin, v45)
						end

						v48(v139)
						v40.reportModalActionWithSection(v36.eventContext, "phoneAutofillSuccess", "autofill", v36.origin, v45)

						return
					end

					v40.reportModalActionWithSection(v36.eventContext, "phoneAutofillNull", "autofill", v36.origin, v45)
				end)
			end)
		end

		return function() -- line: 326
			-- upvalues: connection (ref), v73 (copy), v36 (copy)
			if connection then
				connection:Disconnect()
			end

			connection = nil

			if not v73.current then
				v36.onCancelled()
			end
		end
	end, {})

	local v76 = useSelector(function(p4) -- line: 337
		return p4.ScreenSize
	end)

	local function handlePhoneErrors(n1: number?) -- line: 346
		-- upvalues: v74 (copy)
		if n1 == 2 then
			return v74.invalidPhoneFormatKey
		end

		if n1 == 6 then
			return v74.tooManyAttemptsKey
		end

		if n1 == 7 then
			return v74.invalidVerificationCodeKey
		end

		if n1 == 8 then
			return v74.invalidPhoneNumberKey
		end

		if n1 == 9 then
			return v74.tooManyAccountsKey
		end

		return v74.genericErrorKey
	end
	local function handleVerifyPhone() -- line: 423
		-- upvalues: v66 (copy), v39 (copy), v55 (copy), v38 (copy), VerifyPhoneCode (copy), v64 (copy), v40 (copy), v36 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v60 (copy), v74 (copy)
		v66(true)

		local v104 = v39
		local v105 = v55
		local v106 = v38(VerifyPhoneCode(v104, v105))

		if v106 then
			v106:andThen(function() -- line: 428
				-- upvalues: v64 (copy)
				v64(true)
			end):catch(function(t4: {[any]: any}) -- line: 431
				-- upvalues: v40 (copy), v36 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v60 (copy), v74 (copy), v66 (copy)
				if not t4 then
					v40.reportModalShownWithSectionAndError(v36.eventContext, EventStreamConstants.Field.ErrorMessage, v36.origin, PhoneVerificationUpsellState.VerifyPhone, "")
					v60(v74.genericErrorKey)
				else
					v40.reportModalShownWithSectionAndError(v36.eventContext, EventStreamConstants.Field.ErrorMessage, v36.origin, PhoneVerificationUpsellState.VerifyPhone, t4.ErrorCode)

					local v126 = v60
					local ErrorCode = t4.ErrorCode

					v126(if ErrorCode ~= 2 then if ErrorCode ~= 6 then if ErrorCode ~= 7 then if ErrorCode ~= 8 then if ErrorCode ~= 9 then v74.genericErrorKey else v74.tooManyAccountsKey else v74.invalidPhoneNumberKey else v74.invalidVerificationCodeKey else v74.tooManyAttemptsKey else v74.invalidPhoneFormatKey)
				end

				v66(false)
			end)
		end

		v40.reportInteractWithActionAndSection(v36.eventContext, "", "", v36.origin, EventStreamConstants.Button.AutoSubmit, PhoneVerificationUpsellState.VerifyPhone)
	end

	local v79 = debounce(function(p5) -- line: 583
		-- upvalues: v56 (copy)
		v56(p5)
	end, 0.5)

	React.useEffect(function() -- line: 608
		-- upvalues: v55 (copy), handleVerifyPhone (copy)
		if string.len(v55) == 6 then
			handleVerifyPhone()
		end
	end, { v55 })
	React.useEffect(function() -- line: 615
		-- upvalues: v63 (copy), v38 (copy), SetIsPhoneVerified (copy), v40 (copy), v36 (copy), PhoneVerificationUpsellState (copy)
		if v63 then
			local t5 = {
				isPhoneVerified = true
			}

			v38(SetIsPhoneVerified(t5))
			v40.reportModalShownWithSection(v36.eventContext, v36.origin, PhoneVerificationUpsellState.Success)
			v36.onSuccess()
		end
	end, { v63 })

	return {
		phoneUpsellState = v45,
		screenSize = if not GetFFlagPhoneUseParentSizeForScreenSize() then v76 else v71,
		setParentSize = v72,
		handleCloseClick = function() -- line: 341
			-- upvalues: v40 (copy), v36 (copy), v45 (copy)
			v40.reportModalDismissedWithSection(v36.eventContext, v36.origin, v45)
			v36.closeUpsell()
		end,
		proceedToAddPhone = function() -- line: 512
			-- upvalues: v46 (copy), PhoneVerificationUpsellState (copy), v40 (copy), v36 (copy), EventStreamConstants (copy)
			v46(PhoneVerificationUpsellState.AddPhone)
			v40.reportInteractWithActionAndSection(v36.eventContext, "", "", v36.origin, EventStreamConstants.Button.Continue, PhoneVerificationUpsellState.Entry)
		end,
		countryCode = v49,
		setCountryCode = v50,
		phoneNumber = v47,
		addPhoneErrorMessage = v57,
		isDisabled = v65,
		onPhoneNumberTextChange = function(p6) -- line: 551
			-- upvalues: v65 (copy), v58 (copy), v48 (copy)
			if not v65 then
				v58("")
				v48(p6.Text)
			end
		end,
		handleSetPhone = function() -- line: 362
			-- upvalues: v66 (copy), v39 (copy), v49 (copy), v47 (copy), v38 (copy), SetPhoneNumber (copy), v46 (copy), PhoneVerificationUpsellState (copy), v40 (copy), v36 (copy), v42 (copy), IdentityProtocol (copy), v45 (copy), v54 (copy), v56 (copy), EventStreamConstants (copy), v58 (copy), v74 (copy)
			v66(true)

			local v99 = v39
			local code = v49.code
			local prefix = v49.prefix
			local v102 = v47
			local v103 = v38(SetPhoneNumber(v99, code, prefix, v102, nil))

			if v103 then
				v103:andThen(function() -- line: 367
					-- upvalues: v46 (copy), PhoneVerificationUpsellState (copy), v66 (copy), v40 (copy), v36 (copy), v42 (copy), IdentityProtocol (copy), v45 (copy), v54 (copy), v56 (copy)
					v46(PhoneVerificationUpsellState.VerifyPhone)
					v66(false)
					v40.reportModalShownWithSection(v36.eventContext, v36.origin, PhoneVerificationUpsellState.VerifyPhone)

					if v42 then
						local default = IdentityProtocol.default

						default:supportsGetSMSOTP():andThen(function(b2: boolean?) -- line: 273
							-- upvalues: v40 (copy), v36 (copy), v45 (copy), default (copy), v54 (copy), v56 (copy)
							print("PhoneVerification: Autofill OTP supported: {}!", b2)

							if b2 then
								v40.reportModalActionWithSection(v36.eventContext, "codeAutofillEligible", "autofill", v36.origin, v45)

								local v141 = default:getSMSOTP()

								if v141 then
									v141:andThen(function(s2: string?) -- line: 285
										-- upvalues: v54 (copy), v56 (copy), v40 (copy), v36 (copy), v45 (copy)
										if s2 and s2 ~= "" then
											v54(s2)
											v56(s2)
											v40.reportModalActionWithSection(v36.eventContext, "codeAutofillSuccess", "autofill", v36.origin, v45)
										end
									end)
								end
							end
						end)
					end
				end):catch(function(t6: {[any]: any}) -- line: 381
					-- upvalues: v40 (copy), v36 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v58 (copy), v74 (copy), v66 (copy)
					if not t6 then
						v40.reportModalShownWithSectionAndError(v36.eventContext, EventStreamConstants.Field.ErrorMessage, v36.origin, PhoneVerificationUpsellState.AddPhone, "")
						v58(v74.genericErrorKey)
					elseif t6.PhoneRegexFailed then
						v40.reportModalShownWithSectionAndError(v36.eventContext, EventStreamConstants.Field.ErrorMessage, v36.origin, PhoneVerificationUpsellState.AddPhone, "")
						v58(v74.invalidPhoneFormatKey)
					else
						v40.reportModalShownWithSectionAndError(v36.eventContext, EventStreamConstants.Field.ErrorMessage, v36.origin, PhoneVerificationUpsellState.AddPhone, t6.ErrorCode)

						local v123 = v58
						local ErrorCode = t6.ErrorCode

						v123(if ErrorCode ~= 2 then if ErrorCode ~= 6 then if ErrorCode ~= 7 then if ErrorCode ~= 8 then if ErrorCode ~= 9 then v74.genericErrorKey else v74.tooManyAccountsKey else v74.invalidPhoneNumberKey else v74.invalidVerificationCodeKey else v74.tooManyAttemptsKey else v74.invalidPhoneFormatKey)
					end

					v66(false)
				end)
			end

			v40.reportInteractWithActionAndSection(v36.eventContext, "", "", v36.origin, EventStreamConstants.Button.Continue, PhoneVerificationUpsellState.AddPhone)
		end,
		navigateToSMSTerms = function() -- line: 524
			-- upvalues: v65 (copy), v40 (copy), v36 (copy), EventStreamConstants (copy), v45 (copy), Constants (copy)
			if not v65 then
				v40.reportModalActionWithSection(v36.eventContext, EventStreamConstants.Field.TermsOfService, "", v36.origin, v45)
				v36.showWebpage(Constants.TERMS_OF_SERVICE_URL)
			end
		end,
		navigateToPrivacy = function() -- line: 537
			-- upvalues: v65 (copy), v40 (copy), v36 (copy), EventStreamConstants (copy), v45 (copy), Constants (copy)
			if not v65 then
				v40.reportModalActionWithSection(v36.eventContext, EventStreamConstants.Field.PrivacyPolicy, "", v36.origin, v45)
				v36.showWebpage(Constants.PRIVACY_POLICY_URL)
			end
		end,
		onPhoneInputFocus = function() -- line: 569
			-- upvalues: v40 (copy), v36 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), IdentityProtocol (copy), v45 (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v49 (copy), t1 (copy), v48 (copy)
			v40.reportInteractWithActionAndSection(v36.eventContext, EventStreamConstants.Field.PhoneNumber, EventStreamConstants.ActionType.Focus, v36.origin, "", PhoneVerificationUpsellState.AddPhone)

			if not v36.shouldAutofillAndroidPhoneNumberAtLaunch then
				local default = IdentityProtocol.default

				default:supportsGetPhoneNumber():andThen(function(b3: boolean?) -- line: 219
					-- upvalues: v40 (copy), v36 (copy), v45 (copy), default (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v49 (copy), t1 (copy), v48 (copy)
					print("PhoneVerification: Autofill phone number supported: {}!", b3)

					if not b3 then
						return
					end

					v40.reportModalActionWithSection(v36.eventContext, "phoneAutofillEligible", "autofill", v36.origin, v45)

					local v132 = default:getPhoneNumber()

					if not v132 then
						return
					end

					v132:andThen(function(s3: string?) -- line: 235
						-- upvalues: GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v49 (copy), t1 (copy), v40 (copy), v36 (copy), v45 (copy), v48 (copy)
						if s3 and s3 ~= "" then
							local v143, v144 = GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix(s3, v49.prefix)

							if v143 == t1.prefix then
								v40.reportModalActionWithSection(v36.eventContext, "phoneAutofillUSFound", "autofill", v36.origin, v45)
							end

							v48(v144)
							v40.reportModalActionWithSection(v36.eventContext, "phoneAutofillSuccess", "autofill", v36.origin, v45)

							return
						end

						v40.reportModalActionWithSection(v36.eventContext, "phoneAutofillNull", "autofill", v36.origin, v45)
					end)
				end)
			end
		end,
		onCountryCodeSelectorClick = function() -- line: 558
			-- upvalues: v40 (copy), v36 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy)
			v40.reportInteractWithActionAndSection(v36.eventContext, EventStreamConstants.Field.CountryPrefix, EventStreamConstants.ActionType.Focus, v36.origin, "", PhoneVerificationUpsellState.AddPhone)
		end,
		isKeyboardShowing = v67,
		onScreenKeyboardHeight = v69,
		code = v53,
		verifyPhoneErrorMessage = v59,
		onCodeTextChange = function(p7) -- line: 587
			-- upvalues: v53 (copy), v60 (copy), v54 (copy), v79 (copy)
			local v113 = string.sub(p7.Text, 1, 6)

			if v113 ~= v53 then
				v60("")
			end

			v54(v113)
			v79(v113)
		end,
		handleResendCode = function() -- line: 464
			-- upvalues: v60 (copy), v39 (copy), v38 (copy), ResendPhoneCode (copy), v40 (copy), v36 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v74 (copy)
			v60("")

			local v107 = v39
			local v108 = v38(ResendPhoneCode(v107))

			if v108 then
				v108:andThen(function() -- line: 468
				end):catch(function(t7: {[any]: any}) -- line: 468
					-- upvalues: v40 (copy), v36 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v60 (copy), v74 (copy)
					if not t7 then
						v40.reportModalShownWithSectionAndError(v36.eventContext, EventStreamConstants.Field.ErrorMessage, v36.origin, PhoneVerificationUpsellState.VerifyPhone, "")
						v60(v74.genericErrorKey)

						return
					end

					v40.reportModalShownWithSectionAndError(v36.eventContext, EventStreamConstants.Field.ErrorMessage, v36.origin, PhoneVerificationUpsellState.VerifyPhone, t7.ErrorCode)

					local v129 = v60
					local ErrorCode = t7.ErrorCode

					v129(if ErrorCode ~= 2 then if ErrorCode ~= 6 then if ErrorCode ~= 7 then if ErrorCode ~= 8 then if ErrorCode ~= 9 then v74.genericErrorKey else v74.tooManyAccountsKey else v74.invalidPhoneNumberKey else v74.invalidVerificationCodeKey else v74.tooManyAttemptsKey else v74.invalidPhoneFormatKey)
				end)
			end

			v40.reportInteractWithActionAndSection(v36.eventContext, "", "", v36.origin, EventStreamConstants.Button.ResendCode, PhoneVerificationUpsellState.VerifyPhone)
		end,
		returnToAddPhone = function() -- line: 500
			-- upvalues: v46 (copy), PhoneVerificationUpsellState (copy), v40 (copy), v36 (copy), EventStreamConstants (copy)
			v46(PhoneVerificationUpsellState.AddPhone)
			v40.reportInteractWithActionAndSection(v36.eventContext, "", "", v36.origin, EventStreamConstants.Button.ChangePhoneNumber, PhoneVerificationUpsellState.VerifyPhone)
		end,
		onCodeInputFocus = function() -- line: 596
			-- upvalues: v40 (copy), v36 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy)
			v40.reportInteractWithActionAndSection(v36.eventContext, EventStreamConstants.Field.VerificationCode, EventStreamConstants.ActionType.Focus, v36.origin, "", PhoneVerificationUpsellState.VerifyPhone)
		end,
		isLoading = v61,
		verifyingKey = v74.verifyingKey,
		isOTPInputTypeEnabled = v43,
		isPhoneNumberTextTypeEnabled = v44
	}
end

return usePhoneVerificationUpsellProps
