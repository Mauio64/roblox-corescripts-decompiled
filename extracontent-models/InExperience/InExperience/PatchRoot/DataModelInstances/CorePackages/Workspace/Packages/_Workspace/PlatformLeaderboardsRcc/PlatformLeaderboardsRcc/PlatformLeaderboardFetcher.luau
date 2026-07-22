local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent
local HttpRequest = require(ParentParent.HttpRequest)
local SharedFlags = require(ParentParent.SharedFlags)
local Url = require(ParentParent.CoreScriptsCommon).Url
local scriptParent = script.Parent
local PlatformLeaderboardTypes = require(scriptParent.PlatformLeaderboardTypes)
local v8 = `{ Url.APIS_URL .. "platform-leaderboards-api" }/v1/rcc/universes/{ game.GameId }/leaderboard`
local LeaderboardType = PlatformLeaderboardTypes.LeaderboardType
local v10 = game:DefineFastInt("PlatformLeaderboardFetcherHttpRetryCount", 0)
local v11 = game:DefineFastInt("PlatformLeaderboardFetcherDefaultCount", 100)
local v12 = game:DefineFastFlag("PlatformLeaderboardDisplayNameEnabled", false)
local FFlagPlatformLeaderboardDebugLogging = SharedFlags.FFlagPlatformLeaderboardDebugLogging
local v14 = HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
	maxRetryCount = v10
})

local function get(s1: string) -- line: 30
	-- upvalues: v14 (copy), FFlagPlatformLeaderboardDebugLogging (copy), HttpService (copy)
	local ok, result, v24 = pcall(function() -- line: 31
		-- upvalues: v14 (copy), s1 (copy)
		return v14(s1, "GET"):await()
	end)

	if not ok or not result then
		if FFlagPlatformLeaderboardDebugLogging then
			warn("[PlatformLeaderboard] Fetcher request failed")
		end

		return false, nil
	end

	if typeof(v24) ~= "table" then
		if FFlagPlatformLeaderboardDebugLogging then
			warn("[PlatformLeaderboard] Fetcher received malformed response")
		end

		return false, nil
	end

	local v25 = v24.Body or v24.responseBody

	if typeof(v25) == "string" then
		local ok2, result2 = pcall(HttpService.JSONDecode, HttpService, v25)

		if ok2 then
			return true, result2
		end

		if FFlagPlatformLeaderboardDebugLogging then
			warn("[PlatformLeaderboard] Fetcher: JSON decode failed:", (tostring(result2)))
		end

		return false, nil
	end

	return true, v25
end
local function formatEntry(p1) -- line: 61
	-- upvalues: v12 (copy)
	if typeof(p1) ~= "table" then
		return nil
	end

	local userId = p1.userId
	local score = p1.score

	if userId == nil or score == nil then
		return nil
	end

	local num = tonumber(userId)
	local num2 = tonumber(score)

	if num == nil or num2 == nil then
		return nil
	end

	local rank = p1.rank
	local v34 = if rank ~= nil then tonumber(rank) else nil
	local v35 = nil

	if v12 then
		v35 = if typeof(p1.displayName) ~= "string" then nil else p1.displayName
	end

	return {
		userId = num,
		score = num2,
		rank = v34,
		displayName = v35
	}
end
local function formatEntries(t1: {[any]: any}) -- line: 92
	-- upvalues: formatEntry (copy)
	local t2 = {}

	for _, v39 in t1 do
		local v40 = formatEntry(v39)

		if v40 ~= nil then
			table.insert(t2, v40)
		end
	end

	return t2
end
local function formatConfig(t3: {[any]: any}?) -- line: 103
	if t3 == nil or t3.leaderboardId == nil then
		return nil
	end

	local leaderboardId = t3.leaderboardId

	if typeof(leaderboardId) ~= "string" then
		return nil
	end

	local unit = t3.unit

	return {
		leaderboardId = leaderboardId,
		unit = typeof(unit) ~= "string" and "" or unit
	}
end

local t4 = {
	fetchConfig = function() -- line: 120
		-- upvalues: v8 (copy), get (copy), FFlagPlatformLeaderboardDebugLogging (copy), formatConfig (copy)
		local v44 = `{ v8 }/config`
		local v45, v46 = get(v44)

		if not v45 then
			return false, nil
		end

		if typeof(v46) ~= "table" then
			if FFlagPlatformLeaderboardDebugLogging then
				warn("[PlatformLeaderboard] Fetcher received malformed config response body")
			end

			return false, nil
		end

		local config = v46.config

		if config ~= nil and typeof(config) ~= "table" then
			if FFlagPlatformLeaderboardDebugLogging then
				warn("[PlatformLeaderboard] Fetcher received malformed config payload")
			end

			return false, nil
		end

		return true, (formatConfig(config))
	end
}

local function fetchLeaderboard(_: string, p2, n1: number?, n2: number?) -- line: 143
	-- upvalues: v11 (copy), LeaderboardType (copy), v8 (copy), FFlagPlatformLeaderboardDebugLogging (copy), get (copy), formatConfig (copy), formatEntries (copy)
	local v52 = n2 or v11
	local v53

	if p2 == LeaderboardType.Global then
		v53 = `{ v8 }/global?count={ v52 }`
	else
		if p2 ~= LeaderboardType.Friends or n1 == nil then
			if FFlagPlatformLeaderboardDebugLogging then
				warn("[PlatformLeaderboard] Fetcher missing userId for friends leaderboard")
			end

			return false, nil
		end

		v53 = `{ v8 }/friends?userid={ n1 }&count={ v52 }`
	end

	local v54, v55 = get(v53)

	if not v54 then
		return false, nil
	end

	if typeof(v55) ~= "table" then
		if FFlagPlatformLeaderboardDebugLogging then
			warn("[PlatformLeaderboard] Fetcher received malformed leaderboard response body")
		end

		return false, nil
	end

	local config = v55.config

	if config ~= nil and typeof(config) ~= "table" then
		if FFlagPlatformLeaderboardDebugLogging then
			warn("[PlatformLeaderboard] Fetcher received malformed leaderboard config payload")
		end

		return false, nil
	end

	local scores = v55.scores

	if scores ~= nil and typeof(scores) ~= "table" then
		if FFlagPlatformLeaderboardDebugLogging then
			warn("[PlatformLeaderboard] Fetcher received malformed leaderboard scores payload")
		end

		return false, nil
	end

	return true, {
		config = formatConfig(config),
		entries = formatEntries(scores or {})
	}
end

function t4.fetchGlobalLeaderboard(s3: string, n3: number?) -- line: 192
	-- upvalues: fetchLeaderboard (copy), LeaderboardType (copy)
	return fetchLeaderboard(s3, LeaderboardType.Global, nil, n3)
end
function t4.fetchFriendsLeaderboard(s4: string, n4: number, n5: number?) -- line: 199
	-- upvalues: fetchLeaderboard (copy), LeaderboardType (copy)
	return fetchLeaderboard(s4, LeaderboardType.Friends, n4, n5)
end
function t4.fetchUserScore(_: string, n6: number) -- line: 207
	-- upvalues: v8 (copy), get (copy), FFlagPlatformLeaderboardDebugLogging (copy), formatEntry (copy)
	local v65 = `{ v8 }/{ n6 }/score`
	local v66, v67 = get(v65)

	if not v66 then
		return false, nil
	end

	if typeof(v67) ~= "table" then
		if FFlagPlatformLeaderboardDebugLogging then
			warn("[PlatformLeaderboard] Fetcher received malformed user score response body")
		end

		return false, nil
	end

	local userScore = v67.userScore

	if userScore ~= nil and typeof(userScore) ~= "table" then
		if FFlagPlatformLeaderboardDebugLogging then
			warn("[PlatformLeaderboard] Fetcher received malformed user score payload")
		end

		return false, nil
	end

	if not userScore then
		return true, nil
	end

	return true, (formatEntry(userScore))
end

return t4
