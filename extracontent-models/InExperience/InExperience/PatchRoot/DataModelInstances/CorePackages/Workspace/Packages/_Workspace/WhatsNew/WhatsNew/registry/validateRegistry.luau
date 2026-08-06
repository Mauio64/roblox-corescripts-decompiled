local WhatsNew = script:FindFirstAncestor("WhatsNew")
local Constants = require(WhatsNew.Constants)
local Enums = require(WhatsNew.Enums)

require(WhatsNew.Types)

local ScopeActions = require(script.Parent.ScopeActions)

local function appendError(t1: {[any]: any}, s1: string, s2: string) -- line: 21
	table.insert(t1, `{ s1 }:{ s2 }`)
end
local function isNonEmptyString(s3: string?) -- line: 25
	return s3 ~= nil and s3 ~= ""
end
local function getRegistryEntries(p1, p2) -- line: 29
	-- upvalues: Enums (copy)
	if p2 == Enums.TourType.WhatsNew then
		return p1.whatsNew
	end

	return p1.onboarding
end
local function validateConstants(p3, t2: {[any]: any}) -- line: 36
	-- upvalues: Constants (copy)
	local constants = p3.constants

	for v25, v26 in {
		textMaxLength = constants.textMaxLength,
		updateEntryDuration = constants.updateEntryDuration,
		maxTourTips = constants.maxTourTips,
		maxOptOutCount = constants.maxOptOutCount
	} do
		if typeof(v26) ~= "number" or v26 <= 0 then
			table.insert(t2, `{ Constants.ErrorCodes.INVALID_CONSTANTS }:{ `{ v25 }` }`)
		end
	end
end
local function validateScopeKeys(p4, t3: {[any]: any}) -- line: 52
	-- upvalues: Constants (copy)
	for v29, v30 in p4.scopeTours do
		if v29 ~= v30.id then
			table.insert(t3, `{ Constants.ErrorCodes.SCOPE_KEY_MISMATCH }:{ `{ v29 }->{ v30.id }` }`)
		end
	end
end
local function validateEntryScopes(p5, t4: {[any]: any}) -- line: 60
	-- upvalues: Constants (copy), Enums (copy)
	local function validateEntries(t5: {[any]: any}, p6) -- line: 61
		-- upvalues: p5 (copy), t4 (copy), Constants (copy)
		for _, v73 in t5 do
			if p5.scopeTours[v73.scopeId] == nil then
				table.insert(t4, `{ Constants.ErrorCodes.UNKNOWN_SCOPE }:{ `{ v73.id } ({ p6 })` }`)
			end

			if #v73.text > p5.constants.textMaxLength then
				table.insert(t4, `{ Constants.ErrorCodes.TEXT_TOO_LONG }:{ `{ v73.id } ({ p6 })` }`)
			end

			local title = v73.title

			if title == nil or title == "" then
				local text = v73.text

				if text == nil or text == "" then
					table.insert(t4, `{ Constants.ErrorCodes.EMPTY_ENTRY_LABELS }:{ `{ v73.id } ({ p6 })` }`)
				end
			end
		end
	end

	for _, v35 in Enums.TourTypeList do
		validateEntries(if v35 ~= Enums.TourType.WhatsNew then p5.onboarding else p5.whatsNew, v35)
	end
end
local function validateUniqueEntryIds(p7, t6: {[any]: any}) -- line: 82
	-- upvalues: Enums (copy), Constants (copy)
	for _, v39 in Enums.TourTypeList do
		local t7 = {}
		local whatsNew, v42, v43

		if v39 == Enums.TourType.WhatsNew then
			whatsNew = p7.whatsNew
			v42 = nil
			v43 = nil
		else
			whatsNew = p7.onboarding
			v42 = nil
			v43 = nil
		end

		for _, v45 in whatsNew, v42, v43 do
			if t7[v45.id] then
				table.insert(t6, `{ Constants.ErrorCodes.DUPLICATE_ENTRY_ID }:{ `{ v45.id } ({ v39 })` }`)
			else
				t7[v45.id] = true
			end
		end
	end
end
local function scopeHasEntries(s4: string, p8) -- line: 95
	-- upvalues: Enums (copy)
	for _, v49 in Enums.TourTypeList do
		local whatsNew, v51, v52

		if v49 == Enums.TourType.WhatsNew then
			whatsNew = p8.whatsNew
			v51 = nil
			v52 = nil
		else
			whatsNew = p8.onboarding
			v51 = nil
			v52 = nil
		end

		for _, v54 in whatsNew, v51, v52 do
			if s4 == v54.scopeId then
				return true
			end
		end
	end

	return false
end
local function validateNestedScopeActions(p9, t8: {[any]: any}) -- line: 107
	-- upvalues: scopeHasEntries (copy), Constants (copy)
	for v57, v58 in p9.scopeTours do
		if v58.parentScopeId == nil or not scopeHasEntries(v57, p9) then
			continue
		end

		local openActionKey = v58.openActionKey

		if openActionKey ~= nil and openActionKey ~= "" then
			local closeActionKey = v58.closeActionKey

			if closeActionKey ~= nil and closeActionKey ~= "" then
				continue
			end
		end

		table.insert(t8, `{ Constants.ErrorCodes.NESTED_MISSING_ACTION }:{ v57 }`)
	end
end
local function validateKnownActionKeys(p10, p11, t9: {[any]: any}) -- line: 123
	-- upvalues: ScopeActions (copy), Constants (copy)
	if p11 == nil then
		return
	end

	for _, v65 in ScopeActions.collectRegistryActionKeys(p10) do
		if not p11:has(v65) then
			table.insert(t9, `{ Constants.ErrorCodes.UNKNOWN_ACTION_KEY }:{ v65 }`)
		end
	end
end
local function validateRegistry(p12, t10: {[any]: any}?) -- line: 139
	-- upvalues: validateConstants (copy), validateScopeKeys (copy), validateEntryScopes (copy), validateUniqueEntryIds (copy), validateNestedScopeActions (copy), validateKnownActionKeys (copy)
	local t11 = {}
	local v69 = t10 or {}

	validateConstants(p12, t11)
	validateScopeKeys(p12, t11)
	validateEntryScopes(p12, t11)
	validateUniqueEntryIds(p12, t11)
	validateNestedScopeActions(p12, t11)
	validateKnownActionKeys(p12, v69.scopeActions, t11)

	return {
		errors = t11,
		warnings = {}
	}
end

return validateRegistry
