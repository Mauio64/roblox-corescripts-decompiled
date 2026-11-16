local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Promise = require(parent.Promise)

local createDataCache = require(script.Parent.Parent.createDataCache)
require(script.Parent.types)
require(DataHydration.DataHydrationTypes)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData

local function defaultDailyLimit() -- 3 equivalent calls inferred from this helper
	return { additionalUsageEnabled = false, dailyLimitSet = true, dailyLimit = 100 }
end

local function defaultQuota() -- 2 equivalent calls inferred from this helper
	return {
		freeTrialDailyAllowance = 100,
		freeTrialRemaining = 72,
		freeTrialPctUsed = 28,
		nextResetEligibleTime = "2026-07-17T00:00:00Z",
		robuxBalance = 500,
		limitSettings = defaultDailyLimit(), -- inferred equivalent call
		robuxSpentToday = 0,
		limitRemaining = 100,
		freeTrialResetPeriod = "Daily"
	}
end

local function createMockStore(options)
	local v = options or {}
	local dataCache = createDataCache(300, 300)
	local dataCache2 = createDataCache(300, 300)
	local v2 = {}
	local flag = false

	local function getTierEntry(product, tier)
		assert(FFlagBuildExperienceModelPickerData, "Tier quota requires FFlagBuildExperienceModelPickerData")
		assert(not flag, "Creator Credit tier store is disposed")
		assert(product == "PRODUCT_BUILD" or product == "PRODUCT_BUILD_IN_STUDIO", "Invalid quota product")
		assert(tier == "default" or tier == "advanced", "Invalid model tier")
		local formatted = `{product}:{tier}`

		if v2[formatted] == nil then
			v2[formatted] = {
				cache = createDataCache(300, 300),
				product = product,
				tier = tier,
				requested = false
			}
		end

		return v2[formatted]
	end

	local function setTierQuota(product, tier, quota) -- 2 equivalent calls inferred from this helper
		local tierEntry = getTierEntry(product, tier)
		tierEntry.quota = quota
		tierEntry.error = nil
		local clone = table.clone(quota)
		tierEntry.cache.replaceItem("current-user", clone)
	end

	local function refreshTierQuotaSummary(product, tier)
		local tierEntry = getTierEntry(product, tier)
		tierEntry.requested = true

		if tierEntry.error == nil and tierEntry.quota ~= nil then
			setTierQuota(product, tier, tierEntry.quota) -- inferred equivalent call
		else
			tierEntry.cache.getItem("current-user")
			tierEntry.cache.markItemsAsFailed({ "current-user" })
		end

		return tierEntry.cache.getItem("current-user")
	end

	if FFlagBuildExperienceModelPickerData and v.initialTierQuotas then
		for k, initialTierQuota in v.initialTierQuotas do
			for k2, v3 in initialTierQuota do
				setTierQuota(k, k2, v3) -- inferred equivalent call
			end
		end
	end

	if v.initialQuota then
		dataCache.replaceItem("current-user", v.initialQuota)
	end

	if v.initialDailyLimit then
		dataCache2.replaceItem("current-user", v.initialDailyLimit)
	end

	local v3 = nil
	local v4 = 0

	local function scheduleAutoPopulate() -- 1 equivalent call inferred from this helper
		if v3 == nil then
			return
		end

		local v5 = v3

		if v4 <= 0 then
			dataCache.replaceItem("current-user", v5)
		else
			LuauPolyfill.setTimeout(function()
				dataCache.replaceItem("current-user", v5)
			end, v4 * 1000)
		end
	end

	local mockStore = {
		getQuotaSummary = function()
			local item, v5 = dataCache.getItem("current-user")

			if not v5 then
				return item
			end

			scheduleAutoPopulate() -- inferred equivalent call
			return item
		end,
		getQuotaSummarySignals = function()
			return (dataCache.getItem("current-user"))
		end,
		refreshQuotaSummary = function()
			local data = dataCache.getItem("current-user").data(false)
			local v5 = v3 or data or defaultQuota() -- inferred equivalent call
			dataCache.replaceItem("current-user", v5)
			return Promise.resolve(v5)
		end,
		getDailyLimit = function()
			if dataCache2.getItem("current-user").data(false) == nil then
				dataCache2.replaceItem("current-user", defaultDailyLimit()) -- inferred equivalent call
			end

			return (dataCache2.getItem("current-user"))
		end,
		getDailyLimitSignals = function()
			return (dataCache2.getItem("current-user"))
		end,
		refreshDailyLimit = function()
			local v5 = dataCache2.getItem("current-user").data(false) or defaultDailyLimit() -- inferred equivalent call
			dataCache2.replaceItem("current-user", v5)
			return Promise.resolve(v5)
		end,
		setDailyLimit = function(p)
			dataCache2.replaceItem("current-user", p)

			if FFlagBuildExperienceModelPickerData then
				for _, v5 in v2 do
					v5.cache.clear()

					if v5.requested then
						refreshTierQuotaSummary(v5.product, v5.tier)
					end
				end
			end

			return Promise.resolve(p)
		end,
		clear = function()
			dataCache.clear()
			dataCache2.clear()

			if FFlagBuildExperienceModelPickerData then
				for _, v5 in v2 do
					v5.cache.clear()
					v5.quota = nil
					v5.error = nil
				end
			end
		end,
		dispose = function()
			if FFlagBuildExperienceModelPickerData then
				if flag then
					return
				end

				flag = true
			end

			dataCache.dispose()
			dataCache2.dispose()

			if FFlagBuildExperienceModelPickerData then
				for _, v5 in v2 do
					v5.cache.dispose()
				end
			end
		end,
		_setQuota = function(p)
			dataCache.replaceItem("current-user", p)
		end,
		_setDailyLimit = function(p)
			dataCache2.replaceItem("current-user", p)
		end,
		_setError = function()
			dataCache.markItemsAsFailed({ "current-user" })
		end,
		_setLoading = function()
			dataCache.clear()
		end,
		_setAutoPopulate = function(p, value: number?)
			v3 = p or defaultQuota() -- inferred equivalent call
			v4 = value or 0
		end
	}

	if not FFlagBuildExperienceModelPickerData then
		return mockStore
	end

	function mockStore.getTierQuotaSummary(product, tier)
		local tierEntry = getTierEntry(product, tier)
		tierEntry.requested = true
		local item, v5 = tierEntry.cache.getItem("current-user")

		if v5 and tierEntry.quota then
			refreshTierQuotaSummary(product, tier)
		end

		return item
	end

	function mockStore.getTierQuotaSummarySignals(product, tier)
		return getTierEntry(product, tier).cache.getItem("current-user")
	end

	mockStore.refreshTierQuotaSummary = refreshTierQuotaSummary
	mockStore._setTierQuota = setTierQuota
	function mockStore._setTierError(product, tier, p)
		local tierEntry = getTierEntry(product, tier)
		tierEntry.error = p or { errorMessage = "Mock tier quota failed" }
		tierEntry.cache.getItem("current-user")
		tierEntry.cache.markItemsAsFailed({ "current-user" })
	end
	function mockStore._setTierLoading(product, tier)
		local tierEntry = getTierEntry(product, tier)
		tierEntry.cache.clear()
		tierEntry.quota = nil
		tierEntry.error = nil
	end
	function mockStore._setTierRefreshQuota(product, tier, quota)
		local tierEntry = getTierEntry(product, tier)
		tierEntry.quota = quota
		tierEntry.error = nil
	end

	return mockStore
end

return createMockStore
