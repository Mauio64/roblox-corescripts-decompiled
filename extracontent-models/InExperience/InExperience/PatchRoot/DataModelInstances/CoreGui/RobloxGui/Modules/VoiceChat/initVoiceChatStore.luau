local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Players = game:GetService("Players")

local FFlagEnableVoiceChatStorybookFix = require(RobloxGui.Modules.Flags.FFlagEnableVoiceChatStorybookFix)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagLocalMutedNilFix = SharedFlags.GetFFlagLocalMutedNilFix

local VoiceEnabledChanged = require(script.Parent.Actions.VoiceEnabledChanged)
local VoiceStateChanged = require(script.Parent.Actions.VoiceStateChanged)
local ParticipantAdded = require(script.Parent.Actions.ParticipantAdded)
local ParticipantRemoved = require(script.Parent.Actions.ParticipantRemoved)
local PlayerRemoved = require(script.Parent.Actions.PlayerRemoved)

local VoiceChatServiceManager = require(script.Parent.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local VoiceChat = require(CorePackages.Workspace.Packages.VoiceChat)
local Constants = VoiceChat.Constants
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local Logger = require(RobloxGui.Modules.VoiceChat.Logger)
local logger = Logger(script.Name)
local VOICE_STATE

if FFlagEnableVoiceChatStorybookFix() then
	VOICE_STATE = Constants.VOICE_STATE
else
	VOICE_STATE = default.VOICE_STATE
end

local function shorten(userId) -- 3 equivalent calls inferred from this helper
	return "..." .. string.sub(tostring(userId), -4)
end

local v = nil

local function setVoiceEnabled(p, object)
	local userId = tostring(Players.LocalPlayer.UserId)
	object:dispatch(VoiceEnabledChanged(p ~= Enum.VoiceChatState.Ended))

	if v[p] then
		object:dispatch(VoiceStateChanged(userId, v[p]))
	else
		logger:warning("LOCAL_STATE_MAP does not exist for {} state", p)
		object:dispatch(VoiceStateChanged(userId, VOICE_STATE.MUTED))
	end

	if p == Enum.VoiceChatState.Failed then
		for _, v2 in pairs(Players:GetPlayers()) do
			local userId2 = tostring(v2.UserId)

			if v2 ~= Players.LocalPlayer then
				object:dispatch(VoiceStateChanged(userId2, VOICE_STATE.HIDDEN))
			end
		end
	elseif p == Enum.VoiceChatState.Joined then
		local v2

		if GetFFlagLocalMutedNilFix then
			v2 = default.localMuted == false
		else
			v2 = not default.localMuted
		end

		if v2 then
			object:dispatch(VoiceStateChanged(userId, VOICE_STATE.INACTIVE))
		end
	end
end

local function fn(object)
	v = {
		[Enum.VoiceChatState.Idle] = VOICE_STATE.HIDDEN,
		[Enum.VoiceChatState.Joining] = VOICE_STATE.CONNECTING,
		[Enum.VoiceChatState.JoiningRetry] = VOICE_STATE.CONNECTING,
		[Enum.VoiceChatState.Joined] = VOICE_STATE.MUTED,
		[Enum.VoiceChatState.Leaving] = VOICE_STATE.MUTED,
		[Enum.VoiceChatState.Ended] = VOICE_STATE.HIDDEN,
		[Enum.VoiceChatState.Failed] = VOICE_STATE.ERROR
	}

	local service = default:getService()

	if not service then
		logger:debug("VoiceChatService is not available")
		return
	end

	local userId = Players.LocalPlayer.UserId

	for _, v2 in pairs(Players:GetPlayers()) do
		logger:trace("Adding existing player {}", shorten(v2.UserId)) -- inferred equivalent call
		object:dispatch(ParticipantAdded((tostring(v2.UserId))))
	end

	Players.PlayerAdded:Connect(function(player)
		logger:trace("Adding joining player {}", shorten(player.UserId)) -- inferred equivalent call
		object:dispatch(ParticipantAdded((tostring(player.userId))))
	end)

	Players.PlayerRemoving:Connect(function(player)
		logger:trace("Removing player {}", shorten(player.UserId)) -- inferred equivalent call

		object:dispatch(PlayerRemoved((tostring(player.userId))))
		object:dispatch(ParticipantRemoved((tostring(player.userId))))
	end)

	object:dispatch(VoiceStateChanged(userId, VOICE_STATE.HIDDEN))
	default.muteChanged.Event:Connect(function(p)
		logger:debug("Mute changed to {}", p)
		local muted = p and VOICE_STATE.MUTED or VOICE_STATE.INACTIVE
		object:dispatch(VoiceStateChanged(userId, muted))
	end)

	default.participantsUpdate.Event:Connect(function(items)
		for k, item in pairs(items) do
			local v2 = VOICE_STATE.INACTIVE

			if item.subscriptionFailed then
				v2 = VOICE_STATE.ERROR
			elseif item.subscriptionCompleted then
				if item.isMutedLocally then
					v2 = VOICE_STATE.LOCAL_MUTED
				elseif item.isMuted then
					v2 = VOICE_STATE.MUTED
				elseif item.isSignalActive then
					v2 = VOICE_STATE.TALKING
				end
			else
				v2 = VOICE_STATE.CONNECTING
			end

			logger:trace("Participant update for {}, voice state {}", k, v2)
			object:dispatch(VoiceStateChanged(k, v2))
		end
	end)

	default.talkingChanged.Event:Connect(function(p)
		if p then
			object:dispatch(VoiceStateChanged(userId, VOICE_STATE.TALKING))
		else
			object:dispatch(VoiceStateChanged(userId, VOICE_STATE.INACTIVE))
		end
	end)

	BlockingUtility:GetBlockedStatusChangedEvent():Connect(function(p, p2)
		if p2 then
			object:dispatch(ParticipantRemoved((tostring(p))))
		else
			object:dispatch(ParticipantAdded((tostring(p))))
		end
	end)

	logger:debug("Initial voice state is {}", service.VoiceChatState)
	setVoiceEnabled(service.VoiceChatState, object)
	service.StateChanged:Connect(function(_, p)
		logger:debug("Voice state changed to {}", p)
		setVoiceEnabled(p, object)
	end)
end

return function(p)
	if game:GetEngineFeature("VoiceChatSupported") then
		default:asyncInit():andThen(function()
			default:SetupParticipantListeners()
			fn(p)
		end):catch(function()
			logger:warning("Failed to init VoiceChatServiceManager")
		end)
	end
end
