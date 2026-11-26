local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")
local sendConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/sendConfiguration")

local fFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData
local fFlagBuildExperiencePromptFailureTelemetry = SharedFlags.FFlagBuildExperiencePromptFailureTelemetry
local fFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary
local fFlagBuildExperienceChatOpenId = SharedFlags.FFlagBuildExperienceChatOpenId

return {
	createSendPrompt = function(data)
		return {
			sendPrompt = function(data2)
				local v5

				if fFlagBuildExperienceChatOpenId and data.getSendChatOpenId ~= nil then
					v5 = data.getSendChatOpenId()
				else
					v5 = nil
				end

				local v6

				if fFlagBuildExperienceModelPickerData and data2.sendConfiguration ~= nil then
					v6 = sendConfiguration.capture(data2.sendConfiguration.tier, data2.sendConfiguration.experiment)
				else
					v6 = nil
				end

				local v7

				if v6 == nil then
					v7 = if fFlagBuildExperienceModelPickerData then data2.model else nil
				else
					v7 = v6.tier
				end

				if fFlagBuildExperienceModelPickerData then
					assert(v6 == nil or data2.model == nil or data2.model == v7, "conflicting model tiers")
					local model = data2.promptMeta
						and data2.promptMeta._roblox
						and data2.promptMeta._roblox.model
					assert(v7 == nil or model == nil or model == v7, "conflicting model tiers")
					local experiment = data2.promptMeta
						and data2.promptMeta._roblox
						and data2.promptMeta._roblox.experiment
					assert(
						v6 == nil or experiment == nil or sendConfiguration.sameExperiment(experiment, v6.experiment),
						"conflicting experiments"
					)
				end

				local v8 = data.incrementAssistantTurnSequence()

				local signal, v9 = Signals.createSignal(nil)
				local signal2, v10 = Signals.createSignal(nil)

				local flag = false
				local flag2 = false
				local v11 = false
				local v12 = false
				local flag3 = false
				local v13 = nil
				local v14 = nil
				local v15 = nil

				local function fireCompleted(p2)
					if flag2 or v8 ~= data.getAssistantTurnSequence() then
						return
					end

					flag2 = true
					data.setActiveStop(nil)

					if v15 ~= nil then
						v15()
						v15 = nil
					end

					if v14 ~= nil then
						v14()
						v14 = nil
					end

					if v13 ~= nil then
						data.noteTurnSequenceIds(v13)
					end

					if data2.onCompleted ~= nil then
						data2.onCompleted(p2)
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
							or fFlagBuildExperienceModelPickerData
							and data2.isCancelled ~= nil
							and data2.isCancelled()
						then
							fireCompleted(nil)
							return
						end

						if not fFlagBuildExperienceModelPickerData then
							local initialized, v16, v17 = data.ensureInitialized()

							if not initialized then
								if not fFlagBuildExperiencePromptFailureTelemetry then
									v17 = nil
								end

								v10({
									stage = "initialize",
									errorCode = v16,
									requestFailure = v17
								})

								fireCompleted(nil)
								return
							end
						end

						local v16, v17

						if fFlagBuildExperienceModelPickerData then
							local ensureCasSession = data.ensureCasSession

							local isCancelled = data2.isCancelled
							local v21 = if fFlagBuildExperienceChatOpenId then v5 else nil
							v16, v17 = ensureCasSession(v7, isCancelled, v6, true, v21)
						else
							local ensureCasSession = data.ensureCasSession
							local v22 = if fFlagBuildExperienceChatOpenId then v5 else nil
							v16, v17 = ensureCasSession(v7, nil, nil, nil, v22)
						end

						if v16 == nil then
							if not fFlagBuildExperienceModelPickerData or v17 ~= nil then
								v10(v17 or { stage = "session_new" })
							end

							fireCompleted(nil)
						else
							if
								flag3
								or fFlagBuildExperienceModelPickerData
								and (data2.isCancelled ~= nil and data2.isCancelled() or data2.expectedSessionId ~= nil and data2.expectedSessionId ~= v16)
							then
								fireCompleted(nil)
								return
							end

							local sessionPrompt, v18 = data.sessionPrompt(
								{
									sessionId = v16,
									prompt = data2.prompt,
									model = v7,
									_meta = data2.promptMeta
								},
								v6
							)

							v13 = sessionPrompt
							v9(sessionPrompt)

							if flag3 then
								sessionPrompt.cancel()
							end

							v14 = data.startPollingTurnFromHistory(v16, sessionPrompt, {
								rtnIdleFallbackSeconds = data2.rtnIdleFallbackSeconds,
								rtnSequenceGapFallbackSeconds = data2.rtnSequenceGapFallbackSeconds,
								pollMinIntervalSeconds = data2.pollMinIntervalSeconds,
								pollMaxIntervalSeconds = data2.pollMaxIntervalSeconds,
								afterSequenceId = data.getLatestObservedHistorySequenceId(),
								onDroppedChatMessage = data2.onDroppedChatMessage
							})

							v15 = Signals.createEffect(function(p2)
								local state = sessionPrompt.state(p2)

								if
									fFlagBuildExperienceModelPickerData
									and v18 ~= nil
									and (state.status == "streaming" or state.status == "succeeded" or fFlagBuildExperienceLibrary and sessionPrompt.isAccepted(p2) and not state.isDone)
								then
									v18()
									v18 = nil
								end

								if fFlagBuildExperienceLibrary and data2.onAccepted ~= nil and not v12 then
									local v19 = state.status == "streaming" or state.status == "succeeded"
									local v20 = sessionPrompt.isAccepted(p2) and not state.isDone

									if v19 or v20 then
										v12 = true
										data2.onAccepted()
									end
								end

								if
									data2.onReceived ~= nil
									and not v11
									and (state.status == "streaming" or state.status == "succeeded")
								then
									v11 = true
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

					if v13 ~= nil then
						v13.cancel()
						return
					end

					if v15 ~= nil then
						v15()
						v15 = nil
					end

					if v14 ~= nil then
						v14()
						v14 = nil
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
