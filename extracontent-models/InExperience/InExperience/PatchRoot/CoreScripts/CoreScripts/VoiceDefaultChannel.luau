local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")

local RobloxGui = CoreGui.RobloxGui
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local CallProtocol = require(CorePackages.Workspace.Packages.CallProtocol)
local default2 = CallProtocol.CallProtocol.default
local CallProtocol2 = require(CorePackages.Workspace.Packages.CallProtocol)
local Enums = CallProtocol2.Enums

local defineFastFlag = game:DefineFastFlag("DebugDefaultChannelStartMuted", true)
local defineFastFlag2 = game:DefineFastFlag("UseNotificationServiceIsConnected", false)
local defineFastFlag3 = game:DefineFastFlag("DefaultChannelEnableDefaultVoice", true)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagSeamlessVoiceFTUX = SharedFlags.GetFFlagSeamlessVoiceFTUX

game:GetEngineFeature("VoiceServiceGenerateDefaultChannelAvailable")
local engineFeature = game:GetEngineFeature("VoiceServiceEnableDefaultVoiceAvailable")
local engineFeature2 = game:GetEngineFeature("NotificationServiceIsConnectedAvailable")

local Logger = require(RobloxGui.Modules.VoiceChat.Logger)
local logger = Logger(script.Name)
local Analytics = require(RobloxGui.Modules.VoiceChat.Analytics)
local v = Analytics.new()

local VoiceChatService = game:GetService("VoiceChatService")

local function initializeDefaultChannel(p)
	local service = default:getService()

	if not service then
		return nil
	end

	logger:info("Joining default channel")

	local joinByGroupIdToken = service:JoinByGroupIdToken("default", p)

	if joinByGroupIdToken then
		v:reportVoiceChatJoinResult(true, "defaultJoinSuccess")
		return joinByGroupIdToken
	end

	v:reportVoiceChatJoinResult(false, "defaultJoinFailed", "error")

	return joinByGroupIdToken
end

if engineFeature2 and defineFastFlag2 then
	if not NotificationService.IsConnected then
		logger:debug("NotificationService is not yet connected")
		NotificationService:GetPropertyChangedSignal("IsConnected"):Wait()
	end

	logger:debug("NotificationService connected")
end

if not VoiceChatService.UseNewAudioApi then
	if Players.LocalPlayer.Character then
		logger:debug("Player character already loaded")
	else
		Players.LocalPlayer.CharacterAdded:Wait()
		logger:debug("Player character loaded")
	end
end

if engineFeature and defineFastFlag3 then
	local service = game:FindService("VoiceChatService")

	if service then
		if not (service.EnableDefaultVoice or service.UseNewAudioApi) then
			logger:debug("Default channel is disabled.")
			v:reportVoiceChatJoinResult(false, "defaultDisabled")
			return
		end
	else
		logger:info("VoiceChatService not found. Assuming default values.")
	end
end

default2:getCallState():andThen(function(p)
	local v2

	if p.status == Enums.CallStatus.Idle.rawValue() or p.status == Enums.CallStatus.Ringing.rawValue() then
		v2 = defineFastFlag
	else
		v2 = p.muted
	end

	default:asyncInit():andThen(function()
		if initializeDefaultChannel(v2) == false then
			default:InitialJoinFailedPrompt()
		end
	end):catch(function()
		logger:info("VoiceChatServiceManager did not initialize")
	end)
end)

if GetFFlagSeamlessVoiceFTUX() then
	task.spawn(function()
		default:VoiceChatFirstTimeUX(game:GetService("AppStorageService"))
	end)
end
