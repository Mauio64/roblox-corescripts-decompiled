local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")
local sendConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/sendConfiguration")

local fFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData
local fFlagBuildExperiencePromptFailureTelemetry = SharedFlags.FFlagBuildExperiencePromptFailureTelemetry
local fFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary

return {
	createSendPrompt = function(data)
		return {
			sendPrompt = function(data2)
				local v5

				if fFlagBuildExperienceModelPickerData and data2.sendConfiguration ~= nil then
					v5 = sendConfiguration.capture(data2.sendConfiguration.tier, data2.sendConfiguration.experiment)
				else
					v5 = nil
				end

				local v6

				if v5 == nil then
					v6 = if fFlagBuildExperienceModelPickerData then data2.model else nil
				else
					v6 = v5.tier
				end

				if fFlagBuildExperienceModelPickerData then
					assert(v5 == nil or data2.model == nil or data2.model == v6, "conflicting model tiers")
					local model = data2.promptMeta
						and data2.promptMeta._roblox
						and data2.promptMeta._roblox.model
					assert(v6 == nil or model == nil or model == v6, "conflicting model tiers")
					local experiment = data2.promptMeta
						and data2.promptMeta._roblox
						and data2.promptMeta._roblox.experiment
					assert(
						v5 == nil or experiment == nil or sendConfiguration.sameExperiment(experiment, v5.experiment),
						"conflicting experiments"
					)
				end

				local v7 = data.incrementAssistantTurnSequence()

				local signal, v8 = Signals.createSignal(nil)
				local signal2, v9 = Signals.createSignal(nil)

				local flag = false
				local flag2 = false
				local v10 = false
				local v11 = false
				local flag3 = false
				local v12 = nil
				local v13 = nil
				local v14 = nil

				local function fireCompleted(p2)
					if flag2 or v7 ~= data.getAssistantTurnSequence() then
						return
					end

					flag2 = true
					data.setActiveStop(nil)

					if v14 ~= nil then
						v14()
						v14 = nil
					end

					if v13 ~= nil then
						v13()
						v13 = nil
					end

					if v12 ~= nil then
						data.noteTurnSequenceIds(v12)
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
							local initialized, v15, v16 = data.ensureInitialized()

							if not initialized then
								if not fFlagBuildExperiencePromptFailureTelemetry then
									v16 = nil
								end

								v9({
									stage = "initialize",
									errorCode = v15,
									requestFailure = v16
								})

								fireCompleted(nil)
								return
							end
						end

						local v15, v16

						if fFlagBuildExperienceModelPickerData then
							v15, v16 = data.ensureCasSession(v6, data2.isCancelled, v5, true)
						else
							v15, v16 = data.ensureCasSession(v6)
						end

						if v15 == nil then
							if not fFlagBuildExperienceModelPickerData or v16 ~= nil then
								v9(v16 or { stage = "session_new" })
							end

							fireCompleted(nil)
						else
							if
								flag3
								or fFlagBuildExperienceModelPickerData
								and (data2.isCancelled ~= nil and data2.isCancelled() or data2.expectedSessionId ~= nil and data2.expectedSessionId ~= v15)
							then
								fireCompleted(nil)
								return
							end

							local sessionPrompt, v17 = data.sessionPrompt(
								{
									sessionId = v15,
									prompt = data2.prompt,
									model = v6,
									_meta = data2.promptMeta
								},
								v5
							)

							v12 = sessionPrompt
							v8(sessionPrompt)

							if flag3 then
								sessionPrompt.cancel()
							end

							v13 = data.startPollingTurnFromHistory(v15, sessionPrompt, {
								rtnIdleFallbackSeconds = data2.rtnIdleFallbackSeconds,
								rtnSequenceGapFallbackSeconds = data2.rtnSequenceGapFallbackSeconds,
								pollMinIntervalSeconds = data2.pollMinIntervalSeconds,
								pollMaxIntervalSeconds = data2.pollMaxIntervalSeconds,
								afterSequenceId = data.getLatestObservedHistorySequenceId(),
								onDroppedChatMessage = data2.onDroppedChatMessage
							})

							v14 = Signals.createEffect(function(p2)
								local state = sessionPrompt.state(p2)

								if
									fFlagBuildExperienceModelPickerData
									and v17 ~= nil
									and (state.status == "streaming" or state.status == "succeeded" or fFlagBuildExperienceLibrary and sessionPrompt.isAccepted(p2) and not state.isDone)
								then
									v17()
									v17 = nil
								end

								if fFlagBuildExperienceLibrary and data2.onAccepted ~= nil and not v11 then
									local v18 = state.status == "streaming" or state.status == "succeeded"
									local v19 = sessionPrompt.isAccepted(p2) and not state.isDone

									if v18 or v19 then
										v11 = true
										data2.onAccepted()
									end
								end

								if
									data2.onReceived ~= nil
									and not v10
									and (state.status == "streaming" or state.status == "succeeded")
								then
									v10 = true
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

					if v12 ~= nil then
						v12.cancel()
						return
					end

					if v14 ~= nil then
						v14()
						v14 = nil
					end

					if v13 ~= nil then
						v13()
						v13 = nil
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
