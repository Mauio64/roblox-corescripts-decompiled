require(script.Parent.types)
local parent = script:FindFirstAncestor("DataHydration").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData

local v = {
	BLOCK_REASON_FREE_TRIAL_EXHAUSTED = "FreeTrialExhausted",
	BLOCK_REASON_DAILY_LIMIT_REACHED = "DailyLimitReached",
	BLOCK_REASON_INSUFFICIENT_ROBUX_BALANCE = "InsufficientRobuxBalance",
	"InsufficientRobuxBalance",
	"DailyLimitReached",
	"FreeTrialExhausted"
}

local v2 = {
	MODEL_TIER_DEFAULT = "default",
	MODEL_TIER_ADVANCED = "advanced",
	"default",
	"advanced"
}

local v3 = {
	FREE_TRIAL_RESET_PERIOD_DAILY = "Daily",
	FREE_TRIAL_RESET_PERIOD_WEEKLY = "Weekly",
	FREE_TRIAL_RESET_PERIOD_MONTHLY = "Monthly"
}

local function decodeNumber(value) -- 7 equivalent calls inferred from this helper
	if typeof(value) == "number" then
		return value
	end

	if typeof(value) == "string" then
		return tonumber(value) or 0
	end

	return 0
end

local function decodeDailyLimitSettings(limitSettings)
	local v4 = typeof(limitSettings) ~= "table" and {} or limitSettings

	if typeof(v4.limitSettings) == "table" then
		v4 = v4.limitSettings
	end

	return {
		additionalUsageEnabled = v4.additionalUsageEnabled == true,
		dailyLimitSet = v4.dailyLimitSet == true,
		dailyLimit = decodeNumber(v4.dailyLimit) -- inferred equivalent call
	}
end

local function decodeQuotaBlockReason(reason) -- 1 equivalent call inferred from this helper
	if typeof(reason) == "string" then
		return v[reason]
	end

	return nil
end

local function decodeFreeTrialResetPeriod(freeTrialResetPeriod) -- 1 equivalent call inferred from this helper
	if typeof(freeTrialResetPeriod) == "string" then
		return v3[freeTrialResetPeriod] or "Daily"
	end

	return "Daily"
end

local function decodeModelTier(modelTier) -- 1 equivalent call inferred from this helper
	if typeof(modelTier) == "string" or typeof(modelTier) == "number" then
		return v2[modelTier]
	end

	return nil
end

local function decodeOptionalRobux(value) -- 2 equivalent calls inferred from this helper
	if typeof(value) ~= "number" and typeof(value) ~= "string" then
		return nil
	end

	local v4 = tonumber(value)

	if v4 == nil or v4 < 0 or v4 > 9007199254740991 or v4 % 1 ~= 0 then
		return nil
	end

	return v4
end

local function decodeQuotaSummary(p)
	local v4 = typeof(p) ~= "table" and {} or p

	if typeof(v4.summary) == "table" then
		v4 = v4.summary
	end

	local v5 = {
		freeTrialDailyAllowance = decodeNumber(v4.freeTrialDailyAllowance), -- inferred equivalent call
		freeTrialRemaining = decodeNumber(v4.freeTrialRemaining), -- inferred equivalent call
		freeTrialPctUsed = decodeNumber(v4.freeTrialPctUsed), -- inferred equivalent call
		nextResetEligibleTime = v4.nextResetEligibleTime or "",
		robuxBalance = decodeNumber(v4.robuxBalance), -- inferred equivalent call
		limitSettings = decodeDailyLimitSettings(v4.limitSettings),
		robuxSpentToday = decodeNumber(v4.robuxSpentToday), -- inferred equivalent call
		limitRemaining = decodeNumber(v4.limitRemaining), -- inferred equivalent call
		allowed = 0,
		reason = 0,
		freeTrialResetPeriod = 0
	}
	local allowed

	if typeof(v4.allowed) == "boolean" then
		allowed = v4.allowed
	end

	v5.allowed = allowed
	v5.reason = decodeQuotaBlockReason(v4.reason) -- inferred equivalent call
	v5.freeTrialResetPeriod = decodeFreeTrialResetPeriod(v4.freeTrialResetPeriod) -- inferred equivalent call

	if not FFlagBuildExperienceModelPickerData then
		return v5
	end

	local blockDetails = v4.blockDetails

	if typeof(blockDetails) == "table" then
		v5.blockDetails = {
			modelTier = decodeModelTier(blockDetails.modelTier), -- inferred equivalent call
			requiredRobux = decodeOptionalRobux(blockDetails.requiredRobux), -- inferred equivalent call
			availableRobux = decodeOptionalRobux(blockDetails.availableRobux) -- inferred equivalent call
		}
	end

	return v5
end

return {
	decodeDailyLimitSettings = decodeDailyLimitSettings,
	decodeQuotaSummary = decodeQuotaSummary,
	decodeTierQuotaSummary = function(p)
		local v4 = decodeQuotaSummary(p)
		local summary

		if typeof(p) == "table" then
			summary = p.summary
		end

		if typeof(summary) ~= "table" then
			return v4
		end

		if summary.allowed == nil then
			v4.allowed = false
		end

		if typeof(summary.reason) == "number" then
			v4.reason = v[summary.reason]
		end

		return v4
	end
}
