local WhatsNew = script:FindFirstAncestor("WhatsNew")
local parent = WhatsNew.Parent

local Enums = require(WhatsNew.Enums)
require(WhatsNew.Types)
local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = InExperienceLocales.Localization
require(script.Parent.ScopeActions)
local validateRegistry = require(script.Parent.validateRegistry)
local buildTourTips = require(script.Parent.buildTourTips)

local LocalizationService = game:GetService("LocalizationService")

local function makeRootTourKey(p: string, tourType) -- 1 equivalent call inferred from this helper
	return `{p}:{tourType}`
end

local function collectScreenScopeIds(scopeTours)
	local screenScopeIds = {}

	for k, item in scopeTours do
		if item.parentScopeId == nil then
			table.insert(screenScopeIds, k)
		end
	end

	table.sort(screenScopeIds)
	return screenScopeIds
end

local function getRegistryEntries(p, tourType) -- 1 equivalent call inferred from this helper
	if tourType == Enums.TourType.WhatsNew then
		return p.whatsNew
	end

	return p.onboarding
end

local function assertValidationPassed(p, p2)
	local scopeActions

	if p2 then
		scopeActions = p2.scopeActions
	end

	local v = validateRegistry(p, { scopeActions = scopeActions })

	assert(#v.errors == 0, `loadWhatsNewRegistry validation failed: {table.concat(v.errors, "; ")}`)
end

local function localizeOptional(object, p: string?) -- 4 equivalent calls inferred from this helper
	if p == nil or p == "" then
		return p
	end

	return object:Format(p)
end

local function localizeRegistry(Updates)
	local v = Localization.new(LocalizationService.RobloxLocaleId)

	local clones = {}

	for k, scopeTour in Updates.scopeTours do
		local clone = table.clone(scopeTour)
		clone.onboardingTitle = localizeOptional(v, scopeTour.onboardingTitle) -- inferred equivalent call
		clone.onboardingText = localizeOptional(v, scopeTour.onboardingText) -- inferred equivalent call
		clone.updatesTitle = localizeOptional(v, scopeTour.updatesTitle) -- inferred equivalent call
		clone.updatesText = localizeOptional(v, scopeTour.updatesText) -- inferred equivalent call
		clones[k] = clone
	end

	local function localizeEntries(items)
		local clones2 = {}

		for k, item in items do
			local clone = table.clone(item)
			clone.title = v:Format(item.title)
			clone.text = v:Format(item.text)
			clones2[k] = clone
		end

		return clones2
	end

	return {
		constants = Updates.constants,
		scopeTours = clones,
		whatsNew = localizeEntries(Updates.whatsNew),
		onboarding = localizeEntries(Updates.onboarding)
	}
end

local function loadWhatsNewRegistry(p, p2, options)
	assertValidationPassed(p, options or {})

	local v = collectScreenScopeIds(p.scopeTours)
	local whatsNewRegistry = {}

	for _, screenScopeId in v do
		for _, tourType in Enums.TourTypeList do
			local tourTips = buildTourTips(p, p2, screenScopeId, tourType, getRegistryEntries(p, tourType), nil) -- inferred equivalent call
			whatsNewRegistry[makeRootTourKey(screenScopeId, tourType)] = { -- inferred equivalent call
				screenScopeId = screenScopeId,
				tourType = tourType,
				scopeTree = tourTips.scope,
				globalTotalSteps = tourTips.globalTotalSteps,
				truncated = tourTips.truncated
			}
		end
	end

	return whatsNewRegistry
end

return {
	loadWhatsNewRegistry = loadWhatsNewRegistry,
	loadBundledRegistry = function(p, p2)
		local Updates = require(script.Parent.Updates)
		return loadWhatsNewRegistry(localizeRegistry(Updates), p, p2)
	end,
	makeRootTourKey = makeRootTourKey
}
