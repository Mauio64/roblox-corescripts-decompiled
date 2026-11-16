local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
local config = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorCredit/config")
local responseDecoders = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorCredit/responseDecoders")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorCredit/types")
local DataHydrationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils")
local createTierQuotaStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorCredit/createTierQuotaStore")
local fFlagBuildExperienceModelPickerData = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildExperienceModelPickerData

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function createCreatorCreditStore(options)
	local v5 = options or {}
	local quotaSummaryUrl = v5.quotaSummaryUrl or config.quotaSummaryUrl
	local dailyLimitUrl = v5.dailyLimitUrl or config.dailyLimitUrl
	local network = v5.network
	local ttlSeconds = v5.ttlSeconds or config.pollIntervalSeconds

	local v6 = createDataCache(ttlSeconds, ttlSeconds)
	local v7 = createDataCache(ttlSeconds, ttlSeconds)
	local count = 0
	local count2 = 0
	local v8 = Promise.resolve()
	local v9 = Promise.resolve()
	local v10 = Promise.resolve()
	local flag = false
	local getLocalPlayerUserId = v5.getLocalPlayerUserId or DataHydrationUtils.getLocalPlayerUserId
	local tierStore

	if fFlagBuildExperienceModelPickerData then
		tierStore = createTierQuotaStore({
			quotaSummaryUrl = quotaSummaryUrl,
			network = network,
			ttlSeconds = ttlSeconds,
			getLocalPlayerUserId = getLocalPlayerUserId
		})
	else
		tierStore = nil
	end

	local function getTierStore()
		assert(tierStore, "Tier quota requires FFlagBuildExperienceModelPickerData")
		return tierStore
	end

	local function fetchQuotaSummary(p2)
		local v11 = count
		local v12 = if fFlagBuildExperienceModelPickerData then getLocalPlayerUserId() else nil
		local v13 = count2
		local quotaSummary = v8:catch(function(): nil
			return nil
		end):andThen(function()
			if
				flag
				or v11 ~= count
				or fFlagBuildExperienceModelPickerData and v12 ~= getLocalPlayerUserId()
			then
				return Promise.reject("Creator Credit store changed before queued quota read")
			end

			return asPromise(fetch({
				method = "GET",
				url = quotaSummaryUrl,
				analyticsKey = "creator-credit.get-quota-summary",
				network = network,
				decode = responseDecoders.decodeQuotaSummary
			})):andThen(function(p3)
				if
					flag
					or v11 ~= count
					or fFlagBuildExperienceModelPickerData and v12 ~= getLocalPlayerUserId()
				then
					return Promise.reject("Creator Credit store changed during quota read")
				end

				local v14 = v13 ~= count2 and v7.getItem("current-user").data(false)

				if v14 then
					p3.limitSettings = v14
				end

				return p3
			end)
		end)

		v8 = quotaSummary
		return quotaSummary
	end

	local v11 = createDataResolver({
		cache = v6,
		supportsMultiGet = false,
		fetchFn = fetchQuotaSummary
	})

	local function fetchDailyLimit(p2)
		local v12 = count
		local v13 = if fFlagBuildExperienceModelPickerData then getLocalPlayerUserId() else nil
		local v14 = count2
		local dailyLimit = v9:catch(function(): nil
			return nil
		end):andThen(function()
			if
				flag
				or v12 ~= count
				or fFlagBuildExperienceModelPickerData and v13 ~= getLocalPlayerUserId()
			then
				return Promise.reject("Creator Credit store changed before queued daily-limit read")
			end

			return asPromise(fetch({
				method = "GET",
				url = dailyLimitUrl,
				analyticsKey = "creator-credit.get-daily-limit",
				network = network,
				decode = responseDecoders.decodeDailyLimitSettings
			})):andThen(function(p3)
				if
					flag
					or v12 ~= count
					or fFlagBuildExperienceModelPickerData and v13 ~= getLocalPlayerUserId()
				then
					return Promise.reject("Creator Credit store changed during daily-limit read")
				end

				if v14 == count2 then
					return p3
				end

				return v7.getItem("current-user").data(false) or p3
			end)
		end)

		v9 = dailyLimit
		return dailyLimit
	end

	local v12 = createDataResolver({
		cache = v7,
		supportsMultiGet = false,
		fetchFn = fetchDailyLimit
	})

	local function getQuotaSummary()
		return v11.getAndFetchItem("current-user")
	end

	local function getQuotaSummarySignals()
		return v11.getCachedItem("current-user")
	end

	local function refreshQuotaSummary()
		local v13 = count
		local v14 = if fFlagBuildExperienceModelPickerData then getLocalPlayerUserId() else nil
		return fetchQuotaSummary("current-user"):andThen(function(p2)
			if
				flag
				or v13 ~= count
				or fFlagBuildExperienceModelPickerData and v14 ~= getLocalPlayerUserId()
			then
				return Promise.reject("Creator Credit store changed during quota refresh")
			end

			v6.replaceItem("current-user", p2)
			return p2
		end)
	end

	local function getDailyLimit()
		return v12.getAndFetchItem("current-user")
	end

	local function getDailyLimitSignals()
		return v12.getCachedItem("current-user")
	end

	local function refreshDailyLimit()
		local v13 = count
		local v14 = if fFlagBuildExperienceModelPickerData then getLocalPlayerUserId() else nil
		return fetchDailyLimit("current-user"):andThen(function(p2)
			if
				flag
				or v13 ~= count
				or fFlagBuildExperienceModelPickerData and v14 ~= getLocalPlayerUserId()
			then
				return Promise.reject("Creator Credit store changed during daily-limit refresh")
			end

			v7.replaceItem("current-user", p2)
			return p2
		end)
	end

	local function setDailyLimit(p2)
		local v13 = count
		local v14 = if fFlagBuildExperienceModelPickerData then getLocalPlayerUserId() else nil
		local v15 = v10:catch(function() end):andThen(function()
			if fFlagBuildExperienceModelPickerData and v14 ~= getLocalPlayerUserId() then
				return Promise.reject("Creator Credit account changed before daily-limit write")
			end

			if flag or v13 ~= count then
				return Promise.reject("Creator Credit store changed before queued daily-limit write")
			end

			return asPromise((fetch({
				method = "PUT",
				url = dailyLimitUrl,
				analyticsKey = "creator-credit.set-daily-limit",
				body = p2,
				network = network,
				decode = responseDecoders.decodeDailyLimitSettings
			})))
		end)

		v10 = v15
		return v15:andThen(function(limitSettings)
			if fFlagBuildExperienceModelPickerData and v14 ~= getLocalPlayerUserId() then
				return Promise.reject("Creator Credit account changed during daily-limit write")
			end

			if flag or v13 ~= count then
				return limitSettings
			end

			count2 += 1
			v7.replaceItem("current-user", limitSettings)
			local data = v6.getItem("current-user").data(false)

			if data then
				local clone = table.clone(data)
				clone.limitSettings = limitSettings
				v6.replaceItem("current-user", clone)
			end

			if fFlagBuildExperienceModelPickerData then
				assert(tierStore, "Tier quota requires FFlagBuildExperienceModelPickerData")

				tierStore.invalidate()
			end

			return limitSettings
		end)
	end

	local function clear()
		count += 1
		count2 += 1
		v11.clear()
		v12.clear()

		if fFlagBuildExperienceModelPickerData then
			v8 = Promise.resolve()
			v9 = Promise.resolve()
			assert(tierStore, "Tier quota requires FFlagBuildExperienceModelPickerData")

			tierStore.clear()
		end
	end

	local v13

	if fFlagBuildExperienceModelPickerData then
		v13 = (v5.observeLocalPlayerUserId or DataHydrationUtils.observeLocalPlayerUserId)(clear)
	else
		v13 = nil
	end

	local function dispose()
		if flag then
			return
		end

		flag = true
		count += 1
		count2 += 1
		v11.dispose()
		v12.dispose()

		if fFlagBuildExperienceModelPickerData then
			if v13 then
				v13()
			end

			assert(tierStore, "Tier quota requires FFlagBuildExperienceModelPickerData")

			tierStore.dispose()
		end
	end

	local creatorCreditStore = {
		getQuotaSummary = getQuotaSummary,
		getQuotaSummarySignals = getQuotaSummarySignals,
		refreshQuotaSummary = refreshQuotaSummary,
		getDailyLimit = getDailyLimit,
		getDailyLimitSignals = getDailyLimitSignals,
		refreshDailyLimit = refreshDailyLimit,
		setDailyLimit = setDailyLimit,
		clear = clear,
		dispose = dispose
	}

	if not fFlagBuildExperienceModelPickerData then
		return creatorCreditStore
	end

	assert(tierStore, "Tier quota requires FFlagBuildExperienceModelPickerData")
	local v14 = tierStore

	creatorCreditStore.getTierQuotaSummary = v14.getTierQuotaSummary
	creatorCreditStore.getTierQuotaSummarySignals = v14.getTierQuotaSummarySignals
	creatorCreditStore.refreshTierQuotaSummary = v14.refreshTierQuotaSummary

	return creatorCreditStore
end

return createCreatorCreditStore
