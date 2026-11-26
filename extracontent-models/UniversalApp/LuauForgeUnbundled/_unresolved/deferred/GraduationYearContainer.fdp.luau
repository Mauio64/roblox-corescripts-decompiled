local module = require("@luauforge/deferred/eko")
local useSignalState = require("@luauforge/deferred/eky").useSignalState
local useLocalization = require("@luauforge/deferred/ekQ").Hooks.useLocalization

local module2 = require("@luauforge/deferred/fdq")
local module3 = require("@luauforge/deferred/eli")
local module4 = require("@luauforge/deferred/fds")
local useSchoolVerificationFlow = require("@luauforge/deferred/eln").useSchoolVerificationFlow
require("@luauforge/deferred/ekr")
local module5 = require("@luauforge/deferred/ekv")
local module6 = require("@luauforge/deferred/fbx")
local module7 = require("@luauforge/deferred/fbK")
local module8 = require("@luauforge/deferred/fbE")
local module9 = require("@luauforge/deferred/elp")

local eventNames = module6.EventNames

local function GraduationYearContainer(p2)
	local navigation = p2.navigation
	local v5 = useSchoolVerificationFlow()

	local v6 = module6.useSchoolsAnalytics()

	module.useEffect(function(): nil
		if module9 or not module8 then
			return nil
		end

		v6(eventNames.GraduationYearPageLoad)
		return nil
	end, { v6 })

	local v7 = useSignalState(v5.getSelectedSchool)
	local v8 = not v7 and "" or v7.schoolName

	local v9 = useLocalization({ errorGeneric = module5.SomethingWentWrong })

	local v10 = not v7 and {} or v7.graduationYearOptions

	local v11 = module.useMemo(function()
		local v12 = {}
		local v13 = nil

		for k, v14 in v10 do
			if v14.activeStudent then
				local v15 = string.match(v14.graduationYear, "%d+")
				local v16 = { id = tostring(v14.roleId), text = 0 }

				if v15 == nil then
					v15 = v14.graduationYear
				end

				v16.text = v15
				table.insert(v12, v16)
			else
				v13 = v14
			end
		end

		return { years = v12, alumni = v13 }
	end, { v10 })

	local years = v11.years
	local alumni = v11.alumni

	local state, setState = module.useState(function(): nil
		return nil
	end)

	local state2, setState2 = module.useState(false)
	local state3, setState3 = module.useState(function(): nil
		return nil
	end)

	local ref = module.useRef(true)
	module.useEffect(function()
		return function()
			ref.current = false
		end
	end, {})

	local v12 = module.useCallback(function()
		navigation.pop()
	end, { navigation })

	local v13 = module.useCallback(function(data)
		if state2 or v7 == nil then
			return
		end

		if module8 then
			v6(eventNames.GraduationYearContinueClick)
		end

		if v5.getOtpRequestedSchoolIds()[v7.schoolId] then
			v5.setSelectedGraduationYearOption(data.graduationYear, data.roleId, data.activeStudent)

			navigation.navigate(module3.OtpVerification)
		else
			setState2(true)
			setState3(nil)

			module4(v7.schoolId):andThen(function()
				if not ref.current then
					return
				end

				v5.setSelectedGraduationYearOption(data.graduationYear, data.roleId, data.activeStudent)

				v5.startOtpResendCooldown()
				v5.markSchoolOtpRequested(v7.schoolId)
				navigation.navigate(module3.OtpVerification)
			end):catch(function()
				if not ref.current then
					return
				end

				setState3(v9.errorGeneric)
			end):finally(function()
				if ref.current then
					setState2(false)
				end
			end)
		end
	end, { v5, navigation, state2, v7, v9.errorGeneric, v6 })

	local v14 = module.useCallback(function(p3)
		if state2 or v7 == nil then
			return
		end

		setState(p3)
		setState3(nil)

		if module8 then
			v6(eventNames.GraduationYearYearSelected)
		end

		local v15 = nil

		for k, graduationYearOption in v7.graduationYearOptions do
			if tostring(graduationYearOption.roleId) == p3 then
				v15 = graduationYearOption
				break
			end
		end

		if v15 ~= nil then
			v13(v15)
		end
	end, { state2, v7, v13, v6 })

	local v15 = module.useCallback(function()
		if state2 or alumni == nil then
			return
		end

		setState((tostring(alumni.roleId)))
		setState3(nil)

		if module8 then
			v6(eventNames.GraduationYearYearSelected)
		end

		v13(alumni)
	end, { state2, alumni, v13, v6 })

	local element = module.createElement(module2, {
		schoolName = v8,
		onBack = v12,
		years = years,
		selectedYearId = state,
		onYearSelected = v14,
		hasAlumniOption = alumni ~= nil,
		onAlumniSelected = v15,
		errorMessage = state3
	})

	if module9 and module8 then
		return module.createElement(module.Fragment, nil, {
			PageLoad = module.createElement(module7, {
				eventName = eventNames.GraduationYearPageLoad
			}),
			Page = element
		})
	end

	return element
end

return GraduationYearContainer
