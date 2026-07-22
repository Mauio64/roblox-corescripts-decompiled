local WhatsNew = script:FindFirstAncestor("WhatsNew")
local Enums = require(WhatsNew.Enums)

require(WhatsNew.Types)

local TourTipCtaAccess = require(WhatsNew.TourTipCtaAccess)
local t1 = {}

local function clientGatesPass(p1, p2) -- line: 14
	-- upvalues: Enums (copy)
	if p1 == Enums.TourType.Onboarding then
		return p2.grandfathered ~= true
	end

	return true
end
local function isNonEmptyString(s1: string?) -- line: 21
	return s1 ~= nil and s1 ~= ""
end
local function isoDateToUnix(s2: string) -- line: 25
	local dateTime = DateTime.fromIsoDate(s2)

	return dateTime and dateTime.UnixTimestamp or nil
end

function t1.isEntryInScopeSubtree(p3, s3: string, t2: {[any]: any}) -- line: 30
	local scopeId = p3.scopeId

	while scopeId ~= nil do
		if scopeId == s3 then
			return true
		end

		local v17 = t2[scopeId]

		if v17 == nil then
			return false
		end

		scopeId = v17.parentScopeId
	end

	return false
end
function t1.isEntryExpired(p4, p5, p6, p7) -- line: 49
	-- upvalues: Enums (copy)
	if p5 == Enums.TourType.Onboarding then
		return false
	end

	if p4.disableTime ~= nil then
		local disableTime = p4.disableTime
		local dateTime = DateTime.fromIsoDate(disableTime)
		local v24 = dateTime and dateTime.UnixTimestamp or nil

		if v24 ~= nil and v24 <= p6.currentTime then
			return true
		end
	end

	if p4.publishedTime ~= nil then
		local publishedTime = p4.publishedTime
		local dateTime = DateTime.fromIsoDate(publishedTime)
		local v27 = dateTime and dateTime.UnixTimestamp or nil

		if v27 ~= nil and v27 + p7.updateEntryDuration * 86400 <= p6.currentTime then
			return true
		end
	end

	return false
end
function t1.deriveEntryDisplay(p8, p9, p10, p11) -- line: 82
	-- upvalues: t1 (copy), Enums (copy)
	local v32 = t1.isEntryExpired(p8, p9, p10, p11)
	local v33 = p10.storage[p8.id]
	local v34 = if not v33 then nil else v33.seen
	local meta = p10.meta
	local v36 = p9 ~= Enums.TourType.Onboarding or meta.grandfathered ~= true

	return {
		id = p8.id,
		scopeId = p8.scopeId,
		title = p8.title,
		text = p8.text,
		icon = p8.icon,
		enabled = p8.enabled,
		publishedTime = p8.publishedTime,
		disableTime = p8.disableTime,
		expired = v32,
		seen = v34,
		optOutCount = not v33 and 0 or v33.optOutCount,
		adopted = not not v33 and v33.adopted,
		toShow = p8.enabled and (not v32 and (v34 == nil and v36))
	}
end
function t1.getLabels(p12, p13) -- line: 111
	-- upvalues: Enums (copy)
	if p13 == Enums.TourType.Onboarding then
		return {
			title = p12.onboardingTitle or "",
			text = p12.onboardingText or ""
		}
	end

	return {
		title = p12.updatesTitle or "",
		text = p12.updatesText or ""
	}
end
function t1.hasLabels(p14) -- line: 125
	local title = p14.title
	local v41 = title ~= nil and title ~= ""

	if not v41 then
		local text = p14.text

		v41 = text ~= nil and text ~= ""
	end

	return v41
end
function t1.countScopeSteps(p15) -- line: 129
	-- upvalues: TourTipCtaAccess (copy), Enums (copy), t1 (copy)
	local n1 = 0

	for _, v46 in p15.tourTips do
		local v47 = TourTipCtaAccess.wrap(v46.cta)

		n1 = if v47:getKind() ~= Enums.TourTipCtaKind.Nested then n1 + v46.stepCount else n1 + (1 + t1.countScopeSteps(v47:getScope()))
	end

	return n1
end

return t1
