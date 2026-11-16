local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)
local Players = game:GetService("Players")

local experienceService = dependencies.ExperienceService.ExperienceService
local crossExperience = dependencies.CrossExperience
local react = dependencies.React
local roactUtils = dependencies.RoactUtils
local useStore = roactUtils.Hooks.RoactRodux.useStore
local useDispatch = roactUtils.Hooks.RoactRodux.useDispatch
local sharedFlags = dependencies.SharedFlags
local getFFlagEnableCrossExpVoiceMemoryCheck = sharedFlags.getFFlagEnableCrossExpVoiceMemoryCheck
local fIntPartyVoiceJoinRequestPulseCheckTimeout = sharedFlags.FIntPartyVoiceJoinRequestPulseCheckTimeout

local engineFeature = game:GetEngineFeature("CevReadinessSync")

local voiceStatusChanged = crossExperience.Actions.VoiceStatusChanged

local useEffect = react.useEffect

local Logger = require(CrossExperienceVoice.Logger)
local CrossExperienceVoiceManager = require(CrossExperienceVoice.CrossExperienceVoiceManager)
local default = CrossExperienceVoiceManager.default
local CrossExperienceVoiceAnalytics = require(CrossExperienceVoice.CrossExperienceVoiceAnalytics)
local default2 = CrossExperienceVoiceAnalytics.default
local Flags = require(CrossExperienceVoice.Flags)
local FFlagFireErrorRCCTimeoutSignal = Flags.FFlagFireErrorRCCTimeoutSignal
local FFlagEnableCEVForceInitialize = Flags.FFlagEnableCEVForceInitialize

local function fn() -- 1 equivalent call inferred from this helper
	if game.PlaceId == 0 then
		return crossExperience.Constants.EXPERIENCE_TYPE_LUAAPP
	end

	return crossExperience.Constants.EXPERIENCE_TYPE_UGC
end

local function useCrossExperienceVoice(p): nil
	local v = useStore()
	local v2 = useDispatch()
	local ref = react.useRef(nil)
	local ref2 = react.useRef(nil)
	local ref3 = react.useRef(nil)
	local ref4 = react.useRef(nil)
	local ref5 = react.useRef(nil)
	local ref6 = react.useRef(nil)
	local ref7 = react.useRef(nil)
	local ref8 = react.useRef(nil)
	local ref9 = react.useRef(nil)

	local v3 = react.useMemo(function()
		return crossExperience.EventManager.new(fn(), true) -- inferred equivalent call
	end, {})

	local ref10 = react.useRef(false)

	local function fn2() -- 4 equivalent calls inferred from this helper
		if not ref10.current then
			return
		end

		ref10.current = false
		v3:unsubscribe(v, Logger)
	end

	local function fn3()
		fn2() -- inferred equivalent call

		if ref2.current then
			ref2.current:Disconnect()
			ref2.current = nil
		end

		if ref3.current then
			ref3.current:Disconnect()
			ref3.current = nil
		end

		if ref4.current then
			ref4.current:Disconnect()
			ref4.current = nil
		end

		if ref7.current then
			ref7.current:Disconnect()
			ref7.current = nil
		end

		if ref8.current then
			ref8.current:Disconnect()
			ref8.current = nil
		end

		if ref9.current then
			ref9.current:Disconnect()
			ref9.current = nil
		end

		if ref.current then
			ref.current:Disconnect()
			ref.current = nil
		end
	end

	local function fn4() -- 2 equivalent calls inferred from this helper
		if ref10.current then
			return
		end

		ref10.current = true
		v3:subscribe(v, Logger)
	end

	local function fn5()
		ref7.current = default.JoinRequested.Event:Connect(function()
			v2(voiceStatusChanged({ status = crossExperience.Constants.VOICE_STATUS.RCC_CONNECTING }))

			default2:logPartyVoiceStatusChanged({
				status = crossExperience.Constants.VOICE_STATUS.RCC_CONNECTING,
				voiceChannelId = nil,
				voiceSessionId = nil,
				userId = not Players.LocalPlayer and "" or tostring(Players.LocalPlayer.UserId)
			})
		end)

		if fIntPartyVoiceJoinRequestPulseCheckTimeout > 0 then
			ref.current = default.JoinRequestPulseCheck.Event:Connect(function()
				local state = v:getState()

				if
					state
					and state.Squad
					and state.Squad.CrossExperienceVoice
					and state.Squad.CrossExperienceVoice.Experience.voiceStatus == crossExperience.Constants.VOICE_STATUS.RCC_CONNECTING
				then
					if FFlagFireErrorRCCTimeoutSignal then
						v3:notify(crossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
							status = crossExperience.Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT,
							userId = not Players.LocalPlayer and "" or tostring(Players.LocalPlayer.UserId)
						})
						return
					end

					v2(voiceStatusChanged({
						status = crossExperience.Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT
					}))

					if p and p.handleRCCConnectionTimeout then
						default:logPartyVoiceTimeout()
						default:leave()
					end
				end
			end)
		end

		ref8.current = default.JoinRequestSubmitted.Event:Connect(function(flag: boolean)
			if not flag then
				v2(voiceStatusChanged({
					status = crossExperience.Constants.VOICE_STATUS.ERROR_START_BACKGROUND_DM
				}))

				default2:logPartyVoiceStatusChanged({
					status = crossExperience.Constants.VOICE_STATUS.ERROR_START_BACKGROUND_DM,
					voiceChannelId = nil,
					voiceSessionId = nil,
					userId = not Players.LocalPlayer and "" or tostring(Players.LocalPlayer.UserId)
				})
			end
		end)

		if getFFlagEnableCrossExpVoiceMemoryCheck() then
			ref9.current = default.JoinFeasibilityCheckPerformed.Event:Connect(function(flag: boolean)
				if not flag then
					v2(voiceStatusChanged({
						status = crossExperience.Constants.VOICE_STATUS.ERROR_JOIN_FEASIBILITY_CHECK_FAILED
					}))

					default2:logPartyVoiceStatusChanged({
						status = crossExperience.Constants.VOICE_STATUS.ERROR_JOIN_FEASIBILITY_CHECK_FAILED,
						voiceChannelId = nil,
						voiceSessionId = nil,
						userId = not Players.LocalPlayer and "" or tostring(Players.LocalPlayer.UserId)
					})
				end
			end)
		end

		ref2.current = default.ExperienceJoined.Event:Connect(function()
			fn4() -- inferred equivalent call

			if engineFeature then
				default:signalCevReadinessSync()
			end
		end)
		ref3.current = default.ExperienceJoinFailed.Event:Connect(function()
			fn2() -- inferred equivalent call
		end)

		ref4.current = default.ExperienceLeft.Event:Connect(function()
			fn2() -- inferred equivalent call
		end)

		if experienceService then
			ref5.current = experienceService:RegisterForExperienceJoin(function()
				if game.PlaceId == 0 then
					fn2() -- inferred equivalent call
				end
			end)
			ref6.current = experienceService:RegisterForExperienceLeave(function()
				if game.PlaceId == 0 then
					v3:restoreStateFromBackground(v, Logger)
				end
			end)
		end

		if FFlagEnableCEVForceInitialize and p and p.forceInitializeStoreOnMount then
			fn4() -- inferred equivalent call
		end
	end

	useEffect(function()
		fn5()
		return function()
			fn3()
		end
	end, {})

	return nil
end

return useCrossExperienceVoice
