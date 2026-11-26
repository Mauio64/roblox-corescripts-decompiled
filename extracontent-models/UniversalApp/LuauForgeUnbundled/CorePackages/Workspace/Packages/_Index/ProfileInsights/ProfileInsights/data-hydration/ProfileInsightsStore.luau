local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileInsights/Signals")
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local ProfileInsightsModel = require("@game/CorePackages/Workspace/Packages/_Index/ProfileInsights/ProfileInsights/data-hydration/ProfileInsightsModel")
local HttpService = game:GetService("HttpService")

local defineFastInt = game:DefineFastInt("ProfileInsightsStoreHttpTimeout", 1500)

local fFlagAddFriendsPageTrustedFriendRequestSection = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileInsights/SharedFlags").FFlagAddFriendsPageTrustedFriendRequestSection

local fFlagProfileInsightsSkipFetchNoCacheEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileInsights/SharedFlags").FFlagProfileInsightsSkipFetchNoCacheEntry
local fFlagUserSearchClassmatesInsight = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileInsights/SharedFlags").FFlagUserSearchClassmatesInsight

local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileInsights/UrlBuilder")
local urlBuilder = UrlBuilder.UrlBuilder
local urlBase = UrlBuilder.UrlBase
local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "profile-insights-api/v1/multiProfileInsights"
})()

local function makeHttpCall(userIds, count, rankingStrategy, fn)
	HttpService:RequestInternal({
		Url = v5,
		Method = "POST",
		Body = HttpService:JSONEncode({
			userIds = userIds,
			count = fFlagUserSearchClassmatesInsight and count or not rankingStrategy and (count or 2) or nil,
			rankingStrategy = rankingStrategy
		}),
		Timeout = defineFastInt,
		CachePolicy = Enum.HttpCachePolicy.None,
		Priority = 0,
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
		RequestType = Enum.HttpRequestType.Default
	}):Start(function(p2, p3)
		local success, result

		if p3 and p3.Body then
			success, result = pcall(function()
				return HttpService:JSONDecode(p3.Body)
			end)
		else
			success = false
		end

		if not p2 then
			success = false
		end

		fn(success, result)
	end)
end

local function createFetchResult(p2, p3)
	return { status = p2, data = p3 }
end

return createComputed(function(p2)
	local v6 = {}

	local v7 = {}

	local profileInsightsSignalList = ProfileInsightsModel.createProfileInsightsSignalList()

	local function getCacheKey(list, p3, p4)
		return table.concat(list, ",") .. tostring(p3) .. tostring(p4)
	end

	local function mergeWithExisting(p3, items)
		local v8 = v7[p3]

		if not v8 then
			return items
		end

		local result = { table.unpack(v8.getProfileInsights(false)) }
		local targetUserIdSet = {}
		local flag = false

		for k, v9 in result do
			targetUserIdSet[v9.targetUserId] = true
		end

		for k, item in items do
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

		return (v8.getProfileInsights(false))
	end

	return {
		getProfileInsightsByUserId = function(data)
			local userIds = data.userIds
			local count = data.count
			local rankingStrategy = data.rankingStrategy

			if not userIds or #userIds == 0 then
				return createSignal({ status = "success", data = {} })
			end

			local v8 = table.concat(userIds, ",") .. tostring(count) .. tostring(rankingStrategy)

			if
				fFlagProfileInsightsSkipFetchNoCacheEntry
				and fFlagAddFriendsPageTrustedFriendRequestSection
				and data.skipFetch
				and not v6[v8]
			then
				return createSignal({
					status = "success",
					data = profileInsightsSignalList
				})
			end

			if v6[v8] and not data.forceFetch then
				return createSignal({ status = "success", data = v6[v8] })
			end

			if not v6[v8] then
				v6[v8] = ProfileInsightsModel.createProfileInsightsSignalList()
			end

			if fFlagAddFriendsPageTrustedFriendRequestSection and data.skipFetch then
				return createSignal({ status = "success", data = v6[v8] })
			end

			local signal, v10 = createSignal({ status = "fetching", data = v6[v8] })
			makeHttpCall(userIds, count, rankingStrategy, function(p3, p4)
				if not (p3 and p4.userInsights) then
					v10({ status = "failed", data = v6[v8] })

					return
				end

				v6[v8].setProfileInsights(ProfileInsightsModel.createProfileInsightsList(p4.userInsights))
				v10({ status = "success", data = v6[v8] })
			end)
			return signal
		end,
		getProfileInsightsByPage = function(data)
			local v8 = if data.pageId then data.pageId else HttpService:GenerateGUID(false)
			local userIds = data.userIds
			local count = data.count
			local rankingStrategy = data.rankingStrategy

			if not v7[v8] then
				v7[v8] = ProfileInsightsModel.createProfileInsightsSignalList()
			end

			if not userIds or #userIds == 0 then
				return createSignal({ status = "success", data = v7[v8] })
			end

			local v9 = table.concat(userIds, ",") .. tostring(count) .. tostring(rankingStrategy)

			if v6[v9] then
				v7[v8].setProfileInsights(mergeWithExisting(v8, v6[v9].getProfileInsights(false)))
				return createSignal({ status = "success", data = v7[v8] })
			end

			v6[v9] = ProfileInsightsModel.createProfileInsightsSignalList()
			local signal, v10 = createSignal({ status = "success", data = v7[v8] })
			makeHttpCall(userIds, count, rankingStrategy, function(p3, p4)
				if not (p3 and p4.userInsights) then
					v10({ status = "failed", data = {} })

					return
				end

				local profileInsightsList = ProfileInsightsModel.createProfileInsightsList(p4.userInsights)

				v6[v9].setProfileInsights(profileInsightsList)

				v7[v8].setProfileInsights(mergeWithExisting(v8, profileInsightsList))
				v10({ status = "success", data = v7[v8] })
			end)

			return signal
		end
	}
end)
