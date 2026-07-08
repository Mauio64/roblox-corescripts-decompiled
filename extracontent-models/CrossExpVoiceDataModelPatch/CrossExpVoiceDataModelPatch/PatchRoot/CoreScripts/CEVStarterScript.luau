print("[CEV] Loading CEVStarterScript")

local CorePackages = game:GetService("CorePackages")
local CrossExperience = require(CorePackages.Workspace.Packages.CrossExperience)
local getMemStorageKey = CrossExperience.Utils.getMemStorageKey
local logEvent = CrossExperience.Analytics.CrossExperienceAnalytics.logEvent
local FStringTimeoutLoadingLocalPlayerInBackgroundDM = require(CorePackages.Workspace.Packages.SharedFlags).FStringTimeoutLoadingLocalPlayerInBackgroundDM
local LOCAL_PLAYER_LOADING_TIMEOUT_ENUM = CrossExperience.Constants.LOCAL_PLAYER_LOADING_TIMEOUT_ENUM

logEvent("partyVoiceCEVStarterScriptLoaded", {
	cevJoinAttemptId = getMemStorageKey("cevJoinAttemptId"),
	clientTimeStamp = os.time()
})

local ScriptContext = game:GetService("ScriptContext")
local Players = game:GetService("Players")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")

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
	local LocalPlayer = Players.LocalPlayer

	while not LocalPlayer do
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		LocalPlayer = Players.LocalPlayer
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
