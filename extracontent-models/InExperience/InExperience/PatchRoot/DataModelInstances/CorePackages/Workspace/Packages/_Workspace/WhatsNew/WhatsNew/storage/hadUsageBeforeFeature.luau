local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local WhatsNew = script:FindFirstAncestor("WhatsNew")
local Constants = require(WhatsNew.Constants)

local function readAppRatingPromptStats(p1) -- line: 19
	-- upvalues: HttpService (copy)
	local ok, result = pcall(function() -- line: 20
		-- upvalues: p1 (copy)
		return p1:GetItem("AppRatingPromptStats")
	end)

	if not ok or (type(result) ~= "string" or result == "") then
		return {}
	end

	local ok2, result2 = pcall(function() -- line: 27
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok2 or type(result2) ~= "table" then
		return {}
	end

	return result2
end
local function hadUsageFromStats(t1: {[any]: any}, n1: number) -- line: 37
	local numLaunches = t1.numLaunches

	if type(numLaunches) == "number" and numLaunches > 1 then
		return true
	end

	local numGamesPlayed = t1.numGamesPlayed

	if type(numGamesPlayed) == "number" and numGamesPlayed > 0 then
		return true
	end

	local firstUseDay = t1.firstUseDay

	if type(firstUseDay) == "number" and firstUseDay < n1 then
		return true
	end

	return false
end
local function hadUsageBeforeFeature() -- line: 56
	-- upvalues: readAppRatingPromptStats (copy), AppStorageService (copy), Constants (copy)
	local v18 = readAppRatingPromptStats(AppStorageService)
	local WHATS_NEW_SHIP_UNIX = Constants.WHATS_NEW_SHIP_UNIX
	local numLaunches = v18.numLaunches

	if type(numLaunches) == "number" and numLaunches > 1 then
		return true
	end

	local numGamesPlayed = v18.numGamesPlayed

	if type(numGamesPlayed) == "number" and numGamesPlayed > 0 then
		return true
	end

	local firstUseDay = v18.firstUseDay

	if type(firstUseDay) == "number" and firstUseDay < WHATS_NEW_SHIP_UNIX then
		return true
	end

	return false
end

return hadUsageBeforeFeature
