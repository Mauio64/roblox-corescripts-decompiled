local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/LuauPolyfill")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorCredit/types")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local fFlagBuildExperienceModelPickerData = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildExperienceModelPickerData

local function defaultDailyLimit()
	return { additionalUsageEnabled = false, dailyLimitSet = true, dailyLimit = 100 }
end

local function defaultQuota()
	return {
		freeTrialDailyAllowance = 100,
		freeTrialRemaining = 72,
		freeTrialPctUsed = 28,
		nextResetEligibleTime = "2026-07-17T00:00:00Z",
		robuxBalance = 500,
		limitSettings = {
			additionalUsageEnabled = false,
			dailyLimitSet = true,
			dailyLimit = 100
		},
		robuxSpentToday = 0,
		limitRemaining = 100,
		freeTrialResetPeriod = "Daily"
	}
end

local function createMockStore(options)
	local v5 = options or {}
	local v6 = createDataCache(300, 300)
	local v7 = createDataCache(300, 300)
	local v8 = {}
	local flag = false

	local function getTierEntry(p2, p3)
		assert(
			fFlagBuildExperienceModelPickerData,
			"Tier quota requires FFlagBuildExperienceModelPickerData"
		)
		assert(not flag, "Creator Credit tier store is disposed")
		assert(p2 == "PRODUCT_BUILD" or p2 == "PRODUCT_BUILD_IN_STUDIO", "Invalid quota product")
		assert(p3 == "default" or p3 == "advanced", "Invalid model tier")
		local formatted = `{p2}:{p3}`

		if v8[formatted] == nil then
			v8[formatted] = {
				cache = createDataCache(300, 300),
				product = p2,
				tier = p3,
				requested = false
			}
		end

		return v8[formatted]
	end

	local function setTierQuota(p2, p3, quota)
		local tierEntry = getTierEntry(p2, p3)
		tierEntry.quota = quota
		tierEntry.error = nil
		local clone = table.clone(quota)
		tierEntry.cache.replaceItem("current-user", clone)
	end

	local function refreshTierQuotaSummary(p2, p3)
		local tierEntry = getTierEntry(p2, p3)
		tierEntry.requested = true

		if tierEntry.error == nil and tierEntry.quota ~= nil then
			local quota = tierEntry.quota
			local tierEntry2 = getTierEntry(p2, p3)
			tierEntry2.quota = quota
			tierEntry2.error = nil
			local clone = table.clone(quota)
			tierEntry2.cache.replaceItem("current-user", clone)

			return tierEntry.cache.getItem("current-user")
		end

		tierEntry.cache.getItem("current-user")
		tierEntry.cache.markItemsAsFailed({ "current-user" })
		return tierEntry.cache.getItem("current-user")
	end

	if fFlagBuildExperienceModelPickerData and v5.initialTierQuotas then
		for k, initialTierQuota in v5.initialTierQuotas do
			for k2, v9 in initialTierQuota do
				local tierEntry = getTierEntry(k, k2)
				tierEntry.quota = v9
				tierEntry.error = nil
				local clone = table.clone(v9)
				tierEntry.cache.replaceItem("current-user", clone)
			end
		end
	end

	if v5.initialQuota then
		v6.replaceItem("current-user", v5.initialQuota)
	end

	if v5.initialDailyLimit then
		v7.replaceItem("current-user", v5.initialDailyLimit)
	end

	local v9 = nil
	local v10 = 0

	local function scheduleAutoPopulate()
		if v9 == nil then
			return
		end

		local v11 = v9

		if v10 <= 0 then
			v6.replaceItem("current-user", v11)
		else
			LuauPolyfill.setTimeout(function()
				v6.replaceItem("current-user", v11)
			end, v10 * 1000)
		end
	end

	local mockStore = {
		getQuotaSummary = function()
			local item, v11 = v6.getItem("current-user")

			if not (v11 and v9 ~= nil) then
				return item
			end

			local v12 = v9

			if v10 <= 0 then
				v6.replaceItem("current-user", v12)
				return item
			end

			LuauPolyfill.setTimeout(function()
				v6.replaceItem("current-user", v12)
			end, v10 * 1000)

			return item
		end,
		getQuotaSummarySignals = function()
			return (v6.getItem("current-user"))
		end,
		refreshQuotaSummary = function()
			local data = v6.getItem("current-user").data(false)
			local v11 = v9 or data or {
				freeTrialDailyAllowance = 100,
				freeTrialRemaining = 72,
				freeTrialPctUsed = 28,
				nextResetEligibleTime = "2026-07-17T00:00:00Z",
				robuxBalance = 500,
				limitSettings = {
					additionalUsageEnabled = false,
					dailyLimitSet = true,
					dailyLimit = 100
				},
				robuxSpentToday = 0,
				limitRemaining = 100,
				freeTrialResetPeriod = "Daily"
			}

			v6.replaceItem("current-user", v11)
			return Promise.resolve(v11)
		end,
		getDailyLimit = function()
			if v7.getItem("current-user").data(false) == nil then
				v7.replaceItem("current-user", {
					additionalUsageEnabled = false,
					dailyLimitSet = true,
					dailyLimit = 100
				})
			end

			return v7.getItem("current-user")
		end,
		getDailyLimitSignals = function()
			return (v7.getItem("current-user"))
		end,
		refreshDailyLimit = function()
			local v11 = v7.getItem("current-user").data(false)
				or {
					additionalUsageEnabled = false,
					dailyLimitSet = true,
					dailyLimit = 100
				}
			v7.replaceItem("current-user", v11)
			return Promise.resolve(v11)
		end,
		setDailyLimit = function(p2)
			v7.replaceItem("current-user", p2)

			if fFlagBuildExperienceModelPickerData then
				for k, v11 in v8 do
					v11.cache.clear()

					if v11.requested then
						refreshTierQuotaSummary(v11.product, v11.tier)
					end
				end
			end

			return Promise.resolve(p2)
		end,
		clear = function()
			v6.clear()
			v7.clear()

			if fFlagBuildExperienceModelPickerData then
				for k, v11 in v8 do
					v11.cache.clear()
					v11.quota = nil
					v11.error = nil
				end
			end
		end,
		dispose = function()
			if fFlagBuildExperienceModelPickerData then
				if flag then
					return
				end

				flag = true
			end

			v6.dispose()
			v7.dispose()

			if fFlagBuildExperienceModelPickerData then
				for k, v11 in v8 do
					v11.cache.dispose()
				end
			end
		end,
		_setQuota = function(p2)
			v6.replaceItem("current-user", p2)
		end,
		_setDailyLimit = function(p2)
			v7.replaceItem("current-user", p2)
		end,
		_setError = function()
			v6.markItemsAsFailed({ "current-user" })
		end,
		_setLoading = function()
			v6.clear()
		end,
		_setAutoPopulate = function(p2, value)
			v9 = p2 or {
				freeTrialDailyAllowance = 100,
				freeTrialRemaining = 72,
				freeTrialPctUsed = 28,
				nextResetEligibleTime = "2026-07-17T00:00:00Z",
				robuxBalance = 500,
				limitSettings = {
					additionalUsageEnabled = false,
					dailyLimitSet = true,
					dailyLimit = 100
				},
				robuxSpentToday = 0,
				limitRemaining = 100,
				freeTrialResetPeriod = "Daily"
			}
			v10 = value or 0
		end
	}

	if not fFlagBuildExperienceModelPickerData then
		return mockStore
	end

	function mockStore.getTierQuotaSummary(p2, p3)
		local tierEntry = getTierEntry(p2, p3)
		tierEntry.requested = true
		local item, v11 = tierEntry.cache.getItem("current-user")

		if v11 and tierEntry.quota then
			refreshTierQuotaSummary(p2, p3)
		end

		return item
	end

	function mockStore.getTierQuotaSummarySignals(p2, p3)
		return getTierEntry(p2, p3).cache.getItem("current-user")
	end

	mockStore.refreshTierQuotaSummary = refreshTierQuotaSummary
	mockStore._setTierQuota = setTierQuota
	function mockStore._setTierError(p2, p3, p4)
		local tierEntry = getTierEntry(p2, p3)
		tierEntry.error = p4 or { errorMessage = "Mock tier quota failed" }
		tierEntry.cache.getItem("current-user")
		tierEntry.cache.markItemsAsFailed({ "current-user" })
	end
	function mockStore._setTierLoading(p2, p3)
		local tierEntry = getTierEntry(p2, p3)
		tierEntry.cache.clear()
		tierEntry.quota = nil
		tierEntry.error = nil
	end
	function mockStore._setTierRefreshQuota(p2, p3, quota)
		local tierEntry = getTierEntry(p2, p3)
		tierEntry.quota = quota
		tierEntry.error = nil
	end

	return mockStore
end

return createMockStore
