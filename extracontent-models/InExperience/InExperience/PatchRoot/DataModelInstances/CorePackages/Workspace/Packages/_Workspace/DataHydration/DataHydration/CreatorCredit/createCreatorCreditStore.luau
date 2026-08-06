local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpClient = require(Parent.HttpClient)
local Promise = require(Parent.Promise)
local createDataCache = require(script.Parent.Parent.createDataCache)
local createDataResolver = require(script.Parent.Parent.createDataResolver)
local config = require(script.Parent.config)
local responseDecoders = require(script.Parent.responseDecoders)

require(script.Parent.types)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function createCreatorCreditStore(t1: {[any]: any}?) -- line: 30
	-- upvalues: config (copy), createDataCache (copy), Promise (copy), asPromise (copy), fetch (copy), responseDecoders (copy), createDataResolver (copy)
	local v12 = t1 or {}
	local v13 = v12.quotaSummaryUrl or config.quotaSummaryUrl
	local v14 = v12.dailyLimitUrl or config.dailyLimitUrl
	local network = v12.network
	local v16 = v12.ttlSeconds or config.pollIntervalSeconds
	local v17 = createDataCache(v16, v16)
	local v18 = createDataCache(v16, v16)
	local n1 = 0
	local n2 = 0
	local u21 = Promise.resolve()
	local u22 = Promise.resolve()
	local u23 = Promise.resolve()
	local u24 = false

	local function fetchQuotaSummary(_: string) -- line: 46
		-- upvalues: n1 (ref), n2 (ref), u21 (ref), u24 (ref), Promise (copy), asPromise (copy), fetch (copy), v13 (copy), network (copy), responseDecoders (copy), v18 (copy)
		local v30 = n1
		local v31 = n2
		local v32 = u21:catch(function() -- line: 49
			return nil
		end):andThen(function() -- line: 52
			-- upvalues: u24 (ref), v30 (copy), n1 (ref), Promise (copy), asPromise (copy), fetch (copy), v13 (copy), network (copy), responseDecoders (copy), v31 (copy), n2 (ref), v18 (copy)
			if u24 or v30 ~= n1 then
				return Promise.reject("Creator Credit store changed before queued quota read")
			end

			return asPromise(fetch({
				method = "GET",
				analyticsKey = "creator-credit.get-quota-summary",
				url = v13,
				network = network,
				decode = responseDecoders.decodeQuotaSummary
			})):andThen(function(p1) -- line: 62
				-- upvalues: u24 (ref), v30 (copy), n1 (ref), Promise (copy), v31 (copy), n2 (ref), v18 (copy)
				if u24 or v30 ~= n1 then
					return Promise.reject("Creator Credit store changed during quota read")
				end

				if v31 ~= n2 then
					local v49 = v18.getItem("current-user").data(false)

					if v49 then
						p1.limitSettings = v49
					end
				end

				return p1
			end)
		end)

		u21 = v32

		return v32
	end

	local v26 = createDataResolver({
		supportsMultiGet = false,
		cache = v17,
		fetchFn = fetchQuotaSummary
	})

	local function fetchDailyLimit(_: string) -- line: 85
		-- upvalues: n1 (ref), n2 (ref), u22 (ref), u24 (ref), Promise (copy), asPromise (copy), fetch (copy), v14 (copy), network (copy), responseDecoders (copy), v18 (copy)
		local v34 = n1
		local v35 = n2
		local v36 = u22:catch(function() -- line: 88
			return nil
		end):andThen(function() -- line: 91
			-- upvalues: u24 (ref), v34 (copy), n1 (ref), Promise (copy), asPromise (copy), fetch (copy), v14 (copy), network (copy), responseDecoders (copy), v35 (copy), n2 (ref), v18 (copy)
			if u24 or v34 ~= n1 then
				return Promise.reject("Creator Credit store changed before queued daily-limit read")
			end

			return asPromise(fetch({
				method = "GET",
				analyticsKey = "creator-credit.get-daily-limit",
				url = v14,
				network = network,
				decode = responseDecoders.decodeDailyLimitSettings
			})):andThen(function(p2) -- line: 101
				-- upvalues: u24 (ref), v34 (copy), n1 (ref), Promise (copy), v35 (copy), n2 (ref), v18 (copy)
				if u24 or v34 ~= n1 then
					return Promise.reject("Creator Credit store changed during daily-limit read")
				end

				if v35 ~= n2 then
					return v18.getItem("current-user").data(false) or p2
				end

				return p2
			end)
		end)

		u22 = v36

		return v36
	end

	local v28 = createDataResolver({
		supportsMultiGet = false,
		cache = v18,
		fetchFn = fetchDailyLimit
	})

	return {
		getQuotaSummary = function() -- line: 121
			-- upvalues: v26 (copy)
			return v26.getAndFetchItem("current-user")
		end,
		getQuotaSummarySignals = function() -- line: 125
			-- upvalues: v26 (copy)
			return v26.getCachedItem("current-user")
		end,
		refreshQuotaSummary = function() -- line: 129
			-- upvalues: n1 (ref), fetchQuotaSummary (copy), u24 (ref), Promise (copy), v17 (copy)
			local v37 = n1

			return fetchQuotaSummary("current-user"):andThen(function(p3) -- line: 131
				-- upvalues: u24 (ref), v37 (copy), n1 (ref), Promise (copy), v17 (copy)
				if u24 or v37 ~= n1 then
					return Promise.reject("Creator Credit store changed during quota refresh")
				end

				v17.replaceItem("current-user", p3)

				return p3
			end)
		end,
		getDailyLimit = function() -- line: 140
			-- upvalues: v28 (copy)
			return v28.getAndFetchItem("current-user")
		end,
		getDailyLimitSignals = function() -- line: 144
			-- upvalues: v28 (copy)
			return v28.getCachedItem("current-user")
		end,
		refreshDailyLimit = function() -- line: 148
			-- upvalues: n1 (ref), fetchDailyLimit (copy), u24 (ref), Promise (copy), v18 (copy)
			local v38 = n1

			return fetchDailyLimit("current-user"):andThen(function(p4) -- line: 150
				-- upvalues: u24 (ref), v38 (copy), n1 (ref), Promise (copy), v18 (copy)
				if u24 or v38 ~= n1 then
					return Promise.reject("Creator Credit store changed during daily-limit refresh")
				end

				v18.replaceItem("current-user", p4)

				return p4
			end)
		end,
		setDailyLimit = function(p5) -- line: 159
			-- upvalues: n1 (ref), u23 (ref), u24 (ref), Promise (copy), fetch (copy), v14 (copy), network (copy), responseDecoders (copy), asPromise (copy), n2 (ref), v18 (copy), v17 (copy)
			local v40 = n1
			local v41 = u23:catch(function() -- line: 161
			end):andThen(function() -- line: 162
				-- upvalues: u24 (ref), v40 (copy), n1 (ref), Promise (copy), fetch (copy), v14 (copy), p5 (copy), network (copy), responseDecoders (copy), asPromise (copy)
				if u24 or v40 ~= n1 then
					return Promise.reject("Creator Credit store changed before queued daily-limit write")
				end

				local v44 = fetch({
					method = "PUT",
					analyticsKey = "creator-credit.set-daily-limit",
					url = v14,
					body = p5,
					network = network,
					decode = responseDecoders.decodeDailyLimitSettings
				})

				return asPromise(v44)
			end)

			u23 = v41

			return v41:andThen(function(p6) -- line: 179
				-- upvalues: u24 (ref), v40 (copy), n1 (ref), n2 (ref), v18 (copy), v17 (copy)
				if not u24 and v40 == n1 then
					n2 += 1
					v18.replaceItem("current-user", p6)

					local v46 = v17.getItem("current-user").data(false)

					if v46 then
						local v47 = table.clone(v46)

						v47.limitSettings = p6
						v17.replaceItem("current-user", v47)
					end
				end

				return p6
			end)
		end,
		clear = function() -- line: 194
			-- upvalues: n1 (ref), n2 (ref), v26 (copy), v28 (copy)
			n1 += 1
			n2 += 1
			v26.clear()
			v28.clear()
		end,
		dispose = function() -- line: 201
			-- upvalues: u24 (ref), n1 (ref), n2 (ref), v26 (copy), v28 (copy)
			if u24 then
				return
			end

			u24 = true
			n1 += 1
			n2 += 1
			v26.dispose()
			v28.dispose()
		end
	}
end

return createCreatorCreditStore
