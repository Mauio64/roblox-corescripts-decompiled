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

	for v30, v31 in {
		textMaxLength = constants.textMaxLength,
		updateEntryDuration = constants.updateEntryDuration,
		maxTourTips = constants.maxTourTips,
		maxEntriesPerMenu = constants.maxEntriesPerMenu,
		maxOptOutCount = constants.maxOptOutCount
	} do
		if typeof(v31) ~= "number" or v31 <= 0 then
			table.insert(t3, `{ Constants.ErrorCodes.INVALID_CONSTANTS }:{ `{ v30 }` }`)
		end
	end
end
local function validateScopeKeys(p4, t4: {[any]: any}) -- line: 57
	-- upvalues: Constants (copy)
	for v34, v35 in p4.scopeTours do
		if v34 ~= v35.id then
			table.insert(t4, `{ Constants.ErrorCodes.SCOPE_KEY_MISMATCH }:{ `{ v34 }->{ v35.id }` }`)
		end
	end
end
local function validateEntryScopes(p5, t5: {[any]: any}) -- line: 65
	-- upvalues: Constants (copy), Enums (copy)
	local function validateEntries(t6: {[any]: any}, p6) -- line: 66
		-- upvalues: p5 (copy), t5 (copy), Constants (copy)
		for _, v91 in t6 do
			if p5.scopeTours[v91.scopeId] == nil then
				table.insert(t5, `{ Constants.ErrorCodes.UNKNOWN_SCOPE }:{ `{ v91.id } ({ p6 })` }`)
			end

			if #v91.text > p5.constants.textMaxLength then
				table.insert(t5, `{ Constants.ErrorCodes.TEXT_TOO_LONG }:{ `{ v91.id } ({ p6 })` }`)
			end
		end
	end

	for _, v40 in Enums.TourTypeList do
		validateEntries(if v40 ~= Enums.TourType.WhatsNew then p5.onboarding else p5.whatsNew, v40)
	end
end
local function validateUniqueEntryIds(p7, t7: {[any]: any}) -- line: 83
	-- upvalues: Enums (copy), Constants (copy)
	for _, v44 in Enums.TourTypeList do
		local t8 = {}
		local whatsNew, v47, v48

		if v44 == Enums.TourType.WhatsNew then
			whatsNew = p7.whatsNew
			v47 = nil
			v48 = nil
		else
			whatsNew = p7.onboarding
			v47 = nil
			v48 = nil
		end

		for _, v50 in whatsNew, v47, v48 do
			if t8[v50.id] then
				table.insert(t7, `{ Constants.ErrorCodes.DUPLICATE_ENTRY_ID }:{ `{ v50.id } ({ v44 })` }`)
			else
				t8[v50.id] = true
			end
		end
	end
end
local function scopeHasEntries(s6: string, p8) -- line: 96
	-- upvalues: Enums (copy)
	for _, v54 in Enums.TourTypeList do
		local whatsNew, v56, v57

		if v54 == Enums.TourType.WhatsNew then
			whatsNew = p8.whatsNew
			v56 = nil
			v57 = nil
		else
			whatsNew = p8.onboarding
			v56 = nil
			v57 = nil
		end

		for _, v59 in whatsNew, v56, v57 do
			if s6 == v59.scopeId then
				return true
			end
		end
	end

	return false
end
local function validateNestedScopeActions(p9, t9: {[any]: any}) -- line: 108
	-- upvalues: scopeHasEntries (copy), Constants (copy)
	for v62, v63 in p9.scopeTours do
		if v63.parentScopeId == nil or not scopeHasEntries(v62, p9) then
			continue
		end

		local openActionKey = v63.openActionKey

		if openActionKey ~= nil and openActionKey ~= "" then
			local closeActionKey = v63.closeActionKey

			if closeActionKey ~= nil and closeActionKey ~= "" then
				continue
			end
		end

		table.insert(t9, `{ Constants.ErrorCodes.NESTED_MISSING_ACTION }:{ v62 }`)
	end
end
local function validateKnownActionKeys(p10, p11, t10: {[any]: any}) -- line: 124
	-- upvalues: ScopeActions (copy), Constants (copy)
	if p11 == nil then
		return
	end

	for _, v70 in ScopeActions.collectRegistryActionKeys(p10) do
		if not p11:has(v70) then
			table.insert(t10, `{ Constants.ErrorCodes.UNKNOWN_ACTION_KEY }:{ v70 }`)
		end
	end
end
local function validateMenuGroupDeferred(t11: {[any]: any}, p12, t12: {[any]: any}) -- line: 140
	-- upvalues: Constants (copy)
	local t13 = {}

	for _, v76 in t11 do
		if v76.enabled then
			local v77 = `{ v76.scopeId }:{ v76.anchorId }`
			local v78 = t13[v77]

			if v78 == nil then
				v78 = {}
				t13[v77] = v78
			end

			table.insert(v78, v76.id)
		end
	end

	for v79, v80 in t13 do
		if #v80 >= 2 then
			table.insert(t12, `{ Constants.WarningCodes.MENU_GROUP_DEFERRED }:{ `{ p12 }:{ v79 }` }`)
		end
	end
end
local function validateRegistry(p13, t14: {[any]: any}?) -- line: 168
	-- upvalues: validateConstants (copy), validateScopeKeys (copy), validateEntryScopes (copy), validateUniqueEntryIds (copy), validateNestedScopeActions (copy), validateKnownActionKeys (copy), Enums (copy), validateMenuGroupDeferred (copy)
	local t15 = {}
	local t16 = {}
	local v85 = t14 or {}

	validateConstants(p13, t15)
	validateScopeKeys(p13, t15)
	validateEntryScopes(p13, t15)
	validateUniqueEntryIds(p13, t15)
	validateNestedScopeActions(p13, t15)
	validateKnownActionKeys(p13, v85.scopeActions, t15)

	for _, v87 in Enums.TourTypeList do
		validateMenuGroupDeferred(if v87 ~= Enums.TourType.WhatsNew then p13.onboarding else p13.whatsNew, v87, t16)
	end

	return {
		errors = t15,
		warnings = t16
	}
end

return validateRegistry
