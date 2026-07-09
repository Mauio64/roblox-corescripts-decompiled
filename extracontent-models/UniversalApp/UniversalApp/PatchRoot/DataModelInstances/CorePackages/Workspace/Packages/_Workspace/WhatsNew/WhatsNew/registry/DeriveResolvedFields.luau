local WhatsNew = script:FindFirstAncestor("WhatsNew")
local Enums = require(WhatsNew.Enums)

require(WhatsNew.Types)

local TourTipCtaAccess = require(WhatsNew.TourTipCtaAccess)

local function isNonEmptyString(s1: string?) -- line: 12
	return s1 ~= nil and s1 ~= ""
end
local function isoDateToUnix(s2: string) -- line: 16
	local dateTime = DateTime.fromIsoDate(s2)

	return dateTime and dateTime.UnixTimestamp or nil
end
local function isEntryExpired(p1, p2, p3, p4) -- line: 40
	-- upvalues: Enums (copy)
	if p2 == Enums.TourType.Onboarding then
		return false
	end

	if p1.disableTime ~= nil then
		local disableTime = p1.disableTime
		local dateTime = DateTime.fromIsoDate(disableTime)
		local v22 = dateTime and dateTime.UnixTimestamp or nil

		if v22 ~= nil and v22 <= p3.currentTime then
			return true
		end
	end

	if p1.publishedTime ~= nil then
		local publishedTime = p1.publishedTime
		local dateTime = DateTime.fromIsoDate(publishedTime)
		local v25 = dateTime and dateTime.UnixTimestamp or nil

		if v25 ~= nil and v25 + p4.updateEntryDuration * 86400 <= p3.currentTime then
			return true
		end
	end

	return false
end
local function countScopeSteps(p5) -- line: 118
	-- upvalues: TourTipCtaAccess (copy), Enums (copy), countScopeSteps (copy)
	local n1 = 0

	for _, v41 in p5.tourTips do
		local v42 = TourTipCtaAccess.wrap(v41.cta)

		n1 = if v42:getKind() ~= Enums.TourTipCtaKind.Nested then n1 + v41.stepCount else n1 + (countScopeSteps(v42:getScope()) + 1)
	end

	return n1
end

return {
	isEntryInScopeSubtree = function(p6, s3: string, t1: {[any]: any}) -- line: 21
		local scopeId = p6.scopeId

		while scopeId ~= nil do
			if scopeId == s3 then
				return true
			end

			local v15 = t1[scopeId]

			if v15 == nil then
				return false
			end

			scopeId = v15.parentScopeId
		end

		return false
	end,
	isEntryExpired = isEntryExpired,
	deriveEntryDisplay = function(p7, p8, p9, p10) -- line: 73
		-- upvalues: isEntryExpired (copy)
		local v30 = isEntryExpired(p7, p8, p9, p10)
		local v31 = p9.storage[p7.id]

		return {
			id = p7.id,
			scopeId = p7.scopeId,
			title = p7.title,
			text = p7.text,
			icon = p7.icon,
			enabled = p7.enabled,
			publishedTime = p7.publishedTime,
			disableTime = p7.disableTime,
			expired = v30,
			seen = if not v31 then nil else v31.seen,
			optOutCount = not v31 and 0 or v31.optOutCount,
			adopted = not not v31 and v31.adopted,
			toShow = p7.enabled and not v30
		}
	end,
	getLabels = function(p11, p12) -- line: 100
		-- upvalues: Enums (copy)
		if p12 == Enums.TourType.Onboarding then
			return {
				title = p11.onboardingTitle or "",
				text = p11.onboardingText or ""
			}
		end

		return {
			title = p11.updatesTitle or "",
			text = p11.updatesText or ""
		}
	end,
	hasLabels = function(p13) -- line: 114
		local title = p13.title
		local v36 = title ~= nil and title ~= ""

		if not v36 then
			local text = p13.text

			v36 = text ~= nil and text ~= ""
		end

		return v36
	end,
	countScopeSteps = countScopeSteps
}
