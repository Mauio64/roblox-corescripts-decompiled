local WhatsNew = script:FindFirstAncestor("WhatsNew")
local Enums = require(WhatsNew.Enums)

require(WhatsNew.Types)

local t1 = {}

local function clientGatesPass(p1, p2) -- line: 13
	-- upvalues: Enums (copy)
	if p1 == Enums.TourType.Onboarding then
		return p2.grandfathered ~= true
	end

	return true
end
local function isNonEmptyString(s1: string?) -- line: 20
	return s1 ~= nil and s1 ~= ""
end
local function isoDateToUnix(s2: string) -- line: 24
	local dateTime = DateTime.fromIsoDate(s2)

	return dateTime and dateTime.UnixTimestamp or nil
end

function t1.isEntryInScopeSubtree(p3, s3: string, t2: {[any]: any}) -- line: 29
	local scopeId = p3.scopeId

	while scopeId ~= nil do
		if scopeId == s3 then
			return true
		end

		local v16 = t2[scopeId]

		if v16 == nil then
			return false
		end

		scopeId = v16.parentScopeId
	end

	return false
end
function t1.isEntryExpired(p4, p5, p6, p7) -- line: 48
	-- upvalues: Enums (copy)
	if p5 == Enums.TourType.Onboarding then
		return false
	end

	if p4.disableTime ~= nil then
		local disableTime = p4.disableTime
		local dateTime = DateTime.fromIsoDate(disableTime)
		local v23 = dateTime and dateTime.UnixTimestamp or nil

		if v23 ~= nil and v23 <= p6.currentTime then
			return true
		end
	end

	if p4.publishedTime ~= nil then
		local publishedTime = p4.publishedTime
		local dateTime = DateTime.fromIsoDate(publishedTime)
		local v26 = dateTime and dateTime.UnixTimestamp or nil

		if v26 ~= nil and v26 + p7.updateEntryDuration * 86400 <= p6.currentTime then
			return true
		end
	end

	return false
end
function t1.deriveEntryDisplay(p8, p9, p10, p11) -- line: 81
	-- upvalues: t1 (copy), Enums (copy)
	local v31 = t1.isEntryExpired(p8, p9, p10, p11)
	local v32 = p10.storage[p8.id]
	local v33 = if not v32 then nil else v32.seen
	local meta = p10.meta
	local v35 = p9 ~= Enums.TourType.Onboarding or meta.grandfathered ~= true

	return {
		id = p8.id,
		scopeId = p8.scopeId,
		title = p8.title,
		text = p8.text,
		icon = p8.icon,
		enabled = p8.enabled,
		publishedTime = p8.publishedTime,
		disableTime = p8.disableTime,
		expired = v31,
		seen = v33,
		optOutCount = not v32 and 0 or v32.optOutCount,
		adopted = not not v32 and v32.adopted,
		toShow = p8.enabled and (not v31 and (v33 == nil and v35))
	}
end
function t1.getLabels(p12, p13) -- line: 110
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
function t1.hasLabels(p14) -- line: 124
	local title = p14.title
	local v40 = title ~= nil and title ~= ""

	if not v40 then
		local text = p14.text

		v40 = text ~= nil and text ~= ""
	end

	return v40
end
function t1.countScopeSteps(p15) -- line: 128
	local n1 = 0

	for _, v45 in p15.tourTips do
		n1 += v45.stepCount
	end

	return n1
end

return t1
