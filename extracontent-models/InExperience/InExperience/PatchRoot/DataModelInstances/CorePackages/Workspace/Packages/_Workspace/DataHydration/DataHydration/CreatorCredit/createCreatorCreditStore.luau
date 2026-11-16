local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
local Promise = require(parent.Promise)

local createDataCache = require(script.Parent.Parent.createDataCache)
local createDataResolver = require(script.Parent.Parent.createDataResolver)
local config = require(script.Parent.config)
local responseDecoders = require(script.Parent.responseDecoders)
require(script.Parent.types)
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local createTierQuotaStore = require(script.Parent.createTierQuotaStore)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function createCreatorCreditStore(options)
	local v = options or {}
	local quotaSummaryUrl = v.quotaSummaryUrl or config.quotaSummaryUrl
	local dailyLimitUrl = v.dailyLimitUrl or config.dailyLimitUrl
	local network = v.network
	local ttlSeconds = v.ttlSeconds or config.pollIntervalSeconds

	local dataCache = createDataCache(ttlSeconds, ttlSeconds)
	local dataCache2 = createDataCache(ttlSeconds, ttlSeconds)
	local count = 0
	local count2 = 0
	local v2 = Promise.resolve()
	local v3 = Promise.resolve()
	local v4 = Promise.resolve()
	local flag = false
	local getLocalPlayerUserId = v.getLocalPlayerUserId or DataHydrationUtils.getLocalPlayerUserId
	local tierStore

	if FFlagBuildExperienceModelPickerData then
		tierStore = createTierQuotaStore({
			quotaSummaryUrl = quotaSummaryUrl,
			network = network,
			ttlSeconds = ttlSeconds,
			getLocalPlayerUserId = getLocalPlayerUserId
		})
	else
		tierStore = nil
	end

	local function getTierStore() -- 4 equivalent calls inferred from this helper
		assert(tierStore, "Tier quota requires FFlagBuildExperienceModelPickerData")
		return tierStore
	end

	local function fetchQuotaSummary(_: string)
		local v5 = count
		local v6

		if FFlagBuildExperienceModelPickerData then
			v6 = getLocalPlayerUserId()
		else
			v6 = nil
		end

		local v7 = count2
		local quotaSummary = v2:catch(function(): nil
			return nil
		end):andThen(function()
			if flag or v5 ~= count or FFlagBuildExperienceModelPickerData and v6 ~= getLocalPlayerUserId() then
				return Promise.reject("Creator Credit store changed before queued quota read")
			end

			return asPromise(fetch({
				method = "GET",
				url = quotaSummaryUrl,
				analyticsKey = "creator-credit.get-quota-summary",
				network = network,
				decode = responseDecoders.decodeQuotaSummary
			})):andThen(function(p)
				if flag or v5 ~= count or FFlagBuildExperienceModelPickerData and v6 ~= getLocalPlayerUserId() then
					return Promise.reject("Creator Credit store changed during quota read")
				end

				local limitSettings = v7 ~= count2 and dataCache2.getItem("current-user").data(false)

				if limitSettings then
					p.limitSettings = limitSettings
				end

				return p
			end)
		end)

		v2 = quotaSummary
		return quotaSummary
	end

	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		fetchFn = fetchQuotaSummary
	})

	local function fetchDailyLimit(_: string)
		local v5 = count
		local v6

		if FFlagBuildExperienceModelPickerData then
			v6 = getLocalPlayerUserId()
		else
			v6 = nil
		end

		local v7 = count2
		local dailyLimit = v3:catch(function(): nil
			return nil
		end):andThen(function()
			if flag or v5 ~= count or FFlagBuildExperienceModelPickerData and v6 ~= getLocalPlayerUserId() then
				return Promise.reject("Creator Credit store changed before queued daily-limit read")
			end

			return asPromise(fetch({
				method = "GET",
				url = dailyLimitUrl,
				analyticsKey = "creator-credit.get-daily-limit",
				network = network,
				decode = responseDecoders.decodeDailyLimitSettings
			})):andThen(function(p)
				if flag or v5 ~= count or FFlagBuildExperienceModelPickerData and v6 ~= getLocalPlayerUserId() then
					return Promise.reject("Creator Credit store changed during daily-limit read")
				end

				if v7 == count2 then
					return p
				end

				return dataCache2.getItem("current-user").data(false) or p
			end)
		end)

		v3 = dailyLimit
		return dailyLimit
	end

	local dataResolver2 = createDataResolver({
		cache = dataCache2,
		supportsMultiGet = false,
		fetchFn = fetchDailyLimit
	})

	local function getQuotaSummary()
		return dataResolver.getAndFetchItem("current-user")
	end

	local function getQuotaSummarySignals()
		return dataResolver.getCachedItem("current-user")
	end

	local function refreshQuotaSummary()
		local v5 = count
		local v6

		if FFlagBuildExperienceModelPickerData then
			v6 = getLocalPlayerUserId()
		else
			v6 = nil
		end

		return fetchQuotaSummary("current-user"):andThen(function(p)
			if flag or v5 ~= count or FFlagBuildExperienceModelPickerData and v6 ~= getLocalPlayerUserId() then
				return Promise.reject("Creator Credit store changed during quota refresh")
			end

			dataCache.replaceItem("current-user", p)
			return p
		end)
	end

	local function getDailyLimit()
		return dataResolver2.getAndFetchItem("current-user")
	end

	local function getDailyLimitSignals()
		return dataResolver2.getCachedItem("current-user")
	end

	local function refreshDailyLimit()
		local v5 = count
		local v6

		if FFlagBuildExperienceModelPickerData then
			v6 = getLocalPlayerUserId()
		else
			v6 = nil
		end

		return fetchDailyLimit("current-user"):andThen(function(p)
			if flag or v5 ~= count or FFlagBuildExperienceModelPickerData and v6 ~= getLocalPlayerUserId() then
				return Promise.reject("Creator Credit store changed during daily-limit refresh")
			end

			dataCache2.replaceItem("current-user", p)
			return p
		end)
	end

	local function setDailyLimit(body)
		local v5 = count
		local v6

		if FFlagBuildExperienceModelPickerData then
			v6 = getLocalPlayerUserId()
		else
			v6 = nil
		end

		local v7 = v4:catch(function() end):andThen(function()
			if FFlagBuildExperienceModelPickerData and v6 ~= getLocalPlayerUserId() then
				return Promise.reject("Creator Credit account changed before daily-limit write")
			end

			if flag or v5 ~= count then
				return Promise.reject("Creator Credit store changed before queued daily-limit write")
			end

			return asPromise((fetch({
				method = "PUT",
				url = dailyLimitUrl,
				analyticsKey = "creator-credit.set-daily-limit",
				body = body,
				network = network,
				decode = responseDecoders.decodeDailyLimitSettings
			})))
		end)

		v4 = v7
		return v7:andThen(function(limitSettings)
			if FFlagBuildExperienceModelPickerData and v6 ~= getLocalPlayerUserId() then
				return Promise.reject("Creator Credit account changed during daily-limit write")
			end

			if flag or v5 ~= count then
				return limitSettings
			end

			count2 += 1
			dataCache2.replaceItem("current-user", limitSettings)
			local data = dataCache.getItem("current-user").data(false)

			if data then
				local clone = table.clone(data)
				clone.limitSettings = limitSettings
				dataCache.replaceItem("current-user", clone)
			end

			if FFlagBuildExperienceModelPickerData then
				getTierStore().invalidate() -- inferred equivalent call
			end

			return limitSettings
		end)
	end

	local function clear()
		count += 1
		count2 += 1
		dataResolver.clear()
		dataResolver2.clear()

		if FFlagBuildExperienceModelPickerData then
			v2 = Promise.resolve()
			v3 = Promise.resolve()
			getTierStore().clear() -- inferred equivalent call
		end
	end

	local v5

	if FFlagBuildExperienceModelPickerData then
		v5 = (v.observeLocalPlayerUserId or DataHydrationUtils.observeLocalPlayerUserId)(clear)
	else
		v5 = nil
	end

	local function dispose()
		if flag then
			return
		end

		flag = true
		count += 1
		count2 += 1
		dataResolver.dispose()
		dataResolver2.dispose()

		if FFlagBuildExperienceModelPickerData then
			if v5 then
				v5()
			end

			getTierStore().dispose() -- inferred equivalent call
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

	if FFlagBuildExperienceModelPickerData then
		creatorCreditStore.getTierQuotaSummary = getTierStore().getTierQuotaSummary -- inferred equivalent call
		creatorCreditStore.getTierQuotaSummarySignals = tierStore.getTierQuotaSummarySignals
		creatorCreditStore.refreshTierQuotaSummary = tierStore.refreshTierQuotaSummary
	end

	return creatorCreditStore
end

return createCreatorCreditStore
