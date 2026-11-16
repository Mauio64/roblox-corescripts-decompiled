require(script.Parent.Parent.types)
local sessionHistoryMerge = require(script.Parent.Parent.sessionHistoryMerge)

local constants = require(script.Parent.constants)
local historyPageUtils = require(script.Parent.historyPageUtils)
require(script.Parent.sessionDeps)

return {
	createHistoryLoader = function(data, callback)
		local count = 0
		local v = nil
		local v2 = nil

		local function isRefreshGenerationStale(p: number): boolean -- 3 equivalent calls inferred from this helper
			return p ~= data.getRefreshGeneration()
		end

		local function clearHistoryLoadInFlightIfOwned(casSessionId: string) -- 5 equivalent calls inferred from this helper
			if v == casSessionId then
				data.setHistoryLoadInFlight(false)
				v = nil
			end
		end

		local function tryAcquireHistoryLoad(casSessionId: string): boolean -- 2 equivalent calls inferred from this helper
			if data.getHistoryLoadInFlight() then
				if v == casSessionId then
					return false
				end

				data.setHistoryLoadInFlight(false)
				v = nil
			end

			v = casSessionId
			data.setHistoryLoadInFlight(true)
			return true
		end

		local function loadHistoryPage(p: string, historyPageToken: string?, callback2)
			local v3

			if callback == nil then
				local sessionLoad = data.deps.sessionLoad(p, { historyPageToken = historyPageToken })
				v3 = historyPageUtils.awaitRequestStateCancelled(sessionLoad.state, callback2)
			else
				v3 = callback(p, historyPageToken, callback2, 1e999)
			end

			if callback2() or v3.status ~= "succeeded" then
				return false, {}, nil
			end

			if historyPageToken == nil and callback == nil then
				data.onInitialSessionLoad(p, v3.result)
			end

			return
				true,
				historyPageUtils.getSessionLoadHistory(v3.result),
				historyPageUtils.getNextHistoryPageToken(v3.result)
		end

		local function isSessionLoadStale(p: string, p2: number, callback2) -- 3 equivalent calls inferred from this helper
			return callback2() or data.getCasSessionId() ~= p or isRefreshGenerationStale(p2) -- inferred equivalent call
		end

		local function isPrefetchStale(p: string, p2: number, p3: number, callback2) -- 1 equivalent call inferred from this helper
			return isSessionLoadStale(p, p3, callback2) or p2 ~= count -- inferred equivalent call
		end

		local function commitRefreshedHistory(casSessionId: string, refreshGeneration: number, p, p2: string?, callback2): boolean
			if isSessionLoadStale(casSessionId, refreshGeneration, callback2) then -- inferred equivalent call
				return false
			end

			local v3 = {}
			local v4 = {}
			sessionHistoryMerge.mergeHistoryIntoMap(v3, p, v4)

			for k, v5 in data.getOverlayBySequenceId() do
				if v3[k] == nil then
					v4[k] = v5
				end
			end

			data.setLoadedBySequenceId(v3)
			data.setOverlayBySequenceId(v4)
			data.setNextHistoryPageToken(p2)
			data.noteHistorySequenceIds(p)
			data.notifyMergedHistoryChanged()
			data.markHistoryLoaded()
			return true
		end

		local function prefetchOlderHistoryPagesInBackground(p: string, p2: string?, callback2, p3: number, p4: number) -- 2 equivalent calls inferred from this helper
			task.spawn(function()
				local v3 = p2
				local prefetchHistoryPagesOnRefresh = constants.getPrefetchHistoryPagesOnRefresh()

				while prefetchHistoryPagesOnRefresh > 0 and v3 ~= nil do
					if isPrefetchStale(p, p3, p4, callback2) then -- inferred equivalent call
						break
					end

					local v4, v5
					v4, v5, v3 = loadHistoryPage(p, v3, callback2)

					if not v4 then
						break
					end

					if
						not callback2()
						and data.getCasSessionId() == p
						and p4 == data.getRefreshGeneration()
						and p3 == count
					then
						data.mergeHistoryPage(v5, v3)

						prefetchHistoryPagesOnRefresh -= 1
						continue
					end

					break
				end
			end)
		end

		local function beginPrefetchGeneration() -- 2 equivalent calls inferred from this helper
			count += 1
			return count
		end

		local fn
		local function refreshSession(callback2, flag: boolean?): boolean
			local casSessionId = data.getCasSessionId()

			if casSessionId == nil or casSessionId == "" then
				return false
			end

			local refreshGeneration = data.getRefreshGeneration()

			if not tryAcquireHistoryLoad(casSessionId) then -- inferred equivalent call
				return false
			end

			local mergedHistory = data.buildMergedHistory()
			local sequenceIds = historyPageUtils.collectSequenceIds(mergedHistory)
			local v3 = #mergedHistory > 0
			local count2 = 0
			local v4 = nil
			local v5 = {}
			local v6 = {}
			local v7 = not v3

			while true do
				count2 += 1
				local v8, v9
				v8, v9, v4 = loadHistoryPage(casSessionId, v4, callback2)

				if
					not v8
					or callback2()
					or data.getCasSessionId() ~= casSessionId
					or isRefreshGenerationStale(refreshGeneration) -- inferred equivalent call
				then
					break
				end

				v7 = v3 and historyPageUtils.historyOverlapsSequenceIds(v9, sequenceIds) and true or v7

				historyPageUtils.appendUniqueHistoryBySequenceId(v5, v9, v6)

				if not (not v3 or v7 or v4 == nil or constants.getMaxReconciliationHistoryPages() <= count2) then
					continue
				end

				if v3 and v7 then
					if historyPageUtils.appendUniqueHistoryBySequenceId(v5, mergedHistory, v6) > 0 then
						v4 = data.getNextHistoryPageToken()
					end
				elseif v3 then
					historyPageUtils.appendUniqueHistoryBySequenceId(v5, mergedHistory, v6)
				end

				if commitRefreshedHistory(casSessionId, refreshGeneration, v5, v4, callback2) then
					clearHistoryLoadInFlightIfOwned(casSessionId) -- inferred equivalent call

					if v3 or v4 == nil then
						return true
					end

					if flag then
						fn(constants.getPrefetchHistoryPagesOnRefresh(), callback2, nil)
					else
						local count3 = beginPrefetchGeneration() -- inferred equivalent call
						task.defer(function()
							prefetchOlderHistoryPagesInBackground( -- inferred equivalent call
								casSessionId,
								v4,
								callback2,
								count3,
								refreshGeneration
							)
						end)
					end

					return true
				end

				clearHistoryLoadInFlightIfOwned(casSessionId) -- inferred equivalent call
				return false
			end

			clearHistoryLoadInFlightIfOwned(casSessionId) -- inferred equivalent call
			return false
		end

		local function loadOlderHistoryPage(callback2)
			local casSessionId = data.getCasSessionId()
			local nextHistoryPageToken = data.getNextHistoryPageToken()

			if casSessionId == nil or nextHistoryPageToken == nil then
				return false, nil, nil, nil
			end

			local refreshGeneration = data.getRefreshGeneration()

			if not tryAcquireHistoryLoad(casSessionId) then -- inferred equivalent call
				return false, nil, nil, nil
			end

			local v3, v4, v5 = loadHistoryPage(casSessionId, nextHistoryPageToken, callback2)

			if
				v3
				and not callback2()
				and data.getCasSessionId() == casSessionId
				and refreshGeneration == data.getRefreshGeneration()
			then
				data.mergeHistoryPage(v4, v5)
				clearHistoryLoadInFlightIfOwned(casSessionId) -- inferred equivalent call

				if isSessionLoadStale(casSessionId, refreshGeneration, callback2) then -- inferred equivalent call
					return false, nil, nil, nil
				end

				return true, casSessionId, refreshGeneration, v5
			end

			clearHistoryLoadInFlightIfOwned(casSessionId) -- inferred equivalent call
			return false, nil, nil, nil
		end

		fn = function(minimumPagesRemaining: number, isCancelled, shouldContinue)
			local casSessionId = data.getCasSessionId()

			if casSessionId == nil or data.getNextHistoryPageToken() == nil then
				return
			end

			local refreshGeneration = data.getRefreshGeneration()
			local v3 = v2

			if v3 == nil or v3.sessionId ~= casSessionId or v3.refreshGeneration ~= refreshGeneration then
				local v4 = {
					sessionId = casSessionId,
					refreshGeneration = refreshGeneration,
					minimumPagesRemaining = minimumPagesRemaining,
					isCancelled = isCancelled,
					shouldContinue = shouldContinue
				}

				v2 = v4
				task.defer(function()
					local success, result = xpcall(function()
						while true do
							local sessionId = v4.sessionId
							local refreshGeneration2 = v4.refreshGeneration

							if
								v4.isCancelled()
								or data.getCasSessionId() ~= sessionId
								or isRefreshGenerationStale(refreshGeneration2) -- inferred equivalent call
								or data.getNextHistoryPageToken() == nil
							then
								break
							end

							local v5

							if v4.minimumPagesRemaining > 0 then
								v5 = true
							elseif v4.shouldContinue == nil then
								v5 = false
							else
								v5 = v4.shouldContinue()
							end

							if not (v5 and loadOlderHistoryPage(function()
								return v4.isCancelled() or v2 ~= v4
							end)) then
								break
							end

							if v4.minimumPagesRemaining > 0 then
								v4.minimumPagesRemaining -= 1
							end

							task.wait()
						end
					end, debug.traceback)

					if v2 == v4 then
						v2 = nil
					end

					if not success then
						error(result)
					end
				end)
			else
				v3.minimumPagesRemaining = math.max(v3.minimumPagesRemaining, minimumPagesRemaining)
				v3.isCancelled = isCancelled

				if shouldContinue ~= nil then
					v3.shouldContinue = shouldContinue
				end
			end
		end

		local function requestOlderHistoryWhile(callback2, callback3)
			fn(0, callback2, callback3)
		end

		local function loadOlderHistory(callback2)
			local olderHistory, v3, v4, v5 = loadOlderHistoryPage(callback2)

			if olderHistory and v3 ~= nil and v4 ~= nil and v5 ~= nil then
				local count2 = beginPrefetchGeneration() -- inferred equivalent call
				task.defer(function()
					prefetchOlderHistoryPagesInBackground(v3, v5, callback2, count2, v4) -- inferred equivalent call
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
