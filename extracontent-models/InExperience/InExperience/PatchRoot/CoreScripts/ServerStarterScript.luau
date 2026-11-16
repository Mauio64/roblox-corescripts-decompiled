local RunService = game:GetService("RunService")

while not RunService:IsRunning() do
	wait()
end

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local ScriptContext = game:GetService("ScriptContext")
local CoreGui = game:GetService("CoreGui")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagDisplayServerChannel = SharedFlags.GetFFlagDisplayServerChannel
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local getFFlagExpChatAlwaysRunTCS = SharedFlags2.getFFlagExpChatAlwaysRunTCS

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnableReferredPlayerJoinRemoteEvent = SharedFlags3.GetFFlagEnableReferredPlayerJoinRemoteEvent
local defineFastFlag = game:DefineFastFlag("DebugLogExpchatMigration", false)

local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAXEnableInspectAndBuyBulkPurchase = SharedFlags4.FFlagAXEnableInspectAndBuyBulkPurchase

local SharedFlags5 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagPlatformLeaderboardRccEnabled = SharedFlags5.FFlagPlatformLeaderboardRccEnabled

local SharedFlags6 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags6.FFlagLuaAppsEnablePromptVIPServerPurchase
local defineFastFlag2 = game:DefineFastFlag("DebugServerPlatformLeaderboardDevMock", false)
local defineFastFlag3 = game:DefineFastFlag("EmoteSkinningDisableEnabled", false)

local RobloxGui = CoreGui:WaitForChild("RobloxGui", 1e999)
assert(RobloxGui ~= nil, "RobloxGui should exist")

local ServerUtil = require(RobloxGui.Modules.Server.ServerUtil)

if ServerUtil.getFFlagServerCoreScriptSourceCode() then
	ServerUtil.initSourceCodeFolder()
end

local RemoteAllowList = require(RobloxGui.Modules.Server.RemoteAllowList)
RemoteAllowList()

ScriptContext:AddCoreScriptLocal("ServerCoreScripts/OpenCloud/OpenCloudV2", script.Parent)

if game:DefineFastFlag("OpenCloudClientLibraryCoreScriptEnabled", false) then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/OpenCloud/OpenCloudClientLibraryCoreScript", script.Parent)
end

ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ServerInGameMenu", script.Parent)
ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ServerSocialScript", script.Parent)

if defineFastFlag3 then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/EmoteSkinningDisable", script.Parent)
end

if defineFastFlag2 and RunService:IsStudio() then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ServerPlatformLeaderboardDevMock", script.Parent)
elseif FFlagPlatformLeaderboardRccEnabled then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ServerPlatformLeaderboard", script.Parent)
end

ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ServerLeaderstats", script.Parent)

ScriptContext:AddCoreScriptLocal("ServerCoreScripts/PlayerRagdollRigCreator", script.Parent)

game:DefineFastFlag("DebugFreeCameraForAdmins", true)

if FFlagAXEnableInspectAndBuyBulkPurchase then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ServerBulkPurchaseEvent", script.Parent)
end

local SendChatAnalytics = require(RobloxGui.Modules.Server.SendChatAnalytics)

ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ServerDialog", script.Parent)

local getServerVersion = Instance.new("RemoteFunction")
getServerVersion.Name = "GetServerVersion"
getServerVersion.Parent = RobloxReplicatedStorage
local getServerChannel

if GetFFlagDisplayServerChannel() then
	getServerChannel = Instance.new("RemoteFunction")
	getServerChannel.Name = "GetServerChannel"
	getServerChannel.Parent = RobloxReplicatedStorage
end

local function getServerVersion2()
	local robloxVersion = RunService:GetRobloxVersion()

	local v = robloxVersion == "?" and "DEBUG_SERVER" or RunService:IsStudio() and "ROBLOX Studio" or robloxVersion

	if RunService:IsStudio() then
		return v
	end

	local clientGitHash = RunService.ClientGitHash
	return string.format("%s (%.6s)", v, clientGitHash)
end

local function getServerChannel2()
	return RunService:GetRobloxClientChannel()
end

getServerVersion.OnServerInvoke = getServerVersion2

if GetFFlagDisplayServerChannel() then
	getServerChannel.OnServerInvoke = getServerChannel2
end

local function shouldLoadLuaChat() -- 1 equivalent call inferred from this helper
	local Chat = game:GetService("Chat")
	local loadDefaultChat = Chat.LoadDefaultChat

	if loadDefaultChat then
		local TextChatService = game:GetService("TextChatService")
		return TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService
	end

	return loadDefaultChat
end

if shouldLoadLuaChat() then -- inferred equivalent call
	local CoreGui2 = game:GetService("CoreGui")
	require(CoreGui2.RobloxGui.Modules.Server.ClientChat.ChatWindowInstaller)()
	local CoreGui3 = game:GetService("CoreGui")
	require(CoreGui3.RobloxGui.Modules.Server.ServerChat.ChatServiceInstaller)()
else
	SendChatAnalytics("NoLoadDefaultChat")
end

if game:GetFastFlag("DebugFreeCameraForAdmins") then
	local CoreGui2 = game:GetService("CoreGui")
	require(CoreGui2.RobloxGui.Modules.Server.FreeCamera.FreeCameraInstaller)()
end

local CoreGui2 = game:GetService("CoreGui")
require(CoreGui2.RobloxGui.Modules.Server.ServerSound.SoundDispatcherInstaller)()

local CoreGui3 = game:GetService("CoreGui")
require(CoreGui3.RobloxGui.Modules.Server.UGCValidation.UGCValidationFunctionInstaller)()

local TextChatService = game:GetService("TextChatService")
local ChatVersion = TextChatService.ChatVersion

if getFFlagExpChatAlwaysRunTCS() or ChatVersion == Enum.ChatVersion.TextChatService then
	local ExpChatServer = require(CorePackages.Workspace.Packages.ExpChatServer)
	ExpChatServer.mountServerApp({})
elseif ChatVersion == Enum.ChatVersion.LegacyChatService then
	local Chat = game:GetService("Chat")
	Chat:GetPropertyChangedSignal("IsAutoMigrated"):Connect(function()
		if Chat.IsAutoMigrated then
			if defineFastFlag then
				print("Migrating to ExpChat")
			end

			local ExpChatServer = require(CorePackages.Workspace.Packages.ExpChatServer)
			ExpChatServer.mountServerApp({})
		end
	end)
end

if RunService:IsStudio() == false then
	RbxAnalyticsService:ReportCounter(
		ChatVersion == Enum.ChatVersion.TextChatService and "textChatServiceChatVersionTextChatService" or "textChatServiceChatVersionLegacy",
		1
	)
end

if game:DefineFastFlag("VersionedFlags_Dev", false) then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/VersionedFlagTest", script.Parent)
end

ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ServerBuildExperiencePlaytestTeleport", script.Parent)

if FFlagLuaAppsEnablePromptVIPServerPurchase then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ServerVIPServerTeleport", script.Parent)
end

local FStringRoCaptchaUniverseIds = require(RobloxGui.Modules.Common.Flags.FStringRoCaptchaUniverseIds)

if game:DefineFastFlag("RoCaptchaServerHandlerEnabled", false) and FStringRoCaptchaUniverseIds ~= "" then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ServerRoCaptchaHandler", script.Parent)
end

ScriptContext:AddCoreScriptLocal("ServerCoreScripts/PlayerViewCapability", script.Parent)

local GetFFlagEnableVoiceDefaultServerScript = require(RobloxGui.Modules.Common.Flags.GetFFlagEnableVoiceDefaultServerScript)

if GetFFlagEnableVoiceDefaultServerScript() then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/VoiceDefault", script.Parent)
end

if GetFFlagEnableReferredPlayerJoinRemoteEvent() then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ReferredByPlayerRemoteEvent", script.Parent)
end

local CoreGui4 = game:GetService("CoreGui")
require(CoreGui4.RobloxGui.Modules.Server.VR.VRAvatarGesturesServer).new()
