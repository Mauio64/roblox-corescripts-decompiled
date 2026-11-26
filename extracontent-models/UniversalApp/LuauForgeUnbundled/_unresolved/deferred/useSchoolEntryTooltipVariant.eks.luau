local module = require("@luauforge/deferred/eko")
local dataStatus = require("@luauforge/deferred/ekt").DataStatus

local module2 = require("@luauforge/deferred/eku")
local module3 = require("@luauforge/deferred/ekq")
local searchFilterPredicate = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Utils/searchFilterPredicate")
local module5 = require("@luauforge/deferred/ekx")
local module6 = require("@luauforge/deferred/ekM")

local schoolEntryTooltipVariant = module3.SchoolEntryTooltipVariant

local isShown = module6.isShown
local markShown = module6.markShown

local function useSchoolEntryTooltipVariant()
	local v5 = module5()
	local v6 = v5.status == dataStatus.Ready
	local school = v5.school
	local v7 = v6 and school == nil

	if v6 then
		if school == nil or school.status ~= module3.SchoolStatus.Active then
			v6 = false
		else
			v6 = not searchFilterPredicate(school.subtype)
		end
	end

	local state, setState = module.useState(function()
		return isShown(module2.FeatureAvailable.APP_STORAGE_KEY)
	end)

	local state2, setState2 = module.useState(function()
		return isShown(module2.SchoolIsLive.APP_STORAGE_KEY)
	end)
	local v8

	if v6 and not state2 then
		v8 = schoolEntryTooltipVariant.SchoolIsLive
	else
		v8 = if v7 and not state then schoolEntryTooltipVariant.FeatureAvailable else nil
	end

	local ref = module.useRef(v8)
	module.useLayoutEffect(function()
		ref.current = v8
	end, { v8 })

	return v8, (module.useCallback(function()
		local current = ref.current

		if current == schoolEntryTooltipVariant.FeatureAvailable then
			setState(true)
			markShown(module2.FeatureAvailable.APP_STORAGE_KEY)
		elseif current == schoolEntryTooltipVariant.SchoolIsLive then
			setState2(true)
			markShown(module2.SchoolIsLive.APP_STORAGE_KEY)
		end
	end, {}))
end

return useSchoolEntryTooltipVariant
