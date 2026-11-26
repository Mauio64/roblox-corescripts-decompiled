local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local module = require("@luauforge/bundled/ikQ")

local callOnce = module.AppCommonLib.callOnce
local tutils = module.tutils

local logger = module.Loggers.Logger
local cryo = module.Cryo

local v5 = {}

local sharedFlags = module.SharedFlags

local fFlagEnableAppRatingPromptLua = sharedFlags.FFlagEnableAppRatingPromptLua
local fFlagEnableAndroidAppRatingPromptLua = sharedFlags.FFlagEnableAndroidAppRatingPromptLua

game:DefineFastInt("RatingPromptMinNumFriends", 1)
game:DefineFastInt("RatingPromptMinDaysSinceFirstUse", 1)
game:DefineFastInt("RatingPromptMinNumLaunches", 10)
game:DefineFastInt("RatingPromptMinNumGamesPlayed", 1)
game:DefineFastInt("RatingPromptMinGameDurationSec", 600)
game:DefineFastInt("RatingPromptMinNumLaunchesSinceLastPrompt", 0)
game:DefineFastInt("RatingPromptMinNumDaysSinceLastPrompt", 1)
game:DefineFastFlag("RatingPromptCheckVersionRated", false)

v5.CurrentRatingPromptStats = {}

function v5.GetAppRatingPromptEnabled()
	local v6 = (fFlagEnableAppRatingPromptLua or fFlagEnableAndroidAppRatingPromptLua)
		and game:GetEngineFeature("AppRatingPromptEnabled")

	if v6 then
		local AppRatingPromptService = game:GetService("AppRatingPromptService")
		v6 = AppRatingPromptService:isAppRatingPromptAvailable()
	end

	return v6
end

function v5.GetAppRatingPromptService()
	return if fFlagEnableAppRatingPromptLua or fFlagEnableAndroidAppRatingPromptLua then game:GetEngineFeature("AppRatingPromptEnabled") and game:GetService("AppRatingPromptService") or nil else nil
end

function v5.GetMinimumNumFriends()
	return game:GetFastInt("RatingPromptMinNumFriends")
end

function v5.GetMinDaysSinceFirstUse()
	return game:GetFastInt("RatingPromptMinDaysSinceFirstUse")
end

function v5.GetMinNumLaunches()
	return game:GetFastInt("RatingPromptMinNumLaunches")
end

function v5.GetMinNumGamesPlayed()
	return game:GetFastInt("RatingPromptMinNumGamesPlayed")
end

function v5.GetMinGameDurationSec()
	return game:GetFastInt("RatingPromptMinGameDurationSec")
end

function v5.GetMinNumLaunchesSinceLastPrompt()
	return game:GetFastInt("RatingPromptMinNumLaunchesSinceLastPrompt")
end

function v5.GetMinNumDaysSinceLastPrompt()
	return game:GetFastInt("RatingPromptMinNumDaysSinceLastPrompt")
end

function v5.GetCheckVersionRated()
	return game:GetFastFlag("RatingPromptCheckVersionRated")
end

v5.kAppRatingPromptStorageKey = "AppRatingPromptStats"

v5.kFirstUseDay = "firstUseDay"
v5.kNumLaunches = "numLaunches"
v5.kNumGamesPlayed = "numGamesPlayed"
v5.kLastTriggerTimestamp = "lastTriggerTimestamp"
v5.kLaunchesSinceLastPrompt = "launchesSinceLastPrompt"
v5.kSavedVersion = "savedVersion"
v5.kVersionAlreadyRated = "versionAlreadyRated"
v5.kPassedFriendsCheck = "passedFriendsCheck"

v5.defaultStatValues = {
	[v5.kFirstUseDay] = DateTime.now().UnixTimestamp,
	[v5.kNumLaunches] = 0,
	[v5.kNumGamesPlayed] = 0,
	[v5.kLastTriggerTimestamp] = -1,
	[v5.kLaunchesSinceLastPrompt] = 0,
	[v5.kSavedVersion] = "0",
	[v5.kVersionAlreadyRated] = false,
	[v5.kPassedFriendsCheck] = false
}

function v5.GetAppRatingPromptStats()
	if not game:GetEngineFeature("AppRatingPromptEnabled") then
		return {}
	end

	if next(v5.CurrentRatingPromptStats) ~= nil then
		return v5.CurrentRatingPromptStats
	end

	local item = AppStorageService:GetItem(v5.kAppRatingPromptStorageKey)
	local success, result = pcall(function()
		return HttpService:JSONDecode(item)
	end)

	local v7 = {}

	if success and type(result) == "table" then
		v7 = result
	else
		logger:warning("Error reading AppRatingPrompt stats, reinitializing to default values")
	end

	local fieldCount = tutils.fieldCount(v7)
	local joined = cryo.Dictionary.join(v5.defaultStatValues, v7)

	for k, defaultStatValue in pairs(v5.defaultStatValues) do
		if type(joined[k]) == type(v5.defaultStatValues[k]) then
			continue
		end

		joined[k] = v5.defaultStatValues[k]
		logger:warning(k .. " is of incorrect type, resetting to default value")
	end

	v5.CurrentRatingPromptStats = joined

	if tutils.fieldCount(v5.CurrentRatingPromptStats) ~= fieldCount then
		local jsonEncode = HttpService:JSONEncode(v5.CurrentRatingPromptStats)
		AppStorageService:SetItem(v5.kAppRatingPromptStorageKey, jsonEncode)
		AppStorageService:Flush()
	end

	return v5.CurrentRatingPromptStats
end

function v5.SetAppRatingPromptStat(items)
	if next(items) == nil then
		return
	end

	if game:GetEngineFeature("AppRatingPromptEnabled") then
		local appRatingPromptStats = v5.GetAppRatingPromptStats()
		local flag = false

		for k, item in pairs(items) do
			if appRatingPromptStats[k] == nil then
				logger:warning("SetAppRatingPromptStat: key not found in stats: " .. k)
			else
				appRatingPromptStats[k] = items[k]
				flag = true
			end
		end

		if flag then
			v5.CurrentRatingPromptStats = appRatingPromptStats
			local jsonEncode = HttpService:JSONEncode(v5.CurrentRatingPromptStats)
			AppStorageService:SetItem(v5.kAppRatingPromptStorageKey, jsonEncode)
			AppStorageService:Flush()
		end
	end
end

function v5.IncrementValues(items)
	if next(items) == nil then
		return
	end

	if game:GetEngineFeature("AppRatingPromptEnabled") then
		local appRatingPromptStats = v5.GetAppRatingPromptStats()
		local flag = false

		for k, item in pairs(items) do
			if appRatingPromptStats[item] == nil or type(appRatingPromptStats[item]) ~= "number" then
				logger:warning("IncrementValues: key not found in stats: " .. item)
			else
				appRatingPromptStats[item] += 1
				flag = true
			end
		end

		if flag then
			v5.CurrentRatingPromptStats = appRatingPromptStats
			local jsonEncode = HttpService:JSONEncode(v5.CurrentRatingPromptStats)
			AppStorageService:SetItem(v5.kAppRatingPromptStorageKey, jsonEncode)
			AppStorageService:Flush()
		end
	end
end

function v5.PromptTriggered()
	local unixTimestamp = DateTime.now().UnixTimestamp
	local v7 = {
		[v5.kLastTriggerTimestamp] = unixTimestamp,
		[v5.kLaunchesSinceLastPrompt] = 0,
		[v5.kVersionAlreadyRated] = true
	}

	v5.SetAppRatingPromptStat(v7)
end

function v5.onLaunchHelper()
	if game:GetEngineFeature("AppRatingPromptEnabled") then
		local appRatingPromptStats = v5.GetAppRatingPromptStats()
		local joined = cryo.Dictionary.join(v5.defaultStatValues, appRatingPromptStats)

		local robloxVersion = RunService:GetRobloxVersion()

		if joined[v5.kSavedVersion] ~= robloxVersion then
			joined[v5.kSavedVersion] = robloxVersion
			joined[v5.kVersionAlreadyRated] = false
			joined[v5.kNumLaunches] = 0
			joined[v5.kPassedFriendsCheck] = false
		end

		joined[v5.kNumLaunches] = joined[v5.kNumLaunches] + 1
		joined[v5.kLaunchesSinceLastPrompt] = joined[v5.kLaunchesSinceLastPrompt] + 1
		v5.CurrentRatingPromptStats = joined
		local jsonEncode = HttpService:JSONEncode(v5.CurrentRatingPromptStats)
		AppStorageService:SetItem(v5.kAppRatingPromptStorageKey, jsonEncode)
		AppStorageService:Flush()
	end
end

function v5.onLaunch()
	callOnce("AppRatingPromptOnLaunch", function()
		if v5.GetAppRatingPromptEnabled() then
			v5.onLaunchHelper()
		end
	end)
end

return v5
