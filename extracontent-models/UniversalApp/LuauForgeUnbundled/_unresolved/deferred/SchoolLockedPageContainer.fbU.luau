local module = require("@luauforge/deferred/eko")

local module2 = require("@luauforge/deferred/fbV")
local module3 = require("@luauforge/deferred/fcc")
local module4 = require("@luauforge/deferred/fcn")
local module5 = require("@luauforge/deferred/elj")
local module6 = require("@luauforge/deferred/ekx")
local module7 = require("@luauforge/deferred/fbx")
local module8 = require("@luauforge/deferred/fbK")
local module9 = require("@luauforge/deferred/fbE")
local module10 = require("@luauforge/deferred/elp")

local eventNames = module7.EventNames

local function SchoolLockedPageContainer(p2)
	local navigation = p2.navigation

	local school = module6().school

	local v5 = module7.useSchoolsAnalytics()

	module.useEffect(function(): nil
		if not module10 and module9 then
			v5(eventNames.SchoolLockedPageLoad)
		end

		return nil
	end, { v5 })

	local v6 = module5(navigation)
	local v7 = module.useCallback(function()
		if navigation.isFocused() then
			v6()
		end
	end, { navigation, v6 })

	local v8 = module.useCallback(function()
		if school == nil then
			return nil
		end

		return module4(school.groupId)
	end, { school })

	local v9 = module.useCallback(function()
		return module.createElement(module3, { onLeaveSchool = v8 })
	end, { v8 })

	local element = module.createElement(module2, { onBack = v7, renderTrailing = v9 })

	if module10 and module9 then
		return module.createElement(module.Fragment, nil, {
			PageLoad = module.createElement(module8, {
				eventName = eventNames.SchoolLockedPageLoad
			}),
			Page = element
		})
	end

	return element
end

return SchoolLockedPageContainer
