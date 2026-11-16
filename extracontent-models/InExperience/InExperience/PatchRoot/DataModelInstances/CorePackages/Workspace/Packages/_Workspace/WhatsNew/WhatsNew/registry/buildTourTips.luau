local WhatsNew = script:FindFirstAncestor("WhatsNew")
local Constants = require(WhatsNew.Constants)
require(WhatsNew.Types)
local DeriveResolvedFields = require(script.Parent.DeriveResolvedFields)

local function appendWarning(list, p: string, p2: string) -- 2 equivalent calls inferred from this helper
	if list == nil then
		return
	end

	table.insert(list, `{p}:{p2}`)
end

local function createBuildContext(document, deps, screenScopeId: string, tourType, warnings) -- 1 equivalent call inferred from this helper
	return {
		document = document,
		deps = deps,
		screenScopeId = screenScopeId,
		tourType = tourType,
		warnings = warnings,
		constants = document.constants,
		scopeTours = document.scopeTours
	}
end

local function filterEntriesInSubtree(items, data)
	local result = {}

	for _, item in items do
		if DeriveResolvedFields.isEntryInScopeSubtree(item, data.screenScopeId, data.scopeTours) then
			table.insert(result, item)
		end
	end

	return result
end

local function groupEntriesByScopeId(items)
	local result = {}

	for _, item in items do
		local v = result[item.scopeId]

		if v == nil then
			v = {}
			result[item.scopeId] = v
		end

		table.insert(v, item)
	end

	return result
end

local function collectRelevantScopeIds(screenScopeId: string, items, scopeTours)
	local v = { [screenScopeId] = true }

	local function addAncestorChain(k: string)
		while k ~= nil and not v[k] do
			v[k] = true

			if k == screenScopeId then
				break
			end

			local v2 = scopeTours[k]
			k = if v2 then v2.parentScopeId else nil
		end
	end

	for k in items do
		addAncestorChain(k)
	end

	local relevantScopeIds = {}

	for k in v do
		table.insert(relevantScopeIds, k)
	end

	return relevantScopeIds
end

local function buildEmptyScopeTree(items, scopeTours)
	local emptyScopeTree = {}

	for _, item in items do
		local v = scopeTours[item]
		local parentScopeId

		if v then
			parentScopeId = v.parentScopeId
		end

		emptyScopeTree[item] = { id = item, parentScopeId = parentScopeId, tourTips = {} }
	end

	return emptyScopeTree
end

local function tryConsumeSteps(p, p2: number): boolean -- 2 equivalent calls inferred from this helper
	if p.globalRemaining < p2 then
		return false
	end

	p.globalRemaining -= p2
	return true
end

local function markTruncated(p, warnings, screenScopeId: string) -- 2 equivalent calls inferred from this helper
	if p.truncated then
		return
	end

	p.truncated = true
	appendWarning(warnings, Constants.WarningCodes.TOUR_TIPS_TRUNCATED, screenScopeId) -- inferred equivalent call
end

local function getScopePathFromScreen(p: string, screenScopeId: string, scopeTours)
	local scopePath = {}

	while p ~= nil do
		table.insert(scopePath, 1, p)

		if p == screenScopeId then
			break
		end

		local v = scopeTours[p]
		p = if v then v.parentScopeId else nil
	end

	return scopePath
end

local function entryToTourTip(data, data2)
	return {
		id = data.id,
		scopeId = data.scopeId,
		title = data.title,
		text = data.text,
		icon = data.icon,
		enabled = data.enabled,
		publishedTime = data.publishedTime,
		disabledTime = data.disabledTime,
		expired = data.expired,
		seen = data.seen,
		optOutCount = data.optOutCount,
		adopted = data.adopted,
		toShow = data.toShow,
		anchorId = data2.anchorId,
		stepCount = 1,
		side = data2.side,
		align = data2.align
	}
end

local function buildNestedGatewayTip(scopeTour, scope, labels)
	local openActionKey = scopeTour.openActionKey or ""
	local closeActionKey = scopeTour.closeActionKey or ""
	local anchorId = scopeTour.anchorId or ""

	return {
		id = `gateway:{scopeTour.id}`,
		scopeId = scopeTour.parentScopeId or scopeTour.id,
		title = labels.title,
		text = labels.text,
		icon = nil,
		enabled = true,
		publishedTime = nil,
		disabledTime = nil,
		expired = false,
		seen = nil,
		optOutCount = 0,
		adopted = false,
		toShow = true,
		anchorId = anchorId,
		stepCount = 1,
		side = scopeTour.side,
		align = scopeTour.align,
		gateway = { openActionKey = openActionKey, closeActionKey = closeActionKey, scope = scope }
	}
end

local function addPlainTipToScope(scopeId: string, p, emptyScopeTree, _, p2, data): boolean -- 1 equivalent call inferred from this helper
	if tryConsumeSteps(p2, 1) then -- inferred equivalent call
		table.insert(emptyScopeTree[scopeId].tourTips, p)
		return true
	end

	markTruncated(p2, data.warnings, data.screenScopeId) -- inferred equivalent call
	return false
end

local function ensureNestedGateway(parentScopeId: string, p: string, p2, p3, p4, data): boolean
	if p3[p] ~= nil then
		return true
	end

	local scopeTour = data.scopeTours[p]

	if scopeTour == nil then
		return false
	end

	if tryConsumeSteps(p4, 1) then -- inferred equivalent call
		local labels = DeriveResolvedFields.getLabels(scopeTour, data.tourType)

		if not DeriveResolvedFields.hasLabels(labels) then
			appendWarning(data.warnings, Constants.WarningCodes.GATEWAY_COPY_FALLBACK, p) -- inferred equivalent call
		end

		local nestedGatewayTip = buildNestedGatewayTip(scopeTour, p2[p], labels)
		table.insert(p2[parentScopeId].tourTips, nestedGatewayTip)
		p3[p] = { parentScopeId = parentScopeId, tip = nestedGatewayTip }

		return true
	end

	markTruncated(p4, data.warnings, data.screenScopeId) -- inferred equivalent call
	return false
end

local function ensureScopeChainForEntry(scopeId: string, emptyScopeTree, p, p2, data): boolean
	local scopePathFromScreen = getScopePathFromScreen(scopeId, data.screenScopeId, data.scopeTours)

	for i = 1, #scopePathFromScreen - 1 do
		if not ensureNestedGateway(scopePathFromScreen[i], scopePathFromScreen[i + 1], emptyScopeTree, p, p2, data) then
			return false
		end
	end

	return true
end

local function buildScopeTourForScreen(data, p)
	local scopeTour = data.scopeTours[data.screenScopeId]
	local parentScopeId

	if scopeTour then
		parentScopeId = scopeTour.parentScopeId
	end

	local maxTourTips = data.constants.maxTourTips

	local v = filterEntriesInSubtree(p, data)
	local v2 = groupEntriesByScopeId(v)
	local emptyScopeTree = buildEmptyScopeTree(
		collectRelevantScopeIds(data.screenScopeId, v2, data.scopeTours),
		data.scopeTours
	)

	local v3 = {}
	local v4 = { globalRemaining = maxTourTips, truncated = false }

	for _, v5 in v do
		local entryDisplay = DeriveResolvedFields.deriveEntryDisplay(v5, data.tourType, data.deps)

		if not (entryDisplay.toShow and ensureScopeChainForEntry(v5.scopeId, emptyScopeTree, v3, v4, data)) then
			continue
		end

		local v6 = entryToTourTip(entryDisplay, v5)
		addPlainTipToScope(v5.scopeId, v6, emptyScopeTree, nil, v4, data) -- inferred equivalent call
	end

	local scope = emptyScopeTree[data.screenScopeId]

	if scope == nil then
		return {
			scope = { id = data.screenScopeId, parentScopeId = parentScopeId, tourTips = {} },
			truncated = false,
			globalTotalSteps = 0
		}
	end

	return {
		scope = scope,
		truncated = v4.truncated,
		globalTotalSteps = DeriveResolvedFields.countScopeSteps(scope)
	}
end

local function buildTourTips(document, deps, screenScopeId: string, tourType, p, warnings)
	return buildScopeTourForScreen(createBuildContext(document, deps, screenScopeId, tourType, warnings), p) -- inferred equivalent call
end

return buildTourTips
