local Players = game:GetService("Players")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)

local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId
local createRequestQueue = require(DataHydration.createRequestQueue)
local Promise = require(DataHydrationParent.Promise)
local SharedFlags = require(DataHydrationParent.SharedFlags)
local FFlagLuaAppDataHydrationDataResolverOnClear = SharedFlags.FFlagLuaAppDataHydrationDataResolverOnClear
local FFlagSduiChartsSupport = SharedFlags.FFlagSduiChartsSupport
local FFlagSduiDataCacheResetItem = SharedFlags.FFlagSduiDataCacheResetItem
local v11 = game:DefineFastInt("LuaAppDataHydrationDefaultBatchSize", 50)
local v12 = game:DefineFastInt("LuaAppDataHydrationQueueProcessDelaySec", 1)
local v13 = game:DefineFastInt("LuaAppDataHydrationDefaultRequestTimeoutSec", 30)

local function createDataResolver(t1: {[any]: any}) -- line: 26
	-- upvalues: v11 (copy), v12 (copy), v13 (copy), createRequestQueue (copy), getLocalPlayerUserId (copy), Promise (copy), FFlagSduiDataCacheResetItem (copy), FFlagSduiChartsSupport (copy), FFlagLuaAppDataHydrationDataResolverOnClear (copy), Players (copy)
	local v16 = t1.supportsMultiGet == nil or t1.supportsMultiGet
	local u17 = t1.requestBatchSize or v11

	if not v16 and not t1.requestBatchSize then
		u17 = 1
	end

	local u18 = t1.queueProcessDelaySec or v12

	if not v16 and not t1.queueProcessDelaySec then
		u18 = 0
	end

	local v19 = t1.requestTimeoutSec or v13
	local cache = t1.cache
	local v21 = createRequestQueue()
	local t2 = {}
	local u23 = nil
	local u24 = getLocalPlayerUserId()

	local function FORCE_FETCH() -- line: 58
		return true
	end
	local function logError(p1) -- line: 62
		-- upvalues: t1 (copy)
		if t1.logError then
			t1.logError(p1)
		end
	end
	local function handleFailure(s1: string, t3: {[any]: any}, n1: number?) -- line: 69
		-- upvalues: u24 (ref), t1 (copy), t2 (ref), cache (copy)
		if n1 ~= u24 then
			return
		end

		if t1.logError then
			t1.logError(s1)
		end

		for _, v39 in t3 do
			t2[v39] = nil
		end

		cache.markItemsAsFailed(t3)
	end
	local function handleSuccess(t4: {[any]: any}, t5: {[any]: any}, n2: number?) -- line: 82
		-- upvalues: u24 (ref), t2 (ref), t1 (copy), cache (copy)
		if n2 ~= u24 then
			return
		end

		for v43, _ in t4 do
			t2[v43] = nil
		end

		if t1.replaceItems then
			cache.replaceItems(t4)
		else
			cache.updateItems(t4)
		end

		local t6 = {}

		for _, v47 in t5 do
			if t4[v47] == nil then
				table.insert(t6, v47)
			end
		end

		if #t6 > 0 then
			if n2 ~= u24 then
				return
			end

			if t1.logError then
				t1.logError("Items missing in response")
			end

			for _, v49 in t6 do
				t2[v49] = nil
			end

			cache.markItemsAsFailed(t6)
		end
	end
	local function scheduleFetch() -- line: 109
		-- upvalues: u23 (ref), v21 (copy), u18 (ref), u24 (ref), u17 (ref), t2 (ref), cache (copy), v19 (copy), t1 (copy), v16 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy)
		if u23 ~= nil or v21.isEmpty() then
			return
		end

		u23 = task.delay(u18, function() -- line: 115
			-- upvalues: u24 (ref), u23 (ref), v21 (copy), u17 (ref), t2 (ref), cache (copy), v19 (copy), t1 (copy), v16 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy)
			local v70 = u24

			u23 = nil

			if v21.isEmpty() then
				return
			end

			local v71 = v21.pop(u17)

			for _, v73 in v71 do
				t2[v73] = true
			end

			local v74 = cache.getItems(v71)
			local thread = task.delay(v19, function() -- line: 130
				-- upvalues: v19 (copy), v71 (copy), v70 (copy), u24 (ref), t1 (copy), t2 (ref), cache (copy)
				local v100 = `No fetch response after { v19 } sec`
				local v101 = v71

				if v70 ~= u24 then
					return
				end

				if t1.logError then
					t1.logError(v100)
				end

				for _, v103 in v101 do
					t2[v103] = nil
				end

				cache.markItemsAsFailed(v101)
			end)
			local ok, result = pcall(function() -- line: 134
				-- upvalues: v16 (copy), v71 (copy), v74 (copy), t1 (copy), Promise (copy), handleSuccess (copy), v70 (copy), thread (copy), u24 (ref), t2 (ref), cache (copy)
				if not v16 then
					local t7 = {}

					for _, v106 in v71 do
						local v107 = v74[v106]

						table.insert(t7, t1.fetchFn(v106, v107))
					end

					Promise.all(t7):andThen(function(p2) -- line: 143
						-- upvalues: v71 (copy), handleSuccess (copy), v70 (copy), thread (copy)
						local t8 = {}

						for v126, v127 in v71 do
							t8[v127] = p2[v126]
						end

						handleSuccess(t8, v71, v70)
						task.cancel(thread)
					end):catch(function(p3) -- line: 151
						-- upvalues: v71 (copy), v70 (copy), u24 (ref), t1 (copy), t2 (ref), cache (copy), thread (copy)
						local v129 = v71

						if v70 == u24 then
							if t1.logError then
								t1.logError(p3)
							end

							for _, v131 in v129 do
								t2[v131] = nil
							end

							cache.markItemsAsFailed(v129)
						end

						task.cancel(thread)
					end)

					return
				end

				t1.fetchFn(v74):andThen(function(t9: {[any]: any}) -- line: 157
					-- upvalues: handleSuccess (copy), v71 (copy), v70 (copy), thread (copy)
					handleSuccess(t9, v71, v70)
					task.cancel(thread)
				end):catch(function(p4) -- line: 161
					-- upvalues: v71 (copy), v70 (copy), u24 (ref), t1 (copy), t2 (ref), cache (copy), thread (copy)
					local v134 = v71

					if v70 == u24 then
						if t1.logError then
							t1.logError(p4)
						end

						for _, v136 in v134 do
							t2[v136] = nil
						end

						cache.markItemsAsFailed(v134)
					end

					task.cancel(thread)
				end)
			end)

			if not ok then
				if v70 == u24 then
					if t1.logError then
						t1.logError(result)
					end

					for _, v79 in v71 do
						t2[v79] = nil
					end

					cache.markItemsAsFailed(v71)
				end

				task.cancel(thread)
			end

			scheduleFetch()
		end)
	end
	local function getAndFetchItems(t10: {[any]: any}, p5: ((...any) -> ...any)?) -- line: 187
		-- upvalues: cache (copy), FFlagSduiDataCacheResetItem (copy), v21 (copy), t2 (ref), u23 (ref), u18 (ref), u24 (ref), u17 (ref), v19 (copy), t1 (copy), v16 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy)
		local v53, v54 = cache.getItems(t10, p5)
		local t11 = {}
		local v56 = if not FFlagSduiDataCacheResetItem then nil else {}

		for v57, v58 in v53 do
			t11[v57] = v58

			if v54[v57] and (not v21.hasItem(v57) and t2[v57] == nil) then
				v21.push(v57)

				if FFlagSduiDataCacheResetItem then
					table.insert(v56, v57)
				end
			end
		end

		if FFlagSduiDataCacheResetItem and #v56 > 0 then
			cache.resetFailedItems(v56)
		end

		if not v21.isEmpty() and u23 == nil then
			if v21.isEmpty() then
				return t11
			end

			u23 = task.delay(u18, function() -- line: 115
				-- upvalues: u24 (ref), u23 (ref), v21 (copy), u17 (ref), t2 (ref), cache (copy), v19 (copy), t1 (copy), v16 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy)
				local v80 = u24

				u23 = nil

				if v21.isEmpty() then
					return
				end

				local v81 = v21.pop(u17)

				for _, v83 in v81 do
					t2[v83] = true
				end

				local v84 = cache.getItems(v81)
				local thread = task.delay(v19, function() -- line: 130
					-- upvalues: v19 (copy), v81 (copy), v80 (copy), u24 (ref), t1 (copy), t2 (ref), cache (copy)
					local v108 = `No fetch response after { v19 } sec`
					local v109 = v81

					if v80 ~= u24 then
						return
					end

					if t1.logError then
						t1.logError(v108)
					end

					for _, v111 in v109 do
						t2[v111] = nil
					end

					cache.markItemsAsFailed(v109)
				end)
				local ok, result = pcall(function() -- line: 134
					-- upvalues: v16 (copy), v81 (copy), v84 (copy), t1 (copy), Promise (copy), handleSuccess (copy), v80 (copy), thread (copy), u24 (ref), t2 (ref), cache (copy)
					if not v16 then
						local t12 = {}

						for _, v114 in v81 do
							local v115 = v84[v114]

							table.insert(t12, t1.fetchFn(v114, v115))
						end

						Promise.all(t12):andThen(function(p6) -- line: 143
							-- upvalues: v81 (copy), handleSuccess (copy), v80 (copy), thread (copy)
							local t13 = {}

							for v139, v140 in v81 do
								t13[v140] = p6[v139]
							end

							handleSuccess(t13, v81, v80)
							task.cancel(thread)
						end):catch(function(p7) -- line: 151
							-- upvalues: v81 (copy), v80 (copy), u24 (ref), t1 (copy), t2 (ref), cache (copy), thread (copy)
							local v142 = v81

							if v80 == u24 then
								if t1.logError then
									t1.logError(p7)
								end

								for _, v144 in v142 do
									t2[v144] = nil
								end

								cache.markItemsAsFailed(v142)
							end

							task.cancel(thread)
						end)

						return
					end

					t1.fetchFn(v84):andThen(function(t14: {[any]: any}) -- line: 157
						-- upvalues: handleSuccess (copy), v81 (copy), v80 (copy), thread (copy)
						handleSuccess(t14, v81, v80)
						task.cancel(thread)
					end):catch(function(p8) -- line: 161
						-- upvalues: v81 (copy), v80 (copy), u24 (ref), t1 (copy), t2 (ref), cache (copy), thread (copy)
						local v147 = v81

						if v80 == u24 then
							if t1.logError then
								t1.logError(p8)
							end

							for _, v149 in v147 do
								t2[v149] = nil
							end

							cache.markItemsAsFailed(v147)
						end

						task.cancel(thread)
					end)
				end)

				if not ok then
					if v80 == u24 then
						if t1.logError then
							t1.logError(result)
						end

						for _, v89 in v81 do
							t2[v89] = nil
						end

						cache.markItemsAsFailed(v81)
					end

					task.cancel(thread)
				end

				scheduleFetch()
			end)
		end

		return t11
	end
	local function getAndFetchItem(s2: string, p9: ((...any) -> ...any)?) -- line: 211
		-- upvalues: cache (copy), v21 (copy), t2 (ref), FFlagSduiDataCacheResetItem (copy), u23 (ref), u18 (ref), u24 (ref), u17 (ref), v19 (copy), t1 (copy), v16 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy), FFlagSduiChartsSupport (copy)
		local v61, v62 = cache.getItem(s2, p9)

		if v62 and (not v21.hasItem(s2) and t2[s2] == nil) then
			if FFlagSduiDataCacheResetItem then
				cache.resetFailedItem(s2)
			end

			v21.push(s2)
		end

		if not v21.isEmpty() and u23 == nil and not v21.isEmpty() then
			u23 = task.delay(u18, function() -- line: 115
				-- upvalues: u24 (ref), u23 (ref), v21 (copy), u17 (ref), t2 (ref), cache (copy), v19 (copy), t1 (copy), v16 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy)
				local v90 = u24

				u23 = nil

				if v21.isEmpty() then
					return
				end

				local v91 = v21.pop(u17)

				for _, v93 in v91 do
					t2[v93] = true
				end

				local v94 = cache.getItems(v91)
				local thread = task.delay(v19, function() -- line: 130
					-- upvalues: v19 (copy), v91 (copy), v90 (copy), u24 (ref), t1 (copy), t2 (ref), cache (copy)
					local v116 = `No fetch response after { v19 } sec`
					local v117 = v91

					if v90 ~= u24 then
						return
					end

					if t1.logError then
						t1.logError(v116)
					end

					for _, v119 in v117 do
						t2[v119] = nil
					end

					cache.markItemsAsFailed(v117)
				end)
				local ok, result = pcall(function() -- line: 134
					-- upvalues: v16 (copy), v91 (copy), v94 (copy), t1 (copy), Promise (copy), handleSuccess (copy), v90 (copy), thread (copy), u24 (ref), t2 (ref), cache (copy)
					if not v16 then
						local t15 = {}

						for _, v122 in v91 do
							local v123 = v94[v122]

							table.insert(t15, t1.fetchFn(v122, v123))
						end

						Promise.all(t15):andThen(function(p10) -- line: 143
							-- upvalues: v91 (copy), handleSuccess (copy), v90 (copy), thread (copy)
							local t16 = {}

							for v152, v153 in v91 do
								t16[v153] = p10[v152]
							end

							handleSuccess(t16, v91, v90)
							task.cancel(thread)
						end):catch(function(p11) -- line: 151
							-- upvalues: v91 (copy), v90 (copy), u24 (ref), t1 (copy), t2 (ref), cache (copy), thread (copy)
							local v155 = v91

							if v90 == u24 then
								if t1.logError then
									t1.logError(p11)
								end

								for _, v157 in v155 do
									t2[v157] = nil
								end

								cache.markItemsAsFailed(v155)
							end

							task.cancel(thread)
						end)

						return
					end

					t1.fetchFn(v94):andThen(function(t17: {[any]: any}) -- line: 157
						-- upvalues: handleSuccess (copy), v91 (copy), v90 (copy), thread (copy)
						handleSuccess(t17, v91, v90)
						task.cancel(thread)
					end):catch(function(p12) -- line: 161
						-- upvalues: v91 (copy), v90 (copy), u24 (ref), t1 (copy), t2 (ref), cache (copy), thread (copy)
						local v160 = v91

						if v90 == u24 then
							if t1.logError then
								t1.logError(p12)
							end

							for _, v162 in v160 do
								t2[v162] = nil
							end

							cache.markItemsAsFailed(v160)
						end

						task.cancel(thread)
					end)
				end)

				if not ok then
					if v90 == u24 then
						if t1.logError then
							t1.logError(result)
						end

						for _, v99 in v91 do
							t2[v99] = nil
						end

						cache.markItemsAsFailed(v91)
					end

					task.cancel(thread)
				end

				scheduleFetch()
			end)
		end

		if FFlagSduiChartsSupport then
			return v61, v62
		end

		return v61, nil
	end
	local function clear() -- line: 246
		-- upvalues: u23 (ref), t2 (ref), cache (copy), v21 (copy), FFlagLuaAppDataHydrationDataResolverOnClear (copy), t1 (copy)
		if u23 then
			task.cancel(u23)
			u23 = nil
		end

		t2 = {}
		cache.clear()
		v21.clear()

		if FFlagLuaAppDataHydrationDataResolverOnClear and t1.onClear then
			t1.onClear()
		end
	end

	local connection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- line: 260
		-- upvalues: getLocalPlayerUserId (copy), u24 (ref), clear (copy)
		local v69 = getLocalPlayerUserId()

		if v69 ~= u24 then
			u24 = v69
			clear()
		end
	end)

	return {
		getAndFetchItems = getAndFetchItems,
		getAndFetchItem = getAndFetchItem,
		getCachedItem = function(s3: string) -- line: 230
			-- upvalues: cache (copy)
			return cache.getItem(s3)
		end,
		getCachedItems = function(t18: {[any]: any}) -- line: 234
			-- upvalues: cache (copy)
			return cache.getItems(t18)
		end,
		fetchItem = function(s4: string, p13: ((...any) -> ...any)?) -- line: 238
			-- upvalues: getAndFetchItem (copy), FORCE_FETCH (copy)
			return getAndFetchItem(s4, p13 or FORCE_FETCH)
		end,
		fetchItems = function(t19: {[any]: any}, p14: ((...any) -> ...any)?) -- line: 242
			-- upvalues: getAndFetchItems (copy), FORCE_FETCH (copy)
			return (getAndFetchItems(t19, p14 or FORCE_FETCH))
		end,
		isRequestInQueueOrInFlight = function(s5: string) -- line: 177
			-- upvalues: v21 (copy), t2 (ref)
			if v21.hasItem(s5) then
				return true
			end

			if t2[s5] ~= nil then
				return true
			end

			return false
		end,
		dispose = function() -- line: 268
			-- upvalues: connection (ref), cache (copy)
			if connection then
				connection:Disconnect()
				connection = nil
			end

			cache.dispose()
		end,
		clear = clear
	}
end

return createDataResolver
