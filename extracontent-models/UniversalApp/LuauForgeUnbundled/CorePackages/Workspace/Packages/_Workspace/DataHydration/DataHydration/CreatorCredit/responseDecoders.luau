require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorCredit/types")

local fFlagBuildExperienceModelPickerData = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildExperienceModelPickerData

local v5 = {
	BLOCK_REASON_FREE_TRIAL_EXHAUSTED = "FreeTrialExhausted",
	BLOCK_REASON_DAILY_LIMIT_REACHED = "DailyLimitReached",
	BLOCK_REASON_INSUFFICIENT_ROBUX_BALANCE = "InsufficientRobuxBalance",
	"InsufficientRobuxBalance",
	"DailyLimitReached",
	"FreeTrialExhausted"
}

local v6 = {
	MODEL_TIER_DEFAULT = "default",
	MODEL_TIER_ADVANCED = "advanced",
	"default",
	"advanced"
}

local v7 = {
	FREE_TRIAL_RESET_PERIOD_DAILY = "Daily",
	FREE_TRIAL_RESET_PERIOD_WEEKLY = "Weekly",
	FREE_TRIAL_RESET_PERIOD_MONTHLY = "Monthly"
}

local function decodeNumber(value)
	if typeof(value) == "number" then
		return value
	end

	if typeof(value) == "string" then
		return tonumber(value) or 0
	end

	return 0
end

local function decodeDailyLimitSettings(limitSettings)
	local v8 = typeof(limitSettings) ~= "table" and {} or limitSettings

	if typeof(v8.limitSettings) == "table" then
		v8 = v8.limitSettings
	end

	local v9 = {
		additionalUsageEnabled = v8.additionalUsageEnabled == true,
		dailyLimitSet = v8.dailyLimitSet == true,
		dailyLimit = 0
	}
	local dailyLimit = v8.dailyLimit
	v9.dailyLimit = typeof(dailyLimit) ~= "number"
		and (typeof(dailyLimit) == "string" and tonumber(dailyLimit) or 0)
		or dailyLimit
	return v9
end

local function decodeQuotaBlockReason(value)
	if typeof(value) == "string" then
		return v5[value]
	end

	return nil
end

local function decodeFreeTrialResetPeriod(value)
	if typeof(value) == "string" then
		return v7[value] or "Daily"
	end

	return "Daily"
end

local function decodeModelTier(value)
	if typeof(value) == "string" or typeof(value) == "number" then
		return v6[value]
	end

	return nil
end

local function decodeOptionalRobux(value)
	if typeof(value) ~= "number" and typeof(value) ~= "string" then
		return nil
	end

	local v8 = tonumber(value)

	if v8 == nil or v8 < 0 or v8 > 9007199254740991 or v8 % 1 ~= 0 then
		return nil
	end

	return v8
end

local function decodeQuotaSummary(p2)
	local v8 = typeof(p2) ~= "table" and {} or p2

	if typeof(v8.summary) == "table" then
		v8 = v8.summary
	end

	local freeTrialDailyAllowance = v8.freeTrialDailyAllowance
	local v9 = {
		freeTrialDailyAllowance = typeof(freeTrialDailyAllowance) ~= "number" and (typeof(freeTrialDailyAllowance) == "string" and tonumber(freeTrialDailyAllowance) or 0) or freeTrialDailyAllowance,
		freeTrialRemaining = 0,
		freeTrialPctUsed = 0,
		nextResetEligibleTime = 0,
		robuxBalance = 0,
		limitSettings = 0,
		robuxSpentToday = 0,
		limitRemaining = 0,
		allowed = 0,
		reason = 0,
		freeTrialResetPeriod = 0
	}

	local freeTrialRemaining = v8.freeTrialRemaining
	v9.freeTrialRemaining = typeof(freeTrialRemaining) ~= "number"
		and (typeof(freeTrialRemaining) == "string" and tonumber(freeTrialRemaining) or 0)
		or freeTrialRemaining
	local freeTrialPctUsed = v8.freeTrialPctUsed
	v9.freeTrialPctUsed = typeof(freeTrialPctUsed) ~= "number"
		and (typeof(freeTrialPctUsed) == "string" and tonumber(freeTrialPctUsed) or 0)
		or freeTrialPctUsed
	v9.nextResetEligibleTime = v8.nextResetEligibleTime or ""
	local robuxBalance = v8.robuxBalance
	v9.robuxBalance = typeof(robuxBalance) ~= "number"
		and (typeof(robuxBalance) == "string" and tonumber(robuxBalance) or 0)
		or robuxBalance
	v9.limitSettings = decodeDailyLimitSettings(v8.limitSettings)
	local robuxSpentToday = v8.robuxSpentToday
	v9.robuxSpentToday = typeof(robuxSpentToday) ~= "number"
		and (typeof(robuxSpentToday) == "string" and tonumber(robuxSpentToday) or 0)
		or robuxSpentToday
	local limitRemaining = v8.limitRemaining
	v9.limitRemaining = typeof(limitRemaining) ~= "number"
		and (typeof(limitRemaining) == "string" and tonumber(limitRemaining) or 0)
		or limitRemaining
	local v10 = if typeof(v8.allowed) == "boolean" then v8.allowed else nil
	v9.allowed = v10
	local reason = v8.reason
	local v11 = if typeof(reason) == "string" then v5[reason] else nil

	v9.reason = v11
	local freeTrialResetPeriod = v8.freeTrialResetPeriod
	v9.freeTrialResetPeriod = typeof(freeTrialResetPeriod) == "string" and v7[freeTrialResetPeriod]
		or "Daily"

	if not fFlagBuildExperienceModelPickerData then
		return v9
	end

	local blockDetails = v8.blockDetails

	if typeof(blockDetails) ~= "table" then
		return v9
	end

	local modelTier = blockDetails.modelTier
	local v13 = if typeof(modelTier) == "string" or typeof(modelTier) == "number" then v6[modelTier] else nil

	local requiredRobux = blockDetails.requiredRobux
	local v14

	if typeof(requiredRobux) == "number" or typeof(requiredRobux) == "string" then
		v14 = tonumber(requiredRobux)

		if v14 == nil or v14 < 0 or v14 > 9007199254740991 or v14 % 1 ~= 0 then
			v14 = nil
		end
	end

	local availableRobux = blockDetails.availableRobux
	local v15

	if typeof(availableRobux) == "number" or typeof(availableRobux) == "string" then
		v15 = tonumber(availableRobux)

		if v15 == nil or v15 < 0 or v15 > 9007199254740991 or v15 % 1 ~= 0 then
			v15 = nil
		end
	end

	v9.blockDetails = { modelTier = v13, requiredRobux = v14, availableRobux = v15 }

	return v9
end

return {
	decodeDailyLimitSettings = decodeDailyLimitSettings,
	decodeQuotaSummary = decodeQuotaSummary,
	decodeTierQuotaSummary = function(p2)
		local v8 = decodeQuotaSummary(p2)
		local summary = if typeof(p2) == "table" then p2.summary else nil

		if typeof(summary) ~= "table" then
			return v8
		end

		if summary.allowed == nil then
			v8.allowed = false
		end

		if typeof(summary.reason) == "number" then
			v8.reason = v5[summary.reason]
		end

		return v8
	end
}
