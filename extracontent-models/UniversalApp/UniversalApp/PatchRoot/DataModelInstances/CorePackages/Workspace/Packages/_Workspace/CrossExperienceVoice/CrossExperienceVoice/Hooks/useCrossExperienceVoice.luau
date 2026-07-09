local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)
local Players = game:GetService("Players")
local ExperienceService = dependencies.ExperienceService.ExperienceService
local CrossExperience = dependencies.CrossExperience
local React = dependencies.React
local RoactUtils = dependencies.RoactUtils
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local SharedFlags = dependencies.SharedFlags
local getFFlagEnableCrossExpVoiceMemoryCheck = SharedFlags.getFFlagEnableCrossExpVoiceMemoryCheck
local FIntPartyVoiceJoinRequestPulseCheckTimeout = SharedFlags.FIntPartyVoiceJoinRequestPulseCheckTimeout
local EngineFeature = game:GetEngineFeature("CevReadinessSync")
local VoiceStatusChanged = CrossExperience.Actions.VoiceStatusChanged
local useEffect = React.useEffect
local Logger = require(CrossExperienceVoice.Logger)
local default = require(CrossExperienceVoice.CrossExperienceVoiceManager).default
local default2 = require(CrossExperienceVoice.CrossExperienceVoiceAnalytics).default
local Flags = require(CrossExperienceVoice.Flags)
local FFlagFireErrorRCCTimeoutSignal = Flags.FFlagFireErrorRCCTimeoutSignal
local FFlagEnableCEVForceInitialize = Flags.FFlagEnableCEVForceInitialize

local function useCrossExperienceVoice(t1: {[any]: any}?) -- line: 42
	-- upvalues: useStore (copy), useDispatch (copy), React (copy), CrossExperience (copy), Logger (copy), default (copy), VoiceStatusChanged (copy), default2 (copy), Players (copy), FIntPartyVoiceJoinRequestPulseCheckTimeout (copy), FFlagFireErrorRCCTimeoutSignal (copy), getFFlagEnableCrossExpVoiceMemoryCheck (copy), EngineFeature (copy), ExperienceService (copy), FFlagEnableCEVForceInitialize (copy), useEffect (copy)
	local v24 = useStore()
	local v25 = useDispatch()
	local v26 = React.useRef(nil)
	local v27 = React.useRef(nil)
	local v28 = React.useRef(nil)
	local v29 = React.useRef(nil)
	local v30 = React.useRef(nil)
	local v31 = React.useRef(nil)
	local v32 = React.useRef(nil)
	local v33 = React.useRef(nil)
	local v34 = React.useRef(nil)
	local v35 = React.useMemo(function() -- line: 55
		-- upvalues: CrossExperience (copy)
		return CrossExperience.EventManager.new(if game.PlaceId ~= 0 then CrossExperience.Constants.EXPERIENCE_TYPE_UGC else CrossExperience.Constants.EXPERIENCE_TYPE_LUAAPP, true)
	end, {})
	local v36 = React.useRef(false)

	local function v37() -- line: 80
		-- upvalues: v36 (copy), v35 (copy), v24 (copy), Logger (copy), v27 (copy), v28 (copy), v29 (copy), v32 (copy), v33 (copy), v34 (copy), v26 (copy)
		if v36.current then
			v36.current = false
			v35:unsubscribe(v24, Logger)
		end

		if v27.current then
			v27.current:Disconnect()
			v27.current = nil
		end

		if v28.current then
			v28.current:Disconnect()
			v28.current = nil
		end

		if v29.current then
			v29.current:Disconnect()
			v29.current = nil
		end

		if v32.current then
			v32.current:Disconnect()
			v32.current = nil
		end

		if v33.current then
			v33.current:Disconnect()
			v33.current = nil
		end

		if v34.current then
			v34.current:Disconnect()
			v34.current = nil
		end

		if v26.current then
			v26.current:Disconnect()
			v26.current = nil
		end
	end
	local function v38() -- line: 112
		-- upvalues: v32 (copy), default (copy), v25 (copy), VoiceStatusChanged (copy), CrossExperience (copy), default2 (copy), Players (copy), FIntPartyVoiceJoinRequestPulseCheckTimeout (copy), v26 (copy), v24 (copy), FFlagFireErrorRCCTimeoutSignal (copy), v35 (copy), t1 (copy), v33 (copy), getFFlagEnableCrossExpVoiceMemoryCheck (copy), v34 (copy), v27 (copy), v36 (copy), Logger (copy), EngineFeature (copy), v28 (copy), v29 (copy), ExperienceService (copy), v30 (copy), v31 (copy), FFlagEnableCEVForceInitialize (copy)
		v32.current = default.JoinRequested.Event:Connect(function() -- line: 113
			-- upvalues: v25 (copy), VoiceStatusChanged (copy), CrossExperience (copy), default2 (copy), Players (copy)
			v25(VoiceStatusChanged({
				status = CrossExperience.Constants.VOICE_STATUS.RCC_CONNECTING
			}))
			default2:logPartyVoiceStatusChanged({
				voiceChannelId = nil,
				voiceSessionId = nil,
				status = CrossExperience.Constants.VOICE_STATUS.RCC_CONNECTING,
				userId = not Players.LocalPlayer and "" or tostring(Players.LocalPlayer.UserId)
			})
		end)

		if FIntPartyVoiceJoinRequestPulseCheckTimeout > 0 then
			v26.current = default.JoinRequestPulseCheck.Event:Connect(function() -- line: 128
				-- upvalues: v24 (copy), CrossExperience (copy), FFlagFireErrorRCCTimeoutSignal (copy), v35 (copy), Players (copy), v25 (copy), VoiceStatusChanged (copy), t1 (copy), default (copy)
				local v39 = v24:getState()

				if v39 and (v39.Squad and v39.Squad.CrossExperienceVoice and v39.Squad.CrossExperienceVoice.Experience.voiceStatus == CrossExperience.Constants.VOICE_STATUS.RCC_CONNECTING) then
					if FFlagFireErrorRCCTimeoutSignal then
						v35:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
							status = CrossExperience.Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT,
							userId = not Players.LocalPlayer and "" or tostring(Players.LocalPlayer.UserId)
						})

						return
					end

					v25(VoiceStatusChanged({
						status = CrossExperience.Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT
					}))

					if t1 and t1.handleRCCConnectionTimeout then
						default:logPartyVoiceTimeout()
						default:leave()
					end
				end
			end)
		end

		v33.current = default.JoinRequestSubmitted.Event:Connect(function(b1: boolean) -- line: 157
			-- upvalues: v25 (copy), VoiceStatusChanged (copy), CrossExperience (copy), default2 (copy), Players (copy)
			if not b1 then
				v25(VoiceStatusChanged({
					status = CrossExperience.Constants.VOICE_STATUS.ERROR_START_BACKGROUND_DM
				}))
				default2:logPartyVoiceStatusChanged({
					voiceChannelId = nil,
					voiceSessionId = nil,
					status = CrossExperience.Constants.VOICE_STATUS.ERROR_START_BACKGROUND_DM,
					userId = not Players.LocalPlayer and "" or tostring(Players.LocalPlayer.UserId)
				})
			end
		end)

		if getFFlagEnableCrossExpVoiceMemoryCheck() then
			v34.current = default.JoinFeasibilityCheckPerformed.Event:Connect(function(b2: boolean) -- line: 174
				-- upvalues: v25 (copy), VoiceStatusChanged (copy), CrossExperience (copy), default2 (copy), Players (copy)
				if not b2 then
					v25(VoiceStatusChanged({
						status = CrossExperience.Constants.VOICE_STATUS.ERROR_JOIN_FEASIBILITY_CHECK_FAILED
					}))
					default2:logPartyVoiceStatusChanged({
						voiceChannelId = nil,
						voiceSessionId = nil,
						status = CrossExperience.Constants.VOICE_STATUS.ERROR_JOIN_FEASIBILITY_CHECK_FAILED,
						userId = not Players.LocalPlayer and "" or tostring(Players.LocalPlayer.UserId)
					})
				end
			end)
		end

		v27.current = default.ExperienceJoined.Event:Connect(function() -- line: 190
			-- upvalues: v36 (copy), v35 (copy), v24 (copy), Logger (copy), EngineFeature (copy), default (copy)
			if not v36.current then
				v36.current = true
				v35:subscribe(v24, Logger)
			end

			if EngineFeature then
				default:signalCevReadinessSync()
			end
		end)
		v28.current = default.ExperienceJoinFailed.Event:Connect(function() -- line: 198
			-- upvalues: v36 (copy), v35 (copy), v24 (copy), Logger (copy)
			if not v36.current then
				return
			end

			v36.current = false
			v35:unsubscribe(v24, Logger)
		end)
		v29.current = default.ExperienceLeft.Event:Connect(function() -- line: 202
			-- upvalues: v36 (copy), v35 (copy), v24 (copy), Logger (copy)
			if not v36.current then
				return
			end

			v36.current = false
			v35:unsubscribe(v24, Logger)
		end)

		if ExperienceService then
			v30.current = ExperienceService:RegisterForExperienceJoin(function() -- line: 208
				-- upvalues: v36 (copy), v35 (copy), v24 (copy), Logger (copy)
				if game.PlaceId == 0 then
					if not v36.current then
						return
					end

					v36.current = false
					v35:unsubscribe(v24, Logger)
				end
			end)
			v31.current = ExperienceService:RegisterForExperienceLeave(function() -- line: 214
				-- upvalues: v35 (copy), v24 (copy), Logger (copy)
				if game.PlaceId == 0 then
					v35:restoreStateFromBackground(v24, Logger)
				end
			end)
		end

		if FFlagEnableCEVForceInitialize and t1 and t1.forceInitializeStoreOnMount then
			if v36.current then
				return
			end

			v36.current = true
			v35:subscribe(v24, Logger)
		end
	end

	useEffect(function() -- line: 229
		-- upvalues: v38 (copy), v37 (copy)
		v38()

		return function() -- line: 231
			-- upvalues: v37 (copy)
			v37()
		end
	end, {})

	return nil
end

return useCrossExperienceVoice
