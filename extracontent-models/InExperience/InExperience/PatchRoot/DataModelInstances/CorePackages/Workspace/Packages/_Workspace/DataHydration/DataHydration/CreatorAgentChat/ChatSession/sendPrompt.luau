local parent = script:FindFirstAncestor("DataHydration").Parent

local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)

require(script.Parent.Parent.types)
local sendConfiguration = require(script.Parent.Parent.sendConfiguration)

local FFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData
local FFlagBuildExperiencePromptFailureTelemetry = SharedFlags.FFlagBuildExperiencePromptFailureTelemetry
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary
local FFlagBuildExperienceChatOpenId = SharedFlags.FFlagBuildExperienceChatOpenId

return {
	createSendPrompt = function(data)
		return {
			sendPrompt = function(data2)
				local v

				if FFlagBuildExperienceChatOpenId and data.getSendChatOpenId ~= nil then
					v = data.getSendChatOpenId()
				else
					v = nil
				end

				local v2

				if FFlagBuildExperienceModelPickerData and data2.sendConfiguration ~= nil then
					v2 = sendConfiguration.capture(data2.sendConfiguration.tier, data2.sendConfiguration.experiment)
				else
					v2 = nil
				end

				local model2

				if v2 == nil then
					if FFlagBuildExperienceModelPickerData then
						model2 = data2.model
					else
						model2 = nil
					end
				else
					model2 = v2.tier
				end

				if FFlagBuildExperienceModelPickerData then
					assert(v2 == nil or data2.model == nil or data2.model == model2, "conflicting model tiers")
					local model = data2.promptMeta and data2.promptMeta._roblox and data2.promptMeta._roblox.model
					assert(model2 == nil or model == nil or model == model2, "conflicting model tiers")
					local experiment = data2.promptMeta
						and data2.promptMeta._roblox
						and data2.promptMeta._roblox.experiment
					assert(
						v2 == nil or experiment == nil or sendConfiguration.sameExperiment(experiment, v2.experiment),
						"conflicting experiments"
					)
				end

				local v3 = data.incrementAssistantTurnSequence()

				local signal, v4 = Signals.createSignal(nil)
				local signal2, v5 = Signals.createSignal(nil)

				local flag = false
				local flag2 = false
				local v6 = false
				local v7 = false
				local flag3 = false
				local v8 = nil
				local v9 = nil
				local v10 = nil

				local function fireCompleted(p)
					if flag2 or v3 ~= data.getAssistantTurnSequence() then
						return
					end

					flag2 = true
					data.setActiveStop(nil)

					if v10 ~= nil then
						v10()
						v10 = nil
					end

					if v9 ~= nil then
						v9()
						v9 = nil
					end

					if v8 ~= nil then
						data.noteTurnSequenceIds(v8)
					end

					if data2.onCompleted ~= nil then
						data2.onCompleted(p)
					end
				end

				local function start()
					if flag then
						return
					end

					flag = true

					task.spawn(function()
						if
							flag3
							or FFlagBuildExperienceModelPickerData and data2.isCancelled ~= nil and data2.isCancelled()
						then
							fireCompleted(nil)
							return
						end

						if not FFlagBuildExperienceModelPickerData then
							local initialized, errorCode, requestFailure = data.ensureInitialized()

							if not initialized then
								if not FFlagBuildExperiencePromptFailureTelemetry then
									requestFailure = nil
								end

								v5({
									stage = "initialize",
									errorCode = errorCode,
									requestFailure = requestFailure
								})

								fireCompleted(nil)
								return
							end
						end

						local sessionId, v11

						if FFlagBuildExperienceModelPickerData then
							local ensureCasSession = data.ensureCasSession

							local isCancelled = data2.isCancelled
							local v12

							if FFlagBuildExperienceChatOpenId then
								v12 = v
							end

							sessionId, v11 = ensureCasSession(model2, isCancelled, v2, true, v12)
						else
							local ensureCasSession = data.ensureCasSession
							local v12

							if FFlagBuildExperienceChatOpenId then
								v12 = v
							end

							sessionId, v11 = ensureCasSession(model2, nil, nil, nil, v12)
						end

						if sessionId == nil then
							if not FFlagBuildExperienceModelPickerData or v11 ~= nil then
								v5(v11 or { stage = "session_new" })
							end

							fireCompleted(nil)
						else
							if
								flag3
								or FFlagBuildExperienceModelPickerData
								and (data2.isCancelled ~= nil and data2.isCancelled() or data2.expectedSessionId ~= nil and data2.expectedSessionId ~= sessionId)
							then
								fireCompleted(nil)
								return
							end

							local sessionPrompt, v12 = data.sessionPrompt(
								{
									sessionId = sessionId,
									prompt = data2.prompt,
									model = model2,
									_meta = data2.promptMeta
								},
								v2
							)

							v8 = sessionPrompt
							v4(sessionPrompt)

							if flag3 then
								sessionPrompt.cancel()
							end

							v9 = data.startPollingTurnFromHistory(sessionId, sessionPrompt, {
								rtnIdleFallbackSeconds = data2.rtnIdleFallbackSeconds,
								rtnSequenceGapFallbackSeconds = data2.rtnSequenceGapFallbackSeconds,
								pollMinIntervalSeconds = data2.pollMinIntervalSeconds,
								pollMaxIntervalSeconds = data2.pollMaxIntervalSeconds,
								afterSequenceId = data.getLatestObservedHistorySequenceId(),
								onDroppedChatMessage = data2.onDroppedChatMessage
							})

							v10 = Signals.createEffect(function(p)
								local state = sessionPrompt.state(p)

								if
									FFlagBuildExperienceModelPickerData
									and v12 ~= nil
									and (state.status == "streaming" or state.status == "succeeded" or FFlagBuildExperienceLibrary and sessionPrompt.isAccepted(p) and not state.isDone)
								then
									v12()
									v12 = nil
								end

								if FFlagBuildExperienceLibrary and data2.onAccepted ~= nil and not v7 then
									local v13 = state.status == "streaming" or state.status == "succeeded"
									local v14 = sessionPrompt.isAccepted(p) and not state.isDone

									if v13 or v14 then
										v7 = true
										data2.onAccepted()
									end
								end

								if
									data2.onReceived ~= nil
									and not v6
									and (state.status == "streaming" or state.status == "succeeded")
								then
									v6 = true
									data2.onReceived(sessionPrompt.getTurnId())
								end

								if state.isDone then
									fireCompleted(sessionPrompt.state(false))
								end
							end)
						end
					end)
				end

				local function stop()
					if flag2 then
						return
					end

					flag3 = true

					if v8 ~= nil then
						v8.cancel()
						return
					end

					if v10 ~= nil then
						v10()
						v10 = nil
					end

					if v9 ~= nil then
						v9()
						v9 = nil
					end

					fireCompleted(nil)
				end

				data.setActiveStop(stop)

				return {
					getTurnHandle = signal,
					getSetupError = signal2,
					start = start,
					stop = stop
				}
			end
		}
	end
}
