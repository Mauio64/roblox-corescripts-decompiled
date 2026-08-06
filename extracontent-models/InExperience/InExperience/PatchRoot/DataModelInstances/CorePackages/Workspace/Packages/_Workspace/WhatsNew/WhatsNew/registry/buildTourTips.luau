local WhatsNew = script:FindFirstAncestor("WhatsNew")
local Constants = require(WhatsNew.Constants)

require(WhatsNew.Types)

local DeriveResolvedFields = require(script.Parent.DeriveResolvedFields)

local function appendWarning(t1: {[any]: any}?, s1: string, s2: string) -- line: 33
	if t1 == nil then
		return
	end

	table.insert(t1, `{ s1 }:{ s2 }`)
end
local function createBuildContext(p1, p2, s3: string, p3, t2: {[any]: any}?) -- line: 40
	return {
		document = p1,
		deps = p2,
		screenScopeId = s3,
		tourType = p3,
		warnings = t2,
		constants = p1.constants,
		scopeTours = p1.scopeTours
	}
end
local function filterEntriesInSubtree(t3: {[any]: any}, t4: {[any]: any}) -- line: 59
	-- upvalues: DeriveResolvedFields (copy)
	local t5 = {}

	for _, v32 in t3 do
		if DeriveResolvedFields.isEntryInScopeSubtree(v32, t4.screenScopeId, t4.scopeTours) then
			table.insert(t5, v32)
		end
	end

	return t5
end
local function groupEntriesByScopeId(t6: {[any]: any}) -- line: 69
	local t7 = {}

	for _, v36 in t6 do
		local v37 = t7[v36.scopeId]

		if v37 == nil then
			v37 = {}
			t7[v36.scopeId] = v37
		end

		table.insert(v37, v36)
	end

	return t7
end
local function collectRelevantScopeIds(s4: string, t8: {[any]: any}, t9: {[any]: any}) -- line: 82
	local t10 = {
		[s4] = true
	}

	local function addAncestorChain(s5: string) -- line: 91
		-- upvalues: t10 (copy), s4 (copy), t9 (copy)
		while s5 ~= nil and not t10[s5] do
			t10[s5] = true

			if s5 == s4 then
				return
			end

			local v134 = t9[s5]

			s5 = if not v134 then nil else v134.parentScopeId
		end
	end

	for v43 in t8 do
		addAncestorChain(v43)
	end

	local t11 = {}

	for v45 in t10 do
		table.insert(t11, v45)
	end

	return t11
end
local function buildEmptyScopeTree(t12: {[any]: any}, t13: {[any]: any}) -- line: 118
	local t14 = {}

	for _, v50 in t12 do
		local v51 = t13[v50]

		t14[v50] = {
			id = v50,
			parentScopeId = if not v51 then nil else v51.parentScopeId,
			tourTips = {}
		}
	end

	return t14
end
local function tryConsumeSteps(t15: {[any]: any}, n1: number) -- line: 134
	if n1 > t15.globalRemaining then
		return false
	end

	t15.globalRemaining = t15.globalRemaining - n1

	return true
end
local function markTruncated(t16: {[any]: any}, t17: {[any]: any}?, s6: string) -- line: 142
	-- upvalues: Constants (copy)
	if t16.truncated then
		return
	end

	t16.truncated = true

	local TOUR_TIPS_TRUNCATED = Constants.WarningCodes.TOUR_TIPS_TRUNCATED

	if t17 == nil then
		return
	end

	table.insert(t17, `{ TOUR_TIPS_TRUNCATED }:{ s6 }`)
end
local function getScopePathFromScreen(s7: string, s8: string, t18: {[any]: any}) -- line: 150
	local t19 = {}

	while s7 ~= nil do
		table.insert(t19, 1, s7)

		if s7 == s8 then
			return t19
		end

		local v62 = t18[s7]

		s7 = if not v62 then nil else v62.parentScopeId
	end

	return t19
end
local function entryToTourTip(p4, p5) -- line: 169
	return {
		stepCount = 1,
		id = p4.id,
		scopeId = p4.scopeId,
		title = p4.title,
		text = p4.text,
		icon = p4.icon,
		enabled = p4.enabled,
		publishedTime = p4.publishedTime,
		disableTime = p4.disableTime,
		expired = p4.expired,
		seen = p4.seen,
		optOutCount = p4.optOutCount,
		adopted = p4.adopted,
		toShow = p4.toShow,
		anchorId = p5.anchorId,
		side = p5.side,
		align = p5.align
	}
end
local function buildNestedGatewayTip(p6, p7, p8) -- line: 191
	local v68 = p6.openActionKey or ""
	local v69 = p6.closeActionKey or ""
	local v70 = p6.anchorId or ""

	return {
		icon = nil,
		enabled = true,
		publishedTime = nil,
		disableTime = nil,
		expired = false,
		seen = nil,
		optOutCount = 0,
		adopted = false,
		toShow = true,
		stepCount = 1,
		id = `gateway:{ p6.id }`,
		scopeId = p6.parentScopeId or p6.id,
		title = p8.title,
		text = p8.text,
		anchorId = v70,
		side = p6.side,
		align = p6.align,
		gateway = {
			openActionKey = v68,
			closeActionKey = v69,
			scope = p7
		}
	}
end
local function addPlainTipToScope(s9: string, p9, t20: {[any]: any}, _: {[any]: any}, t22: {[any]: any}, t23: {[any]: any}) -- line: 226
	-- upvalues: Constants (copy)
	local v77

	if t22.globalRemaining < 1 then
		v77 = false
	else
		t22.globalRemaining = t22.globalRemaining - 1
		v77 = true
	end

	if not v77 then
		local warnings = t23.warnings
		local screenScopeId = t23.screenScopeId

		if not t22.truncated then
			t22.truncated = true

			local TOUR_TIPS_TRUNCATED = Constants.WarningCodes.TOUR_TIPS_TRUNCATED

			if warnings ~= nil then
				table.insert(warnings, `{ TOUR_TIPS_TRUNCATED }:{ screenScopeId }`)
			end
		end

		return false
	end

	table.insert(t20[s9].tourTips, p9)

	return true
end
local function ensureNestedGateway(s10: string, s11: string, t24: {[any]: any}, t25: {[any]: any}, t26: {[any]: any}, t27: {[any]: any}) -- line: 243
	-- upvalues: Constants (copy), DeriveResolvedFields (copy), buildNestedGatewayTip (copy)
	if t25[s11] ~= nil then
		return true
	end

	local v87 = t27.scopeTours[s11]

	if v87 == nil then
		return false
	end

	local v88

	if t26.globalRemaining < 1 then
		v88 = false
	else
		t26.globalRemaining = t26.globalRemaining - 1
		v88 = true
	end

	if not v88 then
		local warnings = t27.warnings
		local screenScopeId = t27.screenScopeId

		if not t26.truncated then
			t26.truncated = true

			local TOUR_TIPS_TRUNCATED = Constants.WarningCodes.TOUR_TIPS_TRUNCATED

			if warnings ~= nil then
				table.insert(warnings, `{ TOUR_TIPS_TRUNCATED }:{ screenScopeId }`)
			end
		end

		return false
	end

	local v92 = DeriveResolvedFields.getLabels(v87, t27.tourType)

	if not DeriveResolvedFields.hasLabels(v92) then
		local warnings = t27.warnings
		local GATEWAY_COPY_FALLBACK = Constants.WarningCodes.GATEWAY_COPY_FALLBACK

		if warnings ~= nil then
			table.insert(warnings, `{ GATEWAY_COPY_FALLBACK }:{ s11 }`)
		end
	end

	local v95 = t24[s11]
	local v96 = buildNestedGatewayTip(v87, v95, v92)

	table.insert(t24[s10].tourTips, v96)
	t25[s11] = {
		parentScopeId = s10,
		tip = v96
	}

	return true
end
local function ensureScopeChainForEntry(s12: string, t28: {[any]: any}, t29: {[any]: any}, t30: {[any]: any}, t31: {[any]: any}) -- line: 280
	-- upvalues: getScopePathFromScreen (copy), ensureNestedGateway (copy)
	local v102 = getScopePathFromScreen(s12, t31.screenScopeId, t31.scopeTours)

	for i = 1, #v102 - 1 do
		local v104 = v102[i]
		local v105 = v102[i + 1]

		if not ensureNestedGateway(v104, v105, t28, t29, t30, t31) then
			return false
		end
	end

	return true
end
local function buildScopeTourForScreen(t32: {[any]: any}, t33: {[any]: any}) -- line: 298
	-- upvalues: filterEntriesInSubtree (copy), groupEntriesByScopeId (copy), collectRelevantScopeIds (copy), buildEmptyScopeTree (copy), DeriveResolvedFields (copy), ensureScopeChainForEntry (copy), entryToTourTip (copy), Constants (copy)
	local v108 = t32.scopeTours[t32.screenScopeId]
	local v109 = if not v108 then nil else v108.parentScopeId
	local maxTourTips = t32.constants.maxTourTips
	local v111 = filterEntriesInSubtree(t33, t32)
	local v112 = groupEntriesByScopeId(v111)
	local v113 = collectRelevantScopeIds(t32.screenScopeId, v112, t32.scopeTours)
	local v114 = buildEmptyScopeTree(v113, t32.scopeTours)
	local t34 = {
		truncated = false,
		globalRemaining = maxTourTips
	}

	for _, v117 in v111 do
		local v118 = DeriveResolvedFields.deriveEntryDisplay(v117, t32.tourType, t32.deps, t32.constants)

		if v118.toShow and ensureScopeChainForEntry(v117.scopeId, v114, {}, t34, t32) then
			local v119 = entryToTourTip(v118, v117)
			local scopeId = v117.scopeId
			local v121

			if t34.globalRemaining < 1 then
				v121 = false
			else
				t34.globalRemaining = t34.globalRemaining - 1
				v121 = true
			end

			if not v121 then
				local warnings = t32.warnings
				local screenScopeId = t32.screenScopeId

				if not t34.truncated then
					t34.truncated = true

					local TOUR_TIPS_TRUNCATED = Constants.WarningCodes.TOUR_TIPS_TRUNCATED

					if warnings ~= nil then
						table.insert(warnings, `{ TOUR_TIPS_TRUNCATED }:{ screenScopeId }`)
					end
				end
			else
				table.insert(v114[scopeId].tourTips, v119)
			end
		end
	end

	local v125 = v114[t32.screenScopeId]

	if v125 == nil then
		return {
			truncated = false,
			globalTotalSteps = 0,
			scope = {
				id = t32.screenScopeId,
				parentScopeId = v109,
				tourTips = {}
			}
		}
	end

	return {
		scope = v125,
		truncated = t34.truncated,
		globalTotalSteps = DeriveResolvedFields.countScopeSteps(v125)
	}
end
local function buildTourTips(p10, p11, s13: string, p12, t35: {[any]: any}, t36: {[any]: any}?) -- line: 351
	-- upvalues: buildScopeTourForScreen (copy)
	local t37 = {
		document = p10,
		deps = p11,
		screenScopeId = s13,
		tourType = p12,
		warnings = t36,
		constants = p10.constants,
		scopeTours = p10.scopeTours
	}

	return (buildScopeTourForScreen(t37, t35))
end

return buildTourTips
