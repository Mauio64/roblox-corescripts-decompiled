local Players = game:GetService("Players")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)

local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId
local createRequestQueue = require(DataHydration.createRequestQueue)
local createMutationLayer = require(DataHydration.createMutationLayer)
local Promise = require(DataHydrationParent.Promise)
local SharedFlags = require(DataHydrationParent.SharedFlags)
local FFlagLuaAppDataHydrationDataResolverOnClear = SharedFlags.FFlagLuaAppDataHydrationDataResolverOnClear
local FFlagSduiChartsSupport = SharedFlags.FFlagSduiChartsSupport
local FFlagSduiDataCacheResetItem = SharedFlags.FFlagSduiDataCacheResetItem
local FFlagLuaAppDataHydrationOptimisticMutationLayer = SharedFlags.FFlagLuaAppDataHydrationOptimisticMutationLayer
local v13 = game:DefineFastInt("LuaAppDataHydrationDefaultBatchSize", 50)
local v14 = game:DefineFastInt("LuaAppDataHydrationQueueProcessDelaySec", 1)
local v15 = game:DefineFastInt("LuaAppDataHydrationDefaultRequestTimeoutSec", 30)

local function createDataResolver(t1: {[any]: any}) -- line: 28
	-- upvalues: v13 (copy), v14 (copy), v15 (copy), createRequestQueue (copy), getLocalPlayerUserId (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), createMutationLayer (copy), Promise (copy), FFlagSduiDataCacheResetItem (copy), FFlagSduiChartsSupport (copy), FFlagLuaAppDataHydrationDataResolverOnClear (copy), Players (copy)
	local v18 = t1.supportsMultiGet == nil or t1.supportsMultiGet
	local u19 = t1.requestBatchSize or v13

	if not v18 and not t1.requestBatchSize then
		u19 = 1
	end

	local u20 = t1.queueProcessDelaySec or v14

	if not v18 and not t1.queueProcessDelaySec then
		u20 = 0
	end

	local v21 = t1.requestTimeoutSec or v15
	local cache = t1.cache
	local v23 = createRequestQueue()
	local t2 = {}
	local u25 = nil
	local u26 = getLocalPlayerUserId()
	local u27 = nil

	if FFlagLuaAppDataHydrationOptimisticMutationLayer and t1.supportsMutations then
		u27 = createMutationLayer()
	end

	local function FORCE_FETCH() -- line: 66
		return true
	end
	local function logError(p1) -- line: 70
		-- upvalues: t1 (copy)
		if t1.logError then
			t1.logError(p1)
		end
	end
	local function handleFailure(s1: string, t3: {[any]: any}, n1: number?) -- line: 77
		-- upvalues: u26 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref)
		if n1 ~= u26 then
			return
		end

		if t1.logError then
			t1.logError(s1)
		end

		for _, v43 in t3 do
			t2[v43] = nil
		end

		cache.markItemsAsFailed(t3)

		if FFlagLuaAppDataHydrationOptimisticMutationLayer and u27 then
			u27.drainCommitted(t3, cache.updateItem)
		end
	end
	local function handleSuccess(t4: {[any]: any}, t5: {[any]: any}, n2: number?) -- line: 94
		-- upvalues: u26 (ref), t2 (ref), t1 (copy), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref)
		if n2 ~= u26 then
			return
		end

		for v47, _ in t4 do
			t2[v47] = nil
		end

		if t1.replaceItems then
			cache.replaceItems(t4)
		else
			cache.updateItems(t4)
		end

		local t6 = {}

		if FFlagLuaAppDataHydrationOptimisticMutationLayer then
			for _, v51 in t5 do
				if t4[v51] == nil then
					if u27 and u27.isCommitted(v51) then
						t2[v51] = nil
					else
						table.insert(t6, v51)
					end
				end
			end

			if u27 then
				u27.drainCommitted(t5, cache.updateItem)
			end
		else
			for _, v53 in t5 do
				if t4[v53] == nil then
					table.insert(t6, v53)
				end
			end
		end

		if #t6 > 0 then
			if n2 ~= u26 then
				return
			end

			if t1.logError then
				t1.logError("Items missing in response")
			end

			for _, v55 in t6 do
				t2[v55] = nil
			end

			cache.markItemsAsFailed(t6)

			if FFlagLuaAppDataHydrationOptimisticMutationLayer and u27 then
				u27.drainCommitted(t6, cache.updateItem)
			end
		end
	end
	local function scheduleFetch() -- line: 139
		-- upvalues: u25 (ref), v23 (copy), u20 (ref), u26 (ref), u19 (ref), t2 (ref), cache (copy), v21 (copy), t1 (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref), v18 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy)
		if u25 ~= nil or v23.isEmpty() then
			return
		end

		u25 = task.delay(u20, function() -- line: 145
			-- upvalues: u26 (ref), u25 (ref), v23 (copy), u19 (ref), t2 (ref), cache (copy), v21 (copy), t1 (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref), v18 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy)
			local v99 = u26

			u25 = nil

			if v23.isEmpty() then
				return
			end

			local v100 = v23.pop(u19)

			for _, v102 in v100 do
				t2[v102] = true
			end

			local v103 = cache.getItems(v100)
			local thread = task.delay(v21, function() -- line: 160
				-- upvalues: v21 (copy), v100 (copy), v99 (copy), u26 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref)
				local v129 = `No fetch response after { v21 } sec`
				local v130 = v100

				if v99 ~= u26 then
					return
				end

				if t1.logError then
					t1.logError(v129)
				end

				for _, v132 in v130 do
					t2[v132] = nil
				end

				cache.markItemsAsFailed(v130)

				if FFlagLuaAppDataHydrationOptimisticMutationLayer and u27 then
					u27.drainCommitted(v130, cache.updateItem)
				end
			end)
			local ok, result = pcall(function() -- line: 164
				-- upvalues: v18 (copy), v100 (copy), v103 (copy), t1 (copy), Promise (copy), handleSuccess (copy), v99 (copy), thread (copy), u26 (ref), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref)
				if not v18 then
					local t7 = {}

					for _, v135 in v100 do
						local v136 = v103[v135]

						table.insert(t7, t1.fetchFn(v135, v136))
					end

					Promise.all(t7):andThen(function(p2) -- line: 173
						-- upvalues: v100 (copy), handleSuccess (copy), v99 (copy), thread (copy)
						local t8 = {}

						for v155, v156 in v100 do
							t8[v156] = p2[v155]
						end

						handleSuccess(t8, v100, v99)
						task.cancel(thread)
					end):catch(function(p3) -- line: 181
						-- upvalues: v100 (copy), v99 (copy), u26 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref), thread (copy)
						local v158 = v100

						if v99 == u26 then
							if t1.logError then
								t1.logError(p3)
							end

							for _, v160 in v158 do
								t2[v160] = nil
							end

							cache.markItemsAsFailed(v158)

							if FFlagLuaAppDataHydrationOptimisticMutationLayer and u27 then
								u27.drainCommitted(v158, cache.updateItem)
							end
						end

						task.cancel(thread)
					end)

					return
				end

				t1.fetchFn(v103):andThen(function(t9: {[any]: any}) -- line: 187
					-- upvalues: handleSuccess (copy), v100 (copy), v99 (copy), thread (copy)
					handleSuccess(t9, v100, v99)
					task.cancel(thread)
				end):catch(function(p4) -- line: 191
					-- upvalues: v100 (copy), v99 (copy), u26 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref), thread (copy)
					local v163 = v100

					if v99 == u26 then
						if t1.logError then
							t1.logError(p4)
						end

						for _, v165 in v163 do
							t2[v165] = nil
						end

						cache.markItemsAsFailed(v163)

						if FFlagLuaAppDataHydrationOptimisticMutationLayer and u27 then
							u27.drainCommitted(v163, cache.updateItem)
						end
					end

					task.cancel(thread)
				end)
			end)

			if not ok then
				if v99 == u26 then
					if t1.logError then
						t1.logError(result)
					end

					for _, v108 in v100 do
						t2[v108] = nil
					end

					cache.markItemsAsFailed(v100)

					if FFlagLuaAppDataHydrationOptimisticMutationLayer and u27 then
						u27.drainCommitted(v100, cache.updateItem)
					end
				end

				task.cancel(thread)
			end

			scheduleFetch()
		end)
	end
	local function getAndFetchItems(t10: {[any]: any}, p5: ((...any) -> ...any)?) -- line: 217
		-- upvalues: cache (copy), FFlagSduiDataCacheResetItem (copy), v23 (copy), t2 (ref), u25 (ref), u20 (ref), u26 (ref), u19 (ref), v21 (copy), t1 (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref), v18 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy)
		local v59, v60 = cache.getItems(t10, p5)
		local t11 = {}
		local v62 = if not FFlagSduiDataCacheResetItem then nil else {}

		for v63, v64 in v59 do
			t11[v63] = v64

			if v60[v63] and (not v23.hasItem(v63) and t2[v63] == nil) then
				v23.push(v63)

				if FFlagSduiDataCacheResetItem then
					table.insert(v62, v63)
				end
			end
		end

		if FFlagSduiDataCacheResetItem and #v62 > 0 then
			cache.resetFailedItems(v62)
		end

		if not v23.isEmpty() and u25 == nil then
			if v23.isEmpty() then
				return t11
			end

			u25 = task.delay(u20, function() -- line: 145
				-- upvalues: u26 (ref), u25 (ref), v23 (copy), u19 (ref), t2 (ref), cache (copy), v21 (copy), t1 (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref), v18 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy)
				local v109 = u26

				u25 = nil

				if v23.isEmpty() then
					return
				end

				local v110 = v23.pop(u19)

				for _, v112 in v110 do
					t2[v112] = true
				end

				local v113 = cache.getItems(v110)
				local thread = task.delay(v21, function() -- line: 160
					-- upvalues: v21 (copy), v110 (copy), v109 (copy), u26 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref)
					local v137 = `No fetch response after { v21 } sec`
					local v138 = v110

					if v109 ~= u26 then
						return
					end

					if t1.logError then
						t1.logError(v137)
					end

					for _, v140 in v138 do
						t2[v140] = nil
					end

					cache.markItemsAsFailed(v138)

					if FFlagLuaAppDataHydrationOptimisticMutationLayer and u27 then
						u27.drainCommitted(v138, cache.updateItem)
					end
				end)
				local ok, result = pcall(function() -- line: 164
					-- upvalues: v18 (copy), v110 (copy), v113 (copy), t1 (copy), Promise (copy), handleSuccess (copy), v109 (copy), thread (copy), u26 (ref), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref)
					if not v18 then
						local t12 = {}

						for _, v143 in v110 do
							local v144 = v113[v143]

							table.insert(t12, t1.fetchFn(v143, v144))
						end

						Promise.all(t12):andThen(function(p6) -- line: 173
							-- upvalues: v110 (copy), handleSuccess (copy), v109 (copy), thread (copy)
							local t13 = {}

							for v168, v169 in v110 do
								t13[v169] = p6[v168]
							end

							handleSuccess(t13, v110, v109)
							task.cancel(thread)
						end):catch(function(p7) -- line: 181
							-- upvalues: v110 (copy), v109 (copy), u26 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref), thread (copy)
							local v171 = v110

							if v109 == u26 then
								if t1.logError then
									t1.logError(p7)
								end

								for _, v173 in v171 do
									t2[v173] = nil
								end

								cache.markItemsAsFailed(v171)

								if FFlagLuaAppDataHydrationOptimisticMutationLayer and u27 then
									u27.drainCommitted(v171, cache.updateItem)
								end
							end

							task.cancel(thread)
						end)

						return
					end

					t1.fetchFn(v113):andThen(function(t14: {[any]: any}) -- line: 187
						-- upvalues: handleSuccess (copy), v110 (copy), v109 (copy), thread (copy)
						handleSuccess(t14, v110, v109)
						task.cancel(thread)
					end):catch(function(p8) -- line: 191
						-- upvalues: v110 (copy), v109 (copy), u26 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref), thread (copy)
						local v176 = v110

						if v109 == u26 then
							if t1.logError then
								t1.logError(p8)
							end

							for _, v178 in v176 do
								t2[v178] = nil
							end

							cache.markItemsAsFailed(v176)

							if FFlagLuaAppDataHydrationOptimisticMutationLayer and u27 then
								u27.drainCommitted(v176, cache.updateItem)
							end
						end

						task.cancel(thread)
					end)
				end)

				if not ok then
					if v109 == u26 then
						if t1.logError then
							t1.logError(result)
						end

						for _, v118 in v110 do
							t2[v118] = nil
						end

						cache.markItemsAsFailed(v110)

						if FFlagLuaAppDataHydrationOptimisticMutationLayer and u27 then
							u27.drainCommitted(v110, cache.updateItem)
						end
					end

					task.cancel(thread)
				end

				scheduleFetch()
			end)
		end

		return t11
	end
	local function getAndFetchItem(s2: string, p9: ((...any) -> ...any)?) -- line: 241
		-- upvalues: cache (copy), v23 (copy), t2 (ref), FFlagSduiDataCacheResetItem (copy), u25 (ref), u20 (ref), u26 (ref), u19 (ref), v21 (copy), t1 (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref), v18 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy), FFlagSduiChartsSupport (copy)
		local v67, v68 = cache.getItem(s2, p9)

		if v68 and (not v23.hasItem(s2) and t2[s2] == nil) then
			if FFlagSduiDataCacheResetItem then
				cache.resetFailedItem(s2)
			end

			v23.push(s2)
		end

		if not v23.isEmpty() and u25 == nil and not v23.isEmpty() then
			u25 = task.delay(u20, function() -- line: 145
				-- upvalues: u26 (ref), u25 (ref), v23 (copy), u19 (ref), t2 (ref), cache (copy), v21 (copy), t1 (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref), v18 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy)
				local v119 = u26

				u25 = nil

				if v23.isEmpty() then
					return
				end

				local v120 = v23.pop(u19)

				for _, v122 in v120 do
					t2[v122] = true
				end

				local v123 = cache.getItems(v120)
				local thread = task.delay(v21, function() -- line: 160
					-- upvalues: v21 (copy), v120 (copy), v119 (copy), u26 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref)
					local v145 = `No fetch response after { v21 } sec`
					local v146 = v120

					if v119 ~= u26 then
						return
					end

					if t1.logError then
						t1.logError(v145)
					end

					for _, v148 in v146 do
						t2[v148] = nil
					end

					cache.markItemsAsFailed(v146)

					if FFlagLuaAppDataHydrationOptimisticMutationLayer and u27 then
						u27.drainCommitted(v146, cache.updateItem)
					end
				end)
				local ok, result = pcall(function() -- line: 164
					-- upvalues: v18 (copy), v120 (copy), v123 (copy), t1 (copy), Promise (copy), handleSuccess (copy), v119 (copy), thread (copy), u26 (ref), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref)
					if not v18 then
						local t15 = {}

						for _, v151 in v120 do
							local v152 = v123[v151]

							table.insert(t15, t1.fetchFn(v151, v152))
						end

						Promise.all(t15):andThen(function(p10) -- line: 173
							-- upvalues: v120 (copy), handleSuccess (copy), v119 (copy), thread (copy)
							local t16 = {}

							for v181, v182 in v120 do
								t16[v182] = p10[v181]
							end

							handleSuccess(t16, v120, v119)
							task.cancel(thread)
						end):catch(function(p11) -- line: 181
							-- upvalues: v120 (copy), v119 (copy), u26 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref), thread (copy)
							local v184 = v120

							if v119 == u26 then
								if t1.logError then
									t1.logError(p11)
								end

								for _, v186 in v184 do
									t2[v186] = nil
								end

								cache.markItemsAsFailed(v184)

								if FFlagLuaAppDataHydrationOptimisticMutationLayer and u27 then
									u27.drainCommitted(v184, cache.updateItem)
								end
							end

							task.cancel(thread)
						end)

						return
					end

					t1.fetchFn(v123):andThen(function(t17: {[any]: any}) -- line: 187
						-- upvalues: handleSuccess (copy), v120 (copy), v119 (copy), thread (copy)
						handleSuccess(t17, v120, v119)
						task.cancel(thread)
					end):catch(function(p12) -- line: 191
						-- upvalues: v120 (copy), v119 (copy), u26 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref), thread (copy)
						local v189 = v120

						if v119 == u26 then
							if t1.logError then
								t1.logError(p12)
							end

							for _, v191 in v189 do
								t2[v191] = nil
							end

							cache.markItemsAsFailed(v189)

							if FFlagLuaAppDataHydrationOptimisticMutationLayer and u27 then
								u27.drainCommitted(v189, cache.updateItem)
							end
						end

						task.cancel(thread)
					end)
				end)

				if not ok then
					if v119 == u26 then
						if t1.logError then
							t1.logError(result)
						end

						for _, v128 in v120 do
							t2[v128] = nil
						end

						cache.markItemsAsFailed(v120)

						if FFlagLuaAppDataHydrationOptimisticMutationLayer and u27 then
							u27.drainCommitted(v120, cache.updateItem)
						end
					end

					task.cancel(thread)
				end

				scheduleFetch()
			end)
		end

		if FFlagSduiChartsSupport then
			return v67, v68
		end

		return v67, nil
	end
	local function clear() -- line: 276
		-- upvalues: u25 (ref), t2 (ref), cache (copy), v23 (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u27 (ref), FFlagLuaAppDataHydrationDataResolverOnClear (copy), t1 (copy)
		if u25 then
			task.cancel(u25)
			u25 = nil
		end

		t2 = {}
		cache.clear()
		v23.clear()

		if FFlagLuaAppDataHydrationOptimisticMutationLayer and u27 then
			u27.clearAll()
		end

		if FFlagLuaAppDataHydrationDataResolverOnClear and t1.onClear then
			t1.onClear()
		end
	end

	local connection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- line: 293
		-- upvalues: getLocalPlayerUserId (copy), u26 (ref), clear (copy)
		local v75 = getLocalPlayerUserId()

		if v75 ~= u26 then
			u26 = v75
			clear()
		end
	end)
	local t20 = {
		getAndFetchItems = getAndFetchItems,
		getAndFetchItem = getAndFetchItem,
		getCachedItem = function(s3: string) -- line: 260
			-- upvalues: cache (copy)
			return cache.getItem(s3)
		end,
		getCachedItems = function(t18: {[any]: any}) -- line: 264
			-- upvalues: cache (copy)
			return cache.getItems(t18)
		end,
		fetchItem = function(s4: string, p13: ((...any) -> ...any)?) -- line: 268
			-- upvalues: getAndFetchItem (copy), FORCE_FETCH (copy)
			return getAndFetchItem(s4, p13 or FORCE_FETCH)
		end,
		fetchItems = function(t19: {[any]: any}, p14: ((...any) -> ...any)?) -- line: 272
			-- upvalues: getAndFetchItems (copy), FORCE_FETCH (copy)
			return (getAndFetchItems(t19, p14 or FORCE_FETCH))
		end,
		isRequestInQueueOrInFlight = function(s5: string) -- line: 207
			-- upvalues: v23 (copy), t2 (ref)
			if v23.hasItem(s5) then
				return true
			end

			if t2[s5] ~= nil then
				return true
			end

			return false
		end,
		dispose = function() -- line: 301
			-- upvalues: connection (ref), cache (copy)
			if connection then
				connection:Disconnect()
				connection = nil
			end

			cache.dispose()
		end,
		clear = clear
	}

	if FFlagLuaAppDataHydrationOptimisticMutationLayer and u27 then
		function t20.getOptimisticCachedItem(s6: string) -- line: 327
			-- upvalues: cache (copy), u27 (ref)
			local v77, v78 = cache.getItem(s6)

			return u27.getMergedResult(s6, v77), v78
		end
		function t20.getOptimisticCachedItems(t21: {[any]: any}) -- line: 332
			-- upvalues: cache (copy), u27 (ref)
			local v80, v81 = cache.getItems(t21)
			local t22 = {}

			for v83, v84 in v80 do
				t22[v83] = u27.getMergedResult(v83, v84)
			end

			return t22, v81
		end
		function t20.getOptimisticAndFetchItem(s7: string, p15: ((...any) -> ...any)?) -- line: 342
			-- upvalues: getAndFetchItem (copy), FFlagSduiChartsSupport (copy), u27 (ref)
			local v87, v88 = getAndFetchItem(s7, p15)

			if FFlagSduiChartsSupport then
				return u27.getMergedResult(s7, v87), v88
			end

			return u27.getMergedResult(s7, v87), nil
		end
		function t20.getOptimisticAndFetchItems(t23: {[any]: any}, p16: ((...any) -> ...any)?) -- line: 350
			-- upvalues: getAndFetchItems (copy), u27 (ref)
			local t24 = {}

			for v92, v93 in (getAndFetchItems(t23, p16)) do
				t24[v92] = u27.getMergedResult(v92, v93)
			end

			return t24
		end
		function t20.setMutation(s8: string, p17) -- line: 360
			-- upvalues: u27 (ref)
			u27.set(s8, p17)
		end
		function t20.clearMutation(s9: string) -- line: 365
			-- upvalues: u27 (ref)
			u27.clear(s9)
		end
		function t20.commitMutation(s10: string) -- line: 370
			-- upvalues: v23 (copy), t2 (ref), u27 (ref), cache (copy)
			if not not v23.hasItem(s10) or t2[s10] ~= nil then
				u27.markCommitted(s10)

				return
			end

			local v98 = u27.get(s10)

			if v98 ~= nil then
				cache.updateItem(s10, v98)
			end

			u27.clear(s10)
		end
	end

	return t20
end

return createDataResolver
