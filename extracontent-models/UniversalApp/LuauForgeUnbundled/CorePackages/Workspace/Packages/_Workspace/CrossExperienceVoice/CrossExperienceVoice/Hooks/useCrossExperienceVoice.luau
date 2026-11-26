local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies")
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

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Logger")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/CrossExperienceVoiceManager").default
local default2 = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/CrossExperienceVoiceAnalytics").default
local Flags = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Flags")
local fFlagFireErrorRCCTimeoutSignal = Flags.FFlagFireErrorRCCTimeoutSignal
local fFlagEnableCEVForceInitialize = Flags.FFlagEnableCEVForceInitialize

local function useCrossExperienceVoice(p2): nil
	local v5 = useStore()
	local v6 = useDispatch()
	local ref = react.useRef(nil)
	local ref2 = react.useRef(nil)
	local ref3 = react.useRef(nil)
	local ref4 = react.useRef(nil)
	local ref5 = react.useRef(nil)
	local ref6 = react.useRef(nil)
	local ref7 = react.useRef(nil)
	local ref8 = react.useRef(nil)
	local ref9 = react.useRef(nil)

	local v7 = react.useMemo(function()
		local new = crossExperience.EventManager.new
		local v8 = if game.PlaceId == 0 then crossExperience.Constants.EXPERIENCE_TYPE_LUAAPP else crossExperience.Constants.EXPERIENCE_TYPE_UGC

		return new(v8, true)
	end, {})

	local ref10 = react.useRef(false)

	local function fn()
		if ref10.current then
			ref10.current = false
			v7:unsubscribe(v5, Logger)
		end

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

	local function fn2()
		ref7.current = default.JoinRequested.Event:Connect(function()
			v6(voiceStatusChanged({
				status = crossExperience.Constants.VOICE_STATUS.RCC_CONNECTING
			}))

			default2:logPartyVoiceStatusChanged({
				status = crossExperience.Constants.VOICE_STATUS.RCC_CONNECTING,
				voiceChannelId = nil,
				voiceSessionId = nil,
				userId = not Players.LocalPlayer and "" or tostring(Players.LocalPlayer.UserId)
			})
		end)

		if fIntPartyVoiceJoinRequestPulseCheckTimeout > 0 then
			ref.current = default.JoinRequestPulseCheck.Event:Connect(function()
				local state = v5:getState()

				if
					state
					and state.Squad
					and state.Squad.CrossExperienceVoice
					and state.Squad.CrossExperienceVoice.Experience.voiceStatus == crossExperience.Constants.VOICE_STATUS.RCC_CONNECTING
				then
					if fFlagFireErrorRCCTimeoutSignal then
						v7:notify(crossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
							status = crossExperience.Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT,
							userId = not Players.LocalPlayer and "" or tostring(Players.LocalPlayer.UserId)
						})
						return
					end

					v6(voiceStatusChanged({
						status = crossExperience.Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT
					}))

					if p2 and p2.handleRCCConnectionTimeout then
						default:logPartyVoiceTimeout()
						default:leave()
					end
				end
			end)
		end

		ref8.current = default.JoinRequestSubmitted.Event:Connect(function(p3)
			if not p3 then
				v6(voiceStatusChanged({
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
			ref9.current = default.JoinFeasibilityCheckPerformed.Event:Connect(function(p3)
				if not p3 then
					v6(voiceStatusChanged({
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
			if not ref10.current then
				ref10.current = true
				v7:subscribe(v5, Logger)
			end

			if engineFeature then
				default:signalCevReadinessSync()
			end
		end)
		ref3.current = default.ExperienceJoinFailed.Event:Connect(function()
			if not ref10.current then
				return
			end

			ref10.current = false
			v7:unsubscribe(v5, Logger)
		end)

		ref4.current = default.ExperienceLeft.Event:Connect(function()
			if not ref10.current then
				return
			end

			ref10.current = false
			v7:unsubscribe(v5, Logger)
		end)

		if experienceService then
			ref5.current = experienceService:RegisterForExperienceJoin(function()
				if game.PlaceId == 0 then
					if not ref10.current then
						return
					end

					ref10.current = false
					v7:unsubscribe(v5, Logger)
				end
			end)
			ref6.current = experienceService:RegisterForExperienceLeave(function()
				if game.PlaceId == 0 then
					v7:restoreStateFromBackground(v5, Logger)
				end
			end)
		end

		if fFlagEnableCEVForceInitialize and p2 and p2.forceInitializeStoreOnMount then
			if ref10.current then
				return
			end

			ref10.current = true
			v7:subscribe(v5, Logger)
		end
	end

	useEffect(function()
		fn2()
		return function()
			fn()
		end
	end, {})

	return nil
end

return useCrossExperienceVoice
