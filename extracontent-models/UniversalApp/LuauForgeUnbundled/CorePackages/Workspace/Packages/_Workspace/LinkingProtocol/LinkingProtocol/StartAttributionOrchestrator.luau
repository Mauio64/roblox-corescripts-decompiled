require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/LinkingProtocolTypes")
local AttributionTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/AttributionTelemetry")
local getFFlagEnableStartAttributionTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/Flags/getFFlagEnableStartAttributionTelemetry")
local getFFlagAdConsentSkipOptOutAuthPublish = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/Flags/getFFlagAdConsentSkipOptOutAuthPublish")
local fFlagAdConsentForwardCachedRegion = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/SharedFlags").FFlagAdConsentForwardCachedRegion

local v5 = {}

local v6 = {
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

local function isSubjectToGdpr(value): boolean
	if value == nil or fFlagAdConsentForwardCachedRegion and string.match(value, "^%a%a$") == nil then
		return true
	end

	return v6[string.upper(value)] == true
end

local function toDmaConsent(p2, value)
	return {
		isSubjectToGdpr = value == nil or (fFlagAdConsentForwardCachedRegion and string.match(value, "^%a%a$") == nil and true or v6[string.upper(value)] == true),
		consented = p2
	}
end

function v5.computeDecision(p2, value)
	if p2 == nil then
		return { applySharingFilter = true, dmaConsent = nil }
	end

	return {
		applySharingFilter = not p2,
		dmaConsent = {
			isSubjectToGdpr = value == nil or (fFlagAdConsentForwardCachedRegion and string.match(value, "^%a%a$") == nil and true or v6[string.upper(value)] == true),
			consented = p2
		}
	}
end

local function shouldPublish(p2, p3): boolean
	if getFFlagAdConsentSkipOptOutAuthPublish() and p2 == "Auth" and p3 == false then
		return false
	end

	return true
end

local function isAwaitingConsent(p2): boolean
	return p2 == nil
end

function v5.resolveAndPublish(object, p2, p3, p4)
	if getFFlagAdConsentSkipOptOutAuthPublish() and p2 == "Auth" and p3 == false or p3 == nil then
		return
	end

	local decision = v5.computeDecision(p3, p4)
	object:adConsentResolved(decision)

	if getFFlagEnableStartAttributionTelemetry() then
		AttributionTelemetry.logDecisionPublished(p2, decision.applySharingFilter)
	end
end

return v5
