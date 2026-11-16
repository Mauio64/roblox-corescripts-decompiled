local parent = script.Parent
local parent2 = parent.Parent
require(parent.LinkingProtocolTypes)
local AttributionTelemetry = require(parent.AttributionTelemetry)
local getFFlagEnableStartAttributionTelemetry = require(parent.Flags.getFFlagEnableStartAttributionTelemetry)
local getFFlagAdConsentSkipOptOutAuthPublish = require(parent.Flags.getFFlagAdConsentSkipOptOutAuthPublish)
local SharedFlags = require(parent2.SharedFlags)
local FFlagAdConsentForwardCachedRegion = SharedFlags.FFlagAdConsentForwardCachedRegion

local StartAttributionOrchestrator = {}

local v = {
	AT = true,
	BE = true,
	BG = true,
	CY = true,
	CZ = true,
	DE = true,
	DK = true,
	EE = true,
	ES = true,
	FI = true,
	FR = true,
	GR = true,
	HR = true,
	HU = true,
	IE = true,
	IT = true,
	LT = true,
	LU = true,
	LV = true,
	MT = true,
	NL = true,
	PL = true,
	PT = true,
	RO = true,
	SE = true,
	SI = true,
	SK = true,
	IS = true,
	LI = true,
	NO = true,
	GB = true,
	CH = true
}

local function isSubjectToGdpr(value: string?): boolean -- 1 equivalent call inferred from this helper
	if value == nil or FFlagAdConsentForwardCachedRegion and string.match(value, "^%a%a$") == nil then
		return true
	end

	return v[string.upper(value)] == true
end

local function toDmaConsent(consented: boolean, value: string?) -- 1 equivalent call inferred from this helper
	return { isSubjectToGdpr = isSubjectToGdpr(value), consented = consented } -- inferred equivalent call
end

function StartAttributionOrchestrator.computeDecision(consented: boolean?, p: string?)
	if consented == nil then
		return { applySharingFilter = true, dmaConsent = nil }
	end

	return {
		applySharingFilter = not consented,
		dmaConsent = toDmaConsent(consented, p) -- inferred equivalent call
	}
end

local function shouldPublish(p, flag: boolean?): boolean -- 1 equivalent call inferred from this helper
	return not getFFlagAdConsentSkipOptOutAuthPublish() or p ~= "Auth" or flag ~= false
end

local function isAwaitingConsent(flag: boolean?): boolean -- 1 equivalent call inferred from this helper
	return flag == nil
end

function StartAttributionOrchestrator.resolveAndPublish(object, p, flag: boolean?, p2: string?)
	if not shouldPublish(p, flag) or isAwaitingConsent(flag) then -- inferred equivalent call
		return
	end

	local decision = StartAttributionOrchestrator.computeDecision(flag, p2)
	object:adConsentResolved(decision)

	if getFFlagEnableStartAttributionTelemetry() then
		AttributionTelemetry.logDecisionPublished(p, decision.applySharingFilter)
	end
end

return StartAttributionOrchestrator
