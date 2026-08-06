local WhatsNew = script:FindFirstAncestor("WhatsNew")
local WhatsNewParent = WhatsNew.Parent
local Enums = require(WhatsNew.Enums)

require(WhatsNew.Types)

local Localization = require(WhatsNewParent.InExperienceLocales).Localization

require(script.Parent.ScopeActions)

local validateRegistry = require(script.Parent.validateRegistry)
local buildTourTips = require(script.Parent.buildTourTips)
local LocalizationService = game:GetService("LocalizationService")

local function collectScreenScopeIds(t1: {[any]: any}) -- line: 26
	local t2 = {}

	for v18, v19 in t1 do
		if v19.parentScopeId == nil then
			table.insert(t2, v18)
		end
	end

	table.sort(t2)

	return t2
end
local function getRegistryEntries(p1, p2) -- line: 37
	-- upvalues: Enums (copy)
	if p2 == Enums.TourType.WhatsNew then
		return p1.whatsNew
	end

	return p1.onboarding
end
local function assertValidationPassed(p3, t3: {[any]: any}?) -- line: 44
	-- upvalues: validateRegistry (copy)
	local v24 = validateRegistry(p3, {
		scopeActions = if not t3 then nil else t3.scopeActions
	})

	assert(#v24.errors == 0, `loadWhatsNewRegistry validation failed: { table.concat(v24.errors, "; ") }`)
end
local function localizeOptional(p4, s1: string?) -- line: 51
	if s1 == nil or s1 == "" then
		return s1
	end

	return p4:Format(s1)
end
local function localizeRegistry(p5) -- line: 58
	-- upvalues: Localization (copy), LocalizationService (copy)
	local v28 = Localization.new(LocalizationService.RobloxLocaleId)
	local t4 = {}

	for v30, v31 in p5.scopeTours do
		local v32 = table.clone(v31)
		local onboardingTitle = v31.onboardingTitle

		v32.onboardingTitle = if onboardingTitle ~= nil and onboardingTitle ~= "" then v28:Format(onboardingTitle) else onboardingTitle

		local onboardingText = v31.onboardingText

		v32.onboardingText = if onboardingText ~= nil and onboardingText ~= "" then v28:Format(onboardingText) else onboardingText

		local updatesTitle = v31.updatesTitle

		v32.updatesTitle = if updatesTitle ~= nil and updatesTitle ~= "" then v28:Format(updatesTitle) else updatesTitle

		local updatesText = v31.updatesText

		v32.updatesText = if updatesText ~= nil and updatesText ~= "" then v28:Format(updatesText) else updatesText
		t4[v30] = v32
	end

	local function localizeEntries(t5: {[any]: any}) -- line: 71
		-- upvalues: v28 (copy)
		local t6 = {}

		for v53, v54 in t5 do
			local v55 = table.clone(v54)

			v55.title = v28:Format(v54.title)
			v55.text = v28:Format(v54.text)
			t6[v53] = v55
		end

		return t6
	end

	return {
		constants = p5.constants,
		scopeTours = t4,
		whatsNew = localizeEntries(p5.whatsNew),
		onboarding = localizeEntries(p5.onboarding)
	}
end
local function loadWhatsNewRegistry(p6, p7, t7: {[any]: any}?) -- line: 90
	-- upvalues: assertValidationPassed (copy), collectScreenScopeIds (copy), Enums (copy), buildTourTips (copy)
	local v41 = t7 or {}

	assertValidationPassed(p6, v41)

	local t8 = {}

	for _, v44 in (collectScreenScopeIds(p6.scopeTours)) do
		for _, v46 in Enums.TourTypeList do
			local v47 = buildTourTips(p6, p7, v44, v46, if v46 ~= Enums.TourType.WhatsNew then p6.onboarding else p6.whatsNew, nil)

			t8[`{ v44 }:{ v46 }`] = {
				screenScopeId = v44,
				tourType = v46,
				scopeTree = v47.scope,
				globalTotalSteps = v47.globalTotalSteps,
				truncated = v47.truncated
			}
		end
	end

	return t8
end

return {
	loadWhatsNewRegistry = loadWhatsNewRegistry,
	loadBundledRegistry = function(p8, t9: {[any]: any}?) -- line: 118
		-- upvalues: loadWhatsNewRegistry (copy), localizeRegistry (copy)
		local Updates = require(script.Parent.Updates)

		return (loadWhatsNewRegistry(localizeRegistry(Updates), p8, t9))
	end,
	makeRootTourKey = function(s2: string, p9) -- line: 22
		return `{ s2 }:{ p9 }`
	end
}
