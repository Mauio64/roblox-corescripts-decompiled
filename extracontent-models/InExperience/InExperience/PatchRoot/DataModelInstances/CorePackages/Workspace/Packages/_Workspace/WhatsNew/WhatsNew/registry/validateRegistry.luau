local WhatsNew = script:FindFirstAncestor("WhatsNew")
local Constants = require(WhatsNew.Constants)
local Enums = require(WhatsNew.Enums)
require(WhatsNew.Types)
local ScopeActions = require(script.Parent.ScopeActions)

local function appendError(list, p: string, p2: string) -- 14 equivalent calls inferred from this helper
	table.insert(list, `{p}:{p2}`)
end

local function isNonEmptyString(p: string?): boolean -- 7 equivalent calls inferred from this helper
	return p ~= nil and p ~= ""
end

local function isoDateToUnix(p: string) -- 3 equivalent calls inferred from this helper
	local dateTime = DateTime.fromIsoDate(p)
	return dateTime and dateTime.UnixTimestamp or nil
end

local function getRegistryEntries(p, tourType) -- 3 equivalent calls inferred from this helper
	if tourType == Enums.TourType.WhatsNew then
		return p.whatsNew
	end

	return p.onboarding
end

local function validateConstants(p, list)
	local constants = p.constants

	for k, v in {
		textMaxLength = constants.textMaxLength,
		maxTourTips = constants.maxTourTips,
		maxOptOutCount = constants.maxOptOutCount
	} do
		if typeof(v) ~= "number" or v <= 0 then
			appendError(list, Constants.ErrorCodes.INVALID_CONSTANTS, `{k}`) -- inferred equivalent call
		end
	end
end

local function validateScopeKeys(p, list)
	for k, scopeTour in p.scopeTours do
		if scopeTour.id ~= k then
			appendError(list, Constants.ErrorCodes.SCOPE_KEY_MISMATCH, `{k}->{scopeTour.id}`) -- inferred equivalent call
		end
	end
end

local function validateEntrySchedule(item, p, list)
	local formatted = `{item.id} ({p})`
	local v = nil
	local v2 = nil

	if isNonEmptyString(item.publishedTime) then -- inferred equivalent call
		v = isoDateToUnix(item.publishedTime) -- inferred equivalent call

		if v == nil then
			appendError(list, Constants.ErrorCodes.INVALID_PUBLISHED_TIME, formatted) -- inferred equivalent call
		end
	else
		appendError(list, Constants.ErrorCodes.MISSING_PUBLISHED_TIME, formatted) -- inferred equivalent call
	end

	if p == Enums.TourType.WhatsNew then
		if isNonEmptyString(item.disabledTime) then -- inferred equivalent call
			v2 = isoDateToUnix(item.disabledTime) -- inferred equivalent call

			if v2 == nil then
				appendError(list, Constants.ErrorCodes.INVALID_DISABLED_TIME, formatted) -- inferred equivalent call
			end
		else
			appendError(list, Constants.ErrorCodes.MISSING_DISABLED_TIME, formatted) -- inferred equivalent call
		end
	elseif isNonEmptyString(item.disabledTime) then -- inferred equivalent call
		v2 = isoDateToUnix(item.disabledTime) -- inferred equivalent call

		if v2 == nil then
			appendError(list, Constants.ErrorCodes.INVALID_DISABLED_TIME, formatted) -- inferred equivalent call
		end
	end

	if v ~= nil and v2 ~= nil and v2 <= v then
		appendError(list, Constants.ErrorCodes.INVALID_SCHEDULE_WINDOW, formatted) -- inferred equivalent call
	end
end

local function validateEntryScopes(p, list)
	local function validateEntries(items, tourType)
		for _, item in items do
			if p.scopeTours[item.scopeId] == nil then
				appendError(list, Constants.ErrorCodes.UNKNOWN_SCOPE, `{item.id} ({tourType})`) -- inferred equivalent call
			end

			if #item.text > p.constants.textMaxLength then
				appendError(list, Constants.ErrorCodes.TEXT_TOO_LONG, `{item.id} ({tourType})`) -- inferred equivalent call
			end

			if not isNonEmptyString(item.title) and not isNonEmptyString(item.text) then -- inferred equivalent call
				appendError(list, Constants.ErrorCodes.EMPTY_ENTRY_LABELS, `{item.id} ({tourType})`) -- inferred equivalent call
			end

			validateEntrySchedule(item, tourType, list)
		end
	end

	for _, tourType in Enums.TourTypeList do
		validateEntries(getRegistryEntries(p, tourType), tourType) -- inferred equivalent call
	end
end

local function validateUniqueEntryIds(p, list)
	for _, tourType in Enums.TourTypeList do
		local idSet = {}
		local registryEntries = getRegistryEntries(p, tourType) -- inferred equivalent call

		for _, registryEntry in registryEntries do
			if idSet[registryEntry.id] then
				appendError(list, Constants.ErrorCodes.DUPLICATE_ENTRY_ID, `{registryEntry.id} ({tourType})`) -- inferred equivalent call
			else
				idSet[registryEntry.id] = true
			end
		end
	end
end

local function scopeHasEntries(k: string, p): boolean
	for _, tourType in Enums.TourTypeList do
		local registryEntries = getRegistryEntries(p, tourType) -- inferred equivalent call

		for _, registryEntry in registryEntries do
			if registryEntry.scopeId == k then
				return true
			end
		end
	end

	return false
end

local function validateNestedScopeActions(p, list)
	for k, scopeTour in p.scopeTours do
		if
			scopeTour.parentScopeId == nil
			or not scopeHasEntries(k, p)
			or isNonEmptyString(scopeTour.openActionKey) and isNonEmptyString(scopeTour.closeActionKey) -- inferred equivalent call
		then
			continue
		end

		appendError(list, Constants.ErrorCodes.NESTED_MISSING_ACTION, k) -- inferred equivalent call
	end
end

local function validateKnownActionKeys(p, scopeActions, list)
	if scopeActions == nil then
		return
	end

	for _, v in ScopeActions.collectRegistryActionKeys(p) do
		if not scopeActions:has(v) then
			appendError(list, Constants.ErrorCodes.UNKNOWN_ACTION_KEY, v) -- inferred equivalent call
		end
	end
end

local function validateRegistry(p, options)
	local errors = {}

	validateConstants(p, errors)
	validateScopeKeys(p, errors)
	validateEntryScopes(p, errors)
	validateUniqueEntryIds(p, errors)
	validateNestedScopeActions(p, errors)
	validateKnownActionKeys(p, (options or {}).scopeActions, errors)
	return { errors = errors, warnings = {} }
end

return validateRegistry
