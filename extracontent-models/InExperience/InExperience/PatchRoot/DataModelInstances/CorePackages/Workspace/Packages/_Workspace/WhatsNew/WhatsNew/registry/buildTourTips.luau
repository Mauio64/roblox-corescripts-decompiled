local WhatsNew = script:FindFirstAncestor("WhatsNew")
local Constants = require(WhatsNew.Constants)

require(WhatsNew.Types)

local TourTipCtaAccess = require(WhatsNew.TourTipCtaAccess)
local DeriveResolvedFields = require(script.Parent.DeriveResolvedFields)

local function appendWarning(t1: {[any]: any}?, s1: string, s2: string) -- line: 34
	if t1 == nil then
		return
	end

	table.insert(t1, `{ s1 }:{ s2 }`)
end
local function createBuildContext(p1, p2, s3: string, p3, t2: {[any]: any}?) -- line: 41
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
local function filterEntriesInSubtree(t3: {[any]: any}, t4: {[any]: any}) -- line: 60
	-- upvalues: DeriveResolvedFields (copy)
	local t5 = {}

	for _, v34 in t3 do
		if DeriveResolvedFields.isEntryInScopeSubtree(v34, t4.screenScopeId, t4.scopeTours) then
			table.insert(t5, v34)
		end
	end

	return t5
end
local function groupEntriesByScopeId(t6: {[any]: any}) -- line: 70
	local t7 = {}

	for _, v38 in t6 do
		local v39 = t7[v38.scopeId]

		if v39 == nil then
			v39 = {}
			t7[v38.scopeId] = v39
		end

		table.insert(v39, v38)
	end

	return t7
end
local function collectRelevantScopeIds(s4: string, t8: {[any]: any}, t9: {[any]: any}) -- line: 83
	local t10 = {
		[s4] = true
	}

	local function addAncestorChain(s5: string) -- line: 92
		-- upvalues: t10 (copy), s4 (copy), t9 (copy)
		while s5 ~= nil and not t10[s5] do
			t10[s5] = true

			if s5 == s4 then
				return
			end

			local v147 = t9[s5]

			s5 = if not v147 then nil else v147.parentScopeId
		end
	end

	for v45 in t8 do
		addAncestorChain(v45)
	end

	local t11 = {}

	for v47 in t10 do
		table.insert(t11, v47)
	end

	return t11
end
local function buildEmptyScopeTree(t12: {[any]: any}, t13: {[any]: any}) -- line: 119
	local t14 = {}

	for _, v52 in t12 do
		local v53 = t13[v52]

		t14[v52] = {
			id = v52,
			parentScopeId = if not v53 then nil else v53.parentScopeId,
			tourTips = {}
		}
	end

	return t14
end
local function tryConsumeSteps(t15: {[any]: any}, n1: number) -- line: 135
	if n1 > t15.globalRemaining then
		return false
	end

	t15.globalRemaining = t15.globalRemaining - n1

	return true
end
local function markTruncated(t16: {[any]: any}, t17: {[any]: any}?, s6: string) -- line: 143
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
local function getScopePathFromScreen(s7: string, s8: string, t18: {[any]: any}) -- line: 151
	local t19 = {}

	while s7 ~= nil do
		table.insert(t19, 1, s7)

		if s7 == s8 then
			return t19
		end

		local v64 = t18[s7]

		s7 = if not v64 then nil else v64.parentScopeId
	end

	return t19
end
local function entryToTourTip(p4, p5) -- line: 170
	-- upvalues: TourTipCtaAccess (copy)
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
		align = p5.align,
		cta = TourTipCtaAccess.none()
	}
end
local function buildNestedGatewayTip(p6, p7, p8) -- line: 193
	-- upvalues: DeriveResolvedFields (copy), TourTipCtaAccess (copy)
	local v70 = p6.openActionKey or ""
	local v71 = p6.closeActionKey or ""
	local v72 = p6.anchorId or ""
	local v73 = DeriveResolvedFields.countScopeSteps(p7)

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
		id = `gateway:{ p6.id }`,
		scopeId = p6.parentScopeId or p6.id,
		title = p8.title,
		text = p8.text,
		anchorId = v72,
		stepCount = 1 + v73,
		side = p6.side,
		align = p6.align,
		cta = TourTipCtaAccess.nested(v70, v71, p7)
	}
end
local function refreshGatewayStepCount(t20: {[any]: any}, p9) -- line: 225
	-- upvalues: DeriveResolvedFields (copy)
	local v76 = 1 + DeriveResolvedFields.countScopeSteps(p9)

	t20.tip.stepCount = v76
end
local function ensureNestedGateway(s9: string, s10: string, t21: {[any]: any}, t22: {[any]: any}, t23: {[any]: any}, t24: {[any]: any}) -- line: 230
	-- upvalues: Constants (copy), DeriveResolvedFields (copy), buildNestedGatewayTip (copy)
	if t22[s10] ~= nil then
		return true
	end

	local v83 = t24.scopeTours[s10]

	if v83 == nil then
		return false
	end

	local v84

	if t23.globalRemaining < 1 then
		v84 = false
	else
		t23.globalRemaining = t23.globalRemaining - 1
		v84 = true
	end

	if not v84 then
		local warnings = t24.warnings
		local screenScopeId = t24.screenScopeId

		if not t23.truncated then
			t23.truncated = true

			local TOUR_TIPS_TRUNCATED = Constants.WarningCodes.TOUR_TIPS_TRUNCATED

			if warnings ~= nil then
				table.insert(warnings, `{ TOUR_TIPS_TRUNCATED }:{ screenScopeId }`)
			end
		end

		return false
	end

	local v88 = DeriveResolvedFields.getLabels(v83, t24.tourType)

	if not DeriveResolvedFields.hasLabels(v88) then
		local warnings = t24.warnings
		local GATEWAY_COPY_FALLBACK = Constants.WarningCodes.GATEWAY_COPY_FALLBACK

		if warnings ~= nil then
			table.insert(warnings, `{ GATEWAY_COPY_FALLBACK }:{ s10 }`)
		end
	end

	local v91 = t21[s10]
	local v92 = buildNestedGatewayTip(v83, v91, v88)

	table.insert(t21[s9].tourTips, v92)
	t22[s10] = {
		parentScopeId = s9,
		tip = v92
	}

	return true
end
local function addPlainTipToScope(s11: string, p10, t25: {[any]: any}, t26: {[any]: any}, t27: {[any]: any}, t28: {[any]: any}) -- line: 267
	-- upvalues: Constants (copy), DeriveResolvedFields (copy)
	local v99

	if t27.globalRemaining < 1 then
		v99 = false
	else
		t27.globalRemaining = t27.globalRemaining - 1
		v99 = true
	end

	if not v99 then
		local warnings = t28.warnings
		local screenScopeId = t28.screenScopeId

		if not t27.truncated then
			t27.truncated = true

			local TOUR_TIPS_TRUNCATED = Constants.WarningCodes.TOUR_TIPS_TRUNCATED

			if warnings ~= nil then
				table.insert(warnings, `{ TOUR_TIPS_TRUNCATED }:{ screenScopeId }`)
			end
		end

		return false
	end

	table.insert(t25[s11].tourTips, p10)

	local v103 = t26[s11]

	if v103 ~= nil then
		local v104 = t25[s11]
		local v105 = 1 + DeriveResolvedFields.countScopeSteps(v104)

		v103.tip.stepCount = v105
	end

	return true
end
local function ensureScopeChainForEntry(s12: string, t29: {[any]: any}, t30: {[any]: any}, t31: {[any]: any}, t32: {[any]: any}) -- line: 290
	-- upvalues: getScopePathFromScreen (copy), ensureNestedGateway (copy)
	local v111 = getScopePathFromScreen(s12, t32.screenScopeId, t32.scopeTours)

	for i = 1, #v111 - 1 do
		local v113 = v111[i]
		local v114 = v111[i + 1]

		if not ensureNestedGateway(v113, v114, t29, t30, t31, t32) then
			return false
		end
	end

	return true
end
local function buildScopeTourForScreen(t33: {[any]: any}, t34: {[any]: any}) -- line: 308
	-- upvalues: filterEntriesInSubtree (copy), groupEntriesByScopeId (copy), collectRelevantScopeIds (copy), buildEmptyScopeTree (copy), DeriveResolvedFields (copy), ensureScopeChainForEntry (copy), entryToTourTip (copy), Constants (copy)
	local v117 = t33.scopeTours[t33.screenScopeId]
	local v118 = if not v117 then nil else v117.parentScopeId
	local maxTourTips = t33.constants.maxTourTips
	local v120 = filterEntriesInSubtree(t34, t33)
	local v121 = groupEntriesByScopeId(v120)
	local v122 = collectRelevantScopeIds(t33.screenScopeId, v121, t33.scopeTours)
	local v123 = buildEmptyScopeTree(v122, t33.scopeTours)
	local t35 = {
		truncated = false,
		globalRemaining = maxTourTips
	}
	local t36 = {}

	for _, v127 in v120 do
		local v128 = DeriveResolvedFields.deriveEntryDisplay(v127, t33.tourType, t33.deps, t33.constants)

		if v128.toShow and ensureScopeChainForEntry(v127.scopeId, v123, t36, t35, t33) then
			local v129 = entryToTourTip(v128, v127)
			local scopeId = v127.scopeId
			local v131

			if t35.globalRemaining < 1 then
				v131 = false
			else
				t35.globalRemaining = t35.globalRemaining - 1
				v131 = true
			end

			if not v131 then
				local warnings = t33.warnings
				local screenScopeId = t33.screenScopeId

				if not t35.truncated then
					t35.truncated = true

					local TOUR_TIPS_TRUNCATED = Constants.WarningCodes.TOUR_TIPS_TRUNCATED

					if warnings ~= nil then
						table.insert(warnings, `{ TOUR_TIPS_TRUNCATED }:{ screenScopeId }`)
					end
				end
			else
				table.insert(v123[scopeId].tourTips, v129)

				local v135 = t36[scopeId]

				if v135 ~= nil then
					local v136 = v123[scopeId]
					local v137 = 1 + DeriveResolvedFields.countScopeSteps(v136)

					v135.tip.stepCount = v137
				end
			end
		end
	end

	local v138 = v123[t33.screenScopeId]

	if v138 == nil then
		return {
			truncated = false,
			globalTotalSteps = 0,
			scope = {
				id = t33.screenScopeId,
				parentScopeId = v118,
				tourTips = {}
			}
		}
	end

	return {
		scope = v138,
		truncated = t35.truncated,
		globalTotalSteps = DeriveResolvedFields.countScopeSteps(v138)
	}
end
local function buildTourTips(p11, p12, s13: string, p13, t37: {[any]: any}, t38: {[any]: any}?) -- line: 361
	-- upvalues: buildScopeTourForScreen (copy)
	local t39 = {
		document = p11,
		deps = p12,
		screenScopeId = s13,
		tourType = p13,
		warnings = t38,
		constants = p11.constants,
		scopeTours = p11.scopeTours
	}

	return (buildScopeTourForScreen(t39, t37))
end

return buildTourTips
