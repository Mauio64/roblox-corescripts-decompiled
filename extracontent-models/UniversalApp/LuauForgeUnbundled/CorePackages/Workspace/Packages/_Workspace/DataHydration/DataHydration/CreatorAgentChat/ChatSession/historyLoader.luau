require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")
local sessionHistoryMerge = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/sessionHistoryMerge")

local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/constants")
local historyPageUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/historyPageUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/sessionDeps")

return {
	createHistoryLoader = function(data, callback)
		local count = 0
		local v5 = nil
		local v6 = nil

		local function isRefreshGenerationStale(p2): boolean
			return p2 ~= data.getRefreshGeneration()
		end

		local function clearHistoryLoadInFlightIfOwned(p2)
			if v5 == p2 then
				data.setHistoryLoadInFlight(false)
				v5 = nil
			end
		end

		local function tryAcquireHistoryLoad(p2): boolean
			if data.getHistoryLoadInFlight() then
				if v5 == p2 then
					return false
				end

				data.setHistoryLoadInFlight(false)
				v5 = nil
			end

			v5 = p2
			data.setHistoryLoadInFlight(true)
			return true
		end

		local function loadHistoryPage(p2, p3, callback2)
			local v7

			if callback == nil then
				local sessionLoad = data.deps.sessionLoad(p2, { historyPageToken = p3 })
				v7 = historyPageUtils.awaitRequestStateCancelled(sessionLoad.state, callback2)
			else
				v7 = callback(p2, p3, callback2, 1e999)
			end

			if callback2() or v7.status ~= "succeeded" then
				return false, {}, nil
			end

			if p3 == nil and callback == nil then
				data.onInitialSessionLoad(p2, v7.result)
			end

			return
				true,
				historyPageUtils.getSessionLoadHistory(v7.result),
				historyPageUtils.getNextHistoryPageToken(v7.result)
		end

		local function isSessionLoadStale(p2, p3, callback2)
			return callback2() or data.getCasSessionId() ~= p2 or p3 ~= data.getRefreshGeneration()
		end

		local function isPrefetchStale(p2, p3, p4, callback2)
			return callback2()
				or data.getCasSessionId() ~= p2
				or p4 ~= data.getRefreshGeneration()
				or p3 ~= count
		end

		local function commitRefreshedHistory(casSessionId, refreshGeneration, p2, p3, callback2): boolean
			if
				callback2()
				or data.getCasSessionId() ~= casSessionId
				or refreshGeneration ~= data.getRefreshGeneration()
			then
				return false
			end

			local v7 = {}
			local v8 = {}
			sessionHistoryMerge.mergeHistoryIntoMap(v7, p2, v8)

			for k, v9 in data.getOverlayBySequenceId() do
				if v7[k] == nil then
					v8[k] = v9
				end
			end

			data.setLoadedBySequenceId(v7)
			data.setOverlayBySequenceId(v8)
			data.setNextHistoryPageToken(p3)
			data.noteHistorySequenceIds(p2)
			data.notifyMergedHistoryChanged()
			data.markHistoryLoaded()
			return true
		end

		local function prefetchOlderHistoryPagesInBackground(p2, p3, callback2, p4, p5)
			task.spawn(function()
				local v7 = p3
				local prefetchHistoryPagesOnRefresh = constants.getPrefetchHistoryPagesOnRefresh()

				while prefetchHistoryPagesOnRefresh > 0 and v7 ~= nil do
					if
						callback2()
						or data.getCasSessionId() ~= p2
						or p5 ~= data.getRefreshGeneration()
						or p4 ~= count
					then
						break
					end

					local v11, v12
					v11, v12, v7 = loadHistoryPage(p2, v7, callback2)

					if not v11 then
						break
					end

					if
						not callback2()
						and data.getCasSessionId() == p2
						and p5 == data.getRefreshGeneration()
						and p4 == count
					then
						data.mergeHistoryPage(v12, v7)

						prefetchHistoryPagesOnRefresh -= 1
						continue
					end

					break
				end
			end)
		end

		local function beginPrefetchGeneration()
			count += 1
			return count
		end

		local fn
		local function refreshSession(callback2, p2): boolean
			local casSessionId = data.getCasSessionId()

			if casSessionId == nil or casSessionId == "" then
				return false
			end

			local refreshGeneration = data.getRefreshGeneration()
			local v7

			if data.getHistoryLoadInFlight() then
				if v5 == casSessionId then
					v7 = false
				else
					data.setHistoryLoadInFlight(false)
					v5 = nil

					v5 = casSessionId
					data.setHistoryLoadInFlight(true)
					v7 = true
				end
			else
				v5 = casSessionId
				data.setHistoryLoadInFlight(true)
				v7 = true
			end

			if not v7 then
				return false
			end

			local mergedHistory = data.buildMergedHistory()
			local sequenceIds = historyPageUtils.collectSequenceIds(mergedHistory)
			local v8 = #mergedHistory > 0
			local count2 = 0
			local v9 = nil
			local v10 = {}
			local v11 = {}
			local v12 = not v8

			while true do
				count2 += 1
				local v13, v14
				v13, v14, v9 = loadHistoryPage(casSessionId, v9, callback2)

				if
					not v13
					or callback2()
					or data.getCasSessionId() ~= casSessionId
					or refreshGeneration ~= data.getRefreshGeneration()
				then
					break
				end

				v12 = v8 and historyPageUtils.historyOverlapsSequenceIds(v14, sequenceIds) and true or v12

				historyPageUtils.appendUniqueHistoryBySequenceId(v10, v14, v11)

				if not (not v8 or v12 or v9 == nil or constants.getMaxReconciliationHistoryPages() <= count2) then
					continue
				end

				if v8 and v12 then
					if historyPageUtils.appendUniqueHistoryBySequenceId(v10, mergedHistory, v11) > 0 then
						v9 = data.getNextHistoryPageToken()
					end
				elseif v8 then
					historyPageUtils.appendUniqueHistoryBySequenceId(v10, mergedHistory, v11)
				end

				if commitRefreshedHistory(casSessionId, refreshGeneration, v10, v9, callback2) then
					if v5 == casSessionId then
						data.setHistoryLoadInFlight(false)
						v5 = nil
					end

					if v8 or v9 == nil then
						return true
					end

					if p2 then
						fn(constants.getPrefetchHistoryPagesOnRefresh(), callback2, nil)
					else
						count += 1
						local v15 = count

						task.defer(function()
							local v16 = casSessionId
							local v17 = v9
							local v18 = callback2
							local v19 = v15
							local v20 = refreshGeneration
							task.spawn(function()
								local v21 = v17
								local prefetchHistoryPagesOnRefresh = constants.getPrefetchHistoryPagesOnRefresh()

								while prefetchHistoryPagesOnRefresh > 0 and v21 ~= nil do
									if
										v18()
										or data.getCasSessionId() ~= v16
										or v20 ~= data.getRefreshGeneration()
										or v19 ~= count
									then
										break
									end

									local v25, v26
									v25, v26, v21 = loadHistoryPage(v16, v21, v18)

									if not v25 then
										break
									end

									if
										not v18()
										and data.getCasSessionId() == v16
										and v20 == data.getRefreshGeneration()
										and v19 == count
									then
										data.mergeHistoryPage(v26, v21)

										prefetchHistoryPagesOnRefresh -= 1
										continue
									end

									break
								end
							end)
						end)
					end

					return true
				end

				if v5 == casSessionId then
					data.setHistoryLoadInFlight(false)
					v5 = nil
				end

				return false
			end

			if v5 == casSessionId then
				data.setHistoryLoadInFlight(false)
				v5 = nil
			end

			return false
		end

		local function loadOlderHistoryPage(callback2)
			local casSessionId = data.getCasSessionId()
			local nextHistoryPageToken = data.getNextHistoryPageToken()

			if casSessionId == nil or nextHistoryPageToken == nil then
				return false, nil, nil, nil
			end

			local refreshGeneration = data.getRefreshGeneration()
			local v7

			if data.getHistoryLoadInFlight() then
				if v5 == casSessionId then
					v7 = false
				else
					data.setHistoryLoadInFlight(false)
					v5 = nil

					v5 = casSessionId
					data.setHistoryLoadInFlight(true)
					v7 = true
				end
			else
				v5 = casSessionId
				data.setHistoryLoadInFlight(true)
				v7 = true
			end

			if not v7 then
				return false, nil, nil, nil
			end

			local v8, v9, v10 = loadHistoryPage(casSessionId, nextHistoryPageToken, callback2)

			if
				v8
				and not callback2()
				and data.getCasSessionId() == casSessionId
				and refreshGeneration == data.getRefreshGeneration()
			then
				data.mergeHistoryPage(v9, v10)

				if v5 == casSessionId then
					data.setHistoryLoadInFlight(false)
					v5 = nil
				end

				if
					callback2()
					or data.getCasSessionId() ~= casSessionId
					or refreshGeneration ~= data.getRefreshGeneration()
				then
					return false, nil, nil, nil
				end

				return true, casSessionId, refreshGeneration, v10
			end

			if v5 == casSessionId then
				data.setHistoryLoadInFlight(false)
				v5 = nil
			end

			return false, nil, nil, nil
		end

		fn = function(p2, isCancelled, shouldContinue)
			local casSessionId = data.getCasSessionId()

			if casSessionId == nil or data.getNextHistoryPageToken() == nil then
				return
			end

			local refreshGeneration = data.getRefreshGeneration()
			local v7 = v6

			if v7 == nil or v7.sessionId ~= casSessionId or v7.refreshGeneration ~= refreshGeneration then
				local v8 = {
					sessionId = casSessionId,
					refreshGeneration = refreshGeneration,
					minimumPagesRemaining = p2,
					isCancelled = isCancelled,
					shouldContinue = shouldContinue
				}

				v6 = v8
				task.defer(function()
					local success, result = xpcall(function()
						while true do
							local sessionId = v8.sessionId
							local refreshGeneration2 = v8.refreshGeneration

							if
								v8.isCancelled()
								or data.getCasSessionId() ~= sessionId
								or refreshGeneration2 ~= data.getRefreshGeneration()
								or data.getNextHistoryPageToken() == nil
							then
								break
							end

							local v9 = v8.minimumPagesRemaining > 0
								or not (v8.shouldContinue == nil) and v8.shouldContinue()

							if not (v9 and loadOlderHistoryPage(function()
								return v8.isCancelled() or v6 ~= v8
							end)) then
								break
							end

							if v8.minimumPagesRemaining > 0 then
								v8.minimumPagesRemaining -= 1
							end

							task.wait()
						end
					end, debug.traceback)

					if v6 == v8 then
						v6 = nil
					end

					if not success then
						error(result)
					end
				end)
			else
				v7.minimumPagesRemaining = math.max(v7.minimumPagesRemaining, p2)
				v7.isCancelled = isCancelled

				if shouldContinue ~= nil then
					v7.shouldContinue = shouldContinue
				end
			end
		end

		local function requestOlderHistoryWhile(p2, p3)
			fn(0, p2, p3)
		end

		local function loadOlderHistory(p2)
			local olderHistory, v7, v8, v9 = loadOlderHistoryPage(p2)

			if olderHistory and v7 ~= nil and v8 ~= nil and v9 ~= nil then
				count += 1
				local v10 = count

				task.defer(function()
					local v11 = v7
					local v12 = v9
					local v13 = p2
					local v14 = v10
					local v15 = v8
					task.spawn(function()
						local v16 = v12
						local prefetchHistoryPagesOnRefresh = constants.getPrefetchHistoryPagesOnRefresh()

						while prefetchHistoryPagesOnRefresh > 0 and v16 ~= nil do
							if
								v13()
								or data.getCasSessionId() ~= v11
								or v15 ~= data.getRefreshGeneration()
								or v14 ~= count
							then
								break
							end

							local v20, v21
							v20, v21, v16 = loadHistoryPage(v11, v16, v13)

							if not v20 then
								break
							end

							if
								not v13()
								and data.getCasSessionId() == v11
								and v15 == data.getRefreshGeneration()
								and v14 == count
							then
								data.mergeHistoryPage(v21, v16)

								prefetchHistoryPagesOnRefresh -= 1
								continue
							end

							break
						end
					end)
				end)
			end

			return olderHistory
		end

		return {
			refreshSession = refreshSession,
			loadOlderHistory = loadOlderHistory,
			requestOlderHistoryWhile = requestOlderHistoryWhile
		}
	end
}
