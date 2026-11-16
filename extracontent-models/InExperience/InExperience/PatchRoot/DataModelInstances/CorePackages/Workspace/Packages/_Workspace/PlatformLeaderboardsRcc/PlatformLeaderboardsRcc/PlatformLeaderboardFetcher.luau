local HttpService = game:GetService("HttpService")

local parent = script.Parent.Parent
local HttpRequest = require(parent.HttpRequest)
local SharedFlags = require(parent.SharedFlags)
local CoreScriptsCommon = require(parent.CoreScriptsCommon)
local Url = CoreScriptsCommon.Url

local parent2 = script.Parent
local PlatformLeaderboardTypes = require(parent2.PlatformLeaderboardTypes)

local formatted = `{Url.APIS_URL .. "platform-leaderboards-api"}/v1/rcc/universes/{game.GameId}/leaderboard`
local LeaderboardType = PlatformLeaderboardTypes.LeaderboardType
local defineFastInt = game:DefineFastInt("PlatformLeaderboardFetcherHttpRetryCount", 0)
local defineFastInt2 = game:DefineFastInt("PlatformLeaderboardFetcherDefaultCount", 100)
local defineFastFlag = game:DefineFastFlag("PlatformLeaderboardDisplayNameEnabled", false)

local defineFastFlag2 = game:DefineFastFlag("PlatformLeaderboardBadgeMetadataEnabled", false)
local FFlagPlatformLeaderboardDebugLogging = SharedFlags.FFlagPlatformLeaderboardDebugLogging

local config = HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
	maxRetryCount = defineFastInt
})

local function get(p: string)
	local success, result, v = pcall(function()
		return config(p, "GET"):await()
	end)

	if success and result then
		if typeof(v) == "table" then
			local body = v.Body or v.responseBody

			if typeof(body) ~= "string" then
				return true, body
			end

			local success2, result2 = pcall(HttpService.JSONDecode, HttpService, body)

			if success2 then
				return true, result2
			end

			if FFlagPlatformLeaderboardDebugLogging then
				warn("[PlatformLeaderboard] Fetcher: JSON decode failed:", (tostring(result2)))
			end

			return false, nil
		end

		if FFlagPlatformLeaderboardDebugLogging then
			warn("[PlatformLeaderboard] Fetcher received malformed response")
		end

		return false, nil
	end

	if FFlagPlatformLeaderboardDebugLogging then
		warn("[PlatformLeaderboard] Fetcher request failed")
	end

	return false, nil
end

local function formatEntry(data)
	if typeof(data) ~= "table" then
		return nil
	end

	local userId = data.userId
	local score = data.score

	if userId == nil or score == nil then
		return nil
	end

	local userId2 = tonumber(userId)
	local score2 = tonumber(score)

	if userId2 == nil or score2 == nil then
		return nil
	end

	local rank = data.rank
	local rank2

	if rank ~= nil then
		rank2 = tonumber(rank)
	end

	local displayName

	if defineFastFlag and typeof(data.displayName) == "string" then
		displayName = data.displayName
	end

	local isVerified, hasRobloxSubscription

	if defineFastFlag2 then
		if typeof(data.isVerified) == "boolean" then
			isVerified = data.isVerified
		end

		if typeof(data.hasRobloxSubscription) == "boolean" then
			hasRobloxSubscription = data.hasRobloxSubscription
		end
	end

	return {
		userId = userId2,
		score = score2,
		rank = rank2,
		displayName = displayName,
		isVerified = isVerified,
		hasRobloxSubscription = hasRobloxSubscription
	}
end

local function formatEntries(items)
	local result = {}

	for _, item in items do
		local v = formatEntry(item)

		if v ~= nil then
			table.insert(result, v)
		end
	end

	return result
end

local function formatConfig(config2)
	if config2 == nil or config2.leaderboardId == nil then
		return nil
	end

	local leaderboardId = config2.leaderboardId

	if typeof(leaderboardId) ~= "string" then
		return nil
	end

	local unit = config2.unit
	return {
		leaderboardId = leaderboardId,
		unit = typeof(unit) ~= "string" and "" or unit
	}
end

local PlatformLeaderboardFetcher = {}

function PlatformLeaderboardFetcher.fetchConfig()
	local v, v2 = get(`{formatted}/config`)

	if not v then
		return false, nil
	end

	if typeof(v2) == "table" then
		local config2 = v2.config

		if config2 == nil or typeof(config2) == "table" then
			return true, formatConfig(config2)
		end

		if FFlagPlatformLeaderboardDebugLogging then
			warn("[PlatformLeaderboard] Fetcher received malformed config payload")
		end

		return false, nil
	end

	if FFlagPlatformLeaderboardDebugLogging then
		warn("[PlatformLeaderboard] Fetcher received malformed config response body")
	end

	return false, nil
end

local function fetchLeaderboard(_: string, p, p2: number?, p3: number?)
	local v = p3 or defineFastInt2
	local v2

	if p == LeaderboardType.Global then
		v2 = `{formatted}/global?count={v}`
	elseif p == LeaderboardType.Friends and p2 ~= nil then
		v2 = `{formatted}/friends?userid={p2}&count={v}`
	else
		if FFlagPlatformLeaderboardDebugLogging then
			warn("[PlatformLeaderboard] Fetcher missing userId for friends leaderboard")
		end

		return false, nil
	end

	local v3, v4 = get(v2)

	if not v3 then
		return false, nil
	end

	if typeof(v4) == "table" then
		local config2 = v4.config

		if config2 == nil or typeof(config2) == "table" then
			local scores = v4.scores

			if scores == nil or typeof(scores) == "table" then
				return true, {
					config = formatConfig(config2),
					entries = formatEntries(scores or {})
				}
			end

			if FFlagPlatformLeaderboardDebugLogging then
				warn("[PlatformLeaderboard] Fetcher received malformed leaderboard scores payload")
			end

			return false, nil
		end

		if FFlagPlatformLeaderboardDebugLogging then
			warn("[PlatformLeaderboard] Fetcher received malformed leaderboard config payload")
		end

		return false, nil
	end

	if FFlagPlatformLeaderboardDebugLogging then
		warn("[PlatformLeaderboard] Fetcher received malformed leaderboard response body")
	end

	return false, nil
end

function PlatformLeaderboardFetcher.fetchGlobalLeaderboard(p: string, p2: number?)
	return fetchLeaderboard(p, LeaderboardType.Global, nil, p2)
end

function PlatformLeaderboardFetcher.fetchFriendsLeaderboard(p: string, p2: number, p3: number?)
	return fetchLeaderboard(p, LeaderboardType.Friends, p2, p3)
end

function PlatformLeaderboardFetcher.fetchUserScore(_: string, p: number)
	local v, v2 = get(`{formatted}/{p}/score`)

	if not v then
		return false, nil
	end

	if typeof(v2) == "table" then
		local userScore = v2.userScore

		if userScore == nil or typeof(userScore) == "table" then
			if userScore then
				return true, formatEntry(userScore)
			end

			return true, nil
		end

		if FFlagPlatformLeaderboardDebugLogging then
			warn("[PlatformLeaderboard] Fetcher received malformed user score payload")
		end

		return false, nil
	end

	if FFlagPlatformLeaderboardDebugLogging then
		warn("[PlatformLeaderboard] Fetcher received malformed user score response body")
	end

	return false, nil
end

return PlatformLeaderboardFetcher
