local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local UserInputService = game:GetService("UserInputService")
local React = require(PhoneUpsellParent.React)
local useSelector = require(PhoneUpsellParent.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(PhoneUpsellParent.RoactUtils).Hooks.RoactRodux.useDispatch

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
local FFlagPhoneUpsellEnforceCodeInputLimit = require(PhoneUpsellParent.SharedFlags).FFlagPhoneUpsellEnforceCodeInputLimit
local IdentityProtocol = require(PhoneUpsellParent.IdentityProtocol).IdentityProtocol
local t1 = {
	name = "United States",
	code = "US",
	prefix = "1",
	localizedName = "United States"
}

local function v29() -- line: 115
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
	onSuccess = v29,
	onFailure = v29,
	onCancelled = v29,
	onExtraButtonClick = v29,
	closeUpsell = v29,
	showWebpage = function(_) -- line: 131
	end
}

local function usePhoneVerificationUpsellProps(t3: {[any]: any}) -- line: 134
	-- upvalues: mergeProps (copy), t2 (copy), useSelector (copy), useDispatch (copy), SetPhoneNumber (copy), VerifyPhoneCode (copy), ResendPhoneCode (copy), SetIsPhoneVerified (copy), useRoactService (copy), RoactNetworking (copy), RoactAnalyticsAuthEvents (copy), useUserExperiment (copy), GetFStringAndroidPhoneVerificationLayer (copy), GetFStringIOSPhoneVerificationLayer (copy), React (copy), PhoneVerificationUpsellState (copy), t1 (copy), useLocalization (copy), IdentityProtocol (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), UserInputService (copy), GetFFlagAddMorePhoneUpsellEvents (copy), EventStreamConstants (copy), Constants (copy), debounce (copy), FFlagPhoneUpsellEnforceCodeInputLimit (copy), GetFFlagPhoneUseParentSizeForScreenSize (copy)
	local v34 = mergeProps(t2, t3)
	local v35 = useSelector(function(p2) -- line: 137
		return p2.CountryCodeList
	end)
	local v36 = useDispatch()
	local v37 = useRoactService(RoactNetworking)
	local v38 = useRoactService(RoactAnalyticsAuthEvents)
	local v39, v40, v41, v42 = useUserExperiment({
		GetFStringAndroidPhoneVerificationLayer(),
		GetFStringIOSPhoneVerificationLayer()
	}, function(p3) -- line: 160
		-- upvalues: GetFStringAndroidPhoneVerificationLayer (copy), GetFStringIOSPhoneVerificationLayer (copy)
		local v88 = p3[GetFStringAndroidPhoneVerificationLayer()] or {}
		local v89 = p3[GetFStringIOSPhoneVerificationLayer()] or {}

		return v88.IsAutofillPhoneNumberEnabled, v88.IsAutofillSMSOtpEnabled, v89.IsAutofillSMSOtpEnabled, v89.IsAutofillPhoneNumberEnabled
	end)
	local v43, v44 = React.useState(if not v34.entryConfig then PhoneVerificationUpsellState.AddPhone else PhoneVerificationUpsellState.Entry)
	local v45, v46 = React.useState("")
	local v47, v48 = React.useState(t1)
	local v49, v50 = React.useState(false)
	local v51, v52 = React.useState("")
	local v53, v54 = React.useState("")
	local v55, v56 = React.useState("")
	local v57, v58 = React.useState("")
	local v59, _ = React.useState(false)
	local v61, v62 = React.useState(false)
	local v63, v64 = React.useState(false)
	local v65, v66 = React.useState(false)
	local v67, v68 = React.useState(0)
	local v69, v70 = React.useState(Vector2.new(400, 400))
	local v71 = React.useRef(false)
	local v72 = useLocalization({
		verifyingKey = "Feature.VerificationUpsell.Label.Verifying",
		invalidPhoneFormatKey = "Feature.VerificationUpsell.Response.ErrorPhoneFormatInvalid",
		invalidPhoneNumberKey = "Feature.VerificationUpsell.Response.InvalidPhoneNumberError",
		invalidVerificationCodeKey = "Feature.VerificationUpsell.Message.InvalidSmsCode",
		tooManyAccountsKey = "Feature.VerificationUpsell.Response.PhoneHasTooManyAssociatedAccounts",
		tooManyAttemptsKey = "Feature.VerificationUpsell.Response.TooManyAttemptsTryAgainLater",
		genericErrorKey = "Feature.VerificationUpsell.Response.ErrorTryAgain"
	})
	local connection = nil

	React.useEffect(function() -- line: 201
		-- upvalues: v49 (copy), v35 (copy), v48 (copy), v50 (copy)
		if not v49 and (v35 and #v35 > 0) then
			for _, v91 in v35 do
				if v91.isDefault then
					v48(v91)
				end
			end

			v50(true)
		end
	end, {
		v35,
		v49
	})
	React.useEffect(function() -- line: 299
		-- upvalues: v71 (copy), v61 (copy)
		return function() -- line: 300
			-- upvalues: v71 (copy), v61 (copy)
			v71.current = v61
		end
	end, { v61 })
	React.useEffect(function() -- line: 305
		-- upvalues: connection (ref), UserInputService (copy), v66 (copy), v68 (copy), v38 (copy), v34 (copy), GetFFlagAddMorePhoneUpsellEvents (copy), v43 (copy), PhoneVerificationUpsellState (copy), v39 (copy), IdentityProtocol (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v47 (copy), t1 (copy), v46 (copy), v71 (copy)
		connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function() -- line: 307
			-- upvalues: v66 (copy), UserInputService (copy), v68 (copy)
			v66(UserInputService.OnScreenKeyboardVisible)
			v68(UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0)
		end)
		v38.reportModalShownWithSection(v34.eventContext, v34.origin, if not GetFFlagAddMorePhoneUpsellEvents() then PhoneVerificationUpsellState.AddPhone else v43)

		if v39 then
			local default = IdentityProtocol.default

			default:supportsGetPhoneNumber():andThen(function(b1: boolean?) -- line: 215
				-- upvalues: v38 (copy), v34 (copy), v43 (copy), default (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v47 (copy), t1 (copy), v46 (copy)
				print("PhoneVerification: Autofill phone number supported: {}!", b1)

				if not b1 then
					return
				end

				v38.reportModalActionWithSection(v34.eventContext, "phoneAutofillEligible", "autofill", v34.origin, v43)

				local v118 = default:getPhoneNumber()

				if not v118 then
					return
				end

				v118:andThen(function(s1: string?) -- line: 231
					-- upvalues: GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v47 (copy), t1 (copy), v38 (copy), v34 (copy), v43 (copy), v46 (copy)
					if s1 and s1 ~= "" then
						local v136, v137 = GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix(s1, v47.prefix)

						if v136 == t1.prefix then
							v38.reportModalActionWithSection(v34.eventContext, "phoneAutofillUSFound", "autofill", v34.origin, v43)
						end

						v46(v137)
						v38.reportModalActionWithSection(v34.eventContext, "phoneAutofillSuccess", "autofill", v34.origin, v43)

						return
					end

					v38.reportModalActionWithSection(v34.eventContext, "phoneAutofillNull", "autofill", v34.origin, v43)
				end)
			end)
		end

		return function() -- line: 322
			-- upvalues: connection (ref), v71 (copy), v34 (copy)
			if connection then
				connection:Disconnect()
			end

			connection = nil

			if not v71.current then
				v34.onCancelled()
			end
		end
	end, {})

	local v74 = useSelector(function(p4) -- line: 333
		return p4.ScreenSize
	end)

	local function handlePhoneErrors(n1: number?) -- line: 342
		-- upvalues: v72 (copy)
		if n1 == 2 then
			return v72.invalidPhoneFormatKey
		end

		if n1 == 6 then
			return v72.tooManyAttemptsKey
		end

		if n1 == 7 then
			return v72.invalidVerificationCodeKey
		end

		if n1 == 8 then
			return v72.invalidPhoneNumberKey
		end

		if n1 == 9 then
			return v72.tooManyAccountsKey
		end

		return v72.genericErrorKey
	end
	local function handleVerifyPhone() -- line: 419
		-- upvalues: v64 (copy), v37 (copy), v53 (copy), v36 (copy), VerifyPhoneCode (copy), v62 (copy), v38 (copy), v34 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v58 (copy), v72 (copy)
		v64(true)

		local v102 = v37
		local v103 = v53
		local v104 = v36(VerifyPhoneCode(v102, v103))

		if v104 then
			v104:andThen(function() -- line: 424
				-- upvalues: v62 (copy)
				v62(true)
			end):catch(function(t4: {[any]: any}) -- line: 427
				-- upvalues: v38 (copy), v34 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v58 (copy), v72 (copy), v64 (copy)
				if not t4 then
					v38.reportModalShownWithSectionAndError(v34.eventContext, EventStreamConstants.Field.ErrorMessage, v34.origin, PhoneVerificationUpsellState.VerifyPhone, "")
					v58(v72.genericErrorKey)
				else
					v38.reportModalShownWithSectionAndError(v34.eventContext, EventStreamConstants.Field.ErrorMessage, v34.origin, PhoneVerificationUpsellState.VerifyPhone, t4.ErrorCode)

					local v124 = v58
					local ErrorCode = t4.ErrorCode

					v124(if ErrorCode ~= 2 then if ErrorCode ~= 6 then if ErrorCode ~= 7 then if ErrorCode ~= 8 then if ErrorCode ~= 9 then v72.genericErrorKey else v72.tooManyAccountsKey else v72.invalidPhoneNumberKey else v72.invalidVerificationCodeKey else v72.tooManyAttemptsKey else v72.invalidPhoneFormatKey)
				end

				v64(false)
			end)
		end

		v38.reportInteractWithActionAndSection(v34.eventContext, "", "", v34.origin, EventStreamConstants.Button.AutoSubmit, PhoneVerificationUpsellState.VerifyPhone)
	end

	local v77 = debounce(function(p5) -- line: 579
		-- upvalues: v54 (copy)
		v54(p5)
	end, 0.5)

	React.useEffect(function() -- line: 610
		-- upvalues: v53 (copy), handleVerifyPhone (copy)
		if string.len(v53) == 6 then
			handleVerifyPhone()
		end
	end, { v53 })
	React.useEffect(function() -- line: 617
		-- upvalues: v61 (copy), v36 (copy), SetIsPhoneVerified (copy), v38 (copy), v34 (copy), PhoneVerificationUpsellState (copy)
		if v61 then
			local t5 = {
				isPhoneVerified = true
			}

			v36(SetIsPhoneVerified(t5))
			v38.reportModalShownWithSection(v34.eventContext, v34.origin, PhoneVerificationUpsellState.Success)
			v34.onSuccess()
		end
	end, { v61 })

	return {
		phoneUpsellState = v43,
		screenSize = if not GetFFlagPhoneUseParentSizeForScreenSize() then v74 else v69,
		setParentSize = v70,
		handleCloseClick = function() -- line: 337
			-- upvalues: v38 (copy), v34 (copy), v43 (copy)
			v38.reportModalDismissedWithSection(v34.eventContext, v34.origin, v43)
			v34.closeUpsell()
		end,
		proceedToAddPhone = function() -- line: 508
			-- upvalues: v44 (copy), PhoneVerificationUpsellState (copy), v38 (copy), v34 (copy), EventStreamConstants (copy)
			v44(PhoneVerificationUpsellState.AddPhone)
			v38.reportInteractWithActionAndSection(v34.eventContext, "", "", v34.origin, EventStreamConstants.Button.Continue, PhoneVerificationUpsellState.Entry)
		end,
		countryCode = v47,
		setCountryCode = v48,
		phoneNumber = v45,
		addPhoneErrorMessage = v55,
		isDisabled = v63,
		onPhoneNumberTextChange = function(p6) -- line: 547
			-- upvalues: v63 (copy), v56 (copy), v46 (copy)
			if not v63 then
				v56("")
				v46(p6.Text)
			end
		end,
		handleSetPhone = function() -- line: 358
			-- upvalues: v64 (copy), v37 (copy), v47 (copy), v45 (copy), v36 (copy), SetPhoneNumber (copy), v44 (copy), PhoneVerificationUpsellState (copy), v38 (copy), v34 (copy), v40 (copy), IdentityProtocol (copy), v43 (copy), v52 (copy), v54 (copy), EventStreamConstants (copy), v56 (copy), v72 (copy)
			v64(true)

			local v97 = v37
			local code = v47.code
			local prefix = v47.prefix
			local v100 = v45
			local v101 = v36(SetPhoneNumber(v97, code, prefix, v100, nil))

			if v101 then
				v101:andThen(function() -- line: 363
					-- upvalues: v44 (copy), PhoneVerificationUpsellState (copy), v64 (copy), v38 (copy), v34 (copy), v40 (copy), IdentityProtocol (copy), v43 (copy), v52 (copy), v54 (copy)
					v44(PhoneVerificationUpsellState.VerifyPhone)
					v64(false)
					v38.reportModalShownWithSection(v34.eventContext, v34.origin, PhoneVerificationUpsellState.VerifyPhone)

					if v40 then
						local default = IdentityProtocol.default

						default:supportsGetSMSOTP():andThen(function(b2: boolean?) -- line: 269
							-- upvalues: v38 (copy), v34 (copy), v43 (copy), default (copy), v52 (copy), v54 (copy)
							print("PhoneVerification: Autofill OTP supported: {}!", b2)

							if b2 then
								v38.reportModalActionWithSection(v34.eventContext, "codeAutofillEligible", "autofill", v34.origin, v43)

								local v139 = default:getSMSOTP()

								if v139 then
									v139:andThen(function(s2: string?) -- line: 281
										-- upvalues: v52 (copy), v54 (copy), v38 (copy), v34 (copy), v43 (copy)
										if s2 and s2 ~= "" then
											v52(s2)
											v54(s2)
											v38.reportModalActionWithSection(v34.eventContext, "codeAutofillSuccess", "autofill", v34.origin, v43)
										end
									end)
								end
							end
						end)
					end
				end):catch(function(t6: {[any]: any}) -- line: 377
					-- upvalues: v38 (copy), v34 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v56 (copy), v72 (copy), v64 (copy)
					if not t6 then
						v38.reportModalShownWithSectionAndError(v34.eventContext, EventStreamConstants.Field.ErrorMessage, v34.origin, PhoneVerificationUpsellState.AddPhone, "")
						v56(v72.genericErrorKey)
					elseif t6.PhoneRegexFailed then
						v38.reportModalShownWithSectionAndError(v34.eventContext, EventStreamConstants.Field.ErrorMessage, v34.origin, PhoneVerificationUpsellState.AddPhone, "")
						v56(v72.invalidPhoneFormatKey)
					else
						v38.reportModalShownWithSectionAndError(v34.eventContext, EventStreamConstants.Field.ErrorMessage, v34.origin, PhoneVerificationUpsellState.AddPhone, t6.ErrorCode)

						local v121 = v56
						local ErrorCode = t6.ErrorCode

						v121(if ErrorCode ~= 2 then if ErrorCode ~= 6 then if ErrorCode ~= 7 then if ErrorCode ~= 8 then if ErrorCode ~= 9 then v72.genericErrorKey else v72.tooManyAccountsKey else v72.invalidPhoneNumberKey else v72.invalidVerificationCodeKey else v72.tooManyAttemptsKey else v72.invalidPhoneFormatKey)
					end

					v64(false)
				end)
			end

			v38.reportInteractWithActionAndSection(v34.eventContext, "", "", v34.origin, EventStreamConstants.Button.Continue, PhoneVerificationUpsellState.AddPhone)
		end,
		navigateToSMSTerms = function() -- line: 520
			-- upvalues: v63 (copy), v38 (copy), v34 (copy), EventStreamConstants (copy), v43 (copy), Constants (copy)
			if not v63 then
				v38.reportModalActionWithSection(v34.eventContext, EventStreamConstants.Field.TermsOfService, "", v34.origin, v43)
				v34.showWebpage(Constants.TERMS_OF_SERVICE_URL)
			end
		end,
		navigateToPrivacy = function() -- line: 533
			-- upvalues: v63 (copy), v38 (copy), v34 (copy), EventStreamConstants (copy), v43 (copy), Constants (copy)
			if not v63 then
				v38.reportModalActionWithSection(v34.eventContext, EventStreamConstants.Field.PrivacyPolicy, "", v34.origin, v43)
				v34.showWebpage(Constants.PRIVACY_POLICY_URL)
			end
		end,
		onPhoneInputFocus = function() -- line: 565
			-- upvalues: v38 (copy), v34 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), IdentityProtocol (copy), v43 (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v47 (copy), t1 (copy), v46 (copy)
			v38.reportInteractWithActionAndSection(v34.eventContext, EventStreamConstants.Field.PhoneNumber, EventStreamConstants.ActionType.Focus, v34.origin, "", PhoneVerificationUpsellState.AddPhone)

			if not v34.shouldAutofillAndroidPhoneNumberAtLaunch then
				local default = IdentityProtocol.default

				default:supportsGetPhoneNumber():andThen(function(b3: boolean?) -- line: 215
					-- upvalues: v38 (copy), v34 (copy), v43 (copy), default (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v47 (copy), t1 (copy), v46 (copy)
					print("PhoneVerification: Autofill phone number supported: {}!", b3)

					if not b3 then
						return
					end

					v38.reportModalActionWithSection(v34.eventContext, "phoneAutofillEligible", "autofill", v34.origin, v43)

					local v130 = default:getPhoneNumber()

					if not v130 then
						return
					end

					v130:andThen(function(s3: string?) -- line: 231
						-- upvalues: GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v47 (copy), t1 (copy), v38 (copy), v34 (copy), v43 (copy), v46 (copy)
						if s3 and s3 ~= "" then
							local v141, v142 = GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix(s3, v47.prefix)

							if v141 == t1.prefix then
								v38.reportModalActionWithSection(v34.eventContext, "phoneAutofillUSFound", "autofill", v34.origin, v43)
							end

							v46(v142)
							v38.reportModalActionWithSection(v34.eventContext, "phoneAutofillSuccess", "autofill", v34.origin, v43)

							return
						end

						v38.reportModalActionWithSection(v34.eventContext, "phoneAutofillNull", "autofill", v34.origin, v43)
					end)
				end)
			end
		end,
		onCountryCodeSelectorClick = function() -- line: 554
			-- upvalues: v38 (copy), v34 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy)
			v38.reportInteractWithActionAndSection(v34.eventContext, EventStreamConstants.Field.CountryPrefix, EventStreamConstants.ActionType.Focus, v34.origin, "", PhoneVerificationUpsellState.AddPhone)
		end,
		isKeyboardShowing = v65,
		onScreenKeyboardHeight = v67,
		code = v51,
		verifyPhoneErrorMessage = v57,
		onCodeTextChange = function(p7) -- line: 583
			-- upvalues: FFlagPhoneUpsellEnforceCodeInputLimit (copy), v51 (copy), v58 (copy), v52 (copy), v77 (copy)
			local v111 = string.sub(p7.Text, 1, 6)

			if FFlagPhoneUpsellEnforceCodeInputLimit then
				if v111 ~= v51 then
					v58("")
				end
			elseif string.len(p7.Text) <= 6 then
				v58("")
			end

			v52(v111)
			v77(v111)
		end,
		handleResendCode = function() -- line: 460
			-- upvalues: v58 (copy), v37 (copy), v36 (copy), ResendPhoneCode (copy), v38 (copy), v34 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v72 (copy)
			v58("")

			local v105 = v37
			local v106 = v36(ResendPhoneCode(v105))

			if v106 then
				v106:andThen(function() -- line: 464
				end):catch(function(t7: {[any]: any}) -- line: 464
					-- upvalues: v38 (copy), v34 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v58 (copy), v72 (copy)
					if not t7 then
						v38.reportModalShownWithSectionAndError(v34.eventContext, EventStreamConstants.Field.ErrorMessage, v34.origin, PhoneVerificationUpsellState.VerifyPhone, "")
						v58(v72.genericErrorKey)

						return
					end

					v38.reportModalShownWithSectionAndError(v34.eventContext, EventStreamConstants.Field.ErrorMessage, v34.origin, PhoneVerificationUpsellState.VerifyPhone, t7.ErrorCode)

					local v127 = v58
					local ErrorCode = t7.ErrorCode

					v127(if ErrorCode ~= 2 then if ErrorCode ~= 6 then if ErrorCode ~= 7 then if ErrorCode ~= 8 then if ErrorCode ~= 9 then v72.genericErrorKey else v72.tooManyAccountsKey else v72.invalidPhoneNumberKey else v72.invalidVerificationCodeKey else v72.tooManyAttemptsKey else v72.invalidPhoneFormatKey)
				end)
			end

			v38.reportInteractWithActionAndSection(v34.eventContext, "", "", v34.origin, EventStreamConstants.Button.ResendCode, PhoneVerificationUpsellState.VerifyPhone)
		end,
		returnToAddPhone = function() -- line: 496
			-- upvalues: v44 (copy), PhoneVerificationUpsellState (copy), v38 (copy), v34 (copy), EventStreamConstants (copy)
			v44(PhoneVerificationUpsellState.AddPhone)
			v38.reportInteractWithActionAndSection(v34.eventContext, "", "", v34.origin, EventStreamConstants.Button.ChangePhoneNumber, PhoneVerificationUpsellState.VerifyPhone)
		end,
		onCodeInputFocus = function() -- line: 598
			-- upvalues: v38 (copy), v34 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy)
			v38.reportInteractWithActionAndSection(v34.eventContext, EventStreamConstants.Field.VerificationCode, EventStreamConstants.ActionType.Focus, v34.origin, "", PhoneVerificationUpsellState.VerifyPhone)
		end,
		isLoading = v59,
		verifyingKey = v72.verifyingKey,
		isOTPInputTypeEnabled = v41,
		isPhoneNumberTextTypeEnabled = v42
	}
end

return usePhoneVerificationUpsellProps
