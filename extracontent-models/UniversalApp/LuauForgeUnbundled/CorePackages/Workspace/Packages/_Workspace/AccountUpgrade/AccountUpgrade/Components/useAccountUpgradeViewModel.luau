local LocalizationService = game:GetService("LocalizationService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Promise")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Localization").Hooks.useLocalization
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/RoactServiceTags").RoactNetworking
local AuthCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthCommon")
local AuthAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthAnalytics")
local eventStreamConstants = AuthAnalytics.EventStreamConstants
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authClientError = AuthAnalytics.Events.authClientError
local usernameSuggestor = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthSignup").Thunks.UsernameSuggestor
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/SharedFlags")
local fFlagAllowCurrentUsernameOnSignup = SharedFlags.FFlagAllowCurrentUsernameOnSignup
local getFFlagEnableAuditForSinglePageSignUp = SharedFlags.GetFFlagEnableAuditForSinglePageSignUp
local dateHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Time").DateHelper
local module6 = require("@luauforge/bundled/gwG")
local AccountUpgradeField = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeField")
local AccountUpgradeFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeFlow")
local AccountUpgradeSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeSurface")
local AccountUpgradeAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Analytics/AccountUpgradeAnalytics")
local getFlowSpec = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/FlowSpec").getFlowSpec
local computeIsAccountUpgradeButtonEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Utils/computeIsAccountUpgradeButtonEnabled")
local getAccountUpgradeErrorCode = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Utils/getAccountUpgradeErrorCode")
local getAccountUpgradeErrorTextKey = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Utils/getAccountUpgradeErrorTextKey")
local resolveFieldStates = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Utils/resolveFieldStates")

local useMarketingConsent = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Hooks/useMarketingConsent")
local useTextFieldValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Hooks/useTextFieldValue")
local FFlagAccountUpgradeOAuthTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FFlagAccountUpgradeOAuthTelemetry")
local FFlagAccountUpgradeOAuthDialogFitsContent = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FFlagAccountUpgradeOAuthDialogFitsContent")
local FFlagAccountUpgradeMarketingConsent = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FFlagAccountUpgradeMarketingConsent")
require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/AccountUpgradeView")
require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/AccountUpgradeFields")

local inputValidity = AuthCommon.Enums.InputValidity
local userGender = AuthCommon.Enums.UserGender
local usernameValidationContext = AuthCommon.Enums.UsernameValidationContext
local isStringEmail = AuthCommon.Utils.isStringEmail
local accountUpgradeRequest = AuthCommon.Http.Requests.AccountUpgradeRequest

local v5 = {
	startTermsTag = "<a href=\"terms\">",
	endTermsTag = "</a>",
	startPrivacyTag = "<a href=\"privacy\">",
	endPrivacyTag = "</a>"
}

local function noop() end

local v6 = {
	text = nil,
	isChecked = false,
	isDisabled = false,
	onToggled = noop,
	submit = noop
}

local function hasField(p2, p3): boolean
	return table.find(p2.requiredFields, p3) ~= nil or table.find(p2.optionalFields, p3) ~= nil
end

local v7 = {
	[AccountUpgradeField.Birthday] = "Authentication.SignUp.Response.BirthdayMustBeSetFirst",
	[AccountUpgradeField.Username] = "Authentication.SignUp.Response.UsernameMustBeSetFirst"
}

local function getSummaryErrorTextKey(p2, p3)
	local blockingField = p2.blockingField

	if blockingField == nil then
		return p3
	end

	return assert(v7[blockingField], `Account upgrade field has no blocker error key: {blockingField}`)
end

local function resolveLegalText(flowSpec, data)
	local v8 = if data.flow == AccountUpgradeFlow.OAuth then FFlagAccountUpgradeOAuthDialogFitsContent else module6

	if not v8 or data.hidesLegalText == true then
		return {}
	end

	local linkedPlatformAccountName = if flowSpec.linkedAccountLegalTextKey then data.linkedPlatformAccountName else nil

	if linkedPlatformAccountName then
		return {
			activeKey = flowSpec.linkedAccountLegalTextKey,
			linkedPlatformAccountName = linkedPlatformAccountName
		}
	end

	local clone

	if flowSpec.legalTextKey then
		clone = table.clone(v5)
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

	local v8 = if FFlagAccountUpgradeOAuthTelemetry then AccountUpgradeAnalytics.getEventOrigin(flow, surface) else flow

	local v9 = useRoactService(roactNetworking)
	local submit = if module6 then data.submit else nil
	local v10 = module6 and flowSpec.hostReportsSubmit == true
	local currentUsername = if fFlagAllowCurrentUsernameOnSignup then data.currentUsername else nil

	local state, setState = React.useState(nil)
	local useState = React.useState
	local v11

	if currentUsername == nil or currentUsername == "" then
		v11 = inputValidity.Unvalidated
	else
		v11 = inputValidity.Valid
	end

	local state2, setState2 = useState(v11)

	local state3, setState3 = React.useState(inputValidity.Unvalidated)
	local state4, setState4 = React.useState(userGender.Unknown)
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

	local v12 = React.useCallback(function()
		setState2(inputValidity.Unvalidated)
		setState9({})
	end, {})

	local v13 = React.useCallback(function()
		setState3(inputValidity.Unvalidated)
	end, {})

	local v14 = useTextFieldValue(currentUsername, v12)

	local ref2 = React.useRef(currentUsername)
	local v15 = useTextFieldValue(nil, v13)
	local v16 = useTextFieldValue(nil, reportEmail)

	local v17 = module6 and data.isHidden == true
	local onChanged = v15.onChanged
	local valueRef = v14.valueRef

	if module6 then
		React.useEffect(function()
			if v17 then
				ref2.current = valueRef.current
				onChanged("")
			end
		end, { v17, onChanged, valueRef })
	end

	local value = v14.value
	local value2 = v15.value
	local value3 = v16.value
	local v18 = value3 == "" or isStringEmail(value3)
	local v19 = value3 ~= "" and not v18 and "Authentication.SignUp.Response.InvalidEmail" or nil
	local monthsLocalizationKeys = dateHelper.MonthsLocalizationKeys
	local v20 = if state then monthsLocalizationKeys[state.Month] else nil
	local errorTextKey

	if not (state11 == nil or state11.isHandled) then
		local v21 = if not submit then state11.errorCode else nil
		errorTextKey = state11.errorTextKey or getAccountUpgradeErrorTextKey(v21)
	end

	local onLegalLinkSelected = data.onLegalLinkSelected
	local v21

	if module6 or FFlagAccountUpgradeOAuthTelemetry or FFlagAccountUpgradeOAuthDialogFitsContent then
		v21 = React.useCallback(function(p2)
			if p2 == "terms" then
				if FFlagAccountUpgradeOAuthTelemetry then
					AccountUpgradeAnalytics.reportLegalLinkActivated(flow, surface, "terms")
				end

				if onLegalLinkSelected then
					onLegalLinkSelected("terms")
				end
			elseif p2 == "privacy" then
				if FFlagAccountUpgradeOAuthTelemetry then
					AccountUpgradeAnalytics.reportLegalLinkActivated(flow, surface, "privacy")
				end

				if onLegalLinkSelected then
					onLegalLinkSelected("privacy")
				end
			end
		end, { flow, surface, onLegalLinkSelected })
	end

	local v22 = module6

	if v22 then
		v22 = flowSpec.capturesAuditContent == true and getFFlagEnableAuditForSinglePageSignUp()
	end

	local legalText = resolveLegalText(flowSpec, data)
	local activeKey = legalText.activeKey
	local linkedPlatformAccountName = legalText.linkedPlatformAccountName

	local v26 = useLocalization({
		titleText = flowSpec.titleTextKey,
		subtitleText = flowSpec.subtitleTextKey,
		legalText = legalText.standardKey,
		legalTextTemplate = if v22 then activeKey else nil,
		usernameTitle = v22 and "Authentication.Login.Label.Username" or nil,
		passwordTitle = v22 and "CommonUI.Messages.Label.Password" or nil,
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
		saveText = flowSpec.submitTextKey,
		emailError = v19,
		submitError = errorTextKey,
		monthText = v20,
		dayAffix = dateHelper.DayAffixLocalizationKey,
		yearAffix = dateHelper.YearAffixLocalizationKey
	})
	local legalText2

	if module6 then
		legalText2 = useLocalization({
			legalText = linkedPlatformAccountName and {
				flowSpec.linkedAccountLegalTextKey,
				platform = linkedPlatformAccountName,
				ctaButton = v26.saveText
			} or nil
		}).legalText
	end

	local v27

	if module6 then
		v27 = React.useMemo(function()
			if not v22 then
				return nil
			end

			local translationEntries = {}
			local function add(p2, p3, p4)
				if p3 ~= nil then
					table.insert(translationEntries, {
						translationKey = p2,
						translatedSourceString = p3,
						parameters = p4
					})
				end
			end

			local v28 = flowSpec
			local birthday = AccountUpgradeField.Birthday

			if
				table.find(v28.requiredFields, birthday) ~= nil
				or table.find(v28.optionalFields, birthday) ~= nil
			then
				local birthdayLabel = v26.birthdayLabel

				if birthdayLabel ~= nil then
					table.insert(translationEntries, {
						translationKey = "Authentication.SignUp.Label.Birthday",
						translatedSourceString = birthdayLabel,
						parameters = nil
					})
				end
			end

			local usernameTitle = v26.usernameTitle

			if usernameTitle ~= nil then
				table.insert(translationEntries, {
					translationKey = "Authentication.Login.Label.Username",
					translatedSourceString = usernameTitle,
					parameters = nil
				})
			end

			local v29 = flowSpec
			local password = AccountUpgradeField.Password

			if
				table.find(v29.requiredFields, password) ~= nil
				or table.find(v29.optionalFields, password) ~= nil
			then
				local passwordTitle = v26.passwordTitle

				if passwordTitle ~= nil then
					table.insert(translationEntries, {
						translationKey = "CommonUI.Messages.Label.Password",
						translatedSourceString = passwordTitle,
						parameters = nil
					})
				end
			end

			local v30 = flowSpec
			local email = AccountUpgradeField.Email

			if
				table.find(v30.requiredFields, email) ~= nil
				or table.find(v30.optionalFields, email) ~= nil
			then
				local emailLabel = v26.emailLabel

				if emailLabel ~= nil then
					table.insert(translationEntries, {
						translationKey = "Authentication.Login.Label.Email",
						translatedSourceString = emailLabel,
						parameters = nil
					})
				end
			end

			local v31 = flowSpec
			local gender = AccountUpgradeField.Gender

			if
				table.find(v31.requiredFields, gender) ~= nil
				or table.find(v31.optionalFields, gender) ~= nil
			then
				local genderLabel = v26.genderLabel

				if genderLabel ~= nil then
					table.insert(translationEntries, {
						translationKey = "Authentication.SignUp.Label.Gender",
						translatedSourceString = genderLabel,
						parameters = nil
					})
				end
			end

			if not activeKey then
				return translationEntries
			end

			local v32 = activeKey
			local legalTextTemplate = v26.legalTextTemplate
			local v33

			if linkedPlatformAccountName then
				v33 = { platform = linkedPlatformAccountName, ctaButton = v26.saveText }
			else
				v33 = v5
			end

			if legalTextTemplate ~= nil then
				table.insert(translationEntries, {
					translationKey = v32,
					translatedSourceString = legalTextTemplate,
					parameters = v33
				})
			end

			return translationEntries
		end, {
			v22,
			flowSpec,
			activeKey,
			linkedPlatformAccountName,
			v26.saveText,
			v26.birthdayLabel,
			v26.usernameTitle,
			v26.passwordTitle,
			v26.emailLabel,
			v26.genderLabel,
			v26.legalTextTemplate
		})
	end

	local v28 = (state == nil or v26.monthText == nil) and ""
		or dateHelper:GetFormattedFullString(
			v26.monthText,
			state.Day,
			v26.dayAffix,
			state.Year,
			v26.yearAffix,
			" ",
			LocalizationService.RobloxLocaleId
		)

	local v30 = { spec = flowSpec, isSatisfied = 0 }

	local v31 = {
		[AccountUpgradeField.Birthday] = state ~= nil
	}
	local username = AccountUpgradeField.Username
	v31[username] = value ~= "" and state2 ~= inputValidity.Invalid
	local password = AccountUpgradeField.Password
	v31[password] = value2 ~= "" and state3 == inputValidity.Valid
	v30.isSatisfied = v31
	local v34 = resolveFieldStates(v30)

	local v35 = v34[AccountUpgradeField.Username]
	local v36 = v34[AccountUpgradeField.Password]
	assert(v35 ~= nil, "Account upgrade flow must include a username state")

	local v37 = React.useMemo(function()
		return {
			birthday = not state and "" or state:FormatForEndpoint(),
			context = usernameValidationContext.Signup,
			currentUsername = currentUsername
		}
	end, { state, currentUsername })

	local v38 = React.useMemo(function()
		return { username = value }
	end, { value })

	local v39 = React.useCallback(function(p2, p3)
		setState2(p3)

		if state == nil or p2 == "" then
			return
		end

		usernameSuggestor.suggestUsernames(
			v9,
			p2,
			state:FormatForEndpoint(),
			usernameValidationContext.Signup
		):andThen(function(p4)
			if v14.valueRef.current == p2 and p4.shouldUpdateState then
				setState9(p4.suggestions or {})
			end
		end)
	end, { v9, state, v14.valueRef })

	local v40 = React.useCallback(function(p2, p3)
		setState3(p3)
	end, {})

	local onFieldInteraction = if module6 then data.onFieldInteraction else nil

	local v41 = React.useCallback(function()
		if FFlagAccountUpgradeOAuthTelemetry then
			AccountUpgradeAnalytics.reportBirthdayActivated(flow, surface)
		end

		if onFieldInteraction then
			onFieldInteraction("BirthdayFocused")
		end

		setState5(true)
	end, { flow, surface, onFieldInteraction })

	local v42 = React.useCallback(function()
		if FFlagAccountUpgradeOAuthTelemetry then
			AccountUpgradeAnalytics.reportBirthdayPickerClosed(flow, surface)
		end

		setState5(false)
	end, { flow, surface })
	local v43

	if FFlagAccountUpgradeOAuthTelemetry then
		v43 = React.useCallback(function()
			AccountUpgradeAnalytics.reportBirthdayPickerAllPicked(flow, surface)
		end, { flow, surface })
	end

	local v44 = React.useCallback(function(p2)
		if FFlagAccountUpgradeOAuthTelemetry then
			AccountUpgradeAnalytics.reportBirthdayConfirmed(flow, surface)
		end

		if onFieldInteraction then
			onFieldInteraction("BirthdayConfirmed")
		end

		setState(p2)
		setState5(false)
	end, { flow, surface, onFieldInteraction })
	local v45

	if module6 or FFlagAccountUpgradeOAuthTelemetry then
		v45 = React.useCallback(function()
			if FFlagAccountUpgradeOAuthTelemetry then
				AccountUpgradeAnalytics.reportUsernameFocused(flow, surface)
			end

			if onFieldInteraction then
				onFieldInteraction("UsernameFocused")
			end
		end, { flow, surface, onFieldInteraction })
	end

	local v46

	if module6 then
		v46 = React.useCallback(function()
			if onFieldInteraction then
				onFieldInteraction("PasswordFocused")
			end
		end, { onFieldInteraction })
	end

	local v47

	if module6 or FFlagAccountUpgradeOAuthTelemetry then
		v47 = React.useCallback(function(p2)
			local v48 = if p2 == userGender.Unknown then state4 else p2

			if FFlagAccountUpgradeOAuthTelemetry then
				AccountUpgradeAnalytics.reportGenderActivated(flow, surface, v48)
			end

			if onFieldInteraction then
				onFieldInteraction(v48 == userGender.Male and "GenderMaleActivated" or "GenderFemaleActivated")
			end

			setState4(p2)
		end, { flow, surface, state4, onFieldInteraction })
	end

	local v48 = React.useCallback(function()
		if FFlagAccountUpgradeOAuthTelemetry then
			AccountUpgradeAnalytics.reportCloseButtonClicked(flow, surface)
		end

		setState6(true)
	end, { flow, surface })

	local v49 = React.useCallback(function()
		if FFlagAccountUpgradeOAuthTelemetry then
			AccountUpgradeAnalytics.reportCloseWarningBack(flow, surface)
		end

		setState6(false)
	end, { flow, surface })

	local onSignOut = data.onSignOut
	local v50 = React.useMemo(function()
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
				v48 = nil
			end
		else
			v48 = data.onClose
		end
	else
		v48 = nil
	end

	local v51 = computeIsAccountUpgradeButtonEnabled({
		birthday = state,
		username = value,
		password = value2,
		usernameValid = state2,
		passwordValid = state3,
		email = value3,
		emailValid = v18,
		isSubmitting = state7,
		requiredFields = flowSpec.requiredFields
	})

	local v52 = React.useCallback(function()
		if onFieldInteraction then
			onFieldInteraction(state8 and "PasswordShown" or "PasswordHidden")
		end

		setState8(function(p2): boolean
			return not p2
		end)
	end, { state8, onFieldInteraction })

	local v53 = React.useCallback(function(p2)
		v14.onChanged(p2)
		setState9({})

		if FFlagAccountUpgradeOAuthTelemetry and flow == AccountUpgradeFlow.OAuth then
			AccountUpgradeAnalytics.reportUsernameSuggestionSelected(flow, surface, p2)
		else
			authButtonClick(
				eventStreamConstants.Context.SinglePageSignUpScreen,
				eventStreamConstants.Button.UsernameSuggestion,
				p2
			)
		end
	end, { flow, surface, v14.onChanged })

	local v54 = React.useCallback(function()
		setState10(true)
	end, {})

	local v55 = React.useCallback(function()
		setState10(false)
	end, {})

	local v56 = (state2 ~= inputValidity.Invalid or not (#state9 > 0)) and {} or state9

	local v57 = v6

	if FFlagAccountUpgradeMarketingConsent then
		v57 = useMarketingConsent({
			spec = flowSpec,
			flow = flow,
			surface = surface,
			birthday = state
		})
	end

	local v58 = React.useCallback(function()
		if state7 then
			return
		end

		if not v10 then
			authButtonClick(
				eventStreamConstants.Context.AccountUpgrade,
				eventStreamConstants.Button.Save,
				if FFlagAccountUpgradeOAuthTelemetry then flow else nil,
				nil,
				nil,
				v8
			)
		end

		setState7(true)
		setState11(nil)

		local v59 = {
			username = value,
			password = value2,
			birthday = not state and "" or state:FormatForEndpoint(),
			age = 0,
			email = 0,
			gender = 0
		}
		local v60 = if state then state:GetAgeInYears() else nil
		v59.age = v60
		v59.email = value3
		v59.gender = state4
		local v61

		if submit then
			v61 = Promise.try(function()
				local v62 = submit(v59)

				if Promise.is(v62) then
					return v62
				end

				return Promise.reject({})
			end)
		else
			v61 = accountUpgradeRequest(v9, {
				upgradeType = flowSpec.upgradeType,
				username = v59.username,
				password = v59.password,
				birthday = v59.birthday,
				email = v59.email,
				gender = v59.gender
			})
		end

		v61:andThen(function()
			if FFlagAccountUpgradeOAuthTelemetry and not v10 then
				AccountUpgradeAnalytics.reportSucceeded(flow, surface)
			end

			v57.submit()
			local onSignUpComplete = data.onSignUpComplete
			local v63 = if currentUsername ~= nil then value else nil
			local v64 = if currentUsername ~= nil and value ~= currentUsername then value else nil
			onSignUpComplete({ isSuccess = true, username = v63, displayName = v64 })
		end, function(p2)
			local v62

			if submit == nil then
				v62 = { errorCode = getAccountUpgradeErrorCode(p2) }
			else
				v62 = type(p2) ~= "table" and {} or p2
			end

			local errorCode = v62.errorCode
			setState7(false)
			setState11(v62)

			if data.onSignUpFailed then
				data.onSignUpFailed(errorCode)
			end

			if not v10 then
				local accountUpgrade = eventStreamConstants.Context.AccountUpgrade
				local v64 = if errorCode == nil then eventStreamConstants.State.Unknown else tostring(errorCode)
				authClientError(accountUpgrade, v64, nil, v8)

				if FFlagAccountUpgradeOAuthTelemetry and not ref.current then
					ref.current = true
					AccountUpgradeAnalytics.reportFirstFailure(flow, surface, errorCode)
				end
			end
		end)
	end, {
		state,
		currentUsername,
		value3,
		v8,
		flow,
		state4,
		state7,
		v57.submit,
		v9,
		value2,
		data.onSignUpComplete,
		data.onSignUpFailed,
		submit,
		v10,
		flowSpec,
		surface,
		value
	})

	local v59 = {}
	v59.titleText = v26.titleText
	v59.subtitleText = v26.subtitleText
	v59.birthdayLabel = v26.birthdayLabel
	v59.birthday = state
	v59.birthdayText = v28
	v59.birthdayPlaceholder = v26.birthdayPlaceholder
	v59.usernameTitleTextKey = "Authentication.Login.Label.Username"
	local blockingField = v35.blockingField
	v59.usernameSummaryErrorTextKey = blockingField == nil
		and "Authentication.SignUp.Label.ErrorsWithUsername"
		or assert(v7[blockingField], `Account upgrade field has no blocker error key: {blockingField}`)
	v59.isUsernamePrerequisiteMet = v35.isUnlocked
	v59.fieldStates = v34
	v59.usernameValidatorAdditionalProps = v37
	v59.usernamePlaceholder = v26.usernamePlaceholder
	v59.username = value
	v59.prefilledUsername = ref2.current
	v59.usernameSuggestions = v56

	v59.usernameSuggestionPrompt = `{v26.usernameSuggestionPrompt}:`

	local v60 = if FFlagAccountUpgradeOAuthTelemetry and flow == AccountUpgradeFlow.OAuth then eventStreamConstants.Context.AccountUpgrade else nil
	v59.usernameSuggestionEventContext = v60

	v59.onUsernameSuggestionSelected = v53
	v59.pillClicked = state10
	v59.updatePillClicked = v54
	v59.resetPillClicked = v55
	v59.onUsernameValidated = v39
	v59.passwordTitleTextKey = "CommonUI.Messages.Label.Password"
	local v61

	if v36 then
		local blockingField2 = v36.blockingField
		v61 = blockingField2 == nil and "Authentication.SignUp.Label.ErrorsWithPassword"
			or assert(
				v7[blockingField2],
				`Account upgrade field has no blocker error key: {blockingField2}`
			)
	else
		v61 = "Authentication.SignUp.Label.ErrorsWithPassword"
	end

	v59.passwordSummaryErrorTextKey = v61

	local v62 = if v36 then v36.isUnlocked else false
	v59.isPasswordPrerequisiteMet = v62
	v59.passwordValidatorAdditionalProps = v38
	v59.passwordPlaceholder = v26.passwordPlaceholder
	v59.onPasswordValidated = v40
	v59.hidePassword = state8
	v59.emailLabel = v26.emailLabel
	v59.emailPlaceholder = v26.emailPlaceholder
	v59.email = value3
	v59.emailError = v26.emailError
	v59.genderLabel = v26.genderLabel
	v59.femaleText = v26.femaleText
	v59.maleText = v26.maleText
	v59.gender = state4
	v59.saveText = v26.saveText
	v59.isSaveEnabled = v51
	v59.isSubmitting = state7
	v59.submitError = v26.submitError
	v59.legalText = legalText2 or v26.legalText
	v59.onLegalLinkActivated = v21
	v59.marketingConsentText = v57.text
	v59.isMarketingConsentChecked = v57.isChecked
	v59.isMarketingConsentDisabled = v57.isDisabled
	v59.onMarketingConsentToggled = v57.onToggled
	v59.boldFieldLabels = module6 and flowSpec.boldFieldLabels == true
	v59.fitsDialogToContent = FFlagAccountUpgradeOAuthDialogFitsContent and flowSpec.fitsDialogToContent == true
	v59.auditContent = v27
	v59.isBirthdayPickerOpen = state5
	v59.hasBackdrop = data.hasBackdrop
	v59.onClose = v48
	v59.confirmsClose = v48 ~= nil and flowSpec.signsOutOnDismiss
	v59.isCloseConfirmationOpen = state6
	v59.onCloseConfirmationBack = v49
	v59.onSignOut = v50
	v59.onBirthdayActivated = v41
	v59.onBirthdayConfirmed = v44
	v59.onBirthdayPickerClosed = v42
	v59.onBirthdayPickerAllPicked = v43
	v59.onUsernameChanged = v14.onChanged
	v59.onPasswordChanged = v15.onChanged
	v59.onEmailChanged = v16.onChanged
	v59.onGenderChanged = v47 or setState4
	v59.onUsernameFocused = v45
	v59.onPasswordFocused = v46
	v59.onPasswordVisibilityToggle = v52
	v59.onSaveActivated = v58
	return v59
end

return useAccountUpgradeViewModel
