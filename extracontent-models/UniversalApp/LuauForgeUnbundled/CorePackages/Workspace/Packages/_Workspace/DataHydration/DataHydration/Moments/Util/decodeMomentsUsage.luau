require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")

local function toNumber(value, p2)
	if type(value) == "number" then
		return value
	end

	return p2
end

local function decodeMomentsUsage(p2)
	local v5 = type(p2) ~= "table" and {} or p2

	local limitSeconds = v5.limitSeconds
	local v6 = type(limitSeconds) ~= "number" and -1 or limitSeconds

	local usedSeconds = v5.usedSeconds
	local v7 = type(usedSeconds) ~= "number" and 0 or usedSeconds
	local v8

	if v6 < 0 then
		v8 = -1
	else
		local remainingSeconds = v5.remainingSeconds
		v8 = math.max(0, v6 - v7)

		if type(remainingSeconds) == "number" then
			v8 = remainingSeconds
		end
	end

	local v10 = if type(v5.resetsAt) == "string" then v5.resetsAt else nil
	return {
		limitSeconds = v6,
		usedSeconds = v7,
		remainingSeconds = v8,
		resetsAt = v10
	}
end

return decodeMomentsUsage
