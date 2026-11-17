local DataHydration = script:FindFirstAncestor("DataHydration")

require(DataHydration.Moments.MomentsStoreTypes)

local function toNumber(remainingSeconds, p: number) -- 1 equivalent call inferred from this helper
	if type(remainingSeconds) == "number" then
		return remainingSeconds
	end

	return p
end

local function decodeMomentsUsage(p)
	local v = type(p) ~= "table" and {} or p

	local limitSeconds = v.limitSeconds
	local limitSeconds2 = type(limitSeconds) ~= "number" and -1 or limitSeconds

	local usedSeconds = v.usedSeconds
	local usedSeconds2 = type(usedSeconds) ~= "number" and 0 or usedSeconds
	local remainingSeconds2

	if limitSeconds2 < 0 then
		remainingSeconds2 = -1
	else
		local remainingSeconds = v.remainingSeconds
		remainingSeconds2 = math.max(0, limitSeconds2 - usedSeconds2)
		remainingSeconds2 = toNumber(remainingSeconds, remainingSeconds2) -- inferred equivalent call
	end

	local resetsAt

	if type(v.resetsAt) == "string" then
		resetsAt = v.resetsAt
	end

	return {
		limitSeconds = limitSeconds2,
		usedSeconds = usedSeconds2,
		remainingSeconds = remainingSeconds2,
		resetsAt = resetsAt
	}
end

return decodeMomentsUsage
