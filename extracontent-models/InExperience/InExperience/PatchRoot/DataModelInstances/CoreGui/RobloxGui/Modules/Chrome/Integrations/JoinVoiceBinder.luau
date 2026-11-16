local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)

local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default

local CrossExperienceVoice = require(CorePackages.Workspace.Packages.CrossExperienceVoice)
local CrossExperience = require(CorePackages.Workspace.Packages.CrossExperience)

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local Service

if Chrome2.Enabled() then
	Service = require(Chrome.ChromeShared.Service)
else
	Service = nil
end

local isVoiceFocused = CrossExperience.Utils.isVoiceFocused
local useIsVoiceFocused = CrossExperienceVoice.Hooks.useIsVoiceFocused
local useIsVoiceConnecting = CrossExperienceVoice.Hooks.useIsVoiceConnecting

local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local VOICE_JOIN_PROGRESS = Constants.VOICE_JOIN_PROGRESS
local PromptType = require(RobloxGui.Modules.VoiceChatPrompt.PromptType)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagIntegratePhoneUpsellJoinVoice = SharedFlags.GetFFlagIntegratePhoneUpsellJoinVoice
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagVoiceRewarmTelemetry = SharedFlags2.FFlagVoiceRewarmTelemetry

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagProactiveVoiceRestrictionsUFR = SharedFlags3.FFlagProactiveVoiceRestrictionsUFR
local FFlagVoiceRewarmGrafanaMetrics = require(RobloxGui.Modules.VoiceChat.Flags.FFlagVoiceRewarmGrafanaMetrics)

local function fn()
	local v

	if FFlagVoiceRewarmTelemetry then
		v = default.joinVoiceButtonContext
	end

	default:reportJoinVoiceUpsellEvent("Shown", v)
end

local function fn2(fn3) -- 1 equivalent call inferred from this helper
	local flag = false
	return function(...)
		if flag then
			return nil
		end

		flag = true
		return fn3(...)
	end
end

local v = fn2(fn) -- inferred equivalent call

local function JoinVoiceBinder(): nil
	local v2 = useIsVoiceFocused()
	local v3 = useIsVoiceConnecting()
	local v4 = React.useMemo(function()
		return v2 or v3
	end, { v3, v2 })

	local v5 = React.useMemo(function()
		if Service then
			return Service:integrations().join_voice
		end

		return nil
	end, {})

	local v6 = React.useCallback(function(p: number)
		if not (v5 and Service) then
			return
		end

		if FFlagProactiveVoiceRestrictionsUFR and default:GetVoiceRestrictionState(false) ~= "normal" then
			v5.availability:unavailable()
		elseif not v2 then
			if p == Service.AvailabilitySignal.Available then
				v()

				if FFlagVoiceRewarmGrafanaMetrics then
					default:reportVoiceRewarmShown()
				end

				v5.availability:available()
			elseif p == Service.AvailabilitySignal.Unavailable then
				v5.availability:unavailable()
			end
		end
	end, {})

	local v7 = React.useCallback(function()
		if not Service then
			return
		end

		if GetFFlagIntegratePhoneUpsellJoinVoice() then
			task.spawn(function()
				if default:ShouldShowJoinVoice() and not (v4 or isVoiceFocused()) then
					v6(Service.AvailabilitySignal.Available)
				end
			end)
		elseif default:ShouldShowJoinVoice() and not (v4 or isVoiceFocused()) then
			v6(Service.AvailabilitySignal.Available)
		end
	end, { v5, v4 })

	local v8 = React.useCallback(function(p)
		if not v5 then
			return
		end

		if FFlagProactiveVoiceRestrictionsUFR and default:GetVoiceRestrictionState(false) ~= "normal" then
			v5.availability:unavailable()
		elseif v4 or isVoiceFocused() then
			v5.availability:unavailable()
		elseif p == VOICE_JOIN_PROGRESS.Idle then
			v7()
		elseif p == VOICE_JOIN_PROGRESS.Joined then
			v5.availability:unavailable()

			if default.inExpUpsellEntrypoint == Constants.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE then
				default:ToggleMic()
				default:showPrompt(PromptType.VoiceConsentAcceptedToast)
			end
		end
	end, { v5, v4 })

	local v9 = React.useCallback(function()
		v5.availability:unavailable()
	end, { v5 })

	local v10 = React.useCallback(function()
		local v10

		if FFlagProactiveVoiceRestrictionsUFR and v5 then
			v10 = Signals.createEffect(function(p)
				if default:GetVoiceRestrictionState(p) ~= "normal" then
					v5.availability:unavailable()
				end
			end)
		else
			v10 = nil
		end

		local eventConnection = default.VoiceJoinProgressChanged.Event:Connect(v8)
		local eventConnection2 = default.showVoiceUI.Event:Connect(v9)

		return function()
			if v10 then
				v10()
			end

			if eventConnection then
				eventConnection:Disconnect()
			end

			if eventConnection2 then
				eventConnection2:Disconnect()
			end
		end
	end, {})

	React.useEffect(function()
		v7()

		if FFlagProactiveVoiceRestrictionsUFR then
			return v10()
		end

		v10()
		return nil
	end, {})

	React.useEffect(function()
		v8(default.VoiceJoinProgress)
	end, { v4 })

	return nil
end

return JoinVoiceBinder
