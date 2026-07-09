local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent
local HttpRequest = require(ParentParent.HttpRequest)
local Url = require(ParentParent.CoreScriptsCommon).Url
local scriptParent = script.Parent
local PlatformLeaderboardTypes = require(scriptParent.PlatformLeaderboardTypes)
local v7 = `{ Url.APIS_URL .. "platform-leaderboards-api" }/v1/rcc/universes/{ game.GameId }/leaderboard`
local LeaderboardType = PlatformLeaderboardTypes.LeaderboardType
local v9 = game:DefineFastInt("PlatformLeaderboardFetcherHttpRetryCount", 0)
local v10 = game:DefineFastInt("PlatformLeaderboardFetcherDefaultCount", 100)
local v11 = game:DefineFastFlag("PlatformLeaderboardDisplayNameEnabled", false)
local v12 = HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
	maxRetryCount = v9
})

local function get(s1: string) -- line: 28
	-- upvalues: v12 (copy), HttpService (copy)
	local ok, result, v22 = pcall(function() -- line: 29
		-- upvalues: v12 (copy), s1 (copy)
		return v12(s1, "GET"):await()
	end)

	if not ok or not result then
		warn("[PlatformLeaderboard] Fetcher request failed")

		return false, nil
	end

	if typeof(v22) ~= "table" then
		warn("[PlatformLeaderboard] Fetcher received malformed response")

		return false, nil
	end

	local v23 = v22.Body or v22.responseBody

	if typeof(v23) == "string" then
		local ok2, result2 = pcall(HttpService.JSONDecode, HttpService, v23)

		if ok2 then
			return true, result2
		end

		warn("[PlatformLeaderboard] Fetcher: JSON decode failed:", (tostring(result2)))

		return false, nil
	end

	return true, v23
end
local function formatEntry(p1) -- line: 53
	-- upvalues: v11 (copy)
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
	local v32 = if rank ~= nil then tonumber(rank) else nil
	local v33 = nil

	if v11 then
		v33 = if typeof(p1.displayName) ~= "string" then nil else p1.displayName
	end

	return {
		userId = num,
		score = num2,
		rank = v32,
		displayName = v33
	}
end
local function formatEntries(t1: {[any]: any}) -- line: 84
	-- upvalues: formatEntry (copy)
	local t2 = {}

	for _, v37 in t1 do
		local v38 = formatEntry(v37)

		if v38 ~= nil then
			table.insert(t2, v38)
		end
	end

	return t2
end
local function formatConfig(t3: {[any]: any}?) -- line: 95
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
	fetchConfig = function() -- line: 112
		-- upvalues: v7 (copy), get (copy), formatConfig (copy)
		local v42 = `{ v7 }/config`
		local v43, v44 = get(v42)

		if not v43 then
			return false, nil
		end

		if typeof(v44) ~= "table" then
			warn("[PlatformLeaderboard] Fetcher received malformed config response body")

			return false, nil
		end

		local config = v44.config

		if config ~= nil and typeof(config) ~= "table" then
			warn("[PlatformLeaderboard] Fetcher received malformed config payload")

			return false, nil
		end

		return true, (formatConfig(config))
	end
}

local function fetchLeaderboard(_: string, p2, n1: number?, n2: number?) -- line: 131
	-- upvalues: v10 (copy), LeaderboardType (copy), v7 (copy), get (copy), formatConfig (copy), formatEntries (copy)
	local v50 = n2 or v10
	local v51

	if p2 == LeaderboardType.Global then
		v51 = `{ v7 }/global?count={ v50 }`
	else
		if p2 ~= LeaderboardType.Friends or n1 == nil then
			warn("[PlatformLeaderboard] Fetcher missing userId for friends leaderboard")

			return false, nil
		end

		v51 = `{ v7 }/friends?userid={ n1 }&count={ v50 }`
	end

	local v52, v53 = get(v51)

	if not v52 then
		return false, nil
	end

	if typeof(v53) ~= "table" then
		warn("[PlatformLeaderboard] Fetcher received malformed leaderboard response body")

		return false, nil
	end

	local config = v53.config

	if config ~= nil and typeof(config) ~= "table" then
		warn("[PlatformLeaderboard] Fetcher received malformed leaderboard config payload")

		return false, nil
	end

	local scores = v53.scores

	if scores ~= nil and typeof(scores) ~= "table" then
		warn("[PlatformLeaderboard] Fetcher received malformed leaderboard scores payload")

		return false, nil
	end

	return true, {
		config = formatConfig(config),
		entries = formatEntries(scores or {})
	}
end

function t4.fetchGlobalLeaderboard(s3: string, n3: number?) -- line: 172
	-- upvalues: fetchLeaderboard (copy), LeaderboardType (copy)
	return fetchLeaderboard(s3, LeaderboardType.Global, nil, n3)
end
function t4.fetchFriendsLeaderboard(s4: string, n4: number, n5: number?) -- line: 179
	-- upvalues: fetchLeaderboard (copy), LeaderboardType (copy)
	return fetchLeaderboard(s4, LeaderboardType.Friends, n4, n5)
end
function t4.fetchUserScore(_: string, n6: number) -- line: 187
	-- upvalues: v7 (copy), get (copy), formatEntry (copy)
	local v63 = `{ v7 }/{ n6 }/score`
	local v64, v65 = get(v63)

	if not v64 then
		return false, nil
	end

	if typeof(v65) ~= "table" then
		warn("[PlatformLeaderboard] Fetcher received malformed user score response body")

		return false, nil
	end

	local userScore = v65.userScore

	if userScore ~= nil and typeof(userScore) ~= "table" then
		warn("[PlatformLeaderboard] Fetcher received malformed user score payload")

		return false, nil
	end

	if not userScore then
		return true, nil
	end

	return true, (formatEntry(userScore))
end

return t4
