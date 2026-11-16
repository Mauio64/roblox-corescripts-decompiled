local parent = script:FindFirstAncestor("ProfileInsights").Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local ProfileInsightsModel = require(script.Parent.ProfileInsightsModel)
local HttpService = game:GetService("HttpService")

local defineFastInt = game:DefineFastInt("ProfileInsightsStoreHttpTimeout", 1500)

local SharedFlags = require(parent.SharedFlags)
local FFlagAddFriendsPageTrustedFriendRequestSection = SharedFlags.FFlagAddFriendsPageTrustedFriendRequestSection

local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfileInsightsSkipFetchNoCacheEntry = SharedFlags2.FFlagProfileInsightsSkipFetchNoCacheEntry
local SharedFlags3 = require(parent.SharedFlags)
local FFlagUserSearchClassmatesInsight = SharedFlags3.FFlagUserSearchClassmatesInsight

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase
local url = urlBuilder.new({
	base = UrlBase.APIS,
	path = "profile-insights-api/v1/multiProfileInsights"
})()

local function makeHttpCall(userIds, count: number?, rankingStrategy: string?, fn)
	HttpService:RequestInternal({
		Url = url,
		Method = "POST",
		Body = HttpService:JSONEncode({
			userIds = userIds,
			count = FFlagUserSearchClassmatesInsight and count or not rankingStrategy and (count or 2) or nil,
			rankingStrategy = rankingStrategy
		}),
		Timeout = defineFastInt,
		CachePolicy = Enum.HttpCachePolicy.None,
		Priority = 0,
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
		RequestType = Enum.HttpRequestType.Default
	}):Start(function(p, p2)
		local success, result

		if p2 and p2.Body then
			success, result = pcall(function()
				return HttpService:JSONDecode(p2.Body)
			end)
		else
			success = false
		end

		if not p then
			success = false
		end

		fn(success, result)
	end)
end

local function createFetchResult(status: string, p) -- 12 equivalent calls inferred from this helper
	return { status = status, data = p }
end

return createComputed(function(_)
	local v = {}

	local v2 = {}

	local profileInsightsSignalList = ProfileInsightsModel.createProfileInsightsSignalList()

	local function getCacheKey(userIds, count: number?, rankingStrategy: string?) -- 2 equivalent calls inferred from this helper
		return table.concat(userIds, ",") .. tostring(count) .. tostring(rankingStrategy)
	end

	local function mergeWithExisting(p: string, items)
		local v3 = v2[p]

		if not v3 then
			return items
		end

		local result = { table.unpack(v3.getProfileInsights(false)) }
		local targetUserIdSet = {}
		local flag = false

		for _, v4 in result do
			targetUserIdSet[v4.targetUserId] = true
		end

		for _, item in items do
			if targetUserIdSet[item.targetUserId] then
				continue
			end

			targetUserIdSet[item.targetUserId] = true
			table.insert(result, item)
			flag = true
		end

		if flag then
			return result
		end

		return (v3.getProfileInsights(false))
	end

	return {
		getProfileInsightsByUserId = function(data)
			local userIds = data.userIds
			local count = data.count
			local rankingStrategy = data.rankingStrategy

			if not userIds or #userIds == 0 then
				return createSignal(createFetchResult("success", {})) -- inferred equivalent call
			end

			local cacheKey = getCacheKey(userIds, count, rankingStrategy) -- inferred equivalent call

			if
				FFlagProfileInsightsSkipFetchNoCacheEntry
				and FFlagAddFriendsPageTrustedFriendRequestSection
				and data.skipFetch
				and not v[cacheKey]
			then
				return createSignal(createFetchResult("success", profileInsightsSignalList)) -- inferred equivalent call
			end

			if v[cacheKey] and not data.forceFetch then
				return createSignal(createFetchResult("success", v[cacheKey])) -- inferred equivalent call
			end

			if not v[cacheKey] then
				v[cacheKey] = ProfileInsightsModel.createProfileInsightsSignalList()
			end

			if FFlagAddFriendsPageTrustedFriendRequestSection and data.skipFetch then
				return createSignal(createFetchResult("success", v[cacheKey])) -- inferred equivalent call
			end

			local signal, v3 = createSignal(createFetchResult("fetching", v[cacheKey])) -- inferred equivalent call
			makeHttpCall(userIds, count, rankingStrategy, function(p, p2)
				if p and p2.userInsights then
					v[cacheKey].setProfileInsights(ProfileInsightsModel.createProfileInsightsList(p2.userInsights))

					v3(createFetchResult("success", v[cacheKey])) -- inferred equivalent call
				else
					v3(createFetchResult("failed", v[cacheKey])) -- inferred equivalent call
				end
			end)
			return signal
		end,
		getProfileInsightsByPage = function(data)
			local v3

			if data.pageId then
				v3 = data.pageId
			else
				v3 = HttpService:GenerateGUID(false)
			end

			local userIds = data.userIds
			local count = data.count
			local rankingStrategy = data.rankingStrategy

			if not v2[v3] then
				v2[v3] = ProfileInsightsModel.createProfileInsightsSignalList()
			end

			if not userIds or #userIds == 0 then
				return createSignal(createFetchResult("success", v2[v3])) -- inferred equivalent call
			end

			local cacheKey = getCacheKey(userIds, count, rankingStrategy) -- inferred equivalent call

			if v[cacheKey] then
				v2[v3].setProfileInsights(mergeWithExisting(v3, v[cacheKey].getProfileInsights(false)))
				return createSignal(createFetchResult("success", v2[v3])) -- inferred equivalent call
			end

			v[cacheKey] = ProfileInsightsModel.createProfileInsightsSignalList()
			local signal, v4 = createSignal(createFetchResult("success", v2[v3])) -- inferred equivalent call
			makeHttpCall(userIds, count, rankingStrategy, function(p, p2)
				if not (p and p2.userInsights) then
					v4(createFetchResult("failed", {})) -- inferred equivalent call

					return
				end

				local profileInsightsList = ProfileInsightsModel.createProfileInsightsList(p2.userInsights)

				v[cacheKey].setProfileInsights(profileInsightsList)

				v2[v3].setProfileInsights(mergeWithExisting(v3, profileInsightsList))
				v4(createFetchResult("success", v2[v3])) -- inferred equivalent call
			end)

			return signal
		end
	}
end)
