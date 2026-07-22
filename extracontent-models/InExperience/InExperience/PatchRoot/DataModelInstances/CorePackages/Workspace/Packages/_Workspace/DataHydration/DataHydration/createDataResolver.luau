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
local FFlagLuaAppDataHydrationOptimisticMutationLayer = SharedFlags.FFlagLuaAppDataHydrationOptimisticMutationLayer
local v12 = game:DefineFastInt("LuaAppDataHydrationDefaultBatchSize", 50)
local v13 = game:DefineFastInt("LuaAppDataHydrationQueueProcessDelaySec", 1)
local v14 = game:DefineFastInt("LuaAppDataHydrationDefaultRequestTimeoutSec", 30)

local function createDataResolver(t1: {[any]: any}) -- line: 27
	-- upvalues: v12 (copy), v13 (copy), v14 (copy), createRequestQueue (copy), getLocalPlayerUserId (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), createMutationLayer (copy), Promise (copy), FFlagSduiChartsSupport (copy), FFlagLuaAppDataHydrationDataResolverOnClear (copy), Players (copy)
	local v17 = t1.supportsMultiGet == nil or t1.supportsMultiGet
	local u18 = t1.requestBatchSize or v12

	if not v17 and not t1.requestBatchSize then
		u18 = 1
	end

	local u19 = t1.queueProcessDelaySec or v13

	if not v17 and not t1.queueProcessDelaySec then
		u19 = 0
	end

	local v20 = t1.requestTimeoutSec or v14
	local cache = t1.cache
	local v22 = createRequestQueue()
	local t2 = {}
	local u24 = nil
	local u25 = getLocalPlayerUserId()
	local u26 = nil

	if FFlagLuaAppDataHydrationOptimisticMutationLayer and t1.supportsMutations then
		u26 = createMutationLayer()
	end

	local function FORCE_FETCH() -- line: 65
		return true
	end
	local function logError(p1) -- line: 69
		-- upvalues: t1 (copy)
		if t1.logError then
			t1.logError(p1)
		end
	end
	local function handleFailure(s1: string, t3: {[any]: any}, n1: number?) -- line: 76
		-- upvalues: u25 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref)
		if n1 ~= u25 then
			return
		end

		if t1.logError then
			t1.logError(s1)
		end

		for _, v42 in t3 do
			t2[v42] = nil
		end

		cache.markItemsAsFailed(t3)

		if FFlagLuaAppDataHydrationOptimisticMutationLayer and u26 then
			u26.drainCommitted(t3, cache.updateItem)
		end
	end
	local function handleSuccess(t4: {[any]: any}, t5: {[any]: any}, n2: number?) -- line: 93
		-- upvalues: u25 (ref), t2 (ref), t1 (copy), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref)
		if n2 ~= u25 then
			return
		end

		for v46, _ in t4 do
			t2[v46] = nil
		end

		if t1.replaceItems then
			cache.replaceItems(t4)
		else
			cache.updateItems(t4)
		end

		local t6 = {}

		if FFlagLuaAppDataHydrationOptimisticMutationLayer then
			for _, v50 in t5 do
				if t4[v50] == nil then
					if u26 and u26.isCommitted(v50) then
						t2[v50] = nil
					else
						table.insert(t6, v50)
					end
				end
			end

			if u26 then
				u26.drainCommitted(t5, cache.updateItem)
			end
		else
			for _, v52 in t5 do
				if t4[v52] == nil then
					table.insert(t6, v52)
				end
			end
		end

		if #t6 > 0 then
			if n2 ~= u25 then
				return
			end

			if t1.logError then
				t1.logError("Items missing in response")
			end

			for _, v54 in t6 do
				t2[v54] = nil
			end

			cache.markItemsAsFailed(t6)

			if FFlagLuaAppDataHydrationOptimisticMutationLayer and u26 then
				u26.drainCommitted(t6, cache.updateItem)
			end
		end
	end
	local function scheduleFetch() -- line: 138
		-- upvalues: u24 (ref), v22 (copy), u19 (ref), u25 (ref), u18 (ref), t2 (ref), cache (copy), v20 (copy), t1 (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref), v17 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy)
		if u24 ~= nil or v22.isEmpty() then
			return
		end

		u24 = task.delay(u19, function() -- line: 144
			-- upvalues: u25 (ref), u24 (ref), v22 (copy), u18 (ref), t2 (ref), cache (copy), v20 (copy), t1 (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref), v17 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy)
			local v98 = u25

			u24 = nil

			if v22.isEmpty() then
				return
			end

			local v99 = v22.pop(u18)

			for _, v101 in v99 do
				t2[v101] = true
			end

			local v102 = cache.getItems(v99)
			local thread = task.delay(v20, function() -- line: 159
				-- upvalues: v20 (copy), v99 (copy), v98 (copy), u25 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref)
				local v128 = `No fetch response after { v20 } sec`
				local v129 = v99

				if v98 ~= u25 then
					return
				end

				if t1.logError then
					t1.logError(v128)
				end

				for _, v131 in v129 do
					t2[v131] = nil
				end

				cache.markItemsAsFailed(v129)

				if FFlagLuaAppDataHydrationOptimisticMutationLayer and u26 then
					u26.drainCommitted(v129, cache.updateItem)
				end
			end)
			local ok, result = pcall(function() -- line: 163
				-- upvalues: v17 (copy), v99 (copy), v102 (copy), t1 (copy), Promise (copy), handleSuccess (copy), v98 (copy), thread (copy), u25 (ref), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref)
				if not v17 then
					local t7 = {}

					for _, v134 in v99 do
						local v135 = v102[v134]

						table.insert(t7, t1.fetchFn(v134, v135))
					end

					Promise.all(t7):andThen(function(p2) -- line: 172
						-- upvalues: v99 (copy), handleSuccess (copy), v98 (copy), thread (copy)
						local t8 = {}

						for v154, v155 in v99 do
							t8[v155] = p2[v154]
						end

						handleSuccess(t8, v99, v98)
						task.cancel(thread)
					end):catch(function(p3) -- line: 180
						-- upvalues: v99 (copy), v98 (copy), u25 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref), thread (copy)
						local v157 = v99

						if v98 == u25 then
							if t1.logError then
								t1.logError(p3)
							end

							for _, v159 in v157 do
								t2[v159] = nil
							end

							cache.markItemsAsFailed(v157)

							if FFlagLuaAppDataHydrationOptimisticMutationLayer and u26 then
								u26.drainCommitted(v157, cache.updateItem)
							end
						end

						task.cancel(thread)
					end)

					return
				end

				t1.fetchFn(v102):andThen(function(t9: {[any]: any}) -- line: 186
					-- upvalues: handleSuccess (copy), v99 (copy), v98 (copy), thread (copy)
					handleSuccess(t9, v99, v98)
					task.cancel(thread)
				end):catch(function(p4) -- line: 190
					-- upvalues: v99 (copy), v98 (copy), u25 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref), thread (copy)
					local v162 = v99

					if v98 == u25 then
						if t1.logError then
							t1.logError(p4)
						end

						for _, v164 in v162 do
							t2[v164] = nil
						end

						cache.markItemsAsFailed(v162)

						if FFlagLuaAppDataHydrationOptimisticMutationLayer and u26 then
							u26.drainCommitted(v162, cache.updateItem)
						end
					end

					task.cancel(thread)
				end)
			end)

			if not ok then
				if v98 == u25 then
					if t1.logError then
						t1.logError(result)
					end

					for _, v107 in v99 do
						t2[v107] = nil
					end

					cache.markItemsAsFailed(v99)

					if FFlagLuaAppDataHydrationOptimisticMutationLayer and u26 then
						u26.drainCommitted(v99, cache.updateItem)
					end
				end

				task.cancel(thread)
			end

			scheduleFetch()
		end)
	end
	local function getAndFetchItems(t10: {[any]: any}, p5: ((...any) -> ...any)?) -- line: 216
		-- upvalues: cache (copy), v22 (copy), t2 (ref), u24 (ref), u19 (ref), u25 (ref), u18 (ref), v20 (copy), t1 (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref), v17 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy)
		local v58, v59 = cache.getItems(t10, p5)
		local t11 = {}
		local t12 = {}

		for v62, v63 in v58 do
			t11[v62] = v63

			if v59[v62] and (not v22.hasItem(v62) and t2[v62] == nil) then
				v22.push(v62)
				table.insert(t12, v62)
			end
		end

		if #t12 > 0 then
			cache.resetFailedItems(t12)
		end

		if not v22.isEmpty() and u24 == nil then
			if v22.isEmpty() then
				return t11
			end

			u24 = task.delay(u19, function() -- line: 144
				-- upvalues: u25 (ref), u24 (ref), v22 (copy), u18 (ref), t2 (ref), cache (copy), v20 (copy), t1 (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref), v17 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy)
				local v108 = u25

				u24 = nil

				if v22.isEmpty() then
					return
				end

				local v109 = v22.pop(u18)

				for _, v111 in v109 do
					t2[v111] = true
				end

				local v112 = cache.getItems(v109)
				local thread = task.delay(v20, function() -- line: 159
					-- upvalues: v20 (copy), v109 (copy), v108 (copy), u25 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref)
					local v136 = `No fetch response after { v20 } sec`
					local v137 = v109

					if v108 ~= u25 then
						return
					end

					if t1.logError then
						t1.logError(v136)
					end

					for _, v139 in v137 do
						t2[v139] = nil
					end

					cache.markItemsAsFailed(v137)

					if FFlagLuaAppDataHydrationOptimisticMutationLayer and u26 then
						u26.drainCommitted(v137, cache.updateItem)
					end
				end)
				local ok, result = pcall(function() -- line: 163
					-- upvalues: v17 (copy), v109 (copy), v112 (copy), t1 (copy), Promise (copy), handleSuccess (copy), v108 (copy), thread (copy), u25 (ref), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref)
					if not v17 then
						local t13 = {}

						for _, v142 in v109 do
							local v143 = v112[v142]

							table.insert(t13, t1.fetchFn(v142, v143))
						end

						Promise.all(t13):andThen(function(p6) -- line: 172
							-- upvalues: v109 (copy), handleSuccess (copy), v108 (copy), thread (copy)
							local t14 = {}

							for v167, v168 in v109 do
								t14[v168] = p6[v167]
							end

							handleSuccess(t14, v109, v108)
							task.cancel(thread)
						end):catch(function(p7) -- line: 180
							-- upvalues: v109 (copy), v108 (copy), u25 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref), thread (copy)
							local v170 = v109

							if v108 == u25 then
								if t1.logError then
									t1.logError(p7)
								end

								for _, v172 in v170 do
									t2[v172] = nil
								end

								cache.markItemsAsFailed(v170)

								if FFlagLuaAppDataHydrationOptimisticMutationLayer and u26 then
									u26.drainCommitted(v170, cache.updateItem)
								end
							end

							task.cancel(thread)
						end)

						return
					end

					t1.fetchFn(v112):andThen(function(t15: {[any]: any}) -- line: 186
						-- upvalues: handleSuccess (copy), v109 (copy), v108 (copy), thread (copy)
						handleSuccess(t15, v109, v108)
						task.cancel(thread)
					end):catch(function(p8) -- line: 190
						-- upvalues: v109 (copy), v108 (copy), u25 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref), thread (copy)
						local v175 = v109

						if v108 == u25 then
							if t1.logError then
								t1.logError(p8)
							end

							for _, v177 in v175 do
								t2[v177] = nil
							end

							cache.markItemsAsFailed(v175)

							if FFlagLuaAppDataHydrationOptimisticMutationLayer and u26 then
								u26.drainCommitted(v175, cache.updateItem)
							end
						end

						task.cancel(thread)
					end)
				end)

				if not ok then
					if v108 == u25 then
						if t1.logError then
							t1.logError(result)
						end

						for _, v117 in v109 do
							t2[v117] = nil
						end

						cache.markItemsAsFailed(v109)

						if FFlagLuaAppDataHydrationOptimisticMutationLayer and u26 then
							u26.drainCommitted(v109, cache.updateItem)
						end
					end

					task.cancel(thread)
				end

				scheduleFetch()
			end)
		end

		return t11
	end
	local function getAndFetchItem(s2: string, p9: ((...any) -> ...any)?) -- line: 238
		-- upvalues: cache (copy), v22 (copy), t2 (ref), u24 (ref), u19 (ref), u25 (ref), u18 (ref), v20 (copy), t1 (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref), v17 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy), FFlagSduiChartsSupport (copy)
		local v66, v67 = cache.getItem(s2, p9)

		if v67 and (not v22.hasItem(s2) and t2[s2] == nil) then
			cache.resetFailedItem(s2)
			v22.push(s2)
		end

		if not v22.isEmpty() and u24 == nil and not v22.isEmpty() then
			u24 = task.delay(u19, function() -- line: 144
				-- upvalues: u25 (ref), u24 (ref), v22 (copy), u18 (ref), t2 (ref), cache (copy), v20 (copy), t1 (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref), v17 (copy), Promise (copy), handleSuccess (copy), scheduleFetch (copy)
				local v118 = u25

				u24 = nil

				if v22.isEmpty() then
					return
				end

				local v119 = v22.pop(u18)

				for _, v121 in v119 do
					t2[v121] = true
				end

				local v122 = cache.getItems(v119)
				local thread = task.delay(v20, function() -- line: 159
					-- upvalues: v20 (copy), v119 (copy), v118 (copy), u25 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref)
					local v144 = `No fetch response after { v20 } sec`
					local v145 = v119

					if v118 ~= u25 then
						return
					end

					if t1.logError then
						t1.logError(v144)
					end

					for _, v147 in v145 do
						t2[v147] = nil
					end

					cache.markItemsAsFailed(v145)

					if FFlagLuaAppDataHydrationOptimisticMutationLayer and u26 then
						u26.drainCommitted(v145, cache.updateItem)
					end
				end)
				local ok, result = pcall(function() -- line: 163
					-- upvalues: v17 (copy), v119 (copy), v122 (copy), t1 (copy), Promise (copy), handleSuccess (copy), v118 (copy), thread (copy), u25 (ref), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref)
					if not v17 then
						local t16 = {}

						for _, v150 in v119 do
							local v151 = v122[v150]

							table.insert(t16, t1.fetchFn(v150, v151))
						end

						Promise.all(t16):andThen(function(p10) -- line: 172
							-- upvalues: v119 (copy), handleSuccess (copy), v118 (copy), thread (copy)
							local t17 = {}

							for v180, v181 in v119 do
								t17[v181] = p10[v180]
							end

							handleSuccess(t17, v119, v118)
							task.cancel(thread)
						end):catch(function(p11) -- line: 180
							-- upvalues: v119 (copy), v118 (copy), u25 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref), thread (copy)
							local v183 = v119

							if v118 == u25 then
								if t1.logError then
									t1.logError(p11)
								end

								for _, v185 in v183 do
									t2[v185] = nil
								end

								cache.markItemsAsFailed(v183)

								if FFlagLuaAppDataHydrationOptimisticMutationLayer and u26 then
									u26.drainCommitted(v183, cache.updateItem)
								end
							end

							task.cancel(thread)
						end)

						return
					end

					t1.fetchFn(v122):andThen(function(t18: {[any]: any}) -- line: 186
						-- upvalues: handleSuccess (copy), v119 (copy), v118 (copy), thread (copy)
						handleSuccess(t18, v119, v118)
						task.cancel(thread)
					end):catch(function(p12) -- line: 190
						-- upvalues: v119 (copy), v118 (copy), u25 (ref), t1 (copy), t2 (ref), cache (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref), thread (copy)
						local v188 = v119

						if v118 == u25 then
							if t1.logError then
								t1.logError(p12)
							end

							for _, v190 in v188 do
								t2[v190] = nil
							end

							cache.markItemsAsFailed(v188)

							if FFlagLuaAppDataHydrationOptimisticMutationLayer and u26 then
								u26.drainCommitted(v188, cache.updateItem)
							end
						end

						task.cancel(thread)
					end)
				end)

				if not ok then
					if v118 == u25 then
						if t1.logError then
							t1.logError(result)
						end

						for _, v127 in v119 do
							t2[v127] = nil
						end

						cache.markItemsAsFailed(v119)

						if FFlagLuaAppDataHydrationOptimisticMutationLayer and u26 then
							u26.drainCommitted(v119, cache.updateItem)
						end
					end

					task.cancel(thread)
				end

				scheduleFetch()
			end)
		end

		if FFlagSduiChartsSupport then
			return v66, v67
		end

		return v66, nil
	end
	local function clear() -- line: 271
		-- upvalues: u24 (ref), t2 (ref), cache (copy), v22 (copy), FFlagLuaAppDataHydrationOptimisticMutationLayer (copy), u26 (ref), FFlagLuaAppDataHydrationDataResolverOnClear (copy), t1 (copy)
		if u24 then
			task.cancel(u24)
			u24 = nil
		end

		t2 = {}
		cache.clear()
		v22.clear()

		if FFlagLuaAppDataHydrationOptimisticMutationLayer and u26 then
			u26.clearAll()
		end

		if FFlagLuaAppDataHydrationDataResolverOnClear and t1.onClear then
			t1.onClear()
		end
	end

	local connection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- line: 288
		-- upvalues: getLocalPlayerUserId (copy), u25 (ref), clear (copy)
		local v74 = getLocalPlayerUserId()

		if v74 ~= u25 then
			u25 = v74
			clear()
		end
	end)
	local t21 = {
		getAndFetchItems = getAndFetchItems,
		getAndFetchItem = getAndFetchItem,
		getCachedItem = function(s3: string) -- line: 255
			-- upvalues: cache (copy)
			return cache.getItem(s3)
		end,
		getCachedItems = function(t19: {[any]: any}) -- line: 259
			-- upvalues: cache (copy)
			return cache.getItems(t19)
		end,
		fetchItem = function(s4: string, p13: ((...any) -> ...any)?) -- line: 263
			-- upvalues: getAndFetchItem (copy), FORCE_FETCH (copy)
			return getAndFetchItem(s4, p13 or FORCE_FETCH)
		end,
		fetchItems = function(t20: {[any]: any}, p14: ((...any) -> ...any)?) -- line: 267
			-- upvalues: getAndFetchItems (copy), FORCE_FETCH (copy)
			return (getAndFetchItems(t20, p14 or FORCE_FETCH))
		end,
		isRequestInQueueOrInFlight = function(s5: string) -- line: 206
			-- upvalues: v22 (copy), t2 (ref)
			if v22.hasItem(s5) then
				return true
			end

			if t2[s5] ~= nil then
				return true
			end

			return false
		end,
		dispose = function() -- line: 296
			-- upvalues: connection (ref), cache (copy)
			if connection then
				connection:Disconnect()
				connection = nil
			end

			cache.dispose()
		end,
		clear = clear
	}

	if FFlagLuaAppDataHydrationOptimisticMutationLayer and u26 then
		function t21.getOptimisticCachedItem(s6: string) -- line: 322
			-- upvalues: cache (copy), u26 (ref)
			local v76, v77 = cache.getItem(s6)

			return u26.getMergedResult(s6, v76), v77
		end
		function t21.getOptimisticCachedItems(t22: {[any]: any}) -- line: 327
			-- upvalues: cache (copy), u26 (ref)
			local v79, v80 = cache.getItems(t22)
			local t23 = {}

			for v82, v83 in v79 do
				t23[v82] = u26.getMergedResult(v82, v83)
			end

			return t23, v80
		end
		function t21.getOptimisticAndFetchItem(s7: string, p15: ((...any) -> ...any)?) -- line: 337
			-- upvalues: getAndFetchItem (copy), FFlagSduiChartsSupport (copy), u26 (ref)
			local v86, v87 = getAndFetchItem(s7, p15)

			if FFlagSduiChartsSupport then
				return u26.getMergedResult(s7, v86), v87
			end

			return u26.getMergedResult(s7, v86), nil
		end
		function t21.getOptimisticAndFetchItems(t24: {[any]: any}, p16: ((...any) -> ...any)?) -- line: 345
			-- upvalues: getAndFetchItems (copy), u26 (ref)
			local t25 = {}

			for v91, v92 in (getAndFetchItems(t24, p16)) do
				t25[v91] = u26.getMergedResult(v91, v92)
			end

			return t25
		end
		function t21.setMutation(s8: string, p17) -- line: 355
			-- upvalues: u26 (ref)
			u26.set(s8, p17)
		end
		function t21.clearMutation(s9: string) -- line: 360
			-- upvalues: u26 (ref)
			u26.clear(s9)
		end
		function t21.commitMutation(s10: string) -- line: 365
			-- upvalues: v22 (copy), t2 (ref), u26 (ref), cache (copy)
			if not not v22.hasItem(s10) or t2[s10] ~= nil then
				u26.markCommitted(s10)

				return
			end

			local v97 = u26.get(s10)

			if v97 ~= nil then
				cache.updateItem(s10, v97)
			end

			u26.clear(s10)
		end
	end

	return t21
end

return createDataResolver
