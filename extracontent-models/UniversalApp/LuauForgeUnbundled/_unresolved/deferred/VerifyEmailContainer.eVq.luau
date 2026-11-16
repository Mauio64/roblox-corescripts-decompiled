local linkingProtocol = require("@luauforge/deferred/eVr").LinkingProtocol
local module = require("@luauforge/deferred/egU")
local useLocalization = require("@luauforge/deferred/ehw").Hooks.useLocalization

local module2 = require("@luauforge/deferred/eVs")
local module3 = require("@luauforge/deferred/ehb")
local module4 = require("@luauforge/deferred/ehO")
local module5 = require("@luauforge/deferred/eUy")
local module6 = require("@luauforge/deferred/eVv")
local module7 = require("@luauforge/deferred/eVx")
local useSchoolVerificationFlow = require("@luauforge/deferred/ehT").useSchoolVerificationFlow
require("@luauforge/deferred/egX")
local module8 = require("@luauforge/deferred/egW")
local module9 = require("@luauforge/deferred/eUL")
local module10 = require("@luauforge/deferred/eUF")
local module11 = require("@luauforge/deferred/ehV")
local module12 = require("@luauforge/deferred/ehr")
local module13 = require("@luauforge/deferred/eVu")
local module14 = require("@luauforge/deferred/eVz")
local module15 = require("@luauforge/deferred/eVy")

local v5 = if module13 then require("@luauforge/deferred/eVA") else nil

local eventNames = module5.EventNames
local verifyErrorKind = module8.VerifyErrorKind

local defineFastString = game:DefineFastString(
	"SchoolsUnidaysTermsOfServiceUrl",
	"https://www.myunidays.com/roblox-tos"
)

local defineFastString2 = game:DefineFastString(
	"SchoolsUnidaysPrivacyPolicyUrl",
	"https://www.myunidays.com/roblox-pp"
)

local function VerifyEmailContainer(p2)
	local navigation = p2.navigation
	local v6 = useSchoolVerificationFlow()

	local v7 = module5.useSchoolsAnalytics()

	module.useEffect(function(): nil
		if module11 or not module10 then
			return nil
		end

		v7(eventNames.VerifyEmailPageLoad)
		return nil
	end, { v7 })

	local v9 = {
		errorInvalidEmail = module3.VerifyEmailErrorInvalidEmail,
		errorNotSchoolEmail = 0,
		errorAlreadyLinked = 0,
		errorGeneric = 0
	}

	local v10 = if module15 then module3.VerifyEmailErrorUnidaysEmailNotFound else module3.VerifyEmailErrorInvalidEmail
	v9.errorNotSchoolEmail = v10

	v9.errorAlreadyLinked = module3.VerifyEmailErrorAlreadyLinked
	v9.errorGeneric = module3.SomethingWentWrong
	local v11 = useLocalization(v9)

	local state, setState = module.useState("")
	local state2, setState2 = module.useState(false)
	local state3, setState3 = module.useState(function(): nil
		return nil
	end)

	local state4, setState4 = module.useState(function(): nil
		return nil
	end)
	local state5, setState5

	if module12 then
		state5, setState5 = module.useState(false)
	else
		setState5 = nil
		state5 = false
	end

	local v14 = if state4 then {
		module3.VerifyEmailSuggestedEmail,
		email = state4
	} else {
		module3.VerifyEmailSuggestedEmail,
		email = ""
	}
	local v15 = useLocalization({ suggestedEmail = v14 })

	local v16 = module.useCallback(function(p3)
		setState(p3)
		setState3(nil)
		setState4(nil)
		v6.clearSuggestedEmail()
	end, { v6 })

	local v17 = module.useCallback(function()
		navigation.pop()
	end, { navigation })

	local useCallback = module.useCallback
	local function fn(p3)
		local kind = if typeof(p3) == "table" then p3.kind else nil

		if kind == verifyErrorKind.NotSchoolEmail then
			if module15 then
				return v11.errorNotSchoolEmail
			end

			return v11.errorInvalidEmail
		elseif kind == verifyErrorKind.AlreadyLinked then
			return v11.errorAlreadyLinked
		else
			return v11.errorGeneric
		end
	end

	local errorInvalidEmail = v11.errorInvalidEmail
	local errorAlreadyLinked = v11.errorAlreadyLinked
	local errorGeneric = v11.errorGeneric
	local v19 = if module15 then v11.errorNotSchoolEmail else nil
	local v20 = useCallback(fn, {
		errorInvalidEmail,
		errorAlreadyLinked,
		errorGeneric,
		v19
	})

	local v21 = module.useCallback(function(list)
		if #list ~= 1 then
			navigation.navigate(module4.SchoolSelection)

			return
		end

		v6.setSelectedSchool(list[1])
		navigation.navigate(module4.GraduationYear)
	end, { v6, navigation })

	local v22 = module.useCallback(function()
		if state2 then
			return
		end

		if state4 then
			setState4(nil)
			v6.clearSuggestedEmail()
			v21(v6.getSchools())
		else
			if module11 then
				v6.beginSubmitAttempt()
			end

			local v23 = module6(state)

			if module10 then
				v7(eventNames.VerifyEmailContinueClick, { valid = v23 })
			end

			if not v23 then
				setState3(v11.errorInvalidEmail)
				return
			end

			setState3(nil)
			setState2(true)

			module7(state):andThen(function(p3)
				local schools = p3.schools
				local suggestedEmail = p3.suggestedEmail

				if not suggestedEmail or suggestedEmail == "" then
					suggestedEmail = nil
				end

				if module10 then
					v7(eventNames.VerifyEmailSubmitSuccess, {
						schoolMatchCount = #schools
					})
				end

				v6.setSubmitResult(state, schools, suggestedEmail)

				if not suggestedEmail then
					v21(schools)
					return
				end

				setState4(suggestedEmail)

				if module10 then
					local v24 = string.split(suggestedEmail, "@")[2]
					v7(eventNames.VerifyEmailSuggestedEmailShown, {
						suggestedDomain = v24
					})
				end
			end):catch(function(p3)
				local kind = if typeof(p3) == "table" then p3.kind else nil

				if module10 then
					v7(eventNames.VerifyEmailSubmitFailure, {
						errorKind = kind or verifyErrorKind.Unknown
					})
				end

				if not module12 or kind ~= verifyErrorKind.SchoolNotAvailable then
					setState3(v20(p3))
					return
				end

				if module10 then
					v7(eventNames.VerifyEmailSchoolUnavailableImpression)
				end

				if setState5 then
					setState5(true)
				end
			end):finally(function()
				setState2(false)
			end)
		end
	end, {
		v6,
		navigation,
		state,
		state2,
		state4,
		v21,
		v11.errorInvalidEmail,
		v20,
		v7
	})
	local v23

	if module12 then
		v23 = module.useCallback(function()
			if setState5 then
				setState5(false)
			end
		end, {})
	end

	local state6, v24, v25

	if module13 then
		local setState6
		state6, setState6 = module.useState(false)
		local function fn2()
			if module14 and module10 then
				v7(eventNames.VerifyEmailNoSchoolEmailClick)
			end

			setState6(true)
		end

		v24 = module.useCallback(fn2, { if module14 then v7 else nil })
		v25 = module.useCallback(function()
			setState6(false)
		end, {})
	else
		state6 = false
	end

	local v26 = module.useCallback(function()
		linkingProtocol.default:openURL(defineFastString)
	end, {})

	local v27 = module.useCallback(function()
		linkingProtocol.default:openURL(defineFastString2)
	end, {})

	local suggestedEmail = if state4 then v15.suggestedEmail else nil

	local createElement = module.createElement
	local v29 = {
		email = state,
		onEmailChanged = v16,
		errorMessage = state3,
		suggestedEmailMessage = suggestedEmail,
		isSubmitting = state2,
		onContinue = v22,
		onBack = v17,
		onTermsOfService = v26,
		onPrivacyPolicy = v27,
		showSchoolUnavailableDialog = state5,
		onDismissSchoolUnavailable = v23,
		onNoSchoolEmail = nil,
		schoolInterestSheet = 0
	}

	if not module13 then
		v24 = nil
	end

	v29.onNoSchoolEmail = v24

	local v30 = if module13 then module.createElement(v5, {
		isOpen = state6,
		onClose = v25,
		entryPoint = module14 and "verifyEmail" or nil
	}) else nil
	v29.schoolInterestSheet = v30
	local element = createElement(module2, v29)

	if module11 and module10 then
		return module.createElement(module.Fragment, nil, {
			PageLoad = module.createElement(module9, {
				eventName = eventNames.VerifyEmailPageLoad
			}),
			Page = element
		})
	end

	return element
end

return VerifyEmailContainer
