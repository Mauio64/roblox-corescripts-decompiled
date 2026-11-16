local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local TeleportService = game:GetService("TeleportService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalizationService = game:GetService("LocalizationService")
local VRService = game:GetService("VRService")
local CorePackages = game:GetService("CorePackages")
local TelemetryService = game:GetService("TelemetryService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")

local defineFastFlag = game:DefineFastFlag("ConnectionRemoveLoadingTimeout", false)

CorePackages:WaitForChild("Workspace"):WaitForChild("Packages", defineFastFlag and 1e999 or nil)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create
local ErrorPrompt = require(RobloxGui.Modules.ErrorPrompt)
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local AppCommonLib2 = require(CorePackages.Workspace.Packages.AppCommonLib)
local Logging = AppCommonLib2.Logging
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Url = CoreScriptsCommon.Url
local Loggers = require(CorePackages.Workspace.Packages.Loggers)
local mutedError = Loggers.mutedError
local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol)
local linkingProtocol = LinkingProtocol.LinkingProtocol

local defineFastFlag2 = game:DefineFastFlag("DebugEnableErrorStringTesting", false)
local defineFastFlag3 = game:DefineFastFlag("ShouldMuteUnlocalizedError", false)

local defineFastFlag4 = game:DefineFastFlag("ShowScreentimeLockoutKickMessage", false)

local v = {
	eventName = "ConnectionEvent",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2025, 7, 31 },
	description = "Counter to track connection events.",
	links = "https://roblox.atlassian.net/browse/CSC-585"
}

local defineFastInt = game:DefineFastInt("PotentialClientTimeoutSeconds", 7200)

local defineFastInt2 = game:DefineFastInt("MaxKickMessageLength", 200)

local defineFastFlag5 = game:DefineFastFlag("RefactorReconnectUnblockTeleport", false)

local defineFastFlag6 = game:DefineFastFlag("ConnectionEnableAutoReconnect", false)

local defineFastInt3 = game:DefineFastInt("ConnectionAutoReconnectFirstDelayMs", 2000)
local defineFastInt4 = game:DefineFastInt("ConnectionAutoReconnectBaseDelayMs", 5000)
local defineFastInt5 = game:DefineFastInt("ConnectionAutoReconnectMaxDelayMs", 20000)
local defineFastInt6 = game:DefineFastInt("ConnectionAutoReconnectJitterMs", 2000)
local defineFastInt7 = game:DefineFastInt("ConnectionAutoReconnectMaxDurationSeconds", 300)

local defineFastFlag7 = game:DefineFastFlag("RbxTransportHandleUniqueErrors", false)
local engineFeature = game:GetEngineFeature("RbxTransportUniqueConnectionErrors")
local random

if defineFastFlag6 then
	random = Random.new()
else
	random = nil
end

local engineFeature2 = game:GetEngineFeature("CoreGuiOverflowDetection")

local FFlagCoreScriptShowTeleportPrompt = require(RobloxGui.Modules.Flags.FFlagCoreScriptShowTeleportPrompt)

local FFlagAllowDisconnectGuiForOkUnknown = require(RobloxGui.Modules.Flags.FFlagAllowDisconnectGuiForOkUnknown)

local defineFastFlag8 = game:DefineFastFlag("EnableExperienceGenericChallengeRenderingConnection2", false)

local GetFFlagDisplayChannelNameOnErrorPrompt = require(RobloxGui.Modules.Flags.GetFFlagDisplayChannelNameOnErrorPrompt)

local function safeGetFInt(p, p2) -- 1 equivalent call inferred from this helper
	local success, result = pcall(function()
		return (tonumber(settings():GetFVariable(p)))
	end)
	return success and result or p2
end

local function safeGetFString(p, p2) -- 1 equivalent call inferred from this helper
	local success, result = pcall(function()
		return settings():GetFVariable(p)
	end)
	return success and result or p2
end

local function computeAutoReconnectDelaySeconds(attempt) -- 1 equivalent call inferred from this helper
	local v2

	if attempt <= 1 then
		v2 = defineFastInt3
	elseif attempt == 2 then
		v2 = defineFastInt4
	else
		v2 = math.min(defineFastInt4 * 2 ^ (attempt - 2), defineFastInt5)
	end

	if defineFastInt6 > 0 then
		v2 += random:NextInteger(0, defineFastInt6)
	end

	return v2 / 1000
end

local v2 = safeGetFInt("DefaultTimeoutTimeMs", 10000) / 1000 -- inferred equivalent call

local fFlag = settings():GetFFlag("ReconnectDisabled")
local v3 = safeGetFString( -- inferred equivalent call
	"ReconnectDisabledReason",
	"We're sorry, Roblox is temporarily unavailable.  Please try again later."
)
local now = tick()

local defineFastFlag9 = game:DefineFastFlag("AddPlacelaunchDeviceBlock2", false)
local defineFastFlag10 = game:DefineFastFlag("AddContextualPlayabilityConnectionErrors", false)
local defineFastFlag11 = game:DefineFastFlag("AddVipOwnerNotPresentConnectionError", false)
local defineFastFlag12 = game:DefineFastFlag("VipOwnerNotPresentEnableReconnect", false)

local defineFastFlag13 = game:DefineFastFlag("RAKickLogic2", false)
local defineFastInt8 = game:DefineFastInt("RAMinEngineVersion", 725)

local v4 = false

if defineFastFlag13 then
	local robloxVersion = RunService:GetRobloxVersion()
	local v5 = tonumber(string.match(robloxVersion, "%.(%d+)%."))
	v4 = v5 and defineFastInt8 <= v5 and true or false
end

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagConnectionAmpParentalApprovalUpsell = SharedFlags.FFlagConnectionAmpParentalApprovalUpsell

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagConnectionParentalApprovalLeaveOnly = SharedFlags2.FFlagConnectionParentalApprovalLeaveOnly

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagConnectionUpsellAnalytics = SharedFlags3.FFlagConnectionUpsellAnalytics
local PioneerUtils = require(CorePackages.Workspace.Packages.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch

local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local fFlagErrorPromptUseLeaveGameHelper = SharedFlags4.FFlagErrorPromptUseLeaveGameHelper or isPioneerLaunch()
local leaveGame

if fFlagErrorPromptUseLeaveGameHelper then
	leaveGame = require(RobloxGui.Modules.Settings.leaveGame)
else
	leaveGame = nil
end

local SharedFlags5 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagConnectionRelaunchBuildPlaytest = SharedFlags5.FFlagConnectionRelaunchBuildPlaytest
local playtestReconnect

if FFlagConnectionRelaunchBuildPlaytest then
	playtestReconnect = require(CorePackages.Workspace.Packages.BuildExperiencePlaytestLaunch.playtestReconnect)
else
	playtestReconnect = nil
end

local defineFastFlag14 = game:DefineFastFlag("AddCollaborationCoreGatedConnectionError2", false)

local engineFeature3 = game:GetEngineFeature("PlacelaunchCollaborationCoreGatedConnectionError")

local ConnectionAmpUpsellOnLeave = require(RobloxGui.Modules.ConnectionAmpUpsellOnLeave)

local buildRobloxExperienceKickContent = require(CorePackages.Workspace.Packages.InterventionShared.buildRobloxExperienceKickContent)
local showFeatureRestrictionDirect = require(CorePackages.Workspace.Packages.UniversalFeatureRestrictions.showFeatureRestrictionDirect)

local function fetchUniverseIdFromPlaceId(placeId)
	local v5 = string.format("%suniverses/v1/places/%d/universe", Url.APIS_URL, placeId)
	local success, asyncFullUrl = pcall(HttpRbxApiService.GetAsyncFullUrl, HttpRbxApiService, v5)

	if not success or type(asyncFullUrl) ~= "string" then
		return nil
	end

	local success2, result = pcall(HttpService.JSONDecode, HttpService, asyncFullUrl)

	if not success2 or type(result) ~= "table" then
		return nil
	end

	local universeId = result.universeId

	if type(universeId) == "number" and not (universeId <= 0) then
		return universeId
	end

	return nil
end

local function translateString(p: string, p2)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v5 = Localization.new(robloxLocaleId)
	v5:SetLocale(robloxLocaleId)

	local success, result = pcall(function()
		return v5:Format(p, p2)
	end)

	if success then
		return result
	end

	Logging.warn("Failed to translate string with key: " .. p .. ", LocaleId: " .. robloxLocaleId)
	return ""
end

local default = nil
local v5 = -1
local v6 = RobloxGui.AbsoluteSize.X
local v7 = RobloxGui.AbsoluteSize.Y

local v8 = {
	NONE = 1,
	RECONNECT_PLACELAUNCH = 2,
	RECONNECT_DISCONNECT = 3,
	TELEPORT_FAILED = 4,
	IS_RECONNECTING = 5,
	RECONNECT_DISABLED_DISCONNECT = 6,
	RECONNECT_DISABLED_PLACELAUNCH = 7,
	RECONNECT_DISABLED = 8,
	OUT_OF_MEMORY_KEEPPLAYING_LEAVE = 9,
	RECONNECT_CONNECT_FAILURE = 10,
	RECONNECT_DISABLED_CONNECT_FAILURE = 11,
	RECONNECT_AGE_CHECK_REQUIRED = 12,
	RECONNECT_PARENT_APPROVAL_REQUIRED = 13,
	RECONNECT_COLLABORATION_CORE_GATED = 14
}

if defineFastFlag6 then
	v8.AUTO_RECONNECTING = 15
end

local v9 = v8.NONE

local v10 = Enum.ConnectionError.OK

local v11 = {
	[v8.RECONNECT_PLACELAUNCH] = "Join Error",
	[v8.RECONNECT_DISABLED_PLACELAUNCH] = "Join Error",
	[v8.RECONNECT_DISCONNECT] = "Disconnected",
	[v8.RECONNECT_DISABLED_DISCONNECT] = "Disconnected",
	[v8.TELEPORT_FAILED] = "Teleport Failed",
	[v8.RECONNECT_DISABLED] = "Error",
	[v8.OUT_OF_MEMORY_KEEPPLAYING_LEAVE] = "Low Memory Warning",
	[v8.RECONNECT_CONNECT_FAILURE] = "Connection Failed",
	[v8.RECONNECT_DISABLED_CONNECT_FAILURE] = "Connection Failed",
	[v8.RECONNECT_AGE_CHECK_REQUIRED] = "Join Error",
	[v8.RECONNECT_PARENT_APPROVAL_REQUIRED] = "Join Error"
}

if defineFastFlag14 then
	v11[v8.RECONNECT_COLLABORATION_CORE_GATED] = "Join Error"
end

if defineFastFlag6 then
	v11[v8.AUTO_RECONNECTING] = "Disconnected"
end

local v12 = {
	[v8.RECONNECT_PLACELAUNCH] = "InGame.ConnectionError.Title.JoinError",
	[v8.RECONNECT_DISABLED_PLACELAUNCH] = "InGame.ConnectionError.Title.JoinError",
	[v8.RECONNECT_DISCONNECT] = "InGame.ConnectionError.Title.Disconnected",
	[v8.RECONNECT_DISABLED_DISCONNECT] = "InGame.ConnectionError.Title.Disconnected",
	[v8.TELEPORT_FAILED] = "InGame.ConnectionError.Title.TeleportFailed",
	[v8.RECONNECT_DISABLED] = "InGame.CommonUI.Title.Error",
	[v8.OUT_OF_MEMORY_KEEPPLAYING_LEAVE] = "InGame.ConnectionError.Title.LowMemoryWarning",
	[v8.RECONNECT_CONNECT_FAILURE] = "InGame.ConnectionError.Title.ConnectionFailed",
	[v8.RECONNECT_DISABLED_CONNECT_FAILURE] = "InGame.ConnectionError.Title.ConnectionFailed",
	[v8.RECONNECT_AGE_CHECK_REQUIRED] = "InGame.ConnectionError.Title.JoinError",
	[v8.RECONNECT_PARENT_APPROVAL_REQUIRED] = "InGame.ConnectionError.Title.JoinError"
}

if defineFastFlag14 then
	v12[v8.RECONNECT_COLLABORATION_CORE_GATED] = "InGame.ConnectionError.Title.JoinError"
end

if defineFastFlag6 then
	v12[v8.AUTO_RECONNECTING] = "InGame.ConnectionError.Title.Disconnected"
end

local parent = Create("ScreenGui")({
	Parent = CoreGui,
	Name = "RobloxPromptGui",
	OnTopOfCoreBlur = true,
	DisplayOrder = 9,
	AutoLocalize = false
})

local v13 = Create("Frame")({
	Name = "promptOverlay",
	BackgroundColor3 = Color3.new(0, 0, 0),
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, 1, 36),
	Position = UDim2.new(0, 0, 0, -36),
	Active = false,
	Parent = parent
})

coroutine.wrap(function()
	local Constants = require(RobloxGui.Modules.TopBar.Constants)
	local v14 = Constants.ApplyDisplayScale(Constants.TopBarHeight)

	v13.Size = UDim2.new(1, 0, 1, v14)
	v13.Position = UDim2.new(0, 0, 0, -v14)
end)()

local function openCollaboratorsPageForUniverseId(p)
	TelemetryService:LogCounter(v, {
		customFields = { selectedItem = "ViewCollaboratorsOpenUrl" }
	}, 1)

	local v14 = string.format(
		"%sdashboard/creations/experiences/%s/safety/collaborators",
		Url.CREATE_URL,
		(tostring(p))
	)

	linkingProtocol.default:openURL(v14)
end

local function fn()
	TelemetryService:LogCounter(v, {
		customFields = { selectedItem = "ViewCollaboratorsInitiated" }
	}, 1)

	local gameId = game.GameId

	if gameId and gameId ~= 0 then
		openCollaboratorsPageForUniverseId(gameId)
		return
	end

	local placeId = game.PlaceId

	if placeId and placeId ~= 0 then
		coroutine.wrap(function()
			local v14 = fetchUniverseIdFromPlaceId(placeId)

			if v14 then
				openCollaboratorsPageForUniverseId(v14)
			else
				TelemetryService:LogCounter(v, {
					customFields = { selectedItem = "ViewCollaboratorsUniverseIdLookupFailed" }
				}, 1)
			end
		end)()
	else
		TelemetryService:LogCounter(v, {
			customFields = { selectedItem = "ViewCollaboratorsMissingPlaceId" }
		}, 1)
	end
end

local function fn2()
	tick()

	if v9 == v8.IS_RECONNECTING then
		TelemetryService:LogCounter(v, {
			customFields = { selectedItem = "UserClickWhileReconnecting" }
		}, 1)
		return
	end

	TelemetryService:LogCounter(v, {
		customFields = { selectedItem = "ReconnectInitiated" }
	}, 1)

	RbxAnalyticsService:ReportCounter("ReconnectPrompt-ReconnectActivated")
	v9 = v8.IS_RECONNECTING
	default:primaryShimmerPlay()
	local v14

	if FFlagConnectionRelaunchBuildPlaytest then
		v14 = playtestReconnect.getRelaunchPlaceId()
	end

	if v14 == nil then
		TelemetryService:LogCounter(v, {
			customFields = { selectedItem = "ReconnectSameServer" }
		}, 1)
		TeleportService:TeleportReconnect()

		if FFlagCoreScriptShowTeleportPrompt then
			if defineFastFlag5 then
				TeleportService:UnblockAsync()
			else
				GuiService:SetMenuIsOpen(false, "ErrorPrompt")
			end
		end
	else
		TelemetryService:LogCounter(v, {
			customFields = { selectedItem = "ReconnectBuildPlaytestRelaunch" }
		}, 1)
		playtestReconnect.relaunch(v14)
	end
end

local function fn3()
	if v9 == v8.IS_RECONNECTING then
		TelemetryService:LogCounter(v, {
			customFields = { selectedItem = "UserClickWhileReconnecting" }
		}, 1)
		return
	end

	local placeId = game.PlaceId

	if not placeId or placeId == 0 then
		TelemetryService:LogCounter(v, {
			customFields = { selectedItem = "PlacelaunchRetryMissingPlaceId" }
		}, 1)
		return
	end

	TelemetryService:LogCounter(v, {
		customFields = { selectedItem = "PlacelaunchRetryInitiated" }
	}, 1)
	v9 = v8.IS_RECONNECTING
	default:primaryShimmerPlay()

	GuiService:ClearError()
	TeleportService:Teleport(placeId)
end

local function onDismiss()
	TelemetryService:LogCounter(v, {
		customFields = { selectedItem = "LeaveInitiated" }
	}, 1)

	if fFlagErrorPromptUseLeaveGameHelper then
		leaveGame(false, {
			shouldNativeExit = isPioneerLaunch(),
			inhibitAppRating = true,
			telemetryContext = "ErrorPrompt"
		})
		return
	end

	GuiService.SelectedCoreObject = nil

	RunService.RenderStepped:wait()
	RunService.RenderStepped:wait()

	game:Shutdown()
end

local function fn4()
	GuiService:ClearError()
end

local v14 = {
	active = false,
	attempt = 0,
	pendingThread = nil,
	nextAttemptAt = 0,
	tickerThread = nil,
	errorCode = nil,
	baseMessage = nil,
	lastRenderedText = nil,
	lastRemaining = nil
}

local function pushErrorToPrompt(p, errorCode) -- 1 equivalent call inferred from this helper
	if not default then
		return
	end

	if GetFFlagDisplayChannelNameOnErrorPrompt() then
		default:onErrorChanged(p, errorCode, true)
	else
		default:onErrorChanged(p, errorCode)
	end
end

local function renderAutoReconnectPrompt()
	if not default or v9 ~= v8.AUTO_RECONNECTING and v9 ~= v8.IS_RECONNECTING then
		return
	end

	local lastRemaining = v9 == v8.IS_RECONNECTING and -1 or math.max(0, (math.ceil(v14.nextAttemptAt - tick())))

	if lastRemaining == v14.lastRemaining then
		return
	end

	v14.lastRemaining = lastRemaining

	local attempt = v14.attempt
	local lastRenderedText

	if lastRemaining <= 0 then
		lastRenderedText = translateString("InGame.ConnectionError.ReconnectingAttempt", {
			RBX_ATTEMPT = attempt
		})
	elseif lastRemaining == 1 then
		lastRenderedText = translateString("InGame.ConnectionError.ReconnectingAttemptInSecond", {
			RBX_ATTEMPT = attempt
		})
	else
		lastRenderedText = translateString("InGame.ConnectionError.ReconnectingAttemptInSeconds", {
			RBX_ATTEMPT = attempt,
			RBX_SECONDS = lastRemaining
		})
	end

	if v14.baseMessage and v14.baseMessage ~= "" then
		lastRenderedText = v14.baseMessage .. "\n" .. lastRenderedText
	end

	if lastRenderedText == v14.lastRenderedText then
		return
	end

	v14.lastRenderedText = lastRenderedText
	pushErrorToPrompt(lastRenderedText, v14.errorCode) -- inferred equivalent call
end

local function ensureAutoReconnectTicker()
	if v14.tickerThread then
		return
	end

	v14.tickerThread = task.spawn(function()
		while v14.active do
			task.wait(0.25)
			renderAutoReconnectPrompt()
		end

		v14.tickerThread = nil
	end)
end

local function cancelAutoReconnect() -- 3 equivalent calls inferred from this helper
	v14.active = false
	v14.attempt = 0
	v14.nextAttemptAt = 0
	v14.errorCode = nil
	v14.baseMessage = nil
	v14.lastRenderedText = nil
	v14.lastRemaining = nil

	if v14.pendingThread then
		task.cancel(v14.pendingThread)
		v14.pendingThread = nil
	end

	if v14.tickerThread then
		task.cancel(v14.tickerThread)
		v14.tickerThread = nil
	end
end

local function autoReconnectAttemptBucket(attempt) -- 1 equivalent call inferred from this helper
	if attempt <= 5 then
		return (tostring(attempt))
	end

	return if attempt <= 8 then "6-8" else "9+"
end

local function fireAutoReconnect()
	v14.pendingThread = nil

	if v9 == v8.IS_RECONNECTING then
		return
	end

	TelemetryService:LogCounter(v, {
		customFields = {
			selectedItem = "AutoReconnectAttempt",
			attemptBucket = autoReconnectAttemptBucket(v14.attempt) -- inferred equivalent call
		}
	}, 1)

	v9 = v8.IS_RECONNECTING
	renderAutoReconnectPrompt()

	if default then
		default:primaryShimmerPlay()
	end

	TeleportService:TeleportReconnect()

	if FFlagCoreScriptShowTeleportPrompt then
		if defineFastFlag5 then
			TeleportService:UnblockAsync()
		else
			GuiService:SetMenuIsOpen(false, "ErrorPrompt")
		end
	end
end

local function scheduleAutoReconnect()
	v14.active = true

	if v14.pendingThread then
		task.cancel(v14.pendingThread)
		v14.pendingThread = nil
	end

	v14.attempt += 1
	local autoReconnectDelaySeconds = computeAutoReconnectDelaySeconds(v14.attempt) -- inferred equivalent call
	v14.nextAttemptAt = tick() + autoReconnectDelaySeconds
	v14.lastRenderedText = nil
	v14.lastRemaining = nil
	TelemetryService:LogCounter(v, {
		customFields = { selectedItem = "AutoReconnectScheduled" }
	}, 1)

	if not v14.tickerThread then
		v14.tickerThread = task.spawn(function()
			while v14.active do
				task.wait(0.25)
				renderAutoReconnectPrompt()
			end

			v14.tickerThread = nil
		end)
	end

	v14.pendingThread = task.delay(autoReconnectDelaySeconds, fireAutoReconnect)
end

local function autoReconnectNowFunction()
	if v9 == v8.IS_RECONNECTING then
		TelemetryService:LogCounter(v, {
			customFields = { selectedItem = "UserClickWhileReconnecting" }
		}, 1)
		return
	end

	TelemetryService:LogCounter(v, {
		customFields = { selectedItem = "AutoReconnectManualNow" }
	}, 1)

	if v14.pendingThread then
		task.cancel(v14.pendingThread)
		v14.pendingThread = nil
	end

	fireAutoReconnect()
end

local function fn5()
	TelemetryService:LogCounter(v, {
		customFields = { selectedItem = "AutoReconnectLeave" }
	}, 1)
	cancelAutoReconnect() -- inferred equivalent call
	onDismiss()
end

local set = {
	[Enum.ConnectionError.IPRecentlyConnected] = true,
	[Enum.ConnectionError.ConnectionBanned] = true,
	[Enum.ConnectionError.InvalidPassword] = true,
	[Enum.ConnectionError.OurSystemRequiresSecurity] = true,
	[Enum.ConnectionError.IncompatibleProtocolVersion] = true,
	[Enum.ConnectionError.DisconnectLuaKick] = true,
	[Enum.ConnectionError.DisconnectSecurityKeyMismatch] = true,
	[Enum.ConnectionError.DisconnectNewSecurityKeyMismatch] = true,
	[Enum.ConnectionError.DisconnectDuplicateTicket] = true,
	[Enum.ConnectionError.DisconnectWrongVersion] = true,
	[Enum.ConnectionError.DisconnectProtocolMismatch] = true,
	[Enum.ConnectionError.DisconnectBadhash] = true,
	[Enum.ConnectionError.DisconnectIllegalTeleport] = true,
	[Enum.ConnectionError.DisconnectDuplicatePlayer] = true,
	[Enum.ConnectionError.DisconnectCloudEditKick] = true,
	[Enum.ConnectionError.DisconnectOnRemoteSysStats] = true,
	[Enum.ConnectionError.DisconnectBySecurityPolicy] = true,
	[Enum.ConnectionError.DisconnectBlockedIP] = true,
	[Enum.ConnectionError.DisconnectPrivateServerKickout] = true,
	[Enum.ConnectionError.DisconnectCollaboratorPermissionRevoked] = true,
	[Enum.ConnectionError.DisconnectCollaboratorUnderage] = true,
	[Enum.ConnectionError.PlacelaunchFlooded] = true,
	[Enum.ConnectionError.PlacelaunchHashException] = true,
	[Enum.ConnectionError.PlacelaunchHashExpired] = true,
	[Enum.ConnectionError.PlacelaunchUnauthorized] = true,
	[Enum.ConnectionError.PlacelaunchUserLeft] = true,
	[Enum.ConnectionError.PlacelaunchRestricted] = true,
	[Enum.ConnectionError.PlacelaunchUserPrivacyUnauthorized] = true,
	[Enum.ConnectionError.PlacelaunchCreatorBan] = true,
	[Enum.ConnectionError.AndroidAnticheatKick] = true,
	[Enum.ConnectionError.AndroidEmulatorKick] = true,
	[Enum.ConnectionError.AndroidRootedKick] = true
}

if engineFeature2 then
	set[Enum.ConnectionError.DisconnectClientFailure] = true
end

if defineFastFlag4 then
	set[Enum.ConnectionError.ScreentimeLockoutKick] = true
end

if defineFastFlag9 then
	set[Enum.ConnectionError.PlacelaunchDeviceBlock] = true
end

if defineFastFlag10 then
	set[Enum.ConnectionError.PlacelaunchAgeVerificationRequired] = true
	set[Enum.ConnectionError.PlacelaunchParentalApprovalRequired] = true
	set[Enum.ConnectionError.PlacelaunchCoreGated] = true
end

if defineFastFlag11 and not defineFastFlag12 then
	set[Enum.ConnectionError.PlacelaunchVipOwnerNotPresent] = true
end

local placelaunchCollaborationCoreGated

if defineFastFlag14 and engineFeature3 then
	placelaunchCollaborationCoreGated = Enum.ConnectionError.PlacelaunchCollaborationCoreGated
else
	placelaunchCollaborationCoreGated = nil
end

if defineFastFlag14 and placelaunchCollaborationCoreGated then
	set[placelaunchCollaborationCoreGated] = true
end

if defineFastFlag13 and v4 then
	set[Enum.ConnectionError.DisconnectRemoteAttestationUnsupported] = true
	set[Enum.ConnectionError.DisconnectRemoteAttestationGeneralFailure] = true
	set[Enum.ConnectionError.DisconnectRemoteAttestationOSOutOfDate] = true
	set[Enum.ConnectionError.DisconnectRemoteAttestationBootValidationFailure] = true
end

local set2

if defineFastFlag6 then
	set2 = {}
	set2[Enum.ConnectionError.DisconnectConnectionLost] = true
	set2[Enum.ConnectionError.DisconnectTimeout] = true
	set2[Enum.ConnectionError.DisconnectRaknetErrors] = true
	set2[Enum.ConnectionError.DisconnectReceivePacketError] = true
	set2[Enum.ConnectionError.DisconnectReceivePacketStreamError] = true
	set2[Enum.ConnectionError.DisconnectSendPacketError] = true
	set2[Enum.ConnectionError.DisconnectHashTimeout] = true
	set2[Enum.ConnectionError.ReplicatorTimeout] = true
	set2[Enum.ConnectionError.NetworkTimeout] = true
	set2[Enum.ConnectionError.NetworkInternal] = true
	set2[Enum.ConnectionError.NetworkSend] = true

	if defineFastFlag7 and engineFeature then
		set2[Enum.ConnectionError.DisconnectTransportIoInternetError] = true
	end
else
	set2 = {}
end

local v15 = {
	[v8.RECONNECT_PLACELAUNCH] = {
		{
			Text = "Retry",
			LocalizationKey = "InGame.CommonUI.Button.Retry",
			LayoutOrder = 2,
			Callback = fn2,
			Primary = true
		},
		{
			Text = "Cancel",
			LocalizationKey = "Feature.SettingsHub.Action.CancelSearch",
			LayoutOrder = 1,
			Callback = onDismiss
		}
	},
	[v8.RECONNECT_DISCONNECT] = {
		{
			Text = "Reconnect",
			LocalizationKey = "InGame.ConnectionError.Button.Reconnect",
			LayoutOrder = 2,
			Callback = fn2,
			Primary = true
		},
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 1,
			Callback = onDismiss
		}
	},
	[v8.TELEPORT_FAILED] = {
		{
			Text = "OK",
			LocalizationKey = "InGame.CommonUI.Button.Ok",
			LayoutOrder = 1,
			Callback = fn4,
			Primary = true
		}
	},
	[v8.RECONNECT_DISABLED_DISCONNECT] = {
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 1,
			Callback = onDismiss,
			Primary = true
		}
	},
	[v8.RECONNECT_DISABLED_PLACELAUNCH] = {
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 1,
			Callback = onDismiss,
			Primary = true
		}
	},
	[v8.RECONNECT_DISABLED] = {
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 1,
			Callback = onDismiss,
			Primary = true
		}
	},
	[v8.OUT_OF_MEMORY_KEEPPLAYING_LEAVE] = {
		{
			Text = "Keep Playing",
			LocalizationKey = "InGame.CommonUI.Button.KeepPlaying",
			LayoutOrder = 1,
			Callback = fn4
		},
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 2,
			Callback = onDismiss,
			Primary = true
		}
	},
	[v8.RECONNECT_CONNECT_FAILURE] = {
		{
			Text = "Retry",
			LocalizationKey = "InGame.CommonUI.Button.Retry",
			LayoutOrder = 2,
			Callback = fn2,
			Primary = true
		},
		{
			Text = "Cancel",
			LocalizationKey = "Feature.SettingsHub.Action.CancelSearch",
			LayoutOrder = 1,
			Callback = onDismiss
		}
	},
	[v8.RECONNECT_DISABLED_CONNECT_FAILURE] = {
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 1,
			Callback = onDismiss,
			Primary = true
		}
	}
}

local ageCheckCallback = ConnectionAmpUpsellOnLeave.createAgeCheckCallback(v, fn3, 9)

v15[v8.RECONNECT_AGE_CHECK_REQUIRED] = {
	{
		Text = "Leave",
		LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
		LayoutOrder = 1,
		Callback = onDismiss
	},
	{
		Text = ConnectionAmpUpsellOnLeave.PrimaryButtonText,
		LocalizationKey = ConnectionAmpUpsellOnLeave.PrimaryButtonLocalizationKey,
		LayoutOrder = 2,
		Callback = ageCheckCallback,
		Primary = true
	}
}

if FFlagConnectionAmpParentalApprovalUpsell then
	local parentalApprovalCallback = ConnectionAmpUpsellOnLeave.createParentalApprovalCallback(v, fn3, 9)

	v15[v8.RECONNECT_PARENT_APPROVAL_REQUIRED] = {
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 1,
			Callback = onDismiss
		},
		{
			Text = ConnectionAmpUpsellOnLeave.PrimaryButtonText,
			LocalizationKey = ConnectionAmpUpsellOnLeave.PrimaryButtonLocalizationKey,
			LayoutOrder = 2,
			Callback = parentalApprovalCallback,
			Primary = true
		}
	}
end

if FFlagConnectionParentalApprovalLeaveOnly then
	v15[v8.RECONNECT_PARENT_APPROVAL_REQUIRED] = {
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 1,
			Callback = onDismiss,
			Primary = true
		}
	}
end

if defineFastFlag14 then
	v15[v8.RECONNECT_COLLABORATION_CORE_GATED] = {
		{
			Text = "Ok",
			LocalizationKey = "InGame.ConnectionError.Action.Ok",
			LayoutOrder = 1,
			Callback = onDismiss
		},
		{
			Text = "View collaborators",
			LocalizationKey = "InGame.ConnectionError.Action.ViewCollaborators",
			LayoutOrder = 2,
			Callback = fn,
			Primary = true
		}
	}
end

if defineFastFlag6 then
	v15[v8.AUTO_RECONNECTING] = {
		{
			Text = "Reconnect Now",
			LocalizationKey = "InGame.ConnectionError.Button.ReconnectNow",
			LayoutOrder = 2,
			Callback = autoReconnectNowFunction,
			Primary = true
		},
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 1,
			Callback = fn5
		}
	}
end

if isPioneerLaunch() then
	for _, list in pairs(v15) do
		for _, item in ipairs(list) do
			if not (item.Callback == onDismiss or item.Callback == fn5) then
				continue
			end

			item.Text = "Quit"
			item.LocalizationKey = "Feature.SettingsHub.Label.QuitButton"
		end
	end
end

local v16 = {
	[v8.NONE] = function()
		RunService:SetRobloxGuiFocused(false)
		v13.Active = false
		v13.Transparency = 1
	end,
	[v8.RECONNECT_DISCONNECT] = function()
		if VRService.VREnabled then
			RunService:SetRobloxGuiFocused(false)
		else
			RunService:SetRobloxGuiFocused(true)
		end

		v13.Active = true
		v13.Transparency = 1
	end,
	[v8.RECONNECT_PLACELAUNCH] = function()
		RunService:SetRobloxGuiFocused(false)
		v13.Active = true
		v13.Transparency = 0.3
	end,
	[v8.TELEPORT_FAILED] = function()
		RunService:SetRobloxGuiFocused(false)
		v13.Active = true
		v13.Transparency = 0.3
	end,
	[v8.RECONNECT_DISABLED_DISCONNECT] = function()
		if VRService.VREnabled then
			RunService:SetRobloxGuiFocused(false)
		else
			RunService:SetRobloxGuiFocused(true)
		end

		v13.Active = true
		v13.Transparency = 1
	end,
	[v8.RECONNECT_DISABLED_PLACELAUNCH] = function()
		RunService:SetRobloxGuiFocused(false)
		v13.Active = true
		v13.Transparency = 0.3
	end,
	[v8.RECONNECT_DISABLED] = function()
		if VRService.VREnabled then
			RunService:SetRobloxGuiFocused(false)
		else
			RunService:SetRobloxGuiFocused(true)
		end

		v13.Active = true
		v13.Transparency = 1
	end,
	[v8.RECONNECT_CONNECT_FAILURE] = function()
		RunService:SetRobloxGuiFocused(false)
		v13.Active = true
		v13.Transparency = 0.3
	end,
	[v8.RECONNECT_DISABLED_CONNECT_FAILURE] = function()
		RunService:SetRobloxGuiFocused(false)
		v13.Active = true
		v13.Transparency = 0.3
	end
}

local v17 = v16[v8.RECONNECT_PLACELAUNCH]
v16[v8.RECONNECT_AGE_CHECK_REQUIRED] = v17

if FFlagConnectionAmpParentalApprovalUpsell then
	v16[v8.RECONNECT_PARENT_APPROVAL_REQUIRED] = v17
end

if defineFastFlag14 then
	v16[v8.RECONNECT_COLLABORATION_CORE_GATED] = function()
		RunService:SetRobloxGuiFocused(false)
		v13.Active = true
		v13.Transparency = 0.3
	end
end

if defineFastFlag6 then
	v16[v8.AUTO_RECONNECTING] = v16[v8.RECONNECT_DISCONNECT]
end

local function onEnter(p)
	if not default then
		default = ErrorPrompt.new("Default", {
			MenuIsOpenKey = "ConnectionErrorPrompt",
			PlayAnimation = not defineFastFlag2
		})
		default:setParent(v13)
		default:resizeWidthAndHeight(v6, v7)
	end

	if v16[p] then
		v16[p]()
	end

	default:setErrorTitle(v11[p], v12[p])
	default:updateButtons(v15[p])
end

local function onExit(p)
	if p == v8.IS_RECONNECTING then
		default:primaryShimmerStop()
	end
end

local function stateTransit(p, errorCode, p2)
	if FFlagAllowDisconnectGuiForOkUnknown then
		if errorCode == Enum.ConnectionError.OK then
			return v8.NONE
		end
	elseif p == Enum.ConnectionError.OK then
		return v8.NONE
	end

	if p2 == v8.NONE then
		if fFlag then
			return v8.RECONNECT_DISABLED
		end

		now = tick()

		if FFlagAllowDisconnectGuiForOkUnknown then
			assert(errorCode ~= Enum.ConnectionError.OK)

			if p == Enum.ConnectionError.OK then
				return v8.RECONNECT_DISCONNECT
			end
		end

		if p == Enum.ConnectionError.ConnectErrors then
			v5 = tick() + v2
			v10 = Enum.ConnectionError.ConnectErrors

			if set[errorCode] then
				return v8.RECONNECT_DISABLED_CONNECT_FAILURE
			end

			TelemetryService:LogCounter(v, {
				customFields = { selectedItem = "ConnectError" }
			}, 1)
			TelemetryService:LogCounter(v, {
				customFields = { selectedItem = "ConnectFailed" }
			}, 1)
			return v8.RECONNECT_CONNECT_FAILURE
		elseif p == Enum.ConnectionError.DisconnectErrors then
			v5 = tick() + v2
			v10 = Enum.ConnectionError.DisconnectErrors

			if errorCode == Enum.ConnectionError.DisconnectOutOfMemoryKeepPlayingLeave then
				return v8.OUT_OF_MEMORY_KEEPPLAYING_LEAVE
			end

			if set[errorCode] then
				return v8.RECONNECT_DISABLED_DISCONNECT
			end

			TelemetryService:LogCounter(v, {
				customFields = { selectedItem = "Disconnected" }
			}, 1)
			RbxAnalyticsService:ReportCounter("ReconnectPrompt-Disconnect")

			if FFlagConnectionRelaunchBuildPlaytest and playtestReconnect.getRelaunchPlaceId() ~= nil then
				return v8.RECONNECT_DISCONNECT
			end

			if defineFastFlag6 and set2[errorCode] then
				return v8.AUTO_RECONNECTING
			end

			return v8.RECONNECT_DISCONNECT
		elseif p == Enum.ConnectionError.PlacelaunchErrors then
			v10 = Enum.ConnectionError.PlacelaunchErrors
			local ageVerificationRequiredEnum = ConnectionAmpUpsellOnLeave.AgeVerificationRequiredEnum

			if ageVerificationRequiredEnum and errorCode == ageVerificationRequiredEnum then
				TelemetryService:LogCounter(v, {
					customFields = { selectedItem = "PlaceLaunchAgeVerificationRequired" }
				}, 1)

				if FFlagConnectionUpsellAnalytics then
					ConnectionAmpUpsellOnLeave.fireImpressionAgeCheck(v, game.PlaceId)
				end

				return v8.RECONNECT_AGE_CHECK_REQUIRED
			end

			if FFlagConnectionAmpParentalApprovalUpsell then
				local parentalApprovalRequiredEnum = ConnectionAmpUpsellOnLeave.ParentalApprovalRequiredEnum

				if parentalApprovalRequiredEnum and errorCode == parentalApprovalRequiredEnum then
					TelemetryService:LogCounter(v, {
						customFields = { selectedItem = "PlaceLaunchParentalApprovalRequired" }
					}, 1)

					if FFlagConnectionUpsellAnalytics then
						ConnectionAmpUpsellOnLeave.fireImpressionParentalApproval(v, game.PlaceId)
					end

					return v8.RECONNECT_PARENT_APPROVAL_REQUIRED
				end
			end

			if
				defineFastFlag14
				and placelaunchCollaborationCoreGated
				and errorCode == placelaunchCollaborationCoreGated
			then
				TelemetryService:LogCounter(v, {
					customFields = { selectedItem = "PlaceLaunchCollaborationCoreGated" }
				}, 1)
				return v8.RECONNECT_COLLABORATION_CORE_GATED
			end

			if set[errorCode] then
				return v8.RECONNECT_DISABLED_PLACELAUNCH
			end

			TelemetryService:LogCounter(v, {
				customFields = { selectedItem = "PlaceLaunchError" }
			}, 1)
			RbxAnalyticsService:ReportCounter("ReconnectPrompt-PlaceLaunch")
			return v8.RECONNECT_PLACELAUNCH
		elseif p == Enum.ConnectionError.TeleportErrors then
			TelemetryService:LogCounter(v, {
				customFields = { selectedItem = "TeleportError" }
			}, 1)
			RbxAnalyticsService:ReportCounter("ReconnectPrompt-TeleportFailed")
			return v8.TELEPORT_FAILED
		end
	end

	if p2 == v8.IS_RECONNECTING then
		TelemetryService:LogCounter(v, {
			customFields = { selectedItem = "ReconnectFailed" }
		}, 1)
		RbxAnalyticsService:ReportCounter("ReconnectPrompt-ReconnectFailed")

		if p == Enum.ConnectionError.TeleportErrors then
			local now2 = tick()

			if now + defineFastInt < now2 then
				TelemetryService:LogCounter(v, {
					customFields = { selectedItem = "ReconnectTimedOut" }
				}, 1)

				if v10 == Enum.ConnectionError.PlacelaunchErrors then
					return v8.RECONNECT_DISABLED_PLACELAUNCH
				end

				return v8.RECONNECT_DISABLED_DISCONNECT
			end

			if v10 == Enum.ConnectionError.PlacelaunchErrors then
				TelemetryService:LogCounter(v, {
					customFields = { selectedItem = "PlaceLaunchReconnectFailed" }
				}, 1)
				return v8.RECONNECT_PLACELAUNCH
			end

			if v10 == Enum.ConnectionError.DisconnectErrors then
				TelemetryService:LogCounter(v, {
					customFields = { selectedItem = "DisconnectReconnectFailed" }
				}, 1)

				if defineFastFlag6 and v14.active then
					local v18 = defineFastInt7

					if v18 <= 0 or tick() <= now + v18 then
						return v8.AUTO_RECONNECTING
					end

					TelemetryService:LogCounter(v, {
						customFields = { selectedItem = "AutoReconnectExhausted" }
					}, 1)
				end

				return v8.RECONNECT_DISCONNECT
			elseif v10 == Enum.ConnectionError.ConnectErrors then
				TelemetryService:LogCounter(v, {
					customFields = { selectedItem = "ConnectReconnectFailed" }
				}, 1)
				return v8.RECONNECT_CONNECT_FAILURE
			end
		end
	end

	if not defineFastFlag6 or p2 ~= v8.AUTO_RECONNECTING then
		return p2
	end

	if fFlag then
		return v8.RECONNECT_DISABLED
	end

	if p == Enum.ConnectionError.DisconnectErrors and set[errorCode] then
		return v8.RECONNECT_DISABLED_DISCONNECT
	end

	return p2
end

local function getCreatorBanString(p: string)
	local errorDetails = GuiService:GetErrorDetails()

	if not errorDetails then
		return p
	end

	local v18

	if errorDetails.time then
		local minutes = errorDetails.minutes
		local hours = errorDetails.hours
		local days = errorDetails.days
		local v19

		if minutes == 1 then
			v19 = translateString("InGame.ConnectionError.CreatorBanMinutesSingular")
		else
			v19 = translateString("InGame.ConnectionError.CreatorBanMinutesPlural", {
				RBX_TIME_MINUTES = minutes
			})
		end

		local v20

		if hours == 1 then
			v20 = translateString("InGame.ConnectionError.CreatorBanHoursSingular")
		else
			v20 = translateString("InGame.ConnectionError.CreatorBanHoursPlural", {
				RBX_TIME_HOURS = hours
			})
		end

		local v21

		if days == 1 then
			v21 = translateString("InGame.ConnectionError.CreatorBanDaysSingular")
		else
			v21 = translateString("InGame.ConnectionError.CreatorBanDaysPlural", {
				RBX_TIME_DAYS = days
			})
		end

		if v19 == "" or v20 == "" or v21 == "" then
			return p
		end

		if hours > 0 then
			v19 = v20 .. ", " .. v19
		end

		if days > 0 then
			v19 = v21 .. ", " .. v19
		end

		v18 = translateString("InGame.ConnectionError.CreatorBanWithTime", {
			RBX_TIME_REMAINING = v19
		})
	else
		v18 = translateString("InGame.ConnectionError.CreatorBanNoTime")
	end

	if v18 == "" then
		return p
	end

	local displayReason = errorDetails.displayReason

	if not displayReason or displayReason == "" then
		return v18
	end

	local v19 = translateString("InGame.ConnectionError.CreatorBanMessage", {
		RBX_STR = displayReason
	})

	if v19 == "" then
		return p
	end

	return v18 .. " " .. v19
end

local defineFastFlag15 = game:DefineFastFlag("RemoveRefToMissingLocInConnection", false)

local v18 = {
	[Enum.ConnectionError.ConnectErrors] = "InGame.ConnectionError.ConnectErrors",
	[Enum.ConnectionError.AlreadyConnected] = "InGame.ConnectionError.ConnectionFailedWaitAndTry",
	[Enum.ConnectionError.NoFreeIncomingConnections] = "InGame.ConnectionError.ConnectionFailedWaitAndTry",
	[Enum.ConnectionError.IPRecentlyConnected] = "InGame.ConnectionError.ConnectErrors",
	[Enum.ConnectionError.ConnectionBanned] = "InGame.ConnectionError.ConnectionBanned",
	[Enum.ConnectionError.InvalidPassword] = "InGame.ConnectionError.ConnectionFailedRobloxVersion",
	[Enum.ConnectionError.OurSystemRequiresSecurity] = "InGame.ConnectionError.ConnectionFailedRobloxVersion",
	[Enum.ConnectionError.IncompatibleProtocolVersion] = "InGame.ConnectionError.ConnectionFailedRobloxVersion",
	[Enum.ConnectionError.DisconnectErrors] = "InGame.ConnectionError.DisconnectErrors",
	[Enum.ConnectionError.DisconnectBadhash] = "InGame.ConnectionError.DisconnectBadhash",
	[Enum.ConnectionError.DisconnectSecurityKeyMismatch] = "InGame.ConnectionError.DisconnectSecurityKeyMismatch",
	[Enum.ConnectionError.DisconnectProtocolMismatch] = "InGame.ConnectionError.DisconnectProtocolMismatch",
	[Enum.ConnectionError.DisconnectReceivePacketError] = "InGame.ConnectionError.DisconnectReceivePacketError",
	[Enum.ConnectionError.DisconnectReceivePacketStreamError] = "InGame.ConnectionError.DisconnectReceivePacketStreamError",
	[Enum.ConnectionError.DisconnectSendPacketError] = "InGame.ConnectionError.DisconnectSendPacketError",
	[Enum.ConnectionError.DisconnectIllegalTeleport] = "InGame.ConnectionError.DisconnectIllegalTeleport",
	[Enum.ConnectionError.DisconnectDuplicatePlayer] = "InGame.ConnectionError.DisconnectDuplicatePlayer",
	[Enum.ConnectionError.DisconnectDuplicateTicket] = "InGame.ConnectionError.DisconnectDuplicateTicket",
	[Enum.ConnectionError.DisconnectTimeout] = "InGame.ConnectionError.DisconnectTimeout",
	[Enum.ConnectionError.DisconnectLuaKick] = "InGame.ConnectionError.DisconnectLuaKick",
	[Enum.ConnectionError.DisconnectOnRemoteSysStats] = "InGame.ConnectionError.DisconnectOnRemoteSysStats",
	[Enum.ConnectionError.DisconnectHashTimeout] = "InGame.ConnectionError.DisconnectHashTimeout",
	[Enum.ConnectionError.DisconnectCloudEditKick] = "InGame.ConnectionError.DisconnectCloudEditKick",
	[Enum.ConnectionError.DisconnectPlayerless] = "InGame.ConnectionError.DisconnectPlayerless",
	[Enum.ConnectionError.DisconnectNewSecurityKeyMismatch] = "InGame.ConnectionError.DisconnectNewSecurityKeyMismatch",
	[Enum.ConnectionError.DisconnectEvicted] = "InGame.ConnectionError.DisconnectEvicted",
	[Enum.ConnectionError.DisconnectDevMaintenance] = "InGame.ConnectionError.DisconnectDevMaintenance",
	[Enum.ConnectionError.DisconnectRobloxMaintenance] = "InGame.ConnectionError.DisconnectRobloxMaintenance",
	[Enum.ConnectionError.DisconnectRejoin] = "InGame.ConnectionError.DisconnectRejoin",
	[Enum.ConnectionError.DisconnectConnectionLost] = "InGame.ConnectionError.DisconnectConnectionLost",
	[Enum.ConnectionError.DisconnectIdle] = "InGame.ConnectionError.DisconnectIdle",
	[Enum.ConnectionError.DisconnectRaknetErrors] = "InGame.ConnectionError.DisconnectRaknetErrors",
	[Enum.ConnectionError.DisconnectWrongVersion] = "InGame.ConnectionError.DisconnectWrongVersion",
	[Enum.ConnectionError.DisconnectBySecurityPolicy] = "InGame.ConnectionError.DisconnectBlockedConnection",
	[Enum.ConnectionError.DisconnectBlockedIP] = "InGame.ConnectionError.DisconnectBlockedConnection",
	[Enum.ConnectionError.DisconnectClientFailure] = "InGame.ConnectionError.DisconnectClientFailure",
	[Enum.ConnectionError.DisconnectClientRequest] = "InGame.ConnectionError.DisconnectClientRequest",
	[Enum.ConnectionError.DisconnectPrivateServerKickout] = "InGame.ConnectionError.DisconnectPrivateServerKickout",
	[Enum.ConnectionError.DisconnectModeratedGame] = "InGame.ConnectionError.ServerShutdown",
	[Enum.ConnectionError.ServerShutdown] = "InGame.ConnectionError.ServerShutdown",
	[Enum.ConnectionError.ReplicatorTimeout] = "InGame.ConnectionError.DisconnectTryAgain",
	[Enum.ConnectionError.PlayerRemoved] = "InGame.ConnectionError.DisconnectTryAgain",
	[Enum.ConnectionError.DisconnectOutOfMemoryKeepPlayingLeave] = "InGame.ConnectionError.DisconnectOutOfMemoryKeepPlayingLeave",
	[Enum.ConnectionError.DisconnectRomarkEndOfTest] = "InGame.ConnectionError.DisconnectTryAgain",
	[Enum.ConnectionError.DisconnectCollaboratorPermissionRevoked] = "InGame.ConnectionError.DisconnectCollaboratorPermissionRevoked",
	[Enum.ConnectionError.DisconnectCollaboratorUnderage] = "InGame.ConnectionError.DisconnectCollaboratorUnderage",
	[Enum.ConnectionError.NetworkInternal] = "InGame.ConnectionError.DisconnectTryAgain",
	[Enum.ConnectionError.NetworkSend] = "InGame.ConnectionError.DisconnectTryAgain",
	[Enum.ConnectionError.NetworkTimeout] = "InGame.ConnectionError.DisconnectTryAgain",
	[Enum.ConnectionError.NetworkMisbehavior] = "InGame.ConnectionError.DisconnectTryAgain",
	[Enum.ConnectionError.NetworkSecurity] = "InGame.ConnectionError.DisconnectTryAgain",
	[Enum.ConnectionError.ReplacementReady] = "InGame.ConnectionError.DisconnectTryAgain",
	[Enum.ConnectionError.ServerEmpty] = "InGame.ConnectionError.DisconnectTryAgain",
	[Enum.ConnectionError.PhantomFreeze] = "InGame.ConnectionError.DisconnectTryAgain",
	[Enum.ConnectionError.AndroidAnticheatKick] = "InGame.ConnectionError.AndroidAnticheatKick",
	[Enum.ConnectionError.AndroidEmulatorKick] = "InGame.ConnectionError.AndroidEmulatorKick",
	[Enum.ConnectionError.PlacelaunchErrors] = "InGame.ConnectionError.PlacelaunchErrors",
	[Enum.ConnectionError.PlacelaunchDisabled] = "InGame.ConnectionError.PlacelaunchDisabled",
	[Enum.ConnectionError.PlacelaunchError] = "InGame.ConnectionError.PlacelaunchError",
	[Enum.ConnectionError.PlacelaunchGameEnded] = "InGame.ConnectionError.PlacelaunchGameEnded",
	[Enum.ConnectionError.PlacelaunchGameFull] = "InGame.ConnectionError.PlacelaunchGameFull",
	[Enum.ConnectionError.PlacelaunchUserLeft] = "InGame.ConnectionError.PlacelaunchUserLeft",
	[Enum.ConnectionError.PlacelaunchRestricted] = "InGame.ConnectionError.PlacelaunchRestricted",
	[Enum.ConnectionError.PlacelaunchUnauthorized] = "InGame.ConnectionError.PlacelaunchUnauthorized",
	[Enum.ConnectionError.PlacelaunchFlooded] = "InGame.ConnectionError.PlacelaunchFlooded",
	[Enum.ConnectionError.PlacelaunchHashExpired] = "InGame.ConnectionError.PlacelaunchHashExpired",
	[Enum.ConnectionError.PlacelaunchHashException] = "InGame.ConnectionError.PlacelaunchHashException",
	[Enum.ConnectionError.PlacelaunchPartyCannotFit] = "InGame.ConnectionError.PlacelaunchPartyCannotFit",
	[Enum.ConnectionError.PlacelaunchHttpError] = "InGame.ConnectionError.PlacelaunchHttpError",
	[Enum.ConnectionError.PlacelaunchUserPrivacyUnauthorized] = "InGame.ConnectionError.PlacelaunchUserPrivacyUnauthorized",
	[Enum.ConnectionError.PlacelaunchCreatorBan] = "InGame.ConnectionError.CreatorBanNoTime",
	[Enum.ConnectionError.PlacelaunchCustomMessage] = not defineFastFlag15 and "InGame.ConnectionError.PlacelaunchCustomMessage" or nil,
	[Enum.ConnectionError.PlacelaunchOtherError] = "InGame.ConnectionError.PlacelaunchOtherError",
	[Enum.ConnectionError.TeleportErrors] = "InGame.ConnectionError.TeleportErrors",
	[Enum.ConnectionError.TeleportFailure] = "InGame.ConnectionError.TeleportFailure",
	[Enum.ConnectionError.TeleportGameNotFound] = "InGame.ConnectionError.TeleportGameNotFound",
	[Enum.ConnectionError.TeleportGameEnded] = "InGame.ConnectionError.TeleportGameEnded",
	[Enum.ConnectionError.TeleportGameFull] = "InGame.ConnectionError.TeleportGameFull",
	[Enum.ConnectionError.TeleportUnauthorized] = "InGame.ConnectionError.TeleportUnauthorized",
	[Enum.ConnectionError.TeleportFlooded] = "InGame.ConnectionError.TeleportFlooded",
	[Enum.ConnectionError.TeleportIsTeleporting] = not defineFastFlag15 and "InGame.ConnectionError.TeleportIsTeleporting" or nil,
	[Enum.ConnectionError.DisconnectVerboselyModeratedGame] = "InGame.ConnectionError.DisconnectVerboselyModeratedGame"
}

if defineFastFlag4 then
	v18[Enum.ConnectionError.ScreentimeLockoutKick] = "Feature.Screentime.Content.ScreentimeLimitDialog"
end

if defineFastFlag9 then
	v18[Enum.ConnectionError.PlacelaunchDeviceBlock] = "InGame.ConnectionError.PlacelaunchDeviceBlock"
end

if defineFastFlag10 then
	v18[Enum.ConnectionError.PlacelaunchAgeVerificationRequired] = "InGame.ConnectionError.Description.AgeCheckRequired"
	v18[Enum.ConnectionError.PlacelaunchParentalApprovalRequired] = "InGame.ConnectionError.Description.ParentalApprovalRequired"
	v18[Enum.ConnectionError.PlacelaunchCoreGated] = "InGame.ConnectionError.Description.LockedByAge"
end

if defineFastFlag11 then
	v18[Enum.ConnectionError.PlacelaunchVipOwnerNotPresent] = "InGame.ConnectionError.Description.VipOwnerNotPresent"
end

if defineFastFlag14 and placelaunchCollaborationCoreGated then
	v18[placelaunchCollaborationCoreGated] = "InGame.ConnectionError.Description.CollaborationRequiresTrustedFriends"
end

if defineFastFlag13 and v4 then
	v18[Enum.ConnectionError.DisconnectRemoteAttestationTimeout] = "InGame.ConnectionError.RemoteAttestationTimeout"
	v18[Enum.ConnectionError.DisconnectRemoteAttestationUnsupported] = "InGame.ConnectionError.RemoteAttestationUnsupported"
	v18[Enum.ConnectionError.DisconnectRemoteAttestationGeneralFailure] = "InGame.ConnectionError.RemoteAttestationGeneralFailure"
	v18[Enum.ConnectionError.DisconnectRemoteAttestationOSOutOfDate] = "InGame.ConnectionError.RemoteAttestationOSOutOfDate"
	v18[Enum.ConnectionError.DisconnectRemoteAttestationBootValidationFailure] = "InGame.ConnectionError.RemoteAttestationBootValidationFailure"
end

if defineFastFlag7 and engineFeature then
	v18[Enum.ConnectionError.DisconnectTransportIoError] = "InGame.ConnectionError.DisconnectTryAgain"
	v18[Enum.ConnectionError.DisconnectTransportIoInternetError] = "InGame.ConnectionError.DisconnectConnectionLost"
	v18[Enum.ConnectionError.DisconnectTransportProtocolError] = "InGame.ConnectionError.DisconnectTryAgain"
	v18[Enum.ConnectionError.DisconnectTransportNgtcp2Error] = "InGame.ConnectionError.DisconnectTryAgain"
	v18[Enum.ConnectionError.DisconnectTransportQuicError] = "InGame.ConnectionError.DisconnectTryAgain"
	v18[Enum.ConnectionError.DisconnectTransportRnaError] = "InGame.ConnectionError.DisconnectTryAgain"
end

local function getErrorString(value: string, errorCode, p)
	if errorCode == Enum.ConnectionError.OK then
		return ""
	end

	if p then
		local v19 = translateString("InGame.ConnectionError.ReconnectFailed")

		if v19 == "" then
			return "Reconnect was unsuccessful. Please try again."
		end

		return v19
	elseif errorCode == Enum.ConnectionError.DisconnectLuaKick and value ~= "" then
		local v19 = value:sub(1, defineFastInt2)

		local v20 = translateString("InGame.ConnectionError.DisconnectLuaKickWithMessage", {
			RBX_STR = v19
		})
		return if v20 == "" then v19 else v20
	else
		local v19 = v18[errorCode]

		if not v19 then
			mutedError("Cannot find localization key for " .. tostring(errorCode))
			v19 = "InGame.ConnectionError.UnknownError"
		end

		local selected

		if errorCode == Enum.ConnectionError.DisconnectIdle then
			selected = translateString(v19, { RBX_NUM = tostring(20) })
		else
			selected = translateString(v19)
		end

		if selected ~= "" then
			return selected
		end

		if defineFastFlag3 then
			return translateString("InGame.ConnectionError.UnknownError")
		end

		return value
	end
end

local function updateErrorPrompt(p, errorCode, p2)
	if errorCode == Enum.ConnectionError.DisconnectLuaKick then
		local errorDetails = GuiService:GetErrorDetails()

		if errorDetails and errorDetails.moderatorType == "roblox" then
			local robloxExperienceKickContent = buildRobloxExperienceKickContent(p, errorDetails, translateString)
			showFeatureRestrictionDirect(
				robloxExperienceKickContent.abuseVector,
				robloxExperienceKickContent.moderationDetail,
				{
					onDismiss = onDismiss,
					titleOverride = robloxExperienceKickContent.options.titleOverride,
					bodyOverride = robloxExperienceKickContent.options.bodyOverride
				}
			)

			TelemetryService:LogCounter(v, {
				customFields = { selectedItem = "RobloxExperienceKick" }
			}, 1)

			return
		end
	end

	local v19 = stateTransit(p2, errorCode, v9)

	if v19 ~= v9 then
		if v9 == v8.IS_RECONNECTING then
			default:primaryShimmerStop()
		end

		v9 = v19
		onEnter(v19)

		if defineFastFlag6 then
			if v19 == v8.AUTO_RECONNECTING then
				scheduleAutoReconnect()
			else
				cancelAutoReconnect() -- inferred equivalent call
			end
		end
	end

	local baseMessage

	if errorCode == Enum.ConnectionError.PlacelaunchCreatorBan then
		baseMessage = getCreatorBanString(p)
	elseif p2 == Enum.ConnectionError.TeleportErrors and v9 ~= v8.TELEPORT_FAILED then
		if errorCode == Enum.ConnectionError.OK then
			baseMessage = ""
		else
			local v20 = translateString("InGame.ConnectionError.ReconnectFailed")
			baseMessage = v20 == "" and "Reconnect was unsuccessful. Please try again." or v20
		end
	else
		baseMessage = getErrorString(p, errorCode)
	end

	if v9 == v8.RECONNECT_DISABLED then
		baseMessage = v3
	end

	if defineFastFlag6 and v9 == v8.AUTO_RECONNECTING then
		if v14.baseMessage == nil then
			v14.baseMessage = baseMessage
			v14.errorCode = errorCode
		end

		renderAutoReconnectPrompt()
	elseif default then
		if GetFFlagDisplayChannelNameOnErrorPrompt() then
			default:onErrorChanged(baseMessage, errorCode, true)
		else
			default:onErrorChanged(baseMessage, errorCode)
		end
	end
end

local function onErrorMessageChanged() -- 1 equivalent call inferred from this helper
	updateErrorPrompt(GuiService:GetErrorMessage(), GuiService:GetErrorCode(), GuiService:GetErrorType())
end

local function onScreenSizeChanged()
	if not default then
		return
	end

	local x = RobloxGui.AbsoluteSize.X
	local y = RobloxGui.AbsoluteSize.Y

	if v6 ~= x or v7 ~= y then
		v6 = x
		v7 = y
		default:resizeWidthAndHeight(v6, v7)
	end
end

RobloxGui:GetPropertyChangedSignal("AbsoluteSize"):connect(onScreenSizeChanged)
onErrorMessageChanged() -- inferred equivalent call
GuiService.ErrorMessageChanged:connect(onErrorMessageChanged)

if defineFastFlag2 then
	local ErrorTestSets = require(RobloxGui.Modules.ErrorTestSets)

	for k, errorTestSet in pairs(ErrorTestSets) do
		for _, v19 in pairs(errorTestSet) do
			updateErrorPrompt(
				"Should show localized strings, please file a jira ticket for missing translation.",
				v19,
				k
			)

			wait(2)

			if defineFastFlag6 then
				cancelAutoReconnect() -- inferred equivalent call
			end

			v9 = v8.NONE
		end
	end
end

if engineFeature2 then
	GuiService.CoreGuiRenderOverflowed:Connect(function()
		for _, screenGui in pairs(CoreGui:GetChildren()) do
			if screenGui:IsA("ScreenGui") and screenGui.Name ~= "RobloxPromptGui" then
				screenGui.Enabled = false
			end
		end
	end)
end

if defineFastFlag8 then
	coroutine.wrap(function()
		local GenericChallenges = require(CorePackages.Workspace.Packages.GenericChallenges)
		GenericChallenges.Middleware.InitExperienceChallengeInterceptor()
	end)()
end
