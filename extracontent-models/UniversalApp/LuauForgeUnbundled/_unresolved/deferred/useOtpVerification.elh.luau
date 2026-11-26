local module = require("@luauforge/deferred/eko")
local useSignalState = require("@luauforge/deferred/eky").useSignalState

local module2 = require("@luauforge/deferred/eli")
local module3 = require("@luauforge/deferred/ekq")
local searchFilterPredicate = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Utils/searchFilterPredicate")
local module5 = require("@luauforge/deferred/ekB")
local module6 = require("@luauforge/deferred/elj")
local module7 = require("@luauforge/deferred/ell")
local module8 = require("@luauforge/deferred/elm")
require("@luauforge/deferred/ekr")
local useSchoolVerificationFlow = require("@luauforge/deferred/eln").useSchoolVerificationFlow

local v5 = {
	[module3.VerifyErrorKind.OtpMismatch] = true,
	[module3.VerifyErrorKind.OtpExpired] = true,
	[module3.VerifyErrorKind.OtpInvalidFormat] = true,
	[module3.VerifyErrorKind.OtpAlreadyUsed] = true,
	[module3.VerifyErrorKind.OtpTooManyAttempts] = false
}

local function useOtpVerification(data)
	local navigation = data.navigation
	local v6 = useSchoolVerificationFlow()

	local v7 = module6(navigation)

	local v8 = useSignalState(v6.getEmail)
	local v9 = useSignalState(v6.getSelectedSchool)
	local v10 = useSignalState(v6.getSelectedGraduationYear)
	local v11 = useSignalState(v6.getSelectedRoleId)
	local v12 = useSignalState(v6.getSelectedActiveStudent)
	local v13 = useSignalState(v6.getResendCooldownDeadline)

	local state, setState = module.useState("")
	local state2, setState2 = module.useState(false)
	local state3, setState3 = module.useState(false)
	local state4, setState4 = module.useState(nil)
	local state5, setState5 = module.useState(false)
	local state6, setState6 = module.useState(false)

	local state7, setState7 = module.useState(false)
	local state8, setState8 = module.useState(0)
	local state9, setState9 = module.useState(false)

	local ref = module.useRef(true)
	module.useEffect(function()
		return function()
			ref.current = false
		end
	end, {})

	local ref2 = module.useRef(false)

	module.useEffect(function()
		if v13 == nil then
			setState8(0)
			setState5(true)
		else
			local thread = nil
			local function updateCountdown()
				thread = nil
				local v16 = v13 - DateTime.now().UnixTimestampMillis
				local v17 = math.max(0, (math.ceil(v16 / 1000)))
				setState8(v17)
				setState5(v17 == 0)

				if v16 > 0 then
					thread = task.delay(math.min(1, v16 / 1000), updateCountdown)
				end
			end
			updateCountdown()
			return function()
				if thread ~= nil then
					task.cancel(thread)
				end
			end
		end
	end, { v13 })

	local v16 = module.useCallback(function(data2)
		local v17 = module5(false)

		local v18 = v9 ~= nil and data2 ~= nil and {
			groupId = data2.groupId,
			memberCount = data2.memberCount,
			membersNeededForNextTier = data2.membersNeededForNextTier,
			subtype = data2.subtype,
			country = v9.location.countryCode,
			state = v9.location.state,
			city = v9.location.city,
			status = data2.status
		} or nil
		local v19

		if data2 ~= nil then
			v19 = if data2.nickname == nil or data2.nickname == "" then data2.name else data2.nickname
		end

		v17.updateVerifiedSchool(data.userId, v18)
		v17.refresh(data.userId)

		if not ref.current then
			return
		end

		local v20 = if v18 == nil or v18.status ~= module3.SchoolStatus.Active or v12 ~= true or searchFilterPredicate(v18.subtype) then module2.SchoolWaitlist else module2.SchoolMemberList
		navigation.navigate(v20, { justVerifiedSchoolName = v19 })
		v6.reset()
	end, { v6, navigation, data.userId, v9, v12 })

	local v17 = module.useCallback(function(p2)
		if state2 or state7 or v9 == nil or v10 == nil or v11 == nil or v12 == nil or v8 == nil then
			return
		end

		if data.onCodeSubmitted then
			data.onCodeSubmitted()
		end

		setState2(true)
		setState4(nil)

		module7(v9.schoolId, { graduationYear = v10, roleId = v11, activeStudent = v12 }, p2):andThen(function(p3)
			return v16(p3)
		end):catch(function(p3)
			if not ref.current then
				return
			end

			local v19 = (if typeof(p3) == "table" then p3.kind else nil) or module3.VerifyErrorKind.Unknown

			if v5[v19] then
				setState4(v19)
				return
			end

			if v19 == module3.VerifyErrorKind.OtpTooManyAttempts then
				setState7(true)
			end

			setState9(true)
		end):finally(function()
			if ref.current then
				setState2(false)
			end
		end)
	end, {
		state2,
		state7,
		v9,
		v10,
		v11,
		v12,
		v8,
		v16,
		data.onCodeSubmitted
	})

	return {
		code = state,
		onCodeChanged = module.useCallback(function(value)
			local v19 = string.find(value, "%D") ~= nil
			local v20 = string.gsub(value, "%D", "")

			if #v20 > 6 then
				v20 = string.sub(v20, 1, 6)
			end

			setState(v20)

			if v19 then
				setState4(module3.VerifyErrorKind.OtpInvalidFormat)
				return
			end

			setState4(nil)

			if #v20 == 6 then
				v17(v20)
			end
		end, { v17 }),
		errorKind = state4,
		isVerifying = state2,
		isVerifyLocked = state7,
		canResend = state5 and not state6,
		resendSecondsRemaining = state8,
		isResending = state3,
		onResend = module.useCallback(function()
			if not state5 or state3 or state2 or v9 == nil or state6 then
				return
			end

			if ref2.current then
				return
			end

			ref2.current = true

			if data.onResendRequested then
				data.onResendRequested()
			end

			setState3(true)
			setState4(nil)
			setState5(false)

			module8():andThen(function()
				if not ref.current then
					return
				end

				v6.startOtpResendCooldown()
			end):catch(function(p2)
				if not ref.current then
					return
				end

				local v20 = if typeof(p2) == "table" then p2.kind else nil

				if (v20 or module3.VerifyErrorKind.Unknown) == module3.VerifyErrorKind.OtpTooManyAttempts then
					setState6(true)
					setState9(true)
				else
					setState4(module3.VerifyErrorKind.Unknown)
					setState5(true)
				end
			end):finally(function()
				ref2.current = false

				if ref.current then
					setState3(false)
				end
			end)
		end, { v6, state5, state6, state3, state2, v9, data.onResendRequested }),
		showVerificationFailedDialog = state9,
		onDismissVerificationFailed = module.useCallback(function()
			setState9(false)
			setState("")
			setState4(nil)

			if (state7 or state6) and v7 then
				v7()
			end
		end, { state7, state6, v7 })
	}
end

return useOtpVerification
