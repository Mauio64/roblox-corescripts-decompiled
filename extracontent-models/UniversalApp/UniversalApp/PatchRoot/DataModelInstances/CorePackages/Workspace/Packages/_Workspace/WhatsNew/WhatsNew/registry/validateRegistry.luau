local WhatsNew = script:FindFirstAncestor("WhatsNew")
local Constants = require(WhatsNew.Constants)
local Enums = require(WhatsNew.Enums)

require(WhatsNew.Types)

local ScopeActions = require(script.Parent.ScopeActions)

local function appendError(t1: {[any]: any}, s1: string, s2: string) -- line: 21
	table.insert(t1, `{ s1 }:{ s2 }`)
end
local function appendWarning(t2: {[any]: any}, s3: string, s4: string) -- line: 25
	table.insert(t2, `{ s3 }:{ s4 }`)
end
local function isNonEmptyString(s5: string?) -- line: 29
	return s5 ~= nil and s5 ~= ""
end
local function getRegistryEntries(p1, p2) -- line: 33
	-- upvalues: Enums (copy)
	if p2 == Enums.TourType.WhatsNew then
		return p1.whatsNew
	end

	return p1.onboarding
end
local function validateConstants(p3, t3: {[any]: any}) -- line: 40
	-- upvalues: Constants (copy)
	local constants = p3.constants

	for v29, v30 in {
		textMaxLength = constants.textMaxLength,
		updateEntryDuration = constants.updateEntryDuration,
		maxTourTips = constants.maxTourTips,
		maxEntriesPerMenu = constants.maxEntriesPerMenu,
		maxOptOutCount = constants.maxOptOutCount
	} do
		if typeof(v30) ~= "number" or v30 <= 0 then
			table.insert(t3, `{ Constants.ErrorCodes.INVALID_CONSTANTS }:{ `{ v29 }` }`)
		end
	end
end
local function validateScopeKeys(p4, t4: {[any]: any}) -- line: 57
	-- upvalues: Constants (copy)
	for v33, v34 in p4.scopeTours do
		if v33 ~= v34.id then
			table.insert(t4, `{ Constants.ErrorCodes.SCOPE_KEY_MISMATCH }:{ `{ v33 }->{ v34.id }` }`)
		end
	end
end
local function validateEntryScopes(p5, t5: {[any]: any}) -- line: 65
	-- upvalues: Constants (copy), Enums (copy)
	local function validateEntries(t6: {[any]: any}, p6) -- line: 66
		-- upvalues: p5 (copy), t5 (copy), Constants (copy)
		for _, v80 in t6 do
			if p5.scopeTours[v80.scopeId] == nil then
				table.insert(t5, `{ Constants.ErrorCodes.UNKNOWN_SCOPE }:{ `{ v80.id } ({ p6 })` }`)
			end

			if #v80.text > p5.constants.textMaxLength then
				table.insert(t5, `{ Constants.ErrorCodes.TEXT_TOO_LONG }:{ `{ v80.id } ({ p6 })` }`)
			end
		end
	end

	for _, v39 in Enums.TourTypeList do
		validateEntries(if v39 ~= Enums.TourType.WhatsNew then p5.onboarding else p5.whatsNew, v39)
	end
end
local function scopeHasEntries(s6: string, p7) -- line: 83
	-- upvalues: Enums (copy)
	for _, v43 in Enums.TourTypeList do
		local whatsNew, v45, v46

		if v43 == Enums.TourType.WhatsNew then
			whatsNew = p7.whatsNew
			v45 = nil
			v46 = nil
		else
			whatsNew = p7.onboarding
			v45 = nil
			v46 = nil
		end

		for _, v48 in whatsNew, v45, v46 do
			if s6 == v48.scopeId then
				return true
			end
		end
	end

	return false
end
local function validateNestedScopeActions(p8, t7: {[any]: any}) -- line: 95
	-- upvalues: scopeHasEntries (copy), Constants (copy)
	for v51, v52 in p8.scopeTours do
		if v52.parentScopeId == nil or not scopeHasEntries(v51, p8) then
			continue
		end

		local openActionKey = v52.openActionKey

		if openActionKey ~= nil and openActionKey ~= "" then
			local closeActionKey = v52.closeActionKey

			if closeActionKey ~= nil and closeActionKey ~= "" then
				continue
			end
		end

		table.insert(t7, `{ Constants.ErrorCodes.NESTED_MISSING_ACTION }:{ v51 }`)
	end
end
local function validateKnownActionKeys(p9, p10, t8: {[any]: any}) -- line: 111
	-- upvalues: ScopeActions (copy), Constants (copy)
	if p10 == nil then
		return
	end

	for _, v59 in ScopeActions.collectRegistryActionKeys(p9) do
		if not p10:has(v59) then
			table.insert(t8, `{ Constants.ErrorCodes.UNKNOWN_ACTION_KEY }:{ v59 }`)
		end
	end
end
local function validateMenuGroupDeferred(t9: {[any]: any}, p11, t10: {[any]: any}) -- line: 127
	-- upvalues: Constants (copy)
	local t11 = {}

	for _, v65 in t9 do
		if v65.enabled then
			local v66 = `{ v65.scopeId }:{ v65.anchorId }`
			local v67 = t11[v66]

			if v67 == nil then
				v67 = {}
				t11[v66] = v67
			end

			table.insert(v67, v65.id)
		end
	end

	for v68, v69 in t11 do
		if #v69 >= 2 then
			table.insert(t10, `{ Constants.WarningCodes.MENU_GROUP_DEFERRED }:{ `{ p11 }:{ v68 }` }`)
		end
	end
end
local function validateRegistry(p12, t12: {[any]: any}?) -- line: 155
	-- upvalues: validateConstants (copy), validateScopeKeys (copy), validateEntryScopes (copy), validateNestedScopeActions (copy), validateKnownActionKeys (copy), Enums (copy), validateMenuGroupDeferred (copy)
	local t13 = {}
	local t14 = {}
	local v74 = t12 or {}

	validateConstants(p12, t13)
	validateScopeKeys(p12, t13)
	validateEntryScopes(p12, t13)
	validateNestedScopeActions(p12, t13)
	validateKnownActionKeys(p12, v74.scopeActions, t13)

	for _, v76 in Enums.TourTypeList do
		validateMenuGroupDeferred(if v76 ~= Enums.TourType.WhatsNew then p12.onboarding else p12.whatsNew, v76, t14)
	end

	return {
		errors = t13,
		warnings = t14
	}
end

return validateRegistry
