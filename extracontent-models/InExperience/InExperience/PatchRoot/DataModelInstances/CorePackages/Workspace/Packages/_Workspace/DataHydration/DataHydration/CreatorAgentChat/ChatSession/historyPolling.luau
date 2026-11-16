local parent = script:FindFirstAncestor("DataHydration").Parent

local SharedFlags = require(parent.SharedFlags)

require(script.Parent.Parent.types)

local constants = require(script.Parent.constants)
local historyPageUtils = require(script.Parent.historyPageUtils)
require(script.Parent.sessionDeps)

local FFlagBuildExperienceHistoryPollTelemetry = SharedFlags.FFlagBuildExperienceHistoryPollTelemetry

return {
	createHistoryPolling = function(data, callback)
		local function pollSessionHistory(p: string, afterSequenceId: number?, onDroppedChatMessage, shouldStopPolling, pollTrigger, priorSequenceId: number?): boolean
			if shouldStopPolling() then
				return false
			end

			local v

			if callback == nil then
				local sessionLoad = data.deps.sessionLoad(p, nil)
				v = historyPageUtils.awaitRequestState(sessionLoad.state, os.clock() + data.rpcTimeoutSeconds)

				if v.status == "pending" then
					sessionLoad.dispose()
					return false
				end
			else
				v = callback(p, nil, shouldStopPolling)
			end

			if shouldStopPolling() or v.status ~= "succeeded" then
				return false
			end

			local sessionLoadHistory = historyPageUtils.getSessionLoadHistory(v.result)

			if #sessionLoadHistory == 0 or shouldStopPolling() or shouldStopPolling() then
				return false
			end

			data.mergeHistoryPage(sessionLoadHistory, data.getNextHistoryPageToken())
			local ingestSessionHistory = data.deps.ingestSessionHistory(p, sessionLoadHistory, afterSequenceId)

			if onDroppedChatMessage ~= nil then
				local v2 = pollTrigger ~= nil and {
					pollTrigger = pollTrigger,
					appliedFromThisPoll = #ingestSessionHistory,
					priorSequenceId = priorSequenceId
				} or nil

				for _, v3 in ingestSessionHistory do
					onDroppedChatMessage(v3, v2)
				end
			end

			return not shouldStopPolling() and #ingestSessionHistory > 0
		end

		local function startPollingTurnFromHistory(p: string, activeTurnHandle, options)
			local v = options or {}
			local nonNegativeNumber = historyPageUtils.resolveNonNegativeNumber(
				v.rtnIdleFallbackSeconds,
				constants.getRtnIdleFallbackSeconds()
			)

			local nonNegativeNumber2 = historyPageUtils.resolveNonNegativeNumber(
				v.rtnSequenceGapFallbackSeconds,
				constants.getRtnSequenceGapFallbackSeconds()
			)

			local positiveNumber = historyPageUtils.resolvePositiveNumber(
				v.pollMinIntervalSeconds,
				constants.getPollMinIntervalSeconds()
			)

			local v2 = historyPageUtils.resolvePositiveNumber(
				v.pollMaxIntervalSeconds,
				constants.getPollMaxIntervalSeconds()
			)

			if v2 < positiveNumber then
				v2 = positiveNumber
			end

			local afterSequenceId = v.afterSequenceId

			if afterSequenceId ~= nil and activeTurnHandle.setHistoryBoundary ~= nil then
				activeTurnHandle.setHistoryBoundary(afterSequenceId)
			end

			local noteProcessedSequenceNumber = activeTurnHandle.noteProcessedSequenceNumber

			if afterSequenceId ~= nil and noteProcessedSequenceNumber ~= nil then
				noteProcessedSequenceNumber(afterSequenceId)
			end

			local v3 = false
			local v4 = false
			local v5 = false
			local v6 = false
			local v7 = false
			local v8 = positiveNumber
			local lastTime = os.clock()
			local flag = false
			local count = 0
			local count2 = 0
			local count3 = 0

			local function shouldStopPolling() -- 6 equivalent calls inferred from this helper
				local v9 = v3 or activeTurnHandle.state(false).isDone

				if v9 then
					return v9
				end

				if data.getCasSessionId() == p then
					if activeTurnHandle.isCurrentOwner == nil then
						return false
					end

					return not activeTurnHandle.isCurrentOwner()
				end

				return true
			end

			local fn

			local function stopPolling() -- 3 equivalent calls inferred from this helper
				if not v4 then
					return
				end

				v4 = false
				v8 = positiveNumber
				count3 += 1
			end

			local function startPolling() -- 1 equivalent call inferred from this helper
				if not v4 and not shouldStopPolling() then -- inferred equivalent call
					v4 = true
					v8 = positiveNumber
					fn(0)
				end
			end

			local function updatePollingState() -- 5 equivalent calls inferred from this helper
				if shouldStopPolling() then -- inferred equivalent call
					stopPolling() -- inferred equivalent call
				elseif v5 or v7 then
					startPolling() -- inferred equivalent call
				else
					stopPolling() -- inferred equivalent call
				end
			end

			local function refreshSequenceGapState()
				local hasSequenceGap = activeTurnHandle.hasSequenceGap
				local v9

				if hasSequenceGap == nil then
					v9 = false
				else
					v9 = hasSequenceGap()
				end

				if v9 == v6 then
					return
				end

				v6 = v9
				v7 = false
				count2 += 1
				local v10 = count2

				if v9 then
					task.delay(nonNegativeNumber2, function()
						if v10 == count2 and not shouldStopPolling() and v6 then -- inferred equivalent call
							v7 = true
							updatePollingState() -- inferred equivalent call
						end
					end)
				end

				updatePollingState() -- inferred equivalent call
			end

			local function fn2(nonNegativeNumber3: number)
				if flag then
					return
				end

				flag = true
				local v9 = count
				task.delay(nonNegativeNumber3, function()
					flag = false

					if v9 == count and not shouldStopPolling() then -- inferred equivalent call
						local v10 = nonNegativeNumber - (os.clock() - lastTime)

						if v10 > 0 then
							fn2(v10)
							return
						end

						v5 = true
						updatePollingState() -- inferred equivalent call
					end
				end)
			end

			local function noteRtnActivity() -- 2 equivalent calls inferred from this helper
				lastTime = os.clock()
				v5 = false
				updatePollingState() -- inferred equivalent call
				fn2(nonNegativeNumber)
			end

			fn = function(duration: number)
				count3 += 1
				local v9 = count3
				task.delay(duration, function()
					if v9 == count3 and v4 and not shouldStopPolling() then -- inferred equivalent call
						local v10, v11

						if FFlagBuildExperienceHistoryPollTelemetry then
							v10 = v5 and v7 and "both" or v7 and "sequence_gap" or "rtn_idle"
							local getLatestProcessedSequenceNumber = activeTurnHandle.getLatestProcessedSequenceNumber

							if getLatestProcessedSequenceNumber ~= nil then
								v11 = getLatestProcessedSequenceNumber()
							end
						end

						local v12 = pollSessionHistory(
							p,
							afterSequenceId,
							v.onDroppedChatMessage,
							shouldStopPolling,
							v10,
							v11
						)

						if shouldStopPolling() then -- inferred equivalent call
							stopPolling() -- inferred equivalent call
						else
							refreshSequenceGapState()
							updatePollingState() -- inferred equivalent call

							if not v4 then
								return
							end

							if v12 then
								v8 = positiveNumber
							else
								v8 = math.min(v2, v8 * constants.getPollBackoffMultiplier())
							end

							fn(v8)
						end
					end
				end)
			end

			local v9 = activeTurnHandle.onNotification(function()
				noteRtnActivity() -- inferred equivalent call
				refreshSequenceGapState()
			end)

			refreshSequenceGapState()
			noteRtnActivity() -- inferred equivalent call
			return function()
				v3 = true
				count += 1
				count2 += 1
				count3 += 1
				v9()
			end
		end

		return {
			startPollingTurnFromHistory = startPollingTurnFromHistory,
			startPollingActiveTurn = function(p: string, p2)
				local activeTurnHandle = data.deps.getActiveTurnHandle(p)

				if activeTurnHandle == nil then
					return function() end
				end

				return startPollingTurnFromHistory(p, activeTurnHandle, p2)
			end
		}
	end
}
