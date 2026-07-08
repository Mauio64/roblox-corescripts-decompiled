local RunService = game:GetService("RunService")

while not RunService:IsRunning() do
	wait()
end

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local ScriptContext = game:GetService("ScriptContext")
local CoreGui = game:GetService("CoreGui")
local GetFFlagDisplayServerChannel = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagDisplayServerChannel
local getFFlagExpChatAlwaysRunTCS = require(CorePackages.Workspace.Packages.SharedFlags).getFFlagExpChatAlwaysRunTCS
local GetFFlagEnableReferredPlayerJoinRemoteEvent = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableReferredPlayerJoinRemoteEvent
local v10 = game:DefineFastFlag("DebugLogExpchatMigration", false)
local FFlagAXEnableInspectAndBuyBulkPurchase = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXEnableInspectAndBuyBulkPurchase
local FFlagPlatformLeaderboardRccEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPlatformLeaderboardRccEnabled
local v13 = game:DefineFastFlag("EmoteSkinningDisableEnabled", false)
local RobloxGui = CoreGui:WaitForChild("RobloxGui", 1e999)

assert(RobloxGui ~= nil, "RobloxGui should exist")

local ServerUtil = require(RobloxGui.Modules.Server.ServerUtil)

if ServerUtil.getFFlagServerCoreScriptSourceCode() then
	ServerUtil.initSourceCodeFolder()
end

require(RobloxGui.Modules.Server.RemoteAllowList)()

if game:DefineFastFlag("OpenCloudCoreScriptLuaEnabled", false) then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/OpenCloud/OpenCloudV2", script.Parent)
end

if game:DefineFastFlag("OpenCloudClientLibraryCoreScriptEnabled", false) then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/OpenCloud/OpenCloudClientLibraryCoreScript", script.Parent)
end

ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ServerInGameMenu", script.Parent)
ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ServerSocialScript", script.Parent)

if v13 then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/EmoteSkinningDisable", script.Parent)
end

if FFlagPlatformLeaderboardRccEnabled then
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

local RemoteFunction = Instance.new("RemoteFunction")

RemoteFunction.Name = "GetServerVersion"
RemoteFunction.Parent = RobloxReplicatedStorage

local RemoteFunction2 = nil

if GetFFlagDisplayServerChannel() then
	RemoteFunction2 = Instance.new("RemoteFunction")
	RemoteFunction2.Name = "GetServerChannel"
	RemoteFunction2.Parent = RobloxReplicatedStorage
end

local function getServerVersion() -- line: 94
	-- upvalues: RunService (copy)
	local RobloxVersion = RunService:GetRobloxVersion()
	local v25 = if RobloxVersion ~= "?" then if not RunService:IsStudio() then RobloxVersion else "ROBLOX Studio" else "DEBUG_SERVER"

	if not RunService:IsStudio() then
		local ClientGitHash = RunService.ClientGitHash

		return string.format("%s (%.6s)", v25, ClientGitHash)
	end

	return v25
end
local function getServerChannel() -- line: 115
	-- upvalues: RunService (copy)
	return RunService:GetRobloxClientChannel()
end

RemoteFunction.OnServerInvoke = getServerVersion

if GetFFlagDisplayServerChannel() then
	RemoteFunction2.OnServerInvoke = getServerChannel
end

local function shouldLoadLuaChat() -- line: 123
	return game:GetService("Chat").LoadDefaultChat and (game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.LegacyChatService and not game:GetService("GuiService"):IsTenFootInterface())
end

if shouldLoadLuaChat() then
	require(game:GetService("CoreGui").RobloxGui.Modules.Server.ClientChat.ChatWindowInstaller)()
	require(game:GetService("CoreGui").RobloxGui.Modules.Server.ServerChat.ChatServiceInstaller)()
else
	SendChatAnalytics("NoLoadDefaultChat")
end

if game:GetFastFlag("DebugFreeCameraForAdmins") then
	require(game:GetService("CoreGui").RobloxGui.Modules.Server.FreeCamera.FreeCameraInstaller)()
end

require(game:GetService("CoreGui").RobloxGui.Modules.Server.ServerSound.SoundDispatcherInstaller)()
require(game:GetService("CoreGui").RobloxGui.Modules.Server.UGCValidation.UGCValidationFunctionInstaller)()

local ChatVersion = game:GetService("TextChatService").ChatVersion

if getFFlagExpChatAlwaysRunTCS() or ChatVersion == Enum.ChatVersion.TextChatService then
	require(CorePackages.Workspace.Packages.ExpChatServer).mountServerApp({})
elseif ChatVersion == Enum.ChatVersion.LegacyChatService then
	local Chat = game:GetService("Chat")

	Chat:GetPropertyChangedSignal("IsAutoMigrated"):Connect(function() -- line: 151
		-- upvalues: Chat (copy), v10 (copy), CorePackages (copy)
		if Chat.IsAutoMigrated then
			if v10 then
				print("Migrating to ExpChat")
			end

			require(CorePackages.Workspace.Packages.ExpChatServer).mountServerApp({})
		end
	end)
end

if RunService:IsStudio() == false then
	RbxAnalyticsService:ReportCounter(ChatVersion ~= Enum.ChatVersion.TextChatService and "textChatServiceChatVersionLegacy" or "textChatServiceChatVersionTextChatService", 1)
end

if game:DefineFastFlag("VersionedFlags_Dev", false) then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/VersionedFlagTest", script.Parent)
end

if require(RobloxGui.Modules.Common.Flags.GetFFlagContactListEnabled)() then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ServerContactList", script.Parent)
end

if game:DefineFastFlag("AppBuildReloadRemote", false) then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ServerBuildExperiencePlaytestTeleport", script.Parent)
end

ScriptContext:AddCoreScriptLocal("ServerCoreScripts/PlayerViewCapability", script.Parent)

if require(RobloxGui.Modules.Common.Flags.GetFFlagEnableVoiceDefaultServerScript)() then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/VoiceDefault", script.Parent)
end

if GetFFlagEnableReferredPlayerJoinRemoteEvent() then
	ScriptContext:AddCoreScriptLocal("ServerCoreScripts/ReferredByPlayerRemoteEvent", script.Parent)
end

require(game:GetService("CoreGui").RobloxGui.Modules.Server.VR.VRAvatarGesturesServer).new()
