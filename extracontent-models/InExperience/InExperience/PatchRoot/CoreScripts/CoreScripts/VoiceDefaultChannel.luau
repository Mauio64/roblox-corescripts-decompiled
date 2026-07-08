local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")
local RobloxGui = CoreGui.RobloxGui
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local default2 = require(CorePackages.Workspace.Packages.CallProtocol).CallProtocol.default
local Enums = require(CorePackages.Workspace.Packages.CallProtocol).Enums
local v9 = game:DefineFastFlag("DebugDefaultChannelStartMuted", true)
local v10 = game:DefineFastFlag("UseNotificationServiceIsConnected", false)
local v11 = game:DefineFastFlag("DefaultChannelEnableDefaultVoice", true)
local GetFFlagSeamlessVoiceFTUX = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagSeamlessVoiceFTUX

game:GetEngineFeature("VoiceServiceGenerateDefaultChannelAvailable")

local EngineFeature = game:GetEngineFeature("VoiceServiceEnableDefaultVoiceAvailable")
local EngineFeature2 = game:GetEngineFeature("NotificationServiceIsConnectedAvailable")
local v15 = require(RobloxGui.Modules.VoiceChat.Logger)(script.Name)
local v16 = require(RobloxGui.Modules.VoiceChat.Analytics).new()
local VoiceChatService = game:GetService("VoiceChatService")

local function initializeDefaultChannel(p1) -- line: 27
	-- upvalues: default (copy), v15 (copy), v16 (copy)
	local v21 = default:getService()

	if not v21 then
		return nil
	end

	v15:info("Joining default channel")

	local v22 = v21:JoinByGroupIdToken("default", p1)

	if v22 then
		v16:reportVoiceChatJoinResult(true, "defaultJoinSuccess")

		return v22
	end

	v16:reportVoiceChatJoinResult(false, "defaultJoinFailed", "error")

	return v22
end

if EngineFeature2 and v10 then
	if not NotificationService.IsConnected then
		v15:debug("NotificationService is not yet connected")
		NotificationService:GetPropertyChangedSignal("IsConnected"):Wait()
	end

	v15:debug("NotificationService connected")
end

if not VoiceChatService.UseNewAudioApi then
	if not Players.LocalPlayer.Character then
		Players.LocalPlayer.CharacterAdded:Wait()
		v15:debug("Player character loaded")
	else
		v15:debug("Player character already loaded")
	end
end

if EngineFeature and v11 then
	local Service = game:FindService("VoiceChatService")

	if not Service then
		v15:info("VoiceChatService not found. Assuming default values.")
	elseif not Service.EnableDefaultVoice and not Service.UseNewAudioApi then
		v15:debug("Default channel is disabled.")
		v16:reportVoiceChatJoinResult(false, "defaultDisabled")

		return
	end
end

default2:getCallState():andThen(function(p2) -- line: 74
	-- upvalues: Enums (copy), v9 (copy), default (copy), initializeDefaultChannel (copy), v15 (copy)
	local v24 = if p2.status == Enums.CallStatus.Idle.rawValue() or p2.status == Enums.CallStatus.Ringing.rawValue() then v9 else p2.muted

	default:asyncInit():andThen(function() -- line: 81
		-- upvalues: initializeDefaultChannel (copy), v24 (copy), default (copy)
		if initializeDefaultChannel(v24) == false then
			default:InitialJoinFailedPrompt()
		end
	end):catch(function() -- line: 87
		-- upvalues: v15 (copy)
		v15:info("VoiceChatServiceManager did not initialize")
	end)
end)

if GetFFlagSeamlessVoiceFTUX() then
	task.spawn(function() -- line: 96
		-- upvalues: default (copy)
		default:VoiceChatFirstTimeUX(game:GetService("AppStorageService"))
	end)
end
