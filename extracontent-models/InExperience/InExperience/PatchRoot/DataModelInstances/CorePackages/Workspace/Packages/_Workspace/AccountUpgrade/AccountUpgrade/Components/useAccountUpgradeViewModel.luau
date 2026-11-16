local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local LocalizationService = game:GetService("LocalizationService")

local Promise = require(parent.Promise)
local React = require(parent.React)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local AuthCommon = require(parent.AuthCommon)
local AuthAnalytics = require(parent.AuthAnalytics)
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authClientError = AuthAnalytics.Events.authClientError
local AuthSignup = require(parent.AuthSignup)
local UsernameSuggestor = AuthSignup.Thunks.UsernameSuggestor
local SharedFlags = require(parent.SharedFlags)
local FFlagAllowCurrentUsernameOnSignup = SharedFlags.FFlagAllowCurrentUsernameOnSignup
local GetFFlagEnableAuditForSinglePageSignUp = SharedFlags.GetFFlagEnableAuditForSinglePageSignUp
local Time = require(parent.Time)
local DateHelper = Time.DateHelper
local FFlagEnableDesktopSsoSignupDialog = require(AccountUpgrade.Flags.FFlagEnableDesktopSsoSignupDialog)
local AccountUpgradeField = require(AccountUpgrade.AccountUpgradeField)
local AccountUpgradeFlow = require(AccountUpgrade.AccountUpgradeFlow)
local AccountUpgradeSurface = require(AccountUpgrade.AccountUpgradeSurface)
local AccountUpgradeAnalytics = require(AccountUpgrade.Analytics.AccountUpgradeAnalytics)
local FlowSpec = require(AccountUpgrade.FlowSpec)
local getFlowSpec = FlowSpec.getFlowSpec
local computeIsAccountUpgradeButtonEnabled = require(AccountUpgrade.Utils.computeIsAccountUpgradeButtonEnabled)
local getAccountUpgradeErrorCode = require(AccountUpgrade.Utils.getAccountUpgradeErrorCode)
local getAccountUpgradeErrorTextKey = require(AccountUpgrade.Utils.getAccountUpgradeErrorTextKey)
local resolveFieldStates = require(AccountUpgrade.Utils.resolveFieldStates)

local useMarketingConsent = require(AccountUpgrade.Hooks.useMarketingConsent)
local useTextFieldValue = require(AccountUpgrade.Hooks.useTextFieldValue)
local FFlagAccountUpgradeOAuthTelemetry = require(AccountUpgrade.Flags.FFlagAccountUpgradeOAuthTelemetry)
local FFlagAccountUpgradeOAuthDialogFitsContent = require(AccountUpgrade.Flags.FFlagAccountUpgradeOAuthDialogFitsContent)
local FFlagAccountUpgradeMarketingConsent = require(AccountUpgrade.Flags.FFlagAccountUpgradeMarketingConsent)
require(script.Parent.AccountUpgradeView)
require(script.Parent.AccountUpgradeFields)

local InputValidity = AuthCommon.Enums.InputValidity
local UserGender = AuthCommon.Enums.UserGender
local UsernameValidationContext = AuthCommon.Enums.UsernameValidationContext
local isStringEmail = AuthCommon.Utils.isStringEmail
local AccountUpgradeRequest = AuthCommon.Http.Requests.AccountUpgradeRequest

local v = {
	startTermsTag = "<a href=\"terms\">",
	endTermsTag = "</a>",
	startPrivacyTag = "<a href=\"privacy\">",
	endPrivacyTag = "</a>"
}

local function noop() end

local v2 = {
	text = nil,
	isChecked = false,
	isDisabled = false,
	onToggled = noop,
	submit = noop
}

local function hasField(flowSpec, p): boolean -- 4 equivalent calls inferred from this helper
	return table.find(flowSpec.requiredFields, p) ~= nil or table.find(flowSpec.optionalFields, p) ~= nil
end

local v3 = {
	[AccountUpgradeField.Birthday] = "Authentication.SignUp.Response.BirthdayMustBeSetFirst",
	[AccountUpgradeField.Username] = "Authentication.SignUp.Response.UsernameMustBeSetFirst"
}

local function getSummaryErrorTextKey(fieldState, p: string) -- 2 equivalent calls inferred from this helper
	local blockingField = fieldState.blockingField

	if blockingField == nil then
		return p
	end

	return assert(v3[blockingField], `Account upgrade field has no blocker error key: {blockingField}`)
end

local function resolveLegalText(flowSpec, data)
	local v4

	if data.flow == AccountUpgradeFlow.OAuth then
		v4 = FFlagAccountUpgradeOAuthDialogFitsContent
	else
		v4 = FFlagEnableDesktopSsoSignupDialog
	end

	if not v4 or data.hidesLegalText == true then
		return {}
	end

	local linkedPlatformAccountName

	if flowSpec.linkedAccountLegalTextKey then
		linkedPlatformAccountName = data.linkedPlatformAccountName
	end

	if linkedPlatformAccountName then
		return {
			activeKey = flowSpec.linkedAccountLegalTextKey,
			linkedPlatformAccountName = linkedPlatformAccountName
		}
	end

	local clone

	if flowSpec.legalTextKey then
		clone = table.clone(v)
		clone[1] = flowSpec.legalTextKey
	end

	return { activeKey = flowSpec.legalTextKey, standardKey = clone }
end

local function reportEmail() end

local function useAccountUpgradeViewModel(data)
	local flow = data.flow or AccountUpgradeFlow.Pioneer
	local flowSpec = getFlowSpec(flow)
	assert(flowSpec ~= nil, `Unsupported account upgrade flow: {flow}`)
	local surface = data.surface or AccountUpgradeSurface.Dialog
	local v4

	if FFlagAccountUpgradeOAuthTelemetry then
		v4 = AccountUpgradeAnalytics.getEventOrigin(flow, surface)
	else
		v4 = flow
	end

	local v5 = useRoactService(RoactNetworking)
	local submit

	if FFlagEnableDesktopSsoSignupDialog then
		submit = data.submit
	else
		submit = nil
	end

	local v6 = FFlagEnableDesktopSsoSignupDialog and flowSpec.hostReportsSubmit == true
	local currentUsername

	if FFlagAllowCurrentUsernameOnSignup then
		currentUsername = data.currentUsername
	else
		currentUsername = nil
	end

	local state, setState = React.useState(nil)
	local useState = React.useState
	local v7

	if currentUsername == nil or currentUsername == "" then
		v7 = InputValidity.Unvalidated
	else
		v7 = InputValidity.Valid
	end

	local state2, setState2 = useState(v7)

	local state3, setState3 = React.useState(InputValidity.Unvalidated)
	local state4, setState4 = React.useState(UserGender.Unknown)
	local state5, setState5 = React.useState(false)
	local state6, setState6 = React.useState(false)
	local state7, setState7 = React.useState(false)
	local state8, setState8 = React.useState(true)
	local state9, setState9 = React.useState({})
	local state10, setState10 = React.useState(false)

	local state11, setState11 = React.useState(nil)

	local ref = React.useRef(false)

	React.useEffect(function()
		if FFlagAccountUpgradeOAuthTelemetry then
			AccountUpgradeAnalytics.reportOpened(flow, surface)
		end
	end, { flow, surface })

	local v8 = React.useCallback(function()
		setState2(InputValidity.Unvalidated)
		setState9({})
	end, {})

	local v9 = React.useCallback(function()
		setState3(InputValidity.Unvalidated)
	end, {})

	local v10 = useTextFieldValue(currentUsername, v8)

	local ref2 = React.useRef(currentUsername)
	local v11 = useTextFieldValue(nil, v9)
	local v12 = useTextFieldValue(nil, reportEmail)

	local v13 = FFlagEnableDesktopSsoSignupDialog and data.isHidden == true
	local onChanged = v11.onChanged
	local valueRef = v10.valueRef

	if FFlagEnableDesktopSsoSignupDialog then
		React.useEffect(function()
			if v13 then
				ref2.current = valueRef.current
				onChanged("")
			end
		end, { v13, onChanged, valueRef })
	end

	local username2 = v10.value
	local password2 = v11.value
	local email = v12.value
	local emailValid = email == "" or isStringEmail(email)
	local emailError = email ~= "" and not emailValid and "Authentication.SignUp.Response.InvalidEmail" or nil
	local monthsLocalizationKeys = DateHelper.MonthsLocalizationKeys
	local monthText

	if state then
		monthText = monthsLocalizationKeys[state.Month]
	end

	local errorTextKey

	if not (state11 == nil or state11.isHandled) then
		local v14

		if not submit then
			v14 = state11.errorCode
		end

		errorTextKey = state11.errorTextKey or getAccountUpgradeErrorTextKey(v14)
	end

	local onLegalLinkSelected = data.onLegalLinkSelected
	local onLegalLinkActivated

	if
		FFlagEnableDesktopSsoSignupDialog
		or FFlagAccountUpgradeOAuthTelemetry
		or FFlagAccountUpgradeOAuthDialogFitsContent
	then
		onLegalLinkActivated = React.useCallback(function(p: string)
			if p == "terms" then
				if FFlagAccountUpgradeOAuthTelemetry then
					AccountUpgradeAnalytics.reportLegalLinkActivated(flow, surface, "terms")
				end

				if onLegalLinkSelected then
					onLegalLinkSelected("terms")
				end
			elseif p == "privacy" then
				if FFlagAccountUpgradeOAuthTelemetry then
					AccountUpgradeAnalytics.reportLegalLinkActivated(flow, surface, "privacy")
				end

				if onLegalLinkSelected then
					onLegalLinkSelected("privacy")
				end
			end
		end, { flow, surface, onLegalLinkSelected })
	end

	local v14 = FFlagEnableDesktopSsoSignupDialog

	if v14 then
		if flowSpec.capturesAuditContent == true then
			v14 = GetFFlagEnableAuditForSinglePageSignUp()
		else
			v14 = false
		end
	end

	local legalText = resolveLegalText(flowSpec, data)
	local activeKey = legalText.activeKey
	local linkedPlatformAccountName = legalText.linkedPlatformAccountName

	local v15 = {
		titleText = flowSpec.titleTextKey,
		subtitleText = flowSpec.subtitleTextKey,
		legalText = legalText.standardKey,
		legalTextTemplate = 0,
		usernameTitle = 0,
		passwordTitle = 0,
		birthdayLabel = "Authentication.SignUp.Label.Birthday",
		birthdayPlaceholder = "Authentication.SignUp.Description.BirthdayHint",
		usernamePlaceholder = "Authentication.SignUp.Message.Username.NoRealNameUse",
		usernameSuggestionPrompt = "Authentication.SignUp.Description.Try",
		passwordPlaceholder = "Authentication.SignUp.Label.PasswordPlaceholder",
		emailLabel = "Authentication.Login.Label.Email",
		emailPlaceholder = "Authentication.SignUp.Label.EnterYourEmail",
		genderLabel = "Authentication.SignUp.Label.Gender",
		femaleText = "Authentication.SignUp.Label.GenderFemale",
		maleText = "Authentication.SignUp.Label.GenderMale",
		saveText = 0,
		emailError = 0,
		submitError = 0,
		monthText = 0,
		dayAffix = 0,
		yearAffix = 0
	}
	local legalTextTemplate2

	if v14 then
		legalTextTemplate2 = activeKey
	end

	v15.legalTextTemplate = legalTextTemplate2
	v15.usernameTitle = v14 and "Authentication.Login.Label.Username" or nil
	v15.passwordTitle = v14 and "CommonUI.Messages.Label.Password" or nil

	v15.saveText = flowSpec.submitTextKey
	v15.emailError = emailError
	v15.submitError = errorTextKey
	v15.monthText = monthText
	v15.dayAffix = DateHelper.DayAffixLocalizationKey
	v15.yearAffix = DateHelper.YearAffixLocalizationKey
	local v16 = useLocalization(v15)
	local legalText2

	if FFlagEnableDesktopSsoSignupDialog then
		legalText2 = useLocalization({
			legalText = linkedPlatformAccountName and {
				flowSpec.linkedAccountLegalTextKey,
				platform = linkedPlatformAccountName,
				ctaButton = v16.saveText
			} or nil
		}).legalText
	end

	local auditContent

	if FFlagEnableDesktopSsoSignupDialog then
		auditContent = React.useMemo(function()
			if not v14 then
				return nil
			end

			local translationEntries = {}
			local function add(activeKey2: string, translatedSourceString: string?, parameters) -- 6 equivalent calls inferred from this helper
				if translatedSourceString ~= nil then
					table.insert(translationEntries, {
						translationKey = activeKey2,
						translatedSourceString = translatedSourceString,
						parameters = parameters
					})
				end
			end

			if hasField(flowSpec, AccountUpgradeField.Birthday) then -- inferred equivalent call
				add("Authentication.SignUp.Label.Birthday", v16.birthdayLabel) -- inferred equivalent call
			end

			add("Authentication.Login.Label.Username", v16.usernameTitle) -- inferred equivalent call

			if hasField(flowSpec, AccountUpgradeField.Password) then -- inferred equivalent call
				add("CommonUI.Messages.Label.Password", v16.passwordTitle) -- inferred equivalent call
			end

			if hasField(flowSpec, AccountUpgradeField.Email) then -- inferred equivalent call
				add("Authentication.Login.Label.Email", v16.emailLabel) -- inferred equivalent call
			end

			if hasField(flowSpec, AccountUpgradeField.Gender) then -- inferred equivalent call
				add("Authentication.SignUp.Label.Gender", v16.genderLabel) -- inferred equivalent call
			end

			if not activeKey then
				return translationEntries
			end

			local legalTextTemplate = v16.legalTextTemplate
			local v17

			if linkedPlatformAccountName then
				v17 = { platform = linkedPlatformAccountName, ctaButton = v16.saveText }
			else
				v17 = v
			end

			add(activeKey, legalTextTemplate, v17) -- inferred equivalent call
			return translationEntries
		end, {
			v14,
			flowSpec,
			activeKey,
			linkedPlatformAccountName,
			v16.saveText,
			v16.birthdayLabel,
			v16.usernameTitle,
			v16.passwordTitle,
			v16.emailLabel,
			v16.genderLabel,
			v16.legalTextTemplate
		})
	end

	local birthdayText = (state == nil or v16.monthText == nil) and ""
		or DateHelper:GetFormattedFullString(
			v16.monthText,
			state.Day,
			v16.dayAffix,
			state.Year,
			v16.yearAffix,
			" ",
			LocalizationService.RobloxLocaleId
		)

	local v17 = { spec = flowSpec, isSatisfied = 0 }

	local isSatisfied = {
		[AccountUpgradeField.Birthday] = state ~= nil
	}
	local username = AccountUpgradeField.Username
	isSatisfied[username] = username2 ~= "" and state2 ~= InputValidity.Invalid
	local password = AccountUpgradeField.Password
	isSatisfied[password] = password2 ~= "" and state3 == InputValidity.Valid
	v17.isSatisfied = isSatisfied
	local fieldStates = resolveFieldStates(v17)

	local fieldState = fieldStates[AccountUpgradeField.Username]
	local fieldState2 = fieldStates[AccountUpgradeField.Password]
	assert(fieldState ~= nil, "Account upgrade flow must include a username state")

	local usernameValidatorAdditionalProps = React.useMemo(function()
		return {
			birthday = not state and "" or state:FormatForEndpoint(),
			context = UsernameValidationContext.Signup,
			currentUsername = currentUsername
		}
	end, { state, currentUsername })

	local passwordValidatorAdditionalProps = React.useMemo(function()
		return { username = username2 }
	end, { username2 })

	local onUsernameValidated = React.useCallback(function(p: string, p2)
		setState2(p2)

		if state == nil or p == "" then
			return
		end

		UsernameSuggestor.suggestUsernames(v5, p, state:FormatForEndpoint(), UsernameValidationContext.Signup):andThen(function(p3)
			if v10.valueRef.current == p and p3.shouldUpdateState then
				setState9(p3.suggestions or {})
			end
		end)
	end, { v5, state, v10.valueRef })

	local onPasswordValidated = React.useCallback(function(_: string, p)
		setState3(p)
	end, {})
	local onFieldInteraction

	if FFlagEnableDesktopSsoSignupDialog then
		onFieldInteraction = data.onFieldInteraction
	else
		onFieldInteraction = nil
	end

	local onBirthdayActivated = React.useCallback(function()
		if FFlagAccountUpgradeOAuthTelemetry then
			AccountUpgradeAnalytics.reportBirthdayActivated(flow, surface)
		end

		if onFieldInteraction then
			onFieldInteraction("BirthdayFocused")
		end

		setState5(true)
	end, { flow, surface, onFieldInteraction })

	local onBirthdayPickerClosed = React.useCallback(function()
		if FFlagAccountUpgradeOAuthTelemetry then
			AccountUpgradeAnalytics.reportBirthdayPickerClosed(flow, surface)
		end

		setState5(false)
	end, { flow, surface })
	local onBirthdayPickerAllPicked

	if FFlagAccountUpgradeOAuthTelemetry then
		onBirthdayPickerAllPicked = React.useCallback(function()
			AccountUpgradeAnalytics.reportBirthdayPickerAllPicked(flow, surface)
		end, { flow, surface })
	end

	local onBirthdayConfirmed = React.useCallback(function(p)
		if FFlagAccountUpgradeOAuthTelemetry then
			AccountUpgradeAnalytics.reportBirthdayConfirmed(flow, surface)
		end

		if onFieldInteraction then
			onFieldInteraction("BirthdayConfirmed")
		end

		setState(p)
		setState5(false)
	end, { flow, surface, onFieldInteraction })
	local onUsernameFocused

	if FFlagEnableDesktopSsoSignupDialog or FFlagAccountUpgradeOAuthTelemetry then
		onUsernameFocused = React.useCallback(function()
			if FFlagAccountUpgradeOAuthTelemetry then
				AccountUpgradeAnalytics.reportUsernameFocused(flow, surface)
			end

			if onFieldInteraction then
				onFieldInteraction("UsernameFocused")
			end
		end, { flow, surface, onFieldInteraction })
	end

	local onPasswordFocused

	if FFlagEnableDesktopSsoSignupDialog then
		onPasswordFocused = React.useCallback(function()
			if onFieldInteraction then
				onFieldInteraction("PasswordFocused")
			end
		end, { onFieldInteraction })
	end

	local v18

	if FFlagEnableDesktopSsoSignupDialog or FFlagAccountUpgradeOAuthTelemetry then
		v18 = React.useCallback(function(p: string)
			local v19

			if p == UserGender.Unknown then
				v19 = state4
			else
				v19 = p
			end

			if FFlagAccountUpgradeOAuthTelemetry then
				AccountUpgradeAnalytics.reportGenderActivated(flow, surface, v19)
			end

			if onFieldInteraction then
				onFieldInteraction(v19 == UserGender.Male and "GenderMaleActivated" or "GenderFemaleActivated")
			end

			setState4(p)
		end, { flow, surface, state4, onFieldInteraction })
	end

	local onClose = React.useCallback(function()
		if FFlagAccountUpgradeOAuthTelemetry then
			AccountUpgradeAnalytics.reportCloseButtonClicked(flow, surface)
		end

		setState6(true)
	end, { flow, surface })

	local onCloseConfirmationBack = React.useCallback(function()
		if FFlagAccountUpgradeOAuthTelemetry then
			AccountUpgradeAnalytics.reportCloseWarningBack(flow, surface)
		end

		setState6(false)
	end, { flow, surface })

	local onSignOut = data.onSignOut
	local onSignOut2 = React.useMemo(function()
		if onSignOut == nil then
			return nil
		end

		return function()
			if FFlagAccountUpgradeOAuthTelemetry then
				AccountUpgradeAnalytics.reportCloseWarningClose(flow, surface)
			end

			onSignOut()
		end
	end, { flow, surface, onSignOut })

	if flowSpec.canDismiss then
		if flowSpec.signsOutOnDismiss then
			if data.onSignOut == nil or state7 then
				onClose = nil
			end
		else
			onClose = data.onClose
		end
	else
		onClose = nil
	end

	local isSaveEnabled = computeIsAccountUpgradeButtonEnabled({
		birthday = state,
		username = username2,
		password = password2,
		usernameValid = state2,
		passwordValid = state3,
		email = email,
		emailValid = emailValid,
		isSubmitting = state7,
		requiredFields = flowSpec.requiredFields
	})

	local onPasswordVisibilityToggle = React.useCallback(function()
		if onFieldInteraction then
			onFieldInteraction(state8 and "PasswordShown" or "PasswordHidden")
		end

		setState8(function(p): boolean
			return not p
		end)
	end, { state8, onFieldInteraction })

	local onUsernameSuggestionSelected = React.useCallback(function(p: string)
		v10.onChanged(p)
		setState9({})

		if FFlagAccountUpgradeOAuthTelemetry and flow == AccountUpgradeFlow.OAuth then
			AccountUpgradeAnalytics.reportUsernameSuggestionSelected(flow, surface, p)
		else
			authButtonClick(
				EventStreamConstants.Context.SinglePageSignUpScreen,
				EventStreamConstants.Button.UsernameSuggestion,
				p
			)
		end
	end, { flow, surface, v10.onChanged })

	local updatePillClicked = React.useCallback(function()
		setState10(true)
	end, {})

	local resetPillClicked = React.useCallback(function()
		setState10(false)
	end, {})

	local usernameSuggestions = (state2 ~= InputValidity.Invalid or not (#state9 > 0)) and {} or state9

	local v19 = v2

	if FFlagAccountUpgradeMarketingConsent then
		v19 = useMarketingConsent({
			spec = flowSpec,
			flow = flow,
			surface = surface,
			birthday = state
		})
	end

	local onSaveActivated = React.useCallback(function()
		if state7 then
			return
		end

		if not v6 then
			local accountUpgrade = EventStreamConstants.Context.AccountUpgrade
			local save = EventStreamConstants.Button.Save
			local v20

			if FFlagAccountUpgradeOAuthTelemetry then
				v20 = flow
			end

			authButtonClick(accountUpgrade, save, v20, nil, nil, v4)
		end

		setState7(true)
		setState11(nil)

		local v20 = {
			username = username2,
			password = password2,
			birthday = not state and "" or state:FormatForEndpoint(),
			age = 0,
			email = 0,
			gender = 0
		}
		local age

		if state then
			age = state:GetAgeInYears()
		end

		v20.age = age
		v20.email = email
		v20.gender = state4
		local v21

		if submit then
			v21 = Promise.try(function()
				local v22 = submit(v20)

				if Promise.is(v22) then
					return v22
				end

				return Promise.reject({})
			end)
		else
			v21 = AccountUpgradeRequest(v5, {
				upgradeType = flowSpec.upgradeType,
				username = v20.username,
				password = v20.password,
				birthday = v20.birthday,
				email = v20.email,
				gender = v20.gender
			})
		end

		v21:andThen(function()
			if FFlagAccountUpgradeOAuthTelemetry and not v6 then
				AccountUpgradeAnalytics.reportSucceeded(flow, surface)
			end

			v19.submit()
			local onSignUpComplete = data.onSignUpComplete
			local username3

			if currentUsername ~= nil then
				username3 = username2
			end

			local displayName

			if not (currentUsername == nil or username2 == currentUsername) then
				displayName = username2
			end

			onSignUpComplete({ isSuccess = true, username = username3, displayName = displayName })
		end, function(p)
			local v22

			if submit == nil then
				v22 = { errorCode = getAccountUpgradeErrorCode(p) }
			else
				v22 = type(p) ~= "table" and {} or p
			end

			local errorCode = v22.errorCode
			setState7(false)
			setState11(v22)

			if data.onSignUpFailed then
				data.onSignUpFailed(errorCode)
			end

			if not v6 then
				local accountUpgrade = EventStreamConstants.Context.AccountUpgrade
				local v23

				if errorCode == nil then
					v23 = EventStreamConstants.State.Unknown
				else
					v23 = tostring(errorCode)
				end

				authClientError(accountUpgrade, v23, nil, v4)

				if FFlagAccountUpgradeOAuthTelemetry and not ref.current then
					ref.current = true
					AccountUpgradeAnalytics.reportFirstFailure(flow, surface, errorCode)
				end
			end
		end)
	end, {
		state,
		currentUsername,
		email,
		v4,
		flow,
		state4,
		state7,
		v19.submit,
		v5,
		password2,
		data.onSignUpComplete,
		data.onSignUpFailed,
		submit,
		v6,
		flowSpec,
		surface,
		username2
	})

	local v20 = {}
	v20.titleText = v16.titleText
	v20.subtitleText = v16.subtitleText
	v20.birthdayLabel = v16.birthdayLabel
	v20.birthday = state
	v20.birthdayText = birthdayText
	v20.birthdayPlaceholder = v16.birthdayPlaceholder
	v20.usernameTitleTextKey = "Authentication.Login.Label.Username"
	v20.usernameSummaryErrorTextKey = getSummaryErrorTextKey( -- inferred equivalent call
		fieldState,
		"Authentication.SignUp.Label.ErrorsWithUsername"
	)
	v20.isUsernamePrerequisiteMet = fieldState.isUnlocked
	v20.fieldStates = fieldStates
	v20.usernameValidatorAdditionalProps = usernameValidatorAdditionalProps
	v20.usernamePlaceholder = v16.usernamePlaceholder
	v20.username = username2
	v20.prefilledUsername = ref2.current
	v20.usernameSuggestions = usernameSuggestions
	v20.usernameSuggestionPrompt = `{v16.usernameSuggestionPrompt}:`
	local usernameSuggestionEventContext

	if FFlagAccountUpgradeOAuthTelemetry and flow == AccountUpgradeFlow.OAuth then
		usernameSuggestionEventContext = EventStreamConstants.Context.AccountUpgrade
	end

	v20.usernameSuggestionEventContext = usernameSuggestionEventContext

	v20.onUsernameSuggestionSelected = onUsernameSuggestionSelected
	v20.pillClicked = state10
	v20.updatePillClicked = updatePillClicked
	v20.resetPillClicked = resetPillClicked
	v20.onUsernameValidated = onUsernameValidated
	v20.passwordTitleTextKey = "CommonUI.Messages.Label.Password"
	local passwordSummaryErrorTextKey

	if fieldState2 then
		passwordSummaryErrorTextKey = getSummaryErrorTextKey( -- inferred equivalent call
			fieldState2,
			"Authentication.SignUp.Label.ErrorsWithPassword"
		)
	else
		passwordSummaryErrorTextKey = "Authentication.SignUp.Label.ErrorsWithPassword"
	end

	v20.passwordSummaryErrorTextKey = passwordSummaryErrorTextKey
	local isPasswordPrerequisiteMet

	if fieldState2 then
		isPasswordPrerequisiteMet = fieldState2.isUnlocked
	else
		isPasswordPrerequisiteMet = false
	end

	v20.isPasswordPrerequisiteMet = isPasswordPrerequisiteMet
	v20.passwordValidatorAdditionalProps = passwordValidatorAdditionalProps
	v20.passwordPlaceholder = v16.passwordPlaceholder
	v20.onPasswordValidated = onPasswordValidated
	v20.hidePassword = state8
	v20.emailLabel = v16.emailLabel
	v20.emailPlaceholder = v16.emailPlaceholder
	v20.email = email
	v20.emailError = v16.emailError
	v20.genderLabel = v16.genderLabel
	v20.femaleText = v16.femaleText
	v20.maleText = v16.maleText
	v20.gender = state4
	v20.saveText = v16.saveText
	v20.isSaveEnabled = isSaveEnabled
	v20.isSubmitting = state7
	v20.submitError = v16.submitError
	v20.legalText = legalText2 or v16.legalText
	v20.onLegalLinkActivated = onLegalLinkActivated
	v20.marketingConsentText = v19.text
	v20.isMarketingConsentChecked = v19.isChecked
	v20.isMarketingConsentDisabled = v19.isDisabled
	v20.onMarketingConsentToggled = v19.onToggled
	v20.boldFieldLabels = FFlagEnableDesktopSsoSignupDialog and flowSpec.boldFieldLabels == true
	v20.fitsDialogToContent = FFlagAccountUpgradeOAuthDialogFitsContent and flowSpec.fitsDialogToContent == true
	v20.auditContent = auditContent
	v20.isBirthdayPickerOpen = state5
	v20.hasBackdrop = data.hasBackdrop
	v20.onClose = onClose
	v20.confirmsClose = onClose ~= nil and flowSpec.signsOutOnDismiss
	v20.isCloseConfirmationOpen = state6
	v20.onCloseConfirmationBack = onCloseConfirmationBack
	v20.onSignOut = onSignOut2
	v20.onBirthdayActivated = onBirthdayActivated
	v20.onBirthdayConfirmed = onBirthdayConfirmed
	v20.onBirthdayPickerClosed = onBirthdayPickerClosed
	v20.onBirthdayPickerAllPicked = onBirthdayPickerAllPicked
	v20.onUsernameChanged = v10.onChanged
	v20.onPasswordChanged = v11.onChanged
	v20.onEmailChanged = v12.onChanged
	v20.onGenderChanged = v18 or setState4
	v20.onUsernameFocused = onUsernameFocused
	v20.onPasswordFocused = onPasswordFocused
	v20.onPasswordVisibilityToggle = onPasswordVisibilityToggle
	v20.onSaveActivated = onSaveActivated
	return v20
end

return useAccountUpgradeViewModel
