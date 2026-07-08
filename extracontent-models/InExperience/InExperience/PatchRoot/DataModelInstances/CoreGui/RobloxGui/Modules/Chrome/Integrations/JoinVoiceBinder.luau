local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local React = require(CorePackages.Packages.React)
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local CrossExperienceVoice = require(CorePackages.Workspace.Packages.CrossExperienceVoice)
local CrossExperience = require(CorePackages.Workspace.Packages.CrossExperience)
local v8 = if not require(CorePackages.Workspace.Packages.Chrome).Enabled() then nil else require(Chrome.ChromeShared.Service)
local isVoiceFocused = CrossExperience.Utils.isVoiceFocused
local useIsVoiceFocused = CrossExperienceVoice.Hooks.useIsVoiceFocused
local useIsVoiceConnecting = CrossExperienceVoice.Hooks.useIsVoiceConnecting
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local VOICE_JOIN_PROGRESS = Constants.VOICE_JOIN_PROGRESS
local PromptType = require(RobloxGui.Modules.VoiceChatPrompt.PromptType)
local GetFFlagEnableConnectDisconnectInSettingsAndChrome = require(RobloxGui.Modules.Flags.GetFFlagEnableConnectDisconnectInSettingsAndChrome)
local GetFFlagIntegratePhoneUpsellJoinVoice = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagIntegratePhoneUpsellJoinVoice
local GetFFlagEnableVoiceUxUpdates = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableVoiceUxUpdates
local FFlagVoiceRewarmTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagVoiceRewarmTelemetry

local function v19() -- line: 43
	-- upvalues: default (copy), FFlagVoiceRewarmTelemetry (copy)
	default:reportJoinVoiceUpsellEvent("Shown", if not FFlagVoiceRewarmTelemetry then nil else default.joinVoiceButtonContext)
end

local u20 = false

local function v21(...) -- line: 33
	-- upvalues: u20 (ref), v19 (copy)
	if not u20 then
		u20 = true

		return v19(...)
	end

	return nil
end
local function JoinVoiceBinder() -- line: 50
	-- upvalues: useIsVoiceFocused (copy), useIsVoiceConnecting (copy), React (copy), v8 (copy), v21 (copy), GetFFlagIntegratePhoneUpsellJoinVoice (copy), default (copy), isVoiceFocused (copy), VOICE_JOIN_PROGRESS (copy), GetFFlagEnableVoiceUxUpdates (copy), Constants (copy), PromptType (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy)
	local v25 = useIsVoiceFocused()
	local v26 = useIsVoiceConnecting()
	local v27 = React.useMemo(function() -- line: 53
		-- upvalues: v25 (copy), v26 (copy)
		return v25 or v26
	end, {
		v26,
		v25
	})
	local v28 = React.useMemo(function() -- line: 57
		-- upvalues: v8 (copy)
		if v8 then
			return v8:integrations().join_voice
		end

		return nil
	end, {})
	local v29 = React.useCallback(function(n1: number) -- line: 64
		-- upvalues: v28 (copy), v8 (copy), v25 (copy), v21 (copy)
		if not v28 or not v8 then
			return
		end

		if not v25 then
			if n1 == v8.AvailabilitySignal.Available then
				v21()
				v28.availability:available()

				return
			end

			if n1 == v8.AvailabilitySignal.Unavailable then
				v28.availability:unavailable()
			end
		end
	end, {})
	local v30 = React.useCallback(function() -- line: 79
		-- upvalues: v8 (copy), GetFFlagIntegratePhoneUpsellJoinVoice (copy), default (copy), v27 (copy), isVoiceFocused (copy), v29 (copy)
		if not v8 then
			return
		end

		if GetFFlagIntegratePhoneUpsellJoinVoice() then
			task.spawn(function() -- line: 85
				-- upvalues: default (copy), v27 (copy), isVoiceFocused (copy), v29 (copy), v8 (copy)
				if default:ShouldShowJoinVoice() and (not v27 and not isVoiceFocused()) then
					v29(v8.AvailabilitySignal.Available)
				end
			end)

			return
		end

		if default:ShouldShowJoinVoice() and not v27 and not isVoiceFocused() then
			v29(v8.AvailabilitySignal.Available)
		end
	end, {
		v28,
		v27
	})
	local v31 = React.useCallback(function(p1) -- line: 101
		-- upvalues: v28 (copy), v27 (copy), isVoiceFocused (copy), VOICE_JOIN_PROGRESS (copy), v30 (copy), GetFFlagEnableVoiceUxUpdates (copy), default (copy), Constants (copy), PromptType (copy)
		if not v28 then
			return
		end

		if v27 or isVoiceFocused() then
			v28.availability:unavailable()

			return
		end

		if p1 == VOICE_JOIN_PROGRESS.Idle then
			v30()

			return
		end

		if not GetFFlagEnableVoiceUxUpdates() and p1 == VOICE_JOIN_PROGRESS.Suspended then
			v28.availability:available()

			return
		end

		if p1 == VOICE_JOIN_PROGRESS.Joined then
			v28.availability:unavailable()

			if default.inExpUpsellEntrypoint == Constants.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE then
				default:ToggleMic()
				default:showPrompt(PromptType.VoiceConsentAcceptedToast)
			end
		end
	end, {
		v28,
		v27
	})
	local v32 = React.useCallback(function() -- line: 122
		-- upvalues: v28 (copy)
		v28.availability:unavailable()
	end, { v28 })
	local v33 = React.useCallback(function() -- line: 126
		-- upvalues: v27 (copy), isVoiceFocused (copy), v28 (copy)
		if v27 or isVoiceFocused() then
			v28.availability:unavailable()

			return
		end

		v28.availability:available()
	end, {
		v28,
		v27
	})
	local v34 = React.useCallback(function() -- line: 134
		-- upvalues: default (copy), v31 (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), v32 (copy), GetFFlagEnableVoiceUxUpdates (copy), v33 (copy)
		local connection = nil
		local connection2 = nil
		local connection3 = default.VoiceJoinProgressChanged.Event:Connect(v31)

		if GetFFlagEnableConnectDisconnectInSettingsAndChrome() then
			connection = default.showVoiceUI.Event:Connect(v32)

			if not GetFFlagEnableVoiceUxUpdates() then
				connection2 = default.hideVoiceUI.Event:Connect(v33)
			end
		end

		return function() -- line: 146
			-- upvalues: connection3 (copy), connection (ref), connection2 (ref)
			if connection3 then
				connection3:Disconnect()
			end

			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end
		end
	end, {})

	React.useEffect(function() -- line: 159
		-- upvalues: v30 (copy), v34 (copy)
		v30()
		v34()
	end, {})
	React.useEffect(function() -- line: 164
		-- upvalues: v31 (copy), default (copy)
		v31(default.VoiceJoinProgress)
	end, { v27 })

	return nil
end

return JoinVoiceBinder
