local HttpService = game:GetService("HttpService")

local module = require("@luauforge/deferred/ekz")
local module2 = require("@luauforge/deferred/ela")
local createSignal = module.createSignal
local batch = module2.batch

require("@luauforge/deferred/ekr")
local module3 = require("@luauforge/deferred/elp")

local defineFastInt = game:DefineFastInt("SchoolsOtpResendCooldownMs", 30000)

local function createSchoolVerificationFlowStore()
	local signal, v5 = createSignal(nil)
	local signal2, v6 = createSignal({})
	local signal3, v7 = createSignal(nil)

	local signal4, v8 = createSignal(nil)
	local signal5, v9 = createSignal(nil)

	local signal6, v10 = createSignal(nil)

	local signal7, v11 = createSignal(nil)
	local signal8, v12 = createSignal({})
	local signal9, v13 = createSignal(nil)

	local signal10 = createSignal(not module3 and "" or HttpService:GenerateGUID(false))
	local signal11, v14 = createSignal(0)

	local function setSelectedSchoolAction(p2)
		batch(function()
			v7(p2)
			v8(nil)
			v9(nil)
			v10(nil)
		end)
	end

	return {
		getEmail = signal,
		getSchools = signal2,
		getSelectedSchool = signal3,
		getSelectedGraduationYear = signal4,
		getSelectedRoleId = signal5,
		getSelectedActiveStudent = signal6,
		getResendCooldownDeadline = signal7,
		getOtpRequestedSchoolIds = signal8,
		getSuggestedEmail = signal9,
		getFlowSessionId = signal10,
		getSubmitAttempt = signal11,
		setSubmitResult = function(p2, p3, p4)
			batch(function()
				v5(p2)
				v6(p3)
				v13(p4)
				v7(nil)
				v8(nil)
				v9(nil)
				v10(nil)
				v11(nil)
				v12({})
			end)
		end,
		setSelectedSchool = setSelectedSchoolAction,
		setSelectedGraduationYearOption = function(p2, p3, p4)
			batch(function()
				v8(p2)
				v9(p3)
				v10(p4)
			end)
		end,
		startOtpResendCooldown = function()
			v11(DateTime.now().UnixTimestampMillis + defineFastInt)
		end,
		beginSubmitAttempt = function()
			v14(signal11() + 1)
		end,
		markSchoolOtpRequested = function(p2)
			local clone = table.clone(signal8())
			clone[p2] = true
			v12(clone)
		end,
		clearSuggestedEmail = function()
			v13(nil)
		end,
		reset = function()
			batch(function()
				v5(nil)
				v6({})
				v13(nil)
				v7(nil)
				v8(nil)
				v9(nil)
				v10(nil)
				v11(nil)
				v12({})
			end)
		end
	}
end

return createSchoolVerificationFlowStore
