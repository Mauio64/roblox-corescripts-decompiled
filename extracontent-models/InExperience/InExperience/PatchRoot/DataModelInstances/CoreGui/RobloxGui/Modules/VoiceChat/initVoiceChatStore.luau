local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Players = game:GetService("Players")
local FFlagEnableVoiceChatStorybookFix = require(RobloxGui.Modules.Flags.FFlagEnableVoiceChatStorybookFix)
local GetFFlagLocalMutedNilFix = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLocalMutedNilFix
local VoiceEnabledChanged = require(script.Parent.Actions.VoiceEnabledChanged)
local VoiceStateChanged = require(script.Parent.Actions.VoiceStateChanged)
local ParticipantAdded = require(script.Parent.Actions.ParticipantAdded)
local ParticipantRemoved = require(script.Parent.Actions.ParticipantRemoved)
local PlayerRemoved = require(script.Parent.Actions.PlayerRemoved)
local default = require(script.Parent.VoiceChatServiceManager).default
local Constants = require(CorePackages.Workspace.Packages.VoiceChat).Constants
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local v14 = require(RobloxGui.Modules.VoiceChat.Logger)(script.Name)
local u15 = if not FFlagEnableVoiceChatStorybookFix() then default.VOICE_STATE else Constants.VOICE_STATE

local function shorten(p1) -- line: 28
	return "..." .. string.sub(tostring(p1), -4)
end

local t1 = nil

local function setVoiceEnabled(p2, p3) -- line: 34
	-- upvalues: Players (copy), VoiceEnabledChanged (copy), t1 (ref), v14 (copy), VoiceStateChanged (copy), u15 (ref), GetFFlagLocalMutedNilFix (copy), default (copy)
	local str = tostring(Players.LocalPlayer.UserId)
	local v24 = p2 ~= Enum.VoiceChatState.Ended

	p3:dispatch(VoiceEnabledChanged(v24))

	if not t1[p2] then
		v14:warning("LOCAL_STATE_MAP does not exist for {} state", p2)
		p3:dispatch(VoiceStateChanged(str, u15.MUTED))
	else
		p3:dispatch(VoiceStateChanged(str, t1[p2]))
	end

	if p2 == Enum.VoiceChatState.Failed then
		for _, player in pairs(Players:GetPlayers()) do
			local str2 = tostring(player.UserId)

			if player ~= Players.LocalPlayer then
				p3:dispatch(VoiceStateChanged(str2, u15.HIDDEN))
			end
		end

		return
	end

	if p2 == Enum.VoiceChatState.Joined and if not GetFFlagLocalMutedNilFix then not default.localMuted else default.localMuted == false then
		p3:dispatch(VoiceStateChanged(str, u15.INACTIVE))
	end
end
local function v19(p4) -- line: 64
	-- upvalues: t1 (ref), u15 (ref), default (copy), v14 (copy), Players (copy), ParticipantAdded (copy), PlayerRemoved (copy), ParticipantRemoved (copy), VoiceStateChanged (copy), BlockingUtility (copy), setVoiceEnabled (copy)
	t1 = {
		[Enum.VoiceChatState.Idle] = u15.HIDDEN,
		[Enum.VoiceChatState.Joining] = u15.CONNECTING,
		[Enum.VoiceChatState.JoiningRetry] = u15.CONNECTING,
		[Enum.VoiceChatState.Joined] = u15.MUTED,
		[Enum.VoiceChatState.Leaving] = u15.MUTED,
		[Enum.VoiceChatState.Ended] = u15.HIDDEN,
		[Enum.VoiceChatState.Failed] = u15.ERROR
	}

	local v29 = default:getService()

	if not v29 then
		v14:debug("VoiceChatService is not available")

		return
	end

	local UserId = Players.LocalPlayer.UserId

	for _, player in pairs(Players:GetPlayers()) do
		v14:trace("Adding existing player {}", "..." .. string.sub(tostring(player.UserId), -4))
		p4:dispatch(ParticipantAdded((tostring(player.UserId))))
	end

	Players.PlayerAdded:Connect(function(player) -- line: 88
		-- upvalues: v14 (copy), p4 (copy), ParticipantAdded (copy)
		v14:trace("Adding joining player {}", "..." .. string.sub(tostring(player.UserId), -4))
		p4:dispatch(ParticipantAdded((tostring(player.userId))))
	end)
	Players.PlayerRemoving:Connect(function(player) -- line: 93
		-- upvalues: v14 (copy), p4 (copy), PlayerRemoved (copy), ParticipantRemoved (copy)
		v14:trace("Removing player {}", "..." .. string.sub(tostring(player.UserId), -4))
		p4:dispatch(PlayerRemoved((tostring(player.userId))))
		p4:dispatch(ParticipantRemoved((tostring(player.userId))))
	end)
	p4:dispatch(VoiceStateChanged(UserId, u15.HIDDEN))
	default.muteChanged.Event:Connect(function(p5) -- line: 101
		-- upvalues: v14 (copy), u15 (ref), p4 (copy), VoiceStateChanged (copy), UserId (copy)
		v14:debug("Mute changed to {}", p5)

		local v37 = p5 and u15.MUTED or u15.INACTIVE

		p4:dispatch(VoiceStateChanged(UserId, v37))
	end)
	default.participantsUpdate.Event:Connect(function(p6) -- line: 107
		-- upvalues: u15 (ref), v14 (copy), p4 (copy), VoiceStateChanged (copy)
		for k, v in pairs(p6) do
			local INACTIVE = u15.INACTIVE

			if v.subscriptionFailed then
				INACTIVE = u15.ERROR
			elseif not v.subscriptionCompleted then
				INACTIVE = u15.CONNECTING
			elseif v.isMutedLocally then
				INACTIVE = u15.LOCAL_MUTED
			elseif v.isMuted then
				INACTIVE = u15.MUTED
			elseif v.isSignalActive then
				INACTIVE = u15.TALKING
			end

			v14:trace("Participant update for {}, voice state {}", k, INACTIVE)
			p4:dispatch(VoiceStateChanged(k, INACTIVE))
		end
	end)
	default.talkingChanged.Event:Connect(function(p7) -- line: 128
		-- upvalues: p4 (copy), VoiceStateChanged (copy), UserId (copy), u15 (ref)
		if p7 then
			p4:dispatch(VoiceStateChanged(UserId, u15.TALKING))

			return
		end

		p4:dispatch(VoiceStateChanged(UserId, u15.INACTIVE))
	end)
	BlockingUtility:GetBlockedStatusChangedEvent():Connect(function(p8, p9) -- line: 139
		-- upvalues: p4 (copy), ParticipantRemoved (copy), ParticipantAdded (copy)
		if p9 then
			p4:dispatch(ParticipantRemoved((tostring(p8))))

			return
		end

		p4:dispatch(ParticipantAdded((tostring(p8))))
	end)
	v14:debug("Initial voice state is {}", v29.VoiceChatState)
	setVoiceEnabled(v29.VoiceChatState, p4)
	v29.StateChanged:Connect(function(_, newState) -- line: 149
		-- upvalues: v14 (copy), setVoiceEnabled (copy), p4 (copy)
		v14:debug("Voice state changed to {}", newState)
		setVoiceEnabled(newState, p4)
	end)
end

return function(p11) -- line: 155
	-- upvalues: default (copy), v19 (copy), v14 (copy)
	if game:GetEngineFeature("VoiceChatSupported") then
		default:asyncInit():andThen(function() -- line: 158
			-- upvalues: default (copy), v19 (copy), p11 (copy)
			default:SetupParticipantListeners()
			v19(p11)
		end):catch(function() -- line: 162
			-- upvalues: v14 (copy)
			v14:warning("Failed to init VoiceChatServiceManager")
		end)
	end
end
