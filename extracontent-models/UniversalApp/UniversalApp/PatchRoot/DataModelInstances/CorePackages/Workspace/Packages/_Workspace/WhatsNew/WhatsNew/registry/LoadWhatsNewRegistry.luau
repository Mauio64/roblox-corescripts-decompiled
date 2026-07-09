local WhatsNew = script:FindFirstAncestor("WhatsNew")
local Enums = require(WhatsNew.Enums)

require(WhatsNew.Types)
require(script.Parent.ScopeActions)

local validateRegistry = require(script.Parent.validateRegistry)
local buildTourTips = require(script.Parent.buildTourTips)

local function collectScreenScopeIds(t1: {[any]: any}) -- line: 21
	local t2 = {}

	for v13, v14 in t1 do
		if v14.parentScopeId == nil then
			table.insert(t2, v13)
		end
	end

	table.sort(t2)

	return t2
end
local function getRegistryEntries(p1, p2) -- line: 32
	-- upvalues: Enums (copy)
	if p2 == Enums.TourType.WhatsNew then
		return p1.whatsNew
	end

	return p1.onboarding
end
local function assertValidationPassed(p3, t3: {[any]: any}?) -- line: 39
	-- upvalues: validateRegistry (copy)
	local v19 = validateRegistry(p3, {
		scopeActions = if not t3 then nil else t3.scopeActions
	})

	assert(#v19.errors == 0, `loadWhatsNewRegistry validation failed: { table.concat(v19.errors, "; ") }`)
end
local function loadWhatsNewRegistry(p4, p5, t4: {[any]: any}?) -- line: 46
	-- upvalues: assertValidationPassed (copy), collectScreenScopeIds (copy), Enums (copy), buildTourTips (copy)
	local v23 = t4 or {}

	assertValidationPassed(p4, v23)

	local t5 = {}

	for _, v26 in (collectScreenScopeIds(p4.scopeTours)) do
		for _, v28 in Enums.TourTypeList do
			local v29 = buildTourTips(p4, p5, v26, v28, if v28 ~= Enums.TourType.WhatsNew then p4.onboarding else p4.whatsNew, nil)

			t5[`{ v26 }:{ v28 }`] = {
				screenScopeId = v26,
				tourType = v28,
				scopeTree = v29.scope,
				globalTotalSteps = v29.globalTotalSteps,
				truncated = v29.truncated
			}
		end
	end

	return t5
end

return {
	loadWhatsNewRegistry = loadWhatsNewRegistry,
	loadBundledRegistry = function(p6, t6: {[any]: any}?) -- line: 74
		-- upvalues: loadWhatsNewRegistry (copy)
		local Updates = require(script.Parent.Updates)

		return (loadWhatsNewRegistry(Updates, p6, t6))
	end,
	makeRootTourKey = function(s1: string, p7) -- line: 17
		return `{ s1 }:{ p7 }`
	end
}
