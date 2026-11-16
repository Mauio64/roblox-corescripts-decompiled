local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
local v = CoreScriptsInitializer.CoreLogger:new(script.Name)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice = SharedFlags.GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice

local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local CrossExperience = require(CorePackages.Workspace.Packages.CrossExperience)
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local constants = CrossExperience.Constants

local FIntPartyVoiceUndeafenDelayMS = SharedFlags2.FIntPartyVoiceUndeafenDelayMS
local defineFastFlag = game:DefineFastFlag("FixJoinVoiceDelayedAFMInit", false)

local v2 = false
local v3 = nil
local v4 = false
local v5 = false
local flag = false
local flag2 = false

local thread = nil

if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
	default:subscribe("OnStateChanged", function(_, p)
		v3 = p

		if p == Enum.VoiceChatState.Ended then
			v5 = false
		end
	end)
	default.VoiceJoinProgressChanged.Event:Connect(function(p)
		if p == Constants.VOICE_JOIN_PROGRESS.Suspended then
			v2 = true
		end
	end)

	function performVoiceOperationWhenReady(callback)
		default:asyncInit():andThen(function()
			callback()
		end):catch(function()
			v:info("VCSM was not initialized to perform operation [CEV ExperienceAudioFocusBinder]")
		end)
	end

	function isConnectedToPublicVoice(): boolean
		return not default:ShouldShowJoinVoice() or v3 == Enum.VoiceChatState.Joined
	end

	function initializeAFM()
		if defineFastFlag and v4 then
			v:info("VCSM was already initialized [CEV ExperienceAudioFocusBinder]")
			return
		end

		if defineFastFlag then
			v4 = true
		end

		local success, result = pcall(function()
			return game:GetService("AudioFocusService")
		end)

		local function fn(CONTEXT_ID, FOCUS_PRIORITY) -- 1 equivalent call inferred from this helper
			v:info("UGC requestAudioFocusWithPromise - id: {} - priority: {}", CONTEXT_ID, FOCUS_PRIORITY)
			return Promise.new(function(callback, callback2)
				local success2, result2 = pcall(result.RequestFocus, result, CONTEXT_ID, FOCUS_PRIORITY)

				if success2 then
					v:info("UGC requestAudioFocusWithPromise - focusGranted: {}", result2)
					callback(result2)
				else
					v:info("UGC requestAudioFocusWithPromise - rejected")
					callback2("Failed to call RequestFocus due to an error")
				end
			end)
		end

		local v6 = fn5

		local function fn2(p, p2) -- 2 equivalent calls inferred from this helper
			if not v5 then
				performVoiceOperationWhenReady(function()
					if not v2 then
						v6(p, p2)
					end
				end)
				v5 = true
			end
		end

		if success and result then
			local CONTEXT_ID = constants.AUDIO_FOCUS_MANAGEMENT.UGC.CONTEXT_ID
			local FOCUS_PRIORITY = constants.AUDIO_FOCUS_MANAGEMENT.UGC.FOCUS_PRIORITY

			result:RegisterContextIdFromLua(CONTEXT_ID)

			local function fn3()
				if isConnectedToPublicVoice() then
					if FIntPartyVoiceUndeafenDelayMS > 0 and thread then
						task.cancel(thread)
						thread = nil
					end

					default:MuteAll(true, "AudioFocusManagement UGC")

					if not default.localMuted then
						default:ToggleMic("AudioFocusManagement - UGC deafenAll")
					end

					default:HideVoiceUI()
				end
			end

			local function fn4()
				if isConnectedToPublicVoice() then
					if FIntPartyVoiceUndeafenDelayMS > 0 and thread then
						task.cancel(thread)
						thread = nil
					end

					default:MuteAll(false, "AudioFocusManagement UGC")

					if not default.localMuted then
						default:ToggleMic("AudioFocusManagement - UGC undeafenAll")
					end

					default:ShowVoiceUI()
				end
			end

			result.OnDeafenVoiceAudio:Connect(function(p)
				if p == CONTEXT_ID then
					if FIntPartyVoiceUndeafenDelayMS > 0 and thread then
						task.cancel(thread)
						thread = nil
					end

					v:info("UGC OnDeafenVoiceAudio fired" .. p)
					performVoiceOperationWhenReady(fn3)
				end
			end)

			result.OnUndeafenVoiceAudio:Connect(function(p)
				if p == CONTEXT_ID then
					if FIntPartyVoiceUndeafenDelayMS > 0 then
						if thread then
							task.cancel(thread)
						end

						thread = task.delay(FIntPartyVoiceUndeafenDelayMS / 1000, function()
							thread = nil
							v:info("UGC OnUndeafenVoiceAudio fired delayed" .. p)
							performVoiceOperationWhenReady(fn4)
						end)
					else
						v:info("UGC OnUndeafenVoiceAudio fired" .. p)
						performVoiceOperationWhenReady(fn4)
					end
				end
			end)

			local function fn5(p, p2)
				if p ~= nil then
					if p2 then
						v:info("UGC audio focus request granted, preparing to undeafen.")
						default:MuteAll(false, "AudioFocusManagement UGC")
						default:ShowVoiceUI()
					else
						v:info("UGC audio focus requested denied, preparing to deafen.")
						default:MuteAll(true, "AudioFocusManagement UGC")
						default:HideVoiceUI()
					end
				end
			end

			fn(CONTEXT_ID, FOCUS_PRIORITY):andThen(function(p) -- inferred equivalent call
				default.muteChanged.Event:Connect(function(p2)
					if flag2 then
						fn2(p2, isConnectedToPublicVoice()) -- inferred equivalent call
					else
						fn2(p2, p) -- inferred equivalent call
						flag2 = true
					end
				end)
			end):catch(function()
				v:info("[UGC] Error requesting focus inside UGCdatamodel")
			end)
		end
	end

	local canUseServiceResult = default.canUseServiceResult

	if canUseServiceResult then
		initializeAFM()
	elseif canUseServiceResult == nil then
		if defineFastFlag then
			default:subscribe("OnVoiceChatServiceInitialized", function()
				if flag then
					initializeAFM()
					flag = false
				end
			end)
		end

		default:subscribe("OnCanUseServiceResult", function(p)
			if p then
				initializeAFM()
				return
			end

			if defineFastFlag then
				flag = true
			end

			v:info("VCSM cannot be used [CEV ExperienceAudioFocusBinder]")
		end)
	else
		v:info("VCSM cannot be used [CEV ExperienceAudioFocusBinder]")
	end
else
	default:asyncInit():andThen(function()
		local success, result = pcall(function()
			return game:GetService("AudioFocusService")
		end)

		local function fn() -- 1 equivalent call inferred from this helper
			default:MuteAll(true, "AudioFocusManagement UGC")

			if not default.localMuted then
				default:ToggleMic("AudioFocusManagement - UGC deafenAll")
			end

			default:HideVoiceUI()
		end

		local function fn2() -- 1 equivalent call inferred from this helper
			default:MuteAll(false, "AudioFocusManagement UGC")

			if not default.localMuted then
				default:ToggleMic("AudioFocusManagement - UGC undeafenAll")
			end

			default:ShowVoiceUI()
		end

		if success and result then
			local CONTEXT_ID = constants.AUDIO_FOCUS_MANAGEMENT.UGC.CONTEXT_ID
			local FOCUS_PRIORITY = constants.AUDIO_FOCUS_MANAGEMENT.UGC.FOCUS_PRIORITY

			result:RegisterContextIdFromLua(CONTEXT_ID)

			result.OnDeafenVoiceAudio:Connect(function(p)
				if p == CONTEXT_ID then
					v:info("UGC OnDeafenVoiceAudio fired" .. p)
					fn() -- inferred equivalent call
				end
			end)

			result.OnUndeafenVoiceAudio:Connect(function(p)
				if p == CONTEXT_ID then
					v:info("UGC OnUndeafenVoiceAudio fired" .. p)
					fn2() -- inferred equivalent call
				end
			end)

			Promise.new(function(callback, callback2)
				local success2, result2 = pcall(result.RequestFocus, result, CONTEXT_ID, FOCUS_PRIORITY)

				if success2 then
					callback(result2)
				else
					callback2("Failed to call RequestFocus due to an error")
				end
			end):andThen(function(p)
				if p then
					v:info("UGC audio focus request granted, preparing to undeafen.")
					default.muteChanged.Event:Once(function(p2)
						if p2 ~= nil then
							default:MuteAll(false, "AudioFocusManagement UGC")
						end
					end)
					default:ShowVoiceUI()
				else
					v:info("UGC audio focus requested denied, preparing to deafen.")
					default.muteChanged.Event:Once(function(p2)
						if p2 ~= nil then
							default:MuteAll(true, "AudioFocusManagement UGC")
						end
					end)
					default:HideVoiceUI()
				end
			end):catch(function()
				v:info("[UGC] Error requesting focus inside UGCdatamodel")
			end)
		end
	end):catch(function()
		v:info("VCSM was not initialized [CEV ExperienceAudioFocusBinder]")
	end)
end
