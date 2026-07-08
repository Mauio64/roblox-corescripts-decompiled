local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local v4 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)
local GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local CrossExperience = require(CorePackages.Workspace.Packages.CrossExperience)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Constants2 = CrossExperience.Constants
local FIntPartyVoiceUndeafenDelayMS = SharedFlags.FIntPartyVoiceUndeafenDelayMS
local v12 = game:DefineFastFlag("FixJoinVoiceDelayedAFMInit", false)
local u13 = false
local u14 = nil
local u15 = false
local u16 = false
local u17 = false
local u18 = false
local u19 = nil

if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
	default:subscribe("OnStateChanged", function(_, p2) -- line: 28
		-- upvalues: u14 (ref), u16 (ref)
		u14 = p2

		if p2 == Enum.VoiceChatState.Ended then
			u16 = false
		end
	end)
	default.VoiceJoinProgressChanged.Event:Connect(function(p3) -- line: 34
		-- upvalues: Constants (copy), u13 (ref)
		if p3 == Constants.VOICE_JOIN_PROGRESS.Suspended then
			u13 = true
		end
	end)

	function performVoiceOperationWhenReady(p4) -- line: 40
		-- upvalues: default (copy), v4 (copy)
		default:asyncInit():andThen(function() -- line: 42
			-- upvalues: p4 (copy)
			p4()
		end):catch(function() -- line: 45
			-- upvalues: v4 (copy)
			v4:info("VCSM was not initialized to perform operation [CEV ExperienceAudioFocusBinder]")
		end)
	end
	function isConnectedToPublicVoice() -- line: 50
		-- upvalues: default (copy), u14 (ref)
		return not default:ShouldShowJoinVoice() or u14 == Enum.VoiceChatState.Joined
	end
	function initializeAFM() -- line: 55
		-- upvalues: v12 (copy), u15 (ref), v4 (copy), Constants2 (copy), FIntPartyVoiceUndeafenDelayMS (copy), u19 (ref), default (copy), Promise (copy), u16 (ref), u13 (ref), u18 (ref)
		if v12 and u15 then
			v4:info("VCSM was already initialized [CEV ExperienceAudioFocusBinder]")

			return
		end

		if v12 then
			u15 = true
		end

		local ok, result = pcall(function() -- line: 63
			return game:GetService("AudioFocusService")
		end)

		if ok and result then
			local CONTEXT_ID = Constants2.AUDIO_FOCUS_MANAGEMENT.UGC.CONTEXT_ID
			local FOCUS_PRIORITY = Constants2.AUDIO_FOCUS_MANAGEMENT.UGC.FOCUS_PRIORITY

			result:RegisterContextIdFromLua(CONTEXT_ID)

			local function v29() -- line: 72
				-- upvalues: FIntPartyVoiceUndeafenDelayMS (copy), u19 (ref), default (copy)
				if isConnectedToPublicVoice() then
					if FIntPartyVoiceUndeafenDelayMS > 0 and u19 then
						task.cancel(u19)
						u19 = nil
					end

					default:MuteAll(true, "AudioFocusManagement UGC")

					if not default.localMuted then
						default:ToggleMic("AudioFocusManagement - UGC deafenAll")
					end

					default:HideVoiceUI()
				end
			end
			local function v30() -- line: 89
				-- upvalues: FIntPartyVoiceUndeafenDelayMS (copy), u19 (ref), default (copy)
				if isConnectedToPublicVoice() then
					if FIntPartyVoiceUndeafenDelayMS > 0 and u19 then
						task.cancel(u19)
						u19 = nil
					end

					default:MuteAll(false, "AudioFocusManagement UGC")

					if not default.localMuted then
						default:ToggleMic("AudioFocusManagement - UGC undeafenAll")
					end

					default:ShowVoiceUI()
				end
			end

			result.OnDeafenVoiceAudio:Connect(function(p5) -- line: 105
				-- upvalues: CONTEXT_ID (copy), FIntPartyVoiceUndeafenDelayMS (copy), u19 (ref), v4 (copy), v29 (copy)
				if p5 == CONTEXT_ID then
					if FIntPartyVoiceUndeafenDelayMS > 0 and u19 then
						task.cancel(u19)
						u19 = nil
					end

					v4:info("UGC OnDeafenVoiceAudio fired" .. p5)
					performVoiceOperationWhenReady(v29)
				end
			end)
			result.OnUndeafenVoiceAudio:Connect(function(p6) -- line: 116
				-- upvalues: CONTEXT_ID (copy), FIntPartyVoiceUndeafenDelayMS (copy), u19 (ref), v4 (copy), v30 (copy)
				if p6 == CONTEXT_ID then
					if FIntPartyVoiceUndeafenDelayMS > 0 then
						if u19 then
							task.cancel(u19)
						end

						u19 = task.delay(FIntPartyVoiceUndeafenDelayMS / 1000, function() -- line: 122
							-- upvalues: u19 (ref), v4 (copy), p6 (copy), v30 (copy)
							u19 = nil
							v4:info("UGC OnUndeafenVoiceAudio fired delayed" .. p6)
							performVoiceOperationWhenReady(v30)
						end)

						return
					end

					v4:info("UGC OnUndeafenVoiceAudio fired" .. p6)
					performVoiceOperationWhenReady(v30)
				end
			end)

			local function v31(p7, p8) -- line: 149
				-- upvalues: v4 (copy), default (copy)
				if p7 ~= nil then
					if p8 then
						v4:info("UGC audio focus request granted, preparing to undeafen.")
						default:MuteAll(false, "AudioFocusManagement UGC")
						default:ShowVoiceUI()

						return
					end

					v4:info("UGC audio focus requested denied, preparing to deafen.")
					default:MuteAll(true, "AudioFocusManagement UGC")
					default:HideVoiceUI()
				end
			end

			v4:info("UGC requestAudioFocusWithPromise - id: {} - priority: {}", CONTEXT_ID, FOCUS_PRIORITY)
			Promise.new(function(resolve, reject) -- line: 136
				-- upvalues: result (copy), CONTEXT_ID (copy), FOCUS_PRIORITY (copy), v4 (copy)
				local ok2, result2 = pcall(result.RequestFocus, result, CONTEXT_ID, FOCUS_PRIORITY)

				if ok2 then
					v4:info("UGC requestAudioFocusWithPromise - focusGranted: {}", result2)
					resolve(result2)

					return
				end

				v4:info("UGC requestAudioFocusWithPromise - rejected")
				reject("Failed to call RequestFocus due to an error")
			end):andThen(function(p9) -- line: 175
				-- upvalues: default (copy), u18 (ref), u16 (ref), u13 (ref), v31 (copy)
				default.muteChanged.Event:Connect(function(p10) -- line: 176
					-- upvalues: u18 (ref), p9 (copy), u16 (ref), u13 (ref), v31 (copy)
					if not u18 then
						local v64 = p9

						if not u16 then
							performVoiceOperationWhenReady(function() -- line: 165
								-- upvalues: u13 (ref), v31 (copy), p10 (copy), v64 (copy)
								if not u13 then
									v31(p10, v64)
								end
							end)
							u16 = true
						end

						u18 = true

						return
					end

					local v65 = isConnectedToPublicVoice()

					if not u16 then
						performVoiceOperationWhenReady(function() -- line: 165
							-- upvalues: u13 (ref), v31 (copy), p10 (copy), v65 (copy)
							if not u13 then
								v31(p10, v65)
							end
						end)
						u16 = true
					end
				end)
			end):catch(function() -- line: 185
				-- upvalues: v4 (copy)
				v4:info("[UGC] Error requesting focus inside UGCdatamodel")
			end)
		end
	end

	local canUseServiceResult = default.canUseServiceResult

	if canUseServiceResult then
		initializeAFM()
	elseif canUseServiceResult == nil then
		if v12 then
			default:subscribe("OnVoiceChatServiceInitialized", function() -- line: 196
				-- upvalues: u17 (ref)
				if u17 then
					initializeAFM()
					u17 = false
				end
			end)
		end

		default:subscribe("OnCanUseServiceResult", function(p11) -- line: 204
			-- upvalues: v12 (copy), u17 (ref), v4 (copy)
			if p11 then
				initializeAFM()

				return
			end

			if v12 then
				u17 = true
			end

			v4:info("VCSM cannot be used [CEV ExperienceAudioFocusBinder]")
		end)
	else
		v4:info("VCSM cannot be used [CEV ExperienceAudioFocusBinder]")
	end
else
	default:asyncInit():andThen(function() -- line: 219
		-- upvalues: Constants2 (copy), default (copy), v4 (copy), Promise (copy)
		local ok, result = pcall(function() -- line: 220
			return game:GetService("AudioFocusService")
		end)

		if ok and result then
			local CONTEXT_ID = Constants2.AUDIO_FOCUS_MANAGEMENT.UGC.CONTEXT_ID
			local FOCUS_PRIORITY = Constants2.AUDIO_FOCUS_MANAGEMENT.UGC.FOCUS_PRIORITY

			result:RegisterContextIdFromLua(CONTEXT_ID)
			result.OnDeafenVoiceAudio:Connect(function(p12) -- line: 249
				-- upvalues: CONTEXT_ID (copy), v4 (copy), default (copy)
				if p12 == CONTEXT_ID then
					v4:info("UGC OnDeafenVoiceAudio fired" .. p12)
					default:MuteAll(true, "AudioFocusManagement UGC")

					if not default.localMuted then
						default:ToggleMic("AudioFocusManagement - UGC deafenAll")
					end

					default:HideVoiceUI()
				end
			end)
			result.OnUndeafenVoiceAudio:Connect(function(p13) -- line: 256
				-- upvalues: CONTEXT_ID (copy), v4 (copy), default (copy)
				if p13 == CONTEXT_ID then
					v4:info("UGC OnUndeafenVoiceAudio fired" .. p13)
					default:MuteAll(false, "AudioFocusManagement UGC")

					if not default.localMuted then
						default:ToggleMic("AudioFocusManagement - UGC undeafenAll")
					end

					default:ShowVoiceUI()
				end
			end)
			Promise.new(function(resolve, reject) -- line: 264
				-- upvalues: result (copy), CONTEXT_ID (copy), FOCUS_PRIORITY (copy)
				local ok3, result3 = pcall(result.RequestFocus, result, CONTEXT_ID, FOCUS_PRIORITY)

				if ok3 then
					resolve(result3)

					return
				end

				reject("Failed to call RequestFocus due to an error")
			end):andThen(function(p14) -- line: 276
				-- upvalues: v4 (copy), default (copy)
				if p14 then
					v4:info("UGC audio focus request granted, preparing to undeafen.")
					default.muteChanged.Event:Once(function(p15) -- line: 279
						-- upvalues: default (copy)
						if p15 ~= nil then
							default:MuteAll(false, "AudioFocusManagement UGC")
						end
					end)
					default:ShowVoiceUI()

					return
				end

				v4:info("UGC audio focus requested denied, preparing to deafen.")
				default.muteChanged.Event:Once(function(p16) -- line: 287
					-- upvalues: default (copy)
					if p16 ~= nil then
						default:MuteAll(true, "AudioFocusManagement UGC")
					end
				end)
				default:HideVoiceUI()
			end):catch(function() -- line: 295
				-- upvalues: v4 (copy)
				v4:info("[UGC] Error requesting focus inside UGCdatamodel")
			end)
		end
	end):catch(function() -- line: 300
		-- upvalues: v4 (copy)
		v4:info("VCSM was not initialized [CEV ExperienceAudioFocusBinder]")
	end)
end
