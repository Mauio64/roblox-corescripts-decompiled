local module = require("@luauforge/deferred/egU")
local dataStatus = require("@luauforge/deferred/egZ").DataStatus
local fFlagSchoolsEntryRequiresOpenSchool = require("@luauforge/deferred/eUv").FFlagSchoolsEntryRequiresOpenSchool

local module2 = require("@luauforge/deferred/egW")
local searchFilterPredicate = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Utils/searchFilterPredicate")
local module4 = require("@luauforge/deferred/eUw")
local module5 = require("@luauforge/deferred/eUx")
local module6 = require("@luauforge/deferred/ehy")
local module7 = require("@luauforge/deferred/ehP")
local module8 = require("@luauforge/deferred/ehd")
local module9 = require("@luauforge/deferred/ehO")
local module10 = require("@luauforge/deferred/eUy")
local module11 = require("@luauforge/deferred/eUL")
local module12 = require("@luauforge/deferred/eUF")
local module13 = require("@luauforge/deferred/eUN")
local module14 = require("@luauforge/deferred/ehV")
local module15 = require("@luauforge/deferred/ehr")
local eventNames = module10.EventNames

local function SchoolEntryDecisionContainer(p2)
	local navigation = p2.navigation
	local v5 = module7(navigation)
	local v6 = module6()
	local v7 = module8()
	local status = v7.status
	local school = v7.school
	local isLocked = v7.isLocked
	local v8 = fFlagSchoolsEntryRequiresOpenSchool

	if v8 then
		if v6 == true then
			v8 = status == dataStatus.Failed or status == dataStatus.Ready and school == nil
		else
			v8 = false
		end
	end

	local v9 = module10.useSchoolsAnalytics()

	module.useEffect(function(): nil
		if module14 or not module12 then
			return nil
		end

		v9(eventNames.SchoolsEntryImpression)
		return nil
	end, { v9 })

	local ref = module.useRef(false)

	module.useEffect(function(): nil
		if v6 == nil then
			return nil
		elseif v6 == false then
			return nil
		end

		if status == dataStatus.NotReady or v8 then
			return nil
		end

		if module13 then
			if ref.current then
				return nil
			end

			ref.current = true
		end

		local v10

		if module15 and status == dataStatus.Ready and isLocked then
			v10 = module9.SchoolLocked
		elseif status == dataStatus.Ready and school ~= nil then
			if school.status == module2.SchoolStatus.Active and not searchFilterPredicate(school.subtype) then
				v10 = module9.SchoolMemberList
			else
				v10 = module9.SchoolWaitlist
			end
		else
			v10 = module9.AddSchoolUpsell
		end

		navigation.replace(v10)
		return nil
	end, { v6, status, school, isLocked, v8, navigation, v5 })
	local v10

	if v6 == false or v8 then
		v10 = module.createElement(module4, { onDismiss = v5 })
	else
		v10 = module.createElement(module5, { testId = "schools-entry-decision" })
	end

	if module14 and module12 then
		return module.createElement(module.Fragment, nil, {
			PageLoad = module.createElement(module11, {
				eventName = eventNames.SchoolsEntryImpression
			}),
			Content = v10
		})
	end

	return v10
end

return SchoolEntryDecisionContainer
