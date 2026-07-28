require(script.Parent.types)

local t1 = {
	BLOCK_REASON_FREE_TRIAL_EXHAUSTED = "FreeTrialExhausted",
	BLOCK_REASON_DAILY_LIMIT_REACHED = "DailyLimitReached",
	BLOCK_REASON_INSUFFICIENT_ROBUX_BALANCE = "InsufficientRobuxBalance"
}

local function decodeNumber(p1) -- line: 13
	if typeof(p1) == "number" then
		return p1
	end

	if typeof(p1) == "string" then
		return tonumber(p1) or 0
	end

	return 0
end
local function decodeDailyLimitSettings(p2) -- line: 23
	local v7 = if typeof(p2) ~= "table" then {} else p2
	local v8 = if typeof(v7.limitSettings) ~= "table" then v7 else v7.limitSettings
	local t2 = {
		additionalUsageEnabled = v8.additionalUsageEnabled == true,
		dailyLimitSet = v8.dailyLimitSet == true
	}
	local dailyLimit = v8.dailyLimit

	t2.dailyLimit = if typeof(dailyLimit) ~= "number" then typeof(dailyLimit) ~= "string" and 0 or (tonumber(dailyLimit) or 0) else dailyLimit

	return t2
end
local function decodeQuotaBlockReason(p3) -- line: 33
	-- upvalues: t1 (copy)
	if typeof(p3) ~= "string" then
		return nil
	end

	return t1[p3]
end

return {
	decodeDailyLimitSettings = decodeDailyLimitSettings,
	decodeQuotaSummary = function(p4) -- line: 40
		-- upvalues: decodeDailyLimitSettings (copy), t1 (copy)
		local v13 = if typeof(p4) ~= "table" then {} else p4
		local v14 = if typeof(v13.summary) ~= "table" then v13 else v13.summary
		local t3 = {}
		local freeTrialDailyAllowance = v14.freeTrialDailyAllowance

		t3.freeTrialDailyAllowance = if typeof(freeTrialDailyAllowance) ~= "number" then typeof(freeTrialDailyAllowance) ~= "string" and 0 or (tonumber(freeTrialDailyAllowance) or 0) else freeTrialDailyAllowance

		local freeTrialRemaining = v14.freeTrialRemaining

		t3.freeTrialRemaining = if typeof(freeTrialRemaining) ~= "number" then typeof(freeTrialRemaining) ~= "string" and 0 or (tonumber(freeTrialRemaining) or 0) else freeTrialRemaining

		local freeTrialPctUsed = v14.freeTrialPctUsed

		t3.freeTrialPctUsed = if typeof(freeTrialPctUsed) ~= "number" then typeof(freeTrialPctUsed) ~= "string" and 0 or (tonumber(freeTrialPctUsed) or 0) else freeTrialPctUsed
		t3.nextResetEligibleTime = v14.nextResetEligibleTime or ""

		local robuxBalance = v14.robuxBalance

		t3.robuxBalance = if typeof(robuxBalance) ~= "number" then typeof(robuxBalance) ~= "string" and 0 or (tonumber(robuxBalance) or 0) else robuxBalance
		t3.limitSettings = decodeDailyLimitSettings(v14.limitSettings)

		local robuxSpentToday = v14.robuxSpentToday

		t3.robuxSpentToday = if typeof(robuxSpentToday) ~= "number" then typeof(robuxSpentToday) ~= "string" and 0 or (tonumber(robuxSpentToday) or 0) else robuxSpentToday

		local limitRemaining = v14.limitRemaining

		t3.limitRemaining = if typeof(limitRemaining) ~= "number" then typeof(limitRemaining) ~= "string" and 0 or (tonumber(limitRemaining) or 0) else limitRemaining
		t3.allowed = if typeof(v14.allowed) ~= "boolean" then nil else v14.allowed

		local reason = v14.reason

		t3.reason = if typeof(reason) == "string" then t1[reason] else nil

		return t3
	end
}
