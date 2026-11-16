print("[CEV] Loading CEVStarterScript")
local CorePackages = game:GetService("CorePackages")
local CrossExperience = require(CorePackages.Workspace.Packages.CrossExperience)
local getMemStorageKey = CrossExperience.Utils.getMemStorageKey
local logEvent = CrossExperience.Analytics.CrossExperienceAnalytics.logEvent

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FStringTimeoutLoadingLocalPlayerInBackgroundDM = SharedFlags.FStringTimeoutLoadingLocalPlayerInBackgroundDM

local LOCAL_PLAYER_LOADING_TIMEOUT_ENUM = CrossExperience.Constants.LOCAL_PLAYER_LOADING_TIMEOUT_ENUM

logEvent("partyVoiceCEVStarterScriptLoaded", {
	cevJoinAttemptId = getMemStorageKey("cevJoinAttemptId"),
	clientTimeStamp = os.time()
})

local ScriptContext = game:GetService("ScriptContext")
local Players = game:GetService("Players")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

logEvent("cevStarterScriptRobloxGuiLoaded", {
	cevJoinAttemptId = getMemStorageKey("cevJoinAttemptId"),
	clientTimeStamp = os.time()
})

ScriptContext:AddCoreScriptLocal("CoreScripts/CrossExperienceVoiceErrorReporter", RobloxGui)

logEvent("cevStarterScriptErrorReporterLoaded", {
	cevJoinAttemptId = getMemStorageKey("cevJoinAttemptId"),
	clientTimeStamp = os.time()
})

if FStringTimeoutLoadingLocalPlayerInBackgroundDM == LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable then
	local localPlayer = Players.LocalPlayer

	while not localPlayer do
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		localPlayer = Players.LocalPlayer
	end
end

if FStringTimeoutLoadingLocalPlayerInBackgroundDM == LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable then
	logEvent("cevStarterScriptLocalPlayerLoaded", {
		cevJoinAttemptId = getMemStorageKey("cevJoinAttemptId"),
		clientTimeStamp = os.time()
	})
end

if game:GetEngineFeature("VoiceChatSupported") then
	ScriptContext:AddCoreScriptLocal("CoreScripts/CrossExperienceVoiceDefaultChannel", RobloxGui)
end

logEvent("cevStarterScriptCEVDefaultChannelLoaded", {
	cevJoinAttemptId = getMemStorageKey("cevJoinAttemptId"),
	clientTimeStamp = os.time()
})

print("[CEV] CEVStarterScript Loaded")
