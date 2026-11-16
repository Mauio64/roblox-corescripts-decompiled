local WhatsNew = script:FindFirstAncestor("WhatsNew")
local Enums = require(WhatsNew.Enums)
require(WhatsNew.Types)

local DeriveResolvedFields = {}

local function clientGatesPass(p, p2) -- 1 equivalent call inferred from this helper
	return p ~= Enums.TourType.Onboarding or p2.onboardingEligible
end

local function isNonEmptyString(p: string?): boolean -- 2 equivalent calls inferred from this helper
	return p ~= nil and p ~= ""
end

local function isoDateToUnix(p: string) -- 2 equivalent calls inferred from this helper
	local dateTime = DateTime.fromIsoDate(p)
	return dateTime and dateTime.UnixTimestamp or nil
end

function DeriveResolvedFields.isEntryInScopeSubtree(p, p2: string, p3): boolean
	local v = p.scopeId

	while v ~= nil do
		if v == p2 then
			return true
		end

		local v2 = p3[v]

		if v2 == nil then
			return false
		end

		v = v2.parentScopeId
	end

	return false
end

function DeriveResolvedFields.isEntryExpired(p, p2, p3): boolean
	local v

	if p.publishedTime ~= nil then
		v = isoDateToUnix(p.publishedTime) -- inferred equivalent call
	end

	if v ~= nil and p3.currentTime < v then
		return true
	end

	if p2 == Enums.TourType.Onboarding then
		return false
	end

	if p.disabledTime ~= nil then
		local v2 = isoDateToUnix(p.disabledTime) -- inferred equivalent call

		if v2 ~= nil and v2 <= p3.currentTime then
			return true
		end
	end

	return false
end

function DeriveResolvedFields.deriveEntryDisplay(data, p, p2)
	local entryExpired = DeriveResolvedFields.isEntryExpired(data, p, p2)
	local v = p2.storage[data.id]
	local seen

	if v then
		seen = v.seen
	end

	local v2 = clientGatesPass(p, p2) -- inferred equivalent call
	local v3 = {
		id = data.id,
		scopeId = data.scopeId,
		title = data.title,
		text = data.text,
		icon = data.icon,
		enabled = data.enabled,
		publishedTime = data.publishedTime,
		disabledTime = data.disabledTime,
		expired = entryExpired,
		seen = seen,
		optOutCount = not v and 0 or v.optOutCount,
		adopted = 0,
		toShow = 0
	}
	local adopted = if v then v.adopted else false
	v3.adopted = adopted
	local toShow = data.enabled and not entryExpired

	if toShow then
		toShow = seen == nil and v2
	end

	v3.toShow = toShow
	return v3
end

function DeriveResolvedFields.getLabels(data, p)
	if p == Enums.TourType.Onboarding then
		return {
			title = data.onboardingTitle or "",
			text = data.onboardingText or ""
		}
	end

	return {
		title = data.updatesTitle or "",
		text = data.updatesText or ""
	}
end

function DeriveResolvedFields.hasLabels(p)
	return isNonEmptyString(p.title) or isNonEmptyString(p.text) -- inferred equivalent call
end

function DeriveResolvedFields.countScopeSteps(p)
	local total = 0

	for _, tourTip in p.tourTips do
		total += tourTip.stepCount
	end

	return total
end

return DeriveResolvedFields
