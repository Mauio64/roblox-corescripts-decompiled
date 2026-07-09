local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local scriptParent = script.Parent
local dependencies = require(scriptParent.dependencies)
local callOnce = dependencies.AppCommonLib.callOnce
local tutils = dependencies.tutils
local Logger = dependencies.Loggers.Logger
local Cryo = dependencies.Cryo
local t1 = {}
local SharedFlags = dependencies.SharedFlags
local FFlagEnableAppRatingPromptLua = SharedFlags.FFlagEnableAppRatingPromptLua
local FFlagEnableAndroidAppRatingPromptLua = SharedFlags.FFlagEnableAndroidAppRatingPromptLua

game:DefineFastInt("RatingPromptMinNumFriends", 1)
game:DefineFastInt("RatingPromptMinDaysSinceFirstUse", 1)
game:DefineFastInt("RatingPromptMinNumLaunches", 10)
game:DefineFastInt("RatingPromptMinNumGamesPlayed", 1)
game:DefineFastInt("RatingPromptMinGameDurationSec", 600)
game:DefineFastInt("RatingPromptMinNumLaunchesSinceLastPrompt", 0)
game:DefineFastInt("RatingPromptMinNumDaysSinceLastPrompt", 1)
game:DefineFastFlag("RatingPromptCheckVersionRated", false)
t1.CurrentRatingPromptStats = {}

function t1.GetAppRatingPromptEnabled() -- line: 35
	-- upvalues: FFlagEnableAppRatingPromptLua (copy), FFlagEnableAndroidAppRatingPromptLua (copy)
	return (FFlagEnableAppRatingPromptLua or FFlagEnableAndroidAppRatingPromptLua) and (game:GetEngineFeature("AppRatingPromptEnabled") and game:GetService("AppRatingPromptService"):isAppRatingPromptAvailable())
end
function t1.GetAppRatingPromptService() -- line: 41
	-- upvalues: FFlagEnableAppRatingPromptLua (copy), FFlagEnableAndroidAppRatingPromptLua (copy)
	return not (not FFlagEnableAppRatingPromptLua and not FFlagEnableAndroidAppRatingPromptLua) and (not not game:GetEngineFeature("AppRatingPromptEnabled") and game:GetService("AppRatingPromptService")) or nil
end
function t1.GetMinimumNumFriends() -- line: 52
	return game:GetFastInt("RatingPromptMinNumFriends")
end
function t1.GetMinDaysSinceFirstUse() -- line: 56
	return game:GetFastInt("RatingPromptMinDaysSinceFirstUse")
end
function t1.GetMinNumLaunches() -- line: 60
	return game:GetFastInt("RatingPromptMinNumLaunches")
end
function t1.GetMinNumGamesPlayed() -- line: 64
	return game:GetFastInt("RatingPromptMinNumGamesPlayed")
end
function t1.GetMinGameDurationSec() -- line: 68
	return game:GetFastInt("RatingPromptMinGameDurationSec")
end
function t1.GetMinNumLaunchesSinceLastPrompt() -- line: 72
	return game:GetFastInt("RatingPromptMinNumLaunchesSinceLastPrompt")
end
function t1.GetMinNumDaysSinceLastPrompt() -- line: 76
	return game:GetFastInt("RatingPromptMinNumDaysSinceLastPrompt")
end
function t1.GetCheckVersionRated() -- line: 80
	return game:GetFastFlag("RatingPromptCheckVersionRated")
end

t1.kAppRatingPromptStorageKey = "AppRatingPromptStats"
t1.kFirstUseDay = "firstUseDay"
t1.kNumLaunches = "numLaunches"
t1.kNumGamesPlayed = "numGamesPlayed"
t1.kLastTriggerTimestamp = "lastTriggerTimestamp"
t1.kLaunchesSinceLastPrompt = "launchesSinceLastPrompt"
t1.kSavedVersion = "savedVersion"
t1.kVersionAlreadyRated = "versionAlreadyRated"
t1.kPassedFriendsCheck = "passedFriendsCheck"
t1.defaultStatValues = {
	[t1.kFirstUseDay] = DateTime.now().UnixTimestamp,
	[t1.kNumLaunches] = 0,
	[t1.kNumGamesPlayed] = 0,
	[t1.kLastTriggerTimestamp] = -1,
	[t1.kLaunchesSinceLastPrompt] = 0,
	[t1.kSavedVersion] = "0",
	[t1.kVersionAlreadyRated] = false,
	[t1.kPassedFriendsCheck] = false
}

function t1.GetAppRatingPromptStats() -- line: 111
	-- upvalues: t1 (copy), AppStorageService (copy), HttpService (copy), Logger (copy), tutils (copy), Cryo (copy)
	if game:GetEngineFeature("AppRatingPromptEnabled") then
		if next(t1.CurrentRatingPromptStats) == nil then
			local Item = AppStorageService:GetItem(t1.kAppRatingPromptStorageKey)
			local ok, result = pcall(function() -- line: 115
				-- upvalues: HttpService (copy), Item (copy)
				return HttpService:JSONDecode(Item)
			end)
			local t2 = {}

			if ok and type(result) == "table" then
				t2 = result
			else
				Logger:warning("Error reading AppRatingPrompt stats, reinitializing to default values")
			end

			local v18 = tutils.fieldCount(t2)
			local v19 = Cryo.Dictionary.join(t1.defaultStatValues, t2)

			for k, _ in pairs(t1.defaultStatValues) do
				if type(v19[k]) ~= type(t1.defaultStatValues[k]) then
					v19[k] = t1.defaultStatValues[k]
					Logger:warning(k .. " is of incorrect type, resetting to default value")
				end
			end

			t1.CurrentRatingPromptStats = v19

			if v18 ~= tutils.fieldCount(t1.CurrentRatingPromptStats) then
				local json = HttpService:JSONEncode(t1.CurrentRatingPromptStats)

				AppStorageService:SetItem(t1.kAppRatingPromptStorageKey, json)
				AppStorageService:Flush()
			end
		end

		return t1.CurrentRatingPromptStats
	end

	return {}
end
function t1.SetAppRatingPromptStat(p1) -- line: 147
	-- upvalues: t1 (copy), Logger (copy), HttpService (copy), AppStorageService (copy)
	if next(p1) == nil then
		return
	end

	if game:GetEngineFeature("AppRatingPromptEnabled") then
		local v24 = t1.GetAppRatingPromptStats()
		local v25 = false

		for k, _ in pairs(p1) do
			if v24[k] ~= nil then
				v24[k] = p1[k]
				v25 = true
			else
				Logger:warning("SetAppRatingPromptStat: key not found in stats: " .. k)
			end
		end

		if v25 then
			t1.CurrentRatingPromptStats = v24

			local json = HttpService:JSONEncode(t1.CurrentRatingPromptStats)

			AppStorageService:SetItem(t1.kAppRatingPromptStorageKey, json)
			AppStorageService:Flush()
		end
	end
end
function t1.IncrementValues(p2) -- line: 172
	-- upvalues: t1 (copy), Logger (copy), HttpService (copy), AppStorageService (copy)
	if next(p2) == nil then
		return
	end

	if game:GetEngineFeature("AppRatingPromptEnabled") then
		local v30 = t1.GetAppRatingPromptStats()
		local v31 = false

		for _, v in pairs(p2) do
			if v30[v] ~= nil and type(v30[v]) == "number" then
				v30[v] = v30[v] + 1
				v31 = true
			else
				Logger:warning("IncrementValues: key not found in stats: " .. v)
			end
		end

		if v31 then
			t1.CurrentRatingPromptStats = v30

			local json = HttpService:JSONEncode(t1.CurrentRatingPromptStats)

			AppStorageService:SetItem(t1.kAppRatingPromptStorageKey, json)
			AppStorageService:Flush()
		end
	end
end
function t1.PromptTriggered() -- line: 198
	-- upvalues: t1 (copy)
	local UnixTimestamp = DateTime.now().UnixTimestamp
	local t3 = {
		[t1.kLastTriggerTimestamp] = UnixTimestamp,
		[t1.kLaunchesSinceLastPrompt] = 0,
		[t1.kVersionAlreadyRated] = true
	}

	t1.SetAppRatingPromptStat(t3)
end
function t1.onLaunchHelper() -- line: 209
	-- upvalues: t1 (copy), Cryo (copy), RunService (copy), HttpService (copy), AppStorageService (copy)
	if game:GetEngineFeature("AppRatingPromptEnabled") then
		local v37 = t1.GetAppRatingPromptStats()
		local v38 = Cryo.Dictionary.join(t1.defaultStatValues, v37)
		local RobloxVersion = RunService:GetRobloxVersion()

		if RobloxVersion ~= v38[t1.kSavedVersion] then
			v38[t1.kSavedVersion] = RobloxVersion
			v38[t1.kVersionAlreadyRated] = false
			v38[t1.kNumLaunches] = 0
			v38[t1.kPassedFriendsCheck] = false
		end

		v38[t1.kNumLaunches] = v38[t1.kNumLaunches] + 1
		v38[t1.kLaunchesSinceLastPrompt] = v38[t1.kLaunchesSinceLastPrompt] + 1
		t1.CurrentRatingPromptStats = v38

		local json = HttpService:JSONEncode(t1.CurrentRatingPromptStats)

		AppStorageService:SetItem(t1.kAppRatingPromptStorageKey, json)
		AppStorageService:Flush()
	end
end
function t1.onLaunch() -- line: 230
	-- upvalues: callOnce (copy), t1 (copy)
	callOnce("AppRatingPromptOnLaunch", function() -- line: 231
		-- upvalues: t1 (copy)
		if t1.GetAppRatingPromptEnabled() then
			t1.onLaunchHelper()
		end
	end)
end

return t1
