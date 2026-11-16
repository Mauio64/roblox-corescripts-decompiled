local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/constants")
local historyPageUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/historyPageUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/sessionDeps")

local fFlagBuildExperienceHistoryPollTelemetry = SharedFlags.FFlagBuildExperienceHistoryPollTelemetry

return {
	createHistoryPolling = function(data, callback)
		local function pollSessionHistory(p2, afterSequenceId, onDroppedChatMessage, shouldStopPolling, p3, p4): boolean
			if shouldStopPolling() then
				return false
			end

			local v5

			if callback == nil then
				local sessionLoad = data.deps.sessionLoad(p2, nil)
				v5 = historyPageUtils.awaitRequestState(sessionLoad.state, os.clock() + data.rpcTimeoutSeconds)

				if v5.status == "pending" then
					sessionLoad.dispose()
					return false
				end
			else
				v5 = callback(p2, nil, shouldStopPolling)
			end

			if shouldStopPolling() or v5.status ~= "succeeded" then
				return false
			end

			local sessionLoadHistory = historyPageUtils.getSessionLoadHistory(v5.result)

			if #sessionLoadHistory == 0 or shouldStopPolling() or shouldStopPolling() then
				return false
			end

			data.mergeHistoryPage(sessionLoadHistory, data.getNextHistoryPageToken())
			local ingestSessionHistory = data.deps.ingestSessionHistory(
				p2,
				sessionLoadHistory,
				afterSequenceId
			)

			if onDroppedChatMessage ~= nil then
				local v6 = p3 ~= nil and {
					pollTrigger = p3,
					appliedFromThisPoll = #ingestSessionHistory,
					priorSequenceId = p4
				} or nil

				for k, v7 in ingestSessionHistory do
					onDroppedChatMessage(v7, v6)
				end
			end

			if shouldStopPolling() then
				return false
			end

			return #ingestSessionHistory > 0
		end

		local function startPollingTurnFromHistory(p2, activeTurnHandle, options)
			local v5 = options or {}
			local nonNegativeNumber = historyPageUtils.resolveNonNegativeNumber(
				v5.rtnIdleFallbackSeconds,
				constants.getRtnIdleFallbackSeconds()
			)

			local nonNegativeNumber2 = historyPageUtils.resolveNonNegativeNumber(
				v5.rtnSequenceGapFallbackSeconds,
				constants.getRtnSequenceGapFallbackSeconds()
			)

			local positiveNumber = historyPageUtils.resolvePositiveNumber(
				v5.pollMinIntervalSeconds,
				constants.getPollMinIntervalSeconds()
			)

			local v6 = historyPageUtils.resolvePositiveNumber(
				v5.pollMaxIntervalSeconds,
				constants.getPollMaxIntervalSeconds()
			)

			if v6 < positiveNumber then
				v6 = positiveNumber
			end

			local afterSequenceId = v5.afterSequenceId

			if afterSequenceId ~= nil and activeTurnHandle.setHistoryBoundary ~= nil then
				activeTurnHandle.setHistoryBoundary(afterSequenceId)
			end

			local noteProcessedSequenceNumber = activeTurnHandle.noteProcessedSequenceNumber

			if afterSequenceId ~= nil and noteProcessedSequenceNumber ~= nil then
				noteProcessedSequenceNumber(afterSequenceId)
			end

			local v7 = false
			local flag = false
			local v8 = false
			local v9 = false
			local v10 = false
			local v11 = positiveNumber
			local lastTime = os.clock()
			local flag2 = false
			local count = 0
			local count2 = 0
			local count3 = 0

			local function shouldStopPolling()
				local v12 = v7 or activeTurnHandle.state(false).isDone

				if v12 then
					return v12
				end

				if data.getCasSessionId() == p2 then
					v12 = not (activeTurnHandle.isCurrentOwner == nil)
						and not activeTurnHandle.isCurrentOwner()
				else
					v12 = true
				end

				return v12
			end

			local fn

			local function stopPolling()
				if not flag then
					return
				end

				flag = false
				v11 = positiveNumber
				count3 += 1
			end

			local function startPolling()
				if not flag then
					local v12 = v7 or activeTurnHandle.state(false).isDone

					if not v12 then
						if data.getCasSessionId() == p2 then
							v12 = not (activeTurnHandle.isCurrentOwner == nil)
								and not activeTurnHandle.isCurrentOwner()
						else
							v12 = true
						end
					end

					if not v12 then
						flag = true
						v11 = positiveNumber
						fn(0)
					end
				end
			end

			local function updatePollingState()
				local v12 = v7 or activeTurnHandle.state(false).isDone

				if not v12 then
					if data.getCasSessionId() == p2 then
						v12 = not (activeTurnHandle.isCurrentOwner == nil)
							and not activeTurnHandle.isCurrentOwner()
					else
						v12 = true
					end
				end

				if v12 then
					if not flag then
						return
					end

					flag = false
					v11 = positiveNumber
					count3 += 1
				elseif v8 or v10 then
					if not flag then
						local v13 = v7 or activeTurnHandle.state(false).isDone

						if not v13 then
							if data.getCasSessionId() == p2 then
								v13 = not (activeTurnHandle.isCurrentOwner == nil)
									and not activeTurnHandle.isCurrentOwner()
							else
								v13 = true
							end
						end

						if v13 then
							return
						end

						flag = true
						v11 = positiveNumber
						fn(0)
					end
				else
					if not flag then
						return
					end

					flag = false
					v11 = positiveNumber
					count3 += 1
				end
			end

			local function refreshSequenceGapState()
				local hasSequenceGap = activeTurnHandle.hasSequenceGap
				local v12 = not (hasSequenceGap == nil) and hasSequenceGap()

				if v12 == v9 then
					return
				end

				v9 = v12
				v10 = false
				count2 += 1
				local v13 = count2

				if v12 then
					task.delay(nonNegativeNumber2, function()
						if v13 == count2 then
							local v14 = v7 or activeTurnHandle.state(false).isDone

							if not v14 then
								if data.getCasSessionId() == p2 then
									v14 = not (activeTurnHandle.isCurrentOwner == nil)
										and not activeTurnHandle.isCurrentOwner()
								else
									v14 = true
								end
							end

							if not v14 and v9 then
								v10 = true
								local v15 = v7 or activeTurnHandle.state(false).isDone

								if not v15 then
									if data.getCasSessionId() == p2 then
										v15 = not (activeTurnHandle.isCurrentOwner == nil)
											and not activeTurnHandle.isCurrentOwner()
									else
										v15 = true
									end
								end

								if v15 then
									if not flag then
										return
									end

									flag = false
									v11 = positiveNumber
									count3 += 1
								elseif v8 or v10 then
									if not flag then
										local v16 = v7 or activeTurnHandle.state(false).isDone

										if not v16 then
											if data.getCasSessionId() == p2 then
												v16 = not (activeTurnHandle.isCurrentOwner == nil)
													and not activeTurnHandle.isCurrentOwner()
											else
												v16 = true
											end
										end

										if v16 then
											return
										end

										flag = true
										v11 = positiveNumber
										fn(0)
									end
								else
									if not flag then
										return
									end

									flag = false
									v11 = positiveNumber
									count3 += 1
								end
							end
						end
					end)
				end

				local v14 = v7 or activeTurnHandle.state(false).isDone

				if not v14 then
					if data.getCasSessionId() == p2 then
						v14 = not (activeTurnHandle.isCurrentOwner == nil)
							and not activeTurnHandle.isCurrentOwner()
					else
						v14 = true
					end
				end

				if v14 then
					if not flag then
						return
					end

					flag = false
					v11 = positiveNumber
					count3 += 1
				elseif v8 or v10 then
					if not flag then
						local v15 = v7 or activeTurnHandle.state(false).isDone

						if not v15 then
							if data.getCasSessionId() == p2 then
								v15 = not (activeTurnHandle.isCurrentOwner == nil)
									and not activeTurnHandle.isCurrentOwner()
							else
								v15 = true
							end
						end

						if v15 then
							return
						end

						flag = true
						v11 = positiveNumber
						fn(0)
					end
				else
					if not flag then
						return
					end

					flag = false
					v11 = positiveNumber
					count3 += 1
				end
			end

			local function fn2(nonNegativeNumber3)
				if flag2 then
					return
				end

				flag2 = true
				local v12 = count
				task.delay(nonNegativeNumber3, function()
					flag2 = false

					if v12 == count then
						local v13 = v7 or activeTurnHandle.state(false).isDone

						if not v13 then
							if data.getCasSessionId() == p2 then
								v13 = not (activeTurnHandle.isCurrentOwner == nil)
									and not activeTurnHandle.isCurrentOwner()
							else
								v13 = true
							end
						end

						if not v13 then
							local v14 = nonNegativeNumber - (os.clock() - lastTime)

							if v14 > 0 then
								fn2(v14)
								return
							end

							v8 = true
							local v15 = v7 or activeTurnHandle.state(false).isDone

							if not v15 then
								if data.getCasSessionId() == p2 then
									v15 = not (activeTurnHandle.isCurrentOwner == nil)
										and not activeTurnHandle.isCurrentOwner()
								else
									v15 = true
								end
							end

							if v15 then
								if not flag then
									return
								end

								flag = false
								v11 = positiveNumber
								count3 += 1
							elseif v8 or v10 then
								if not flag then
									local v16 = v7 or activeTurnHandle.state(false).isDone

									if not v16 then
										if data.getCasSessionId() == p2 then
											v16 = not (activeTurnHandle.isCurrentOwner == nil)
												and not activeTurnHandle.isCurrentOwner()
										else
											v16 = true
										end
									end

									if v16 then
										return
									end

									flag = true
									v11 = positiveNumber
									fn(0)
								end
							else
								if not flag then
									return
								end

								flag = false
								v11 = positiveNumber
								count3 += 1
							end
						end
					end
				end)
			end

			local function noteRtnActivity()
				lastTime = os.clock()
				v8 = false
				local v12 = v7 or activeTurnHandle.state(false).isDone

				if not v12 then
					if data.getCasSessionId() == p2 then
						v12 = not (activeTurnHandle.isCurrentOwner == nil)
							and not activeTurnHandle.isCurrentOwner()
					else
						v12 = true
					end
				end

				if v12 then
					if flag then
						flag = false
						v11 = positiveNumber
						count3 += 1
					end
				elseif v8 or v10 then
					if not flag then
						local v13 = v7 or activeTurnHandle.state(false).isDone

						if not v13 then
							if data.getCasSessionId() == p2 then
								v13 = not (activeTurnHandle.isCurrentOwner == nil)
									and not activeTurnHandle.isCurrentOwner()
							else
								v13 = true
							end
						end

						if not v13 then
							flag = true
							v11 = positiveNumber
							fn(0)
						end
					end
				elseif flag then
					flag = false
					v11 = positiveNumber
					count3 += 1
				end

				fn2(nonNegativeNumber)
			end

			fn = function(duration)
				count3 += 1
				local v12 = count3
				task.delay(duration, function()
					if v12 == count3 and flag then
						local v13 = v7 or activeTurnHandle.state(false).isDone

						if not v13 then
							if data.getCasSessionId() == p2 then
								v13 = not (activeTurnHandle.isCurrentOwner == nil)
									and not activeTurnHandle.isCurrentOwner()
							else
								v13 = true
							end
						end

						if not v13 then
							local v14, v15

							if fFlagBuildExperienceHistoryPollTelemetry then
								v14 = v8 and v10 and "both" or v10 and "sequence_gap" or "rtn_idle"
								local getLatestProcessedSequenceNumber = activeTurnHandle.getLatestProcessedSequenceNumber

								if getLatestProcessedSequenceNumber ~= nil then
									v15 = getLatestProcessedSequenceNumber()
								end
							end

							local v16 = pollSessionHistory(
								p2,
								afterSequenceId,
								v5.onDroppedChatMessage,
								shouldStopPolling,
								v14,
								v15
							)
							local v17 = v7 or activeTurnHandle.state(false).isDone

							if not v17 then
								if data.getCasSessionId() == p2 then
									v17 = not (activeTurnHandle.isCurrentOwner == nil)
										and not activeTurnHandle.isCurrentOwner()
								else
									v17 = true
								end
							end

							if v17 then
								if not flag then
									return
								end

								flag = false
								v11 = positiveNumber
								count3 += 1
							else
								refreshSequenceGapState()
								local v18 = v7 or activeTurnHandle.state(false).isDone

								if not v18 then
									if data.getCasSessionId() == p2 then
										v18 = not (activeTurnHandle.isCurrentOwner == nil)
											and not activeTurnHandle.isCurrentOwner()
									else
										v18 = true
									end
								end

								if v18 then
									if flag then
										flag = false
										v11 = positiveNumber
										count3 += 1
									end
								elseif v8 or v10 then
									if not flag then
										local v19 = v7 or activeTurnHandle.state(false).isDone

										if not v19 then
											if data.getCasSessionId() == p2 then
												v19 = not (activeTurnHandle.isCurrentOwner == nil)
													and not activeTurnHandle.isCurrentOwner()
											else
												v19 = true
											end
										end

										if not v19 then
											flag = true
											v11 = positiveNumber
											fn(0)
										end
									end
								elseif flag then
									flag = false
									v11 = positiveNumber
									count3 += 1
								end

								if not flag then
									return
								end

								v11 = if v16 then positiveNumber else math.min(v6, v11 * constants.getPollBackoffMultiplier())

								fn(v11)
							end
						end
					end
				end)
			end

			local v12 = activeTurnHandle.onNotification(function()
				lastTime = os.clock()
				v8 = false
				local v13 = v7 or activeTurnHandle.state(false).isDone

				if not v13 then
					if data.getCasSessionId() == p2 then
						v13 = not (activeTurnHandle.isCurrentOwner == nil)
							and not activeTurnHandle.isCurrentOwner()
					else
						v13 = true
					end
				end

				if v13 then
					if flag then
						flag = false
						v11 = positiveNumber
						count3 += 1
					end
				elseif v8 or v10 then
					if not flag then
						local v14 = v7 or activeTurnHandle.state(false).isDone

						if not v14 then
							if data.getCasSessionId() == p2 then
								v14 = not (activeTurnHandle.isCurrentOwner == nil)
									and not activeTurnHandle.isCurrentOwner()
							else
								v14 = true
							end
						end

						if not v14 then
							flag = true
							v11 = positiveNumber
							fn(0)
						end
					end
				elseif flag then
					flag = false
					v11 = positiveNumber
					count3 += 1
				end

				fn2(nonNegativeNumber)

				refreshSequenceGapState()
			end)

			refreshSequenceGapState()
			lastTime = os.clock()
			v8 = false
			local v13 = v7 or activeTurnHandle.state(false).isDone

			if not v13 then
				if data.getCasSessionId() == p2 then
					v13 = not (activeTurnHandle.isCurrentOwner == nil)
						and not activeTurnHandle.isCurrentOwner()
				else
					v13 = true
				end
			end

			if v13 then
				if flag then
					flag = false
					v11 = positiveNumber
					count3 += 1
				end
			elseif v8 or v10 then
				if not flag then
					local v14 = v7 or activeTurnHandle.state(false).isDone

					if not v14 then
						if data.getCasSessionId() == p2 then
							v14 = not (activeTurnHandle.isCurrentOwner == nil)
								and not activeTurnHandle.isCurrentOwner()
						else
							v14 = true
						end
					end

					if not v14 then
						flag = true
						v11 = positiveNumber
						fn(0)
					end
				end
			elseif flag then
				flag = false
				v11 = positiveNumber
				count3 += 1
			end

			fn2(nonNegativeNumber)

			return function()
				v7 = true
				count += 1
				count2 += 1
				count3 += 1
				v12()
			end
		end

		return {
			startPollingTurnFromHistory = startPollingTurnFromHistory,
			startPollingActiveTurn = function(p2, p3)
				local activeTurnHandle = data.deps.getActiveTurnHandle(p2)

				if activeTurnHandle == nil then
					return function() end
				end

				return startPollingTurnFromHistory(p2, activeTurnHandle, p3)
			end
		}
	end
}
