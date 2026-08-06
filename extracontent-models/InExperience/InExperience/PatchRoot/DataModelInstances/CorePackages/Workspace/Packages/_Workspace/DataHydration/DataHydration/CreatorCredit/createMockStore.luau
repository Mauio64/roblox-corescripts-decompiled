local Parent = script:FindFirstAncestor("DataHydration").Parent
local LuauPolyfill = require(Parent.LuauPolyfill)
local Promise = require(Parent.Promise)
local createDataCache = require(script.Parent.Parent.createDataCache)

require(script.Parent.types)

local function defaultDailyLimit() -- line: 30
	return {
		additionalUsageEnabled = false,
		dailyLimitSet = true,
		dailyLimit = 100
	}
end
local function defaultQuota() -- line: 38
	return {
		freeTrialDailyAllowance = 100,
		freeTrialRemaining = 72,
		freeTrialPctUsed = 28,
		nextResetEligibleTime = "2026-07-17T00:00:00Z",
		robuxBalance = 500,
		robuxSpentToday = 0,
		limitRemaining = 100,
		limitSettings = {
			additionalUsageEnabled = false,
			dailyLimitSet = true,
			dailyLimit = 100
		}
	}
end
local function createMockStore(t1: {[any]: any}?) -- line: 51
	-- upvalues: createDataCache (copy), LuauPolyfill (copy), Promise (copy)
	local v9 = t1 or {}
	local v10 = createDataCache(300, 300)
	local v11 = createDataCache(300, 300)

	if v9.initialQuota then
		v10.replaceItem("current-user", v9.initialQuota)
	end

	if v9.initialDailyLimit then
		v11.replaceItem("current-user", v9.initialDailyLimit)
	end

	local u12 = nil
	local n1 = 0

	local function scheduleAutoPopulate() -- line: 66
		-- upvalues: u12 (ref), n1 (ref), v10 (copy), LuauPolyfill (copy)
		if u12 == nil then
			return
		end

		local v15 = u12

		if n1 <= 0 then
			v10.replaceItem("current-user", v15)

			return
		end

		LuauPolyfill.setTimeout(function() -- line: 75
			-- upvalues: v10 (copy), v15 (copy)
			v10.replaceItem("current-user", v15)
		end, n1 * 1000)
	end

	return {
		getQuotaSummary = function() -- line: 80
			-- upvalues: v10 (copy), u12 (ref), n1 (ref), LuauPolyfill (copy)
			local v16, v17 = v10.getItem("current-user")

			if v17 then
				if u12 == nil then
					return v16
				end

				local v18 = u12

				if n1 <= 0 then
					v10.replaceItem("current-user", v18)

					return v16
				end

				LuauPolyfill.setTimeout(function() -- line: 75
					-- upvalues: v10 (copy), v18 (copy)
					v10.replaceItem("current-user", v18)
				end, n1 * 1000)
			end

			return v16
		end,
		getQuotaSummarySignals = function() -- line: 88
			-- upvalues: v10 (copy)
			return (v10.getItem("current-user"))
		end,
		refreshQuotaSummary = function() -- line: 93
			-- upvalues: v10 (copy), u12 (ref), Promise (copy)
			local v19 = v10.getItem("current-user").data(false)
			local v20 = u12 or (v19 or {
				freeTrialDailyAllowance = 100,
				freeTrialRemaining = 72,
				freeTrialPctUsed = 28,
				nextResetEligibleTime = "2026-07-17T00:00:00Z",
				robuxBalance = 500,
				robuxSpentToday = 0,
				limitRemaining = 100,
				limitSettings = {
					additionalUsageEnabled = false,
					dailyLimitSet = true,
					dailyLimit = 100
				}
			})

			v10.replaceItem("current-user", v20)

			return Promise.resolve(v20)
		end,
		getDailyLimit = function() -- line: 100
			-- upvalues: v11 (copy)
			if v11.getItem("current-user").data(false) == nil then
				v11.replaceItem("current-user", {
					additionalUsageEnabled = false,
					dailyLimitSet = true,
					dailyLimit = 100
				})
			end

			return (v11.getItem("current-user"))
		end,
		getDailyLimitSignals = function() -- line: 108
			-- upvalues: v11 (copy)
			return (v11.getItem("current-user"))
		end,
		refreshDailyLimit = function() -- line: 113
			-- upvalues: v11 (copy), Promise (copy)
			local v21 = v11.getItem("current-user").data(false) or {
				additionalUsageEnabled = false,
				dailyLimitSet = true,
				dailyLimit = 100
			}

			v11.replaceItem("current-user", v21)

			return Promise.resolve(v21)
		end,
		setDailyLimit = function(p1) -- line: 119
			-- upvalues: v11 (copy), Promise (copy)
			v11.replaceItem("current-user", p1)

			return Promise.resolve(p1)
		end,
		clear = function() -- line: 124
			-- upvalues: v10 (copy), v11 (copy)
			v10.clear()
			v11.clear()
		end,
		dispose = function() -- line: 129
			-- upvalues: v10 (copy), v11 (copy)
			v10.dispose()
			v11.dispose()
		end,
		_setQuota = function(p2) -- line: 144
			-- upvalues: v10 (copy)
			v10.replaceItem("current-user", p2)
		end,
		_setDailyLimit = function(p3) -- line: 147
			-- upvalues: v11 (copy)
			v11.replaceItem("current-user", p3)
		end,
		_setError = function() -- line: 150
			-- upvalues: v10 (copy)
			v10.markItemsAsFailed({ "current-user" })
		end,
		_setLoading = function() -- line: 153
			-- upvalues: v10 (copy)
			v10.clear()
		end,
		_setAutoPopulate = function(p4, n2: number?) -- line: 156
			-- upvalues: u12 (ref), n1 (ref)
			u12 = p4 or {
				freeTrialDailyAllowance = 100,
				freeTrialRemaining = 72,
				freeTrialPctUsed = 28,
				nextResetEligibleTime = "2026-07-17T00:00:00Z",
				robuxBalance = 500,
				robuxSpentToday = 0,
				limitRemaining = 100,
				limitSettings = {
					additionalUsageEnabled = false,
					dailyLimitSet = true,
					dailyLimit = 100
				}
			}
			n1 = n2 or 0
		end
	}
end

return createMockStore
