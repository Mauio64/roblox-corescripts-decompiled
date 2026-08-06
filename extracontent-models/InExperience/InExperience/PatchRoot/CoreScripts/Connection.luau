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
local v13 = game:DefineFastFlag("ConnectionRemoveLoadingTimeout", false)

CorePackages:WaitForChild("Workspace"):WaitForChild("Packages", if not v13 then nil else 1e999)

local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local ErrorPrompt = require(RobloxGui.Modules.ErrorPrompt)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Url = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Url
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol).LinkingProtocol
local v21 = game:DefineFastFlag("DebugEnableErrorStringTesting", false)
local v22 = game:DefineFastFlag("ShouldMuteUnlocalizedError", false)
local v23 = game:DefineFastFlag("UpdateConnectionErrorLoc", false)
local v24 = game:DefineFastFlag("ShowScreentimeLockoutKickMessage", false)
local t1 = {
	eventName = "ConnectionEvent",
	description = "Counter to track connection events.",
	links = "https://roblox.atlassian.net/browse/CSC-585",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		2025,
		7,
		31
	}
}
local v26 = game:DefineFastInt("PotentialClientTimeoutSeconds", 7200)
local v27 = game:DefineFastInt("MaxKickMessageLength", 200)
local v28 = game:DefineFastFlag("RefactorReconnectUnblockTeleport", false)
local v29 = game:DefineFastFlag("ConnectionEnableAutoReconnect", false)
local v30 = game:DefineFastInt("ConnectionAutoReconnectFirstDelayMs", 2000)
local v31 = game:DefineFastInt("ConnectionAutoReconnectBaseDelayMs", 5000)
local v32 = game:DefineFastInt("ConnectionAutoReconnectMaxDelayMs", 20000)
local v33 = game:DefineFastInt("ConnectionAutoReconnectJitterMs", 2000)
local v34 = game:DefineFastInt("ConnectionAutoReconnectMaxDurationSeconds", 300)
local random = nil

if v29 then
	random = Random.new()
end

local EngineFeature = game:GetEngineFeature("CoreGuiOverflowDetection")
local FFlagCoreScriptShowTeleportPrompt = require(RobloxGui.Modules.Flags.FFlagCoreScriptShowTeleportPrompt)
local FFlagAllowDisconnectGuiForOkUnknown = require(RobloxGui.Modules.Flags.FFlagAllowDisconnectGuiForOkUnknown)
local v39 = game:DefineFastFlag("EnableExperienceGenericChallengeRenderingConnection2", false)
local GetFFlagDisplayChannelNameOnErrorPrompt = require(RobloxGui.Modules.Flags.GetFFlagDisplayChannelNameOnErrorPrompt)

local function safeGetFInt(p1, p2) -- line: 75
	local ok, result = pcall(function() -- line: 76
		-- upvalues: p1 (copy)
		return (tonumber(settings():GetFVariable(p1)))
	end)

	return ok and result or p2
end
local function safeGetFString(p3, p4) -- line: 82
	local ok, result = pcall(function() -- line: 83
		-- upvalues: p3 (copy)
		return settings():GetFVariable(p3)
	end)

	return ok and result or p4
end
local function computeAutoReconnectDelaySeconds(p5) -- line: 92
	-- upvalues: v30 (copy), v31 (copy), v32 (copy), v33 (copy), random (ref)
	local v133 = if not (p5 <= 1) then if p5 ~= 2 then math.min(v31 * 2 ^ (p5 - 2), v32) else v31 else v30

	if v33 > 0 then
		v133 += random:NextInteger(0, v33)
	end

	return v133 / 1000
end

local s1 = "DefaultTimeoutTimeMs"
local ok, result = pcall(function() -- line: 76
	-- upvalues: s1 (copy)
	return (tonumber(settings():GetFVariable(s1)))
end)
local v47 = (ok and result or 10000) / 1000
local FFlag = settings():GetFFlag("ReconnectDisabled")
local s2 = "ReconnectDisabledReason"
local ok2, result2 = pcall(function() -- line: 83
	-- upvalues: s2 (copy)
	return settings():GetFVariable(s2)
end)
local v52 = ok2 and result2 or "We're sorry, Roblox is temporarily unavailable.  Please try again later."
local timestamp = tick()
local v54 = game:DefineFastFlag("UpdateConnectionLocWarning", false)
local v55 = game:DefineFastFlag("AddPlacelaunchDeviceBlock2", false)
local v56 = game:DefineFastFlag("AddContextualPlayabilityConnectionErrors", false)
local v57 = game:DefineFastFlag("AddVipOwnerNotPresentConnectionError", false)
local v58 = game:DefineFastFlag("VipOwnerNotPresentEnableReconnect", false)
local v59 = game:DefineFastFlag("RAKickLogic2", false)
local v60 = game:DefineFastInt("RAMinEngineVersion", 725)
local v61 = false

if v59 then
	local RobloxVersion = RunService:GetRobloxVersion()
	local num = tonumber(string.match(RobloxVersion, "%.(%d+)%."))

	if num and v60 <= num then
		v61 = true
	end
end

local FFlagConnectionAmpUpsellOnLeave = require(CorePackages.Workspace.Packages.SharedFlags).FFlagConnectionAmpUpsellOnLeave
local FFlagConnectionAmpParentalApprovalUpsell = require(CorePackages.Workspace.Packages.SharedFlags).FFlagConnectionAmpParentalApprovalUpsell
local FFlagConnectionUpsellAnalytics = require(CorePackages.Workspace.Packages.SharedFlags).FFlagConnectionUpsellAnalytics
local FFlagUniversalFeatureRestrictionReceivers = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUniversalFeatureRestrictionReceivers
local v68 = game:DefineFastFlag("AddCollaborationCoreGatedConnectionError2", false)
local EngineFeature2 = game:GetEngineFeature("PlacelaunchCollaborationCoreGatedConnectionError")
local v70 = game:DefineFastFlag("RobloxExperienceKickOverride", false)
local ConnectionAmpUpsellOnLeave = nil

if FFlagConnectionAmpUpsellOnLeave then
	ConnectionAmpUpsellOnLeave = require(RobloxGui.Modules.ConnectionAmpUpsellOnLeave)
end

local buildRobloxExperienceKickContent = require(CorePackages.Workspace.Packages.InterventionShared.buildRobloxExperienceKickContent)
local showFeatureRestrictionDirect = require(CorePackages.Workspace.Packages.UniversalFeatureRestrictions.showFeatureRestrictionDirect)

local function fetchUniverseIdFromPlaceId(p6) -- line: 167
	-- upvalues: Url (copy), HttpRbxApiService (copy), HttpService (copy)
	local v135 = string.format("%suniverses/v1/places/%d/universe", Url.APIS_URL, p6)
	local ok3, result3 = pcall(HttpRbxApiService.GetAsyncFullUrl, HttpRbxApiService, v135)

	if not ok3 or type(result3) ~= "string" then
		return nil
	end

	local ok4, result4 = pcall(HttpService.JSONDecode, HttpService, result3)

	if not ok4 or type(result4) ~= "table" then
		return nil
	end

	local universeId = result4.universeId

	if type(universeId) ~= "number" or universeId <= 0 then
		return nil
	end

	return universeId
end
local function translateString(s3: string, t2: {[any]: any}?) -- line: 187
	-- upvalues: LocalizationService (copy), Localization (copy), v54 (copy), Logging (copy)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local v144 = Localization.new(RobloxLocaleId)

	v144:SetLocale(RobloxLocaleId)

	local ok5, result5 = pcall(function() -- line: 192
		-- upvalues: v144 (copy), s3 (copy), t2 (copy)
		return v144:Format(s3, t2)
	end)

	if ok5 then
		return result5
	end

	if v54 then
		Logging.warn("Failed to translate string with key: " .. s3 .. ", LocaleId: " .. RobloxLocaleId)
	else
		Logging.warn("Failed to translate string with key: " .. s3)
	end

	return ""
end

local u76 = nil
local n1 = -1
local AbsoluteSizeX = RobloxGui.AbsoluteSize.X
local AbsoluteSizeY = RobloxGui.AbsoluteSize.Y
local t3 = {
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

if v29 then
	t3.AUTO_RECONNECTING = 15
end

local NONE = t3.NONE
local OK = Enum.ConnectionError.OK
local t4 = {
	[t3.RECONNECT_PLACELAUNCH] = "Join Error",
	[t3.RECONNECT_DISABLED_PLACELAUNCH] = "Join Error",
	[t3.RECONNECT_DISCONNECT] = "Disconnected",
	[t3.RECONNECT_DISABLED_DISCONNECT] = "Disconnected",
	[t3.TELEPORT_FAILED] = "Teleport Failed",
	[t3.RECONNECT_DISABLED] = "Error",
	[t3.OUT_OF_MEMORY_KEEPPLAYING_LEAVE] = "Low Memory Warning",
	[t3.RECONNECT_CONNECT_FAILURE] = "Connection Failed",
	[t3.RECONNECT_DISABLED_CONNECT_FAILURE] = "Connection Failed"
}

if FFlagConnectionAmpUpsellOnLeave then
	t4[t3.RECONNECT_AGE_CHECK_REQUIRED] = "Join Error"
	t4[t3.RECONNECT_PARENT_APPROVAL_REQUIRED] = "Join Error"
end

if v68 then
	t4[t3.RECONNECT_COLLABORATION_CORE_GATED] = "Join Error"
end

if v29 then
	t4[t3.AUTO_RECONNECTING] = "Disconnected"
end

local t5 = {
	[t3.RECONNECT_PLACELAUNCH] = "InGame.ConnectionError.Title.JoinError",
	[t3.RECONNECT_DISABLED_PLACELAUNCH] = "InGame.ConnectionError.Title.JoinError",
	[t3.RECONNECT_DISCONNECT] = "InGame.ConnectionError.Title.Disconnected",
	[t3.RECONNECT_DISABLED_DISCONNECT] = "InGame.ConnectionError.Title.Disconnected",
	[t3.TELEPORT_FAILED] = "InGame.ConnectionError.Title.TeleportFailed",
	[t3.RECONNECT_DISABLED] = "InGame.CommonUI.Title.Error",
	[t3.OUT_OF_MEMORY_KEEPPLAYING_LEAVE] = "InGame.ConnectionError.Title.LowMemoryWarning",
	[t3.RECONNECT_CONNECT_FAILURE] = "InGame.ConnectionError.Title.ConnectionFailed",
	[t3.RECONNECT_DISABLED_CONNECT_FAILURE] = "InGame.ConnectionError.Title.ConnectionFailed"
}

if FFlagConnectionAmpUpsellOnLeave then
	t5[t3.RECONNECT_AGE_CHECK_REQUIRED] = "InGame.ConnectionError.Title.JoinError"
	t5[t3.RECONNECT_PARENT_APPROVAL_REQUIRED] = "InGame.ConnectionError.Title.JoinError"
end

if v68 then
	t5[t3.RECONNECT_COLLABORATION_CORE_GATED] = "InGame.ConnectionError.Title.JoinError"
end

if v29 then
	t5[t3.AUTO_RECONNECTING] = "InGame.ConnectionError.Title.Disconnected"
end

local v85 = Create("ScreenGui")({
	Name = "RobloxPromptGui",
	OnTopOfCoreBlur = true,
	DisplayOrder = 9,
	AutoLocalize = false,
	Parent = CoreGui
})
local v86 = Create("Frame")({
	Name = "promptOverlay",
	BackgroundTransparency = 1,
	Active = false,
	BackgroundColor3 = Color3.new(0, 0, 0),
	Size = UDim2.new(1, 0, 1, 36),
	Position = UDim2.new(0, 0, 0, -36),
	Parent = v85
})

coroutine.wrap(function() -- line: 315
	-- upvalues: RobloxGui (copy), v86 (copy)
	local Constants = require(RobloxGui.Modules.TopBar.Constants)
	local v148 = Constants.ApplyDisplayScale(Constants.TopBarHeight)

	v86.Size = UDim2.new(1, 0, 1, v148)
	v86.Position = UDim2.new(0, 0, 0, -v148)
end)()

local function openCollaboratorsPageForUniverseId(p7) -- line: 324
	-- upvalues: TelemetryService (copy), t1 (copy), Url (copy), LinkingProtocol (copy)
	TelemetryService:LogCounter(t1, {
		customFields = {
			selectedItem = "ViewCollaboratorsOpenUrl"
		}
	}, 1)

	local v150 = string.format("%sdashboard/creations/experiences/%s/safety/collaborators", Url.CREATE_URL, (tostring(p7)))

	LinkingProtocol.default:openURL(v150)
end
local function v88() -- line: 360
	-- upvalues: NONE (ref), t3 (copy), TelemetryService (copy), t1 (copy), RbxAnalyticsService (copy), u76 (ref), TeleportService (copy), FFlagCoreScriptShowTeleportPrompt (copy), v28 (copy), GuiService (copy)
	tick()

	if NONE == t3.IS_RECONNECTING then
		TelemetryService:LogCounter(t1, {
			customFields = {
				selectedItem = "UserClickWhileReconnecting"
			}
		}, 1)

		return
	end

	TelemetryService:LogCounter(t1, {
		customFields = {
			selectedItem = "ReconnectInitiated"
		}
	}, 1)
	RbxAnalyticsService:ReportCounter("ReconnectPrompt-ReconnectActivated")
	NONE = t3.IS_RECONNECTING
	u76:primaryShimmerPlay()
	TelemetryService:LogCounter(t1, {
		customFields = {
			selectedItem = "ReconnectSameServer"
		}
	}, 1)
	TeleportService:TeleportReconnect()

	if FFlagCoreScriptShowTeleportPrompt then
		if v28 then
			TeleportService:UnblockAsync()

			return
		end

		GuiService:SetMenuIsOpen(false, "ErrorPrompt")
	end
end
local function v89() -- line: 392
	-- upvalues: NONE (ref), t3 (copy), TelemetryService (copy), t1 (copy), u76 (ref), GuiService (copy), TeleportService (copy)
	if NONE == t3.IS_RECONNECTING then
		TelemetryService:LogCounter(t1, {
			customFields = {
				selectedItem = "UserClickWhileReconnecting"
			}
		}, 1)

		return
	end

	local PlaceId = game.PlaceId

	if not PlaceId or PlaceId == 0 then
		TelemetryService:LogCounter(t1, {
			customFields = {
				selectedItem = "PlacelaunchRetryMissingPlaceId"
			}
		}, 1)

		return
	end

	TelemetryService:LogCounter(t1, {
		customFields = {
			selectedItem = "PlacelaunchRetryInitiated"
		}
	}, 1)
	NONE = t3.IS_RECONNECTING
	u76:primaryShimmerPlay()
	GuiService:ClearError()
	TeleportService:Teleport(PlaceId)
end
local function v90() -- line: 412
	-- upvalues: TelemetryService (copy), t1 (copy), GuiService (copy), RunService (copy)
	TelemetryService:LogCounter(t1, {
		customFields = {
			selectedItem = "LeaveInitiated"
		}
	}, 1)
	GuiService.SelectedCoreObject = nil
	RunService.RenderStepped:wait()
	RunService.RenderStepped:wait()
	game:Shutdown()
end
local function v91() -- line: 421
	-- upvalues: GuiService (copy)
	GuiService:ClearError()
end

local t6 = {
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

local function pushErrorToPrompt(p8, p9) -- line: 438
	-- upvalues: u76 (ref), GetFFlagDisplayChannelNameOnErrorPrompt (copy)
	if not u76 then
		return
	end

	if GetFFlagDisplayChannelNameOnErrorPrompt() then
		u76:onErrorChanged(p8, p9, true)

		return
	end

	u76:onErrorChanged(p8, p9)
end
local function renderAutoReconnectPrompt() -- line: 447
	-- upvalues: u76 (ref), NONE (ref), t3 (copy), t6 (copy), translateString (copy), GetFFlagDisplayChannelNameOnErrorPrompt (copy)
	if not u76 then
		return
	end

	if NONE ~= t3.AUTO_RECONNECTING and NONE ~= t3.IS_RECONNECTING then
		return
	end

	local v156 = if NONE ~= t3.IS_RECONNECTING then math.max(0, (math.ceil(t6.nextAttemptAt - tick()))) else -1

	if v156 == t6.lastRemaining then
		return
	end

	t6.lastRemaining = v156

	local attempt = t6.attempt
	local v158 = if not (v156 <= 0) then if v156 ~= 1 then translateString("InGame.ConnectionError.ReconnectingAttemptInSeconds", {
		RBX_ATTEMPT = attempt,
		RBX_SECONDS = v156
	}) else translateString("InGame.ConnectionError.ReconnectingAttemptInSecond", {
		RBX_ATTEMPT = attempt
	}) else translateString("InGame.ConnectionError.ReconnectingAttempt", {
		RBX_ATTEMPT = attempt
	})
	local v159 = if not t6.baseMessage or t6.baseMessage == "" then v158 else t6.baseMessage .. "\n" .. v158

	if v159 == t6.lastRenderedText then
		return
	end

	t6.lastRenderedText = v159

	local errorCode = t6.errorCode

	if not u76 then
		return
	end

	if GetFFlagDisplayChannelNameOnErrorPrompt() then
		u76:onErrorChanged(v159, errorCode, true)

		return
	end

	u76:onErrorChanged(v159, errorCode)
end
local function ensureAutoReconnectTicker() -- line: 493
	-- upvalues: t6 (copy), renderAutoReconnectPrompt (copy)
	if t6.tickerThread then
		return
	end

	t6.tickerThread = task.spawn(function() -- line: 497
		-- upvalues: t6 (copy), renderAutoReconnectPrompt (copy)
		while t6.active do
			task.wait(0.25)
			renderAutoReconnectPrompt()
		end

		t6.tickerThread = nil
	end)
end
local function cancelAutoReconnect() -- line: 506
	-- upvalues: t6 (copy)
	t6.active = false
	t6.attempt = 0
	t6.nextAttemptAt = 0
	t6.errorCode = nil
	t6.baseMessage = nil
	t6.lastRenderedText = nil
	t6.lastRemaining = nil

	if t6.pendingThread then
		task.cancel(t6.pendingThread)
		t6.pendingThread = nil
	end

	if t6.tickerThread then
		task.cancel(t6.tickerThread)
		t6.tickerThread = nil
	end
end
local function autoReconnectAttemptBucket(p10) -- line: 525
	if p10 <= 5 then
		return (tostring(p10))
	end

	if p10 <= 8 then
		return "6-8"
	end

	return "9+"
end
local function fireAutoReconnect() -- line: 535
	-- upvalues: t6 (copy), NONE (ref), t3 (copy), TelemetryService (copy), t1 (copy), renderAutoReconnectPrompt (copy), u76 (ref), TeleportService (copy), FFlagCoreScriptShowTeleportPrompt (copy), v28 (copy), GuiService (copy)
	t6.pendingThread = nil

	if NONE == t3.IS_RECONNECTING then
		return
	end

	local v162 = TelemetryService
	local v163 = t1
	local t7 = {}
	local t8 = {
		selectedItem = "AutoReconnectAttempt"
	}
	local attempt = t6.attempt

	t8.attemptBucket = if not (attempt <= 5) then not (attempt <= 8) and "9+" or "6-8" else tostring(attempt)
	t7.customFields = t8
	v162:LogCounter(v163, t7, 1)
	NONE = t3.IS_RECONNECTING
	renderAutoReconnectPrompt()

	if u76 then
		u76:primaryShimmerPlay()
	end

	TeleportService:TeleportReconnect()

	if FFlagCoreScriptShowTeleportPrompt then
		if v28 then
			TeleportService:UnblockAsync()

			return
		end

		GuiService:SetMenuIsOpen(false, "ErrorPrompt")
	end
end
local function scheduleAutoReconnect() -- line: 561
	-- upvalues: t6 (copy), v30 (copy), v31 (copy), v32 (copy), v33 (copy), random (ref), TelemetryService (copy), t1 (copy), renderAutoReconnectPrompt (copy), fireAutoReconnect (copy)
	t6.active = true

	if t6.pendingThread then
		task.cancel(t6.pendingThread)
		t6.pendingThread = nil
	end

	t6.attempt = t6.attempt + 1

	local attempt = t6.attempt
	local v168 = if not (attempt <= 1) then if attempt ~= 2 then math.min(v31 * 2 ^ (attempt - 2), v32) else v31 else v30

	if v33 > 0 then
		v168 += random:NextInteger(0, v33)
	end

	local v169 = v168 / 1000

	t6.nextAttemptAt = tick() + v169
	t6.lastRenderedText = nil
	t6.lastRemaining = nil
	TelemetryService:LogCounter(t1, {
		customFields = {
			selectedItem = "AutoReconnectScheduled"
		}
	}, 1)

	if not t6.tickerThread then
		t6.tickerThread = task.spawn(function() -- line: 497
			-- upvalues: t6 (copy), renderAutoReconnectPrompt (copy)
			while t6.active do
				task.wait(0.25)
				renderAutoReconnectPrompt()
			end

			t6.tickerThread = nil
		end)
	end

	t6.pendingThread = task.delay(v169, fireAutoReconnect)
end
local function autoReconnectNowFunction() -- line: 578
	-- upvalues: NONE (ref), t3 (copy), TelemetryService (copy), t1 (copy), t6 (copy), fireAutoReconnect (copy)
	if NONE == t3.IS_RECONNECTING then
		TelemetryService:LogCounter(t1, {
			customFields = {
				selectedItem = "UserClickWhileReconnecting"
			}
		}, 1)

		return
	end

	TelemetryService:LogCounter(t1, {
		customFields = {
			selectedItem = "AutoReconnectManualNow"
		}
	}, 1)

	if t6.pendingThread then
		task.cancel(t6.pendingThread)
		t6.pendingThread = nil
	end

	fireAutoReconnect()
end

local t9 = {
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

if EngineFeature then
	t9[Enum.ConnectionError.DisconnectClientFailure] = true
end

if v24 then
	t9[Enum.ConnectionError.ScreentimeLockoutKick] = true
end

if v55 then
	t9[Enum.ConnectionError.PlacelaunchDeviceBlock] = true
end

if v56 then
	t9[Enum.ConnectionError.PlacelaunchAgeVerificationRequired] = true
	t9[Enum.ConnectionError.PlacelaunchParentalApprovalRequired] = true
	t9[Enum.ConnectionError.PlacelaunchCoreGated] = true
end

if v57 and not v58 then
	t9[Enum.ConnectionError.PlacelaunchVipOwnerNotPresent] = true
end

local v102 = if not v68 or not EngineFeature2 then nil else Enum.ConnectionError.PlacelaunchCollaborationCoreGated

if v68 and v102 then
	t9[v102] = true
end

if v59 and v61 then
	t9[Enum.ConnectionError.DisconnectRemoteAttestationUnsupported] = true
	t9[Enum.ConnectionError.DisconnectRemoteAttestationGeneralFailure] = true
	t9[Enum.ConnectionError.DisconnectRemoteAttestationOSOutOfDate] = true
	t9[Enum.ConnectionError.DisconnectRemoteAttestationBootValidationFailure] = true
end

local t10 = {}

if v29 then
	t10 = {
		[Enum.ConnectionError.DisconnectConnectionLost] = true,
		[Enum.ConnectionError.DisconnectTimeout] = true,
		[Enum.ConnectionError.DisconnectRaknetErrors] = true,
		[Enum.ConnectionError.DisconnectReceivePacketError] = true,
		[Enum.ConnectionError.DisconnectReceivePacketStreamError] = true,
		[Enum.ConnectionError.DisconnectSendPacketError] = true,
		[Enum.ConnectionError.DisconnectHashTimeout] = true,
		[Enum.ConnectionError.ReplicatorTimeout] = true,
		[Enum.ConnectionError.NetworkTimeout] = true,
		[Enum.ConnectionError.NetworkInternal] = true,
		[Enum.ConnectionError.NetworkSend] = true
	}
end

local t11 = {
	[t3.RECONNECT_PLACELAUNCH] = {
		{
			Text = "Retry",
			LocalizationKey = "InGame.CommonUI.Button.Retry",
			LayoutOrder = 2,
			Primary = true,
			Callback = v88
		},
		{
			Text = "Cancel",
			LocalizationKey = "Feature.SettingsHub.Action.CancelSearch",
			LayoutOrder = 1,
			Callback = v90
		}
	},
	[t3.RECONNECT_DISCONNECT] = {
		{
			Text = "Reconnect",
			LocalizationKey = "InGame.ConnectionError.Button.Reconnect",
			LayoutOrder = 2,
			Primary = true,
			Callback = v88
		},
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 1,
			Callback = v90
		}
	},
	[t3.TELEPORT_FAILED] = {{
		Text = "OK",
		LocalizationKey = "InGame.CommonUI.Button.Ok",
		LayoutOrder = 1,
		Primary = true,
		Callback = v91
	}},
	[t3.RECONNECT_DISABLED_DISCONNECT] = {{
		Text = "Leave",
		LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
		LayoutOrder = 1,
		Primary = true,
		Callback = v90
	}},
	[t3.RECONNECT_DISABLED_PLACELAUNCH] = {{
		Text = "Leave",
		LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
		LayoutOrder = 1,
		Primary = true,
		Callback = v90
	}},
	[t3.RECONNECT_DISABLED] = {{
		Text = "Leave",
		LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
		LayoutOrder = 1,
		Primary = true,
		Callback = v90
	}},
	[t3.OUT_OF_MEMORY_KEEPPLAYING_LEAVE] = {
		{
			Text = "Keep Playing",
			LocalizationKey = "InGame.CommonUI.Button.KeepPlaying",
			LayoutOrder = 1,
			Callback = v91
		},
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 2,
			Primary = true,
			Callback = v90
		}
	},
	[t3.RECONNECT_CONNECT_FAILURE] = {
		{
			Text = "Retry",
			LocalizationKey = "InGame.CommonUI.Button.Retry",
			LayoutOrder = 2,
			Primary = true,
			Callback = v88
		},
		{
			Text = "Cancel",
			LocalizationKey = "Feature.SettingsHub.Action.CancelSearch",
			LayoutOrder = 1,
			Callback = v90
		}
	},
	[t3.RECONNECT_DISABLED_CONNECT_FAILURE] = {{
		Text = "Leave",
		LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
		LayoutOrder = 1,
		Primary = true,
		Callback = v90
	}}
}

if FFlagConnectionAmpUpsellOnLeave then
	local v105 = ConnectionAmpUpsellOnLeave.createAgeCheckCallback(t1, v89, 9)

	t11[t3.RECONNECT_AGE_CHECK_REQUIRED] = {
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 1,
			Callback = v90
		},
		{
			LayoutOrder = 2,
			Primary = true,
			Text = ConnectionAmpUpsellOnLeave.PrimaryButtonText,
			LocalizationKey = ConnectionAmpUpsellOnLeave.PrimaryButtonLocalizationKey,
			Callback = v105
		}
	}
end

if FFlagConnectionAmpParentalApprovalUpsell then
	local v106 = ConnectionAmpUpsellOnLeave.createParentalApprovalCallback(t1, v89, 9)

	t11[t3.RECONNECT_PARENT_APPROVAL_REQUIRED] = {
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 1,
			Callback = v90
		},
		{
			LayoutOrder = 2,
			Primary = true,
			Text = ConnectionAmpUpsellOnLeave.PrimaryButtonText,
			LocalizationKey = ConnectionAmpUpsellOnLeave.PrimaryButtonLocalizationKey,
			Callback = v106
		}
	}
end

if v68 then
	t11[t3.RECONNECT_COLLABORATION_CORE_GATED] = {
		{
			Text = "Ok",
			LocalizationKey = "InGame.ConnectionError.Action.Ok",
			LayoutOrder = 1,
			Callback = v90
		},
		{
			Text = "View collaborators",
			LocalizationKey = "InGame.ConnectionError.Action.ViewCollaborators",
			LayoutOrder = 2,
			Primary = true,
			Callback = function() -- line: 335
				-- upvalues: TelemetryService (copy), t1 (copy), openCollaboratorsPageForUniverseId (copy), fetchUniverseIdFromPlaceId (copy)
				TelemetryService:LogCounter(t1, {
					customFields = {
						selectedItem = "ViewCollaboratorsInitiated"
					}
				}, 1)

				local GameId = game.GameId

				if GameId and GameId ~= 0 then
					openCollaboratorsPageForUniverseId(GameId)

					return
				end

				local PlaceId = game.PlaceId

				if not PlaceId or PlaceId == 0 then
					TelemetryService:LogCounter(t1, {
						customFields = {
							selectedItem = "ViewCollaboratorsMissingPlaceId"
						}
					}, 1)

					return
				end

				coroutine.wrap(function() -- line: 350
					-- upvalues: fetchUniverseIdFromPlaceId (copy), PlaceId (copy), TelemetryService (copy), t1 (copy), openCollaboratorsPageForUniverseId (copy)
					local v213 = fetchUniverseIdFromPlaceId(PlaceId)

					if not v213 then
						TelemetryService:LogCounter(t1, {
							customFields = {
								selectedItem = "ViewCollaboratorsUniverseIdLookupFailed"
							}
						}, 1)

						return
					end

					openCollaboratorsPageForUniverseId(v213)
				end)()
			end
		}
	}
end

if v29 then
	t11[t3.AUTO_RECONNECTING] = {
		{
			Text = "Reconnect Now",
			LocalizationKey = "InGame.ConnectionError.Button.ReconnectNow",
			LayoutOrder = 2,
			Primary = true,
			Callback = autoReconnectNowFunction
		},
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 1,
			Callback = function() -- line: 591
				-- upvalues: TelemetryService (copy), t1 (copy), t6 (copy), v90 (copy)
				TelemetryService:LogCounter(t1, {
					customFields = {
						selectedItem = "AutoReconnectLeave"
					}
				}, 1)
				t6.active = false
				t6.attempt = 0
				t6.nextAttemptAt = 0
				t6.errorCode = nil
				t6.baseMessage = nil
				t6.lastRenderedText = nil
				t6.lastRemaining = nil

				if t6.pendingThread then
					task.cancel(t6.pendingThread)
					t6.pendingThread = nil
				end

				if t6.tickerThread then
					task.cancel(t6.tickerThread)
					t6.tickerThread = nil
				end

				v90()
			end
		}
	}
end

local t12 = {
	[t3.NONE] = function() -- line: 883
		-- upvalues: RunService (copy), v86 (copy)
		RunService:SetRobloxGuiFocused(false)
		v86.Active = false
		v86.Transparency = 1
	end,
	[t3.RECONNECT_DISCONNECT] = function() -- line: 888
		-- upvalues: VRService (copy), RunService (copy), v86 (copy)
		if VRService.VREnabled then
			RunService:SetRobloxGuiFocused(false)
		else
			RunService:SetRobloxGuiFocused(true)
		end

		v86.Active = true
		v86.Transparency = 1
	end,
	[t3.RECONNECT_PLACELAUNCH] = function() -- line: 897
		-- upvalues: RunService (copy), v86 (copy)
		RunService:SetRobloxGuiFocused(false)
		v86.Active = true
		v86.Transparency = 0.3
	end,
	[t3.TELEPORT_FAILED] = function() -- line: 902
		-- upvalues: RunService (copy), v86 (copy)
		RunService:SetRobloxGuiFocused(false)
		v86.Active = true
		v86.Transparency = 0.3
	end,
	[t3.RECONNECT_DISABLED_DISCONNECT] = function() -- line: 907
		-- upvalues: VRService (copy), RunService (copy), v86 (copy)
		if VRService.VREnabled then
			RunService:SetRobloxGuiFocused(false)
		else
			RunService:SetRobloxGuiFocused(true)
		end

		v86.Active = true
		v86.Transparency = 1
	end,
	[t3.RECONNECT_DISABLED_PLACELAUNCH] = function() -- line: 916
		-- upvalues: RunService (copy), v86 (copy)
		RunService:SetRobloxGuiFocused(false)
		v86.Active = true
		v86.Transparency = 0.3
	end,
	[t3.RECONNECT_DISABLED] = function() -- line: 921
		-- upvalues: VRService (copy), RunService (copy), v86 (copy)
		if VRService.VREnabled then
			RunService:SetRobloxGuiFocused(false)
		else
			RunService:SetRobloxGuiFocused(true)
		end

		v86.Active = true
		v86.Transparency = 1
	end,
	[t3.RECONNECT_CONNECT_FAILURE] = function() -- line: 930
		-- upvalues: RunService (copy), v86 (copy)
		RunService:SetRobloxGuiFocused(false)
		v86.Active = true
		v86.Transparency = 0.3
	end,
	[t3.RECONNECT_DISABLED_CONNECT_FAILURE] = function() -- line: 935
		-- upvalues: RunService (copy), v86 (copy)
		RunService:SetRobloxGuiFocused(false)
		v86.Active = true
		v86.Transparency = 0.3
	end
}

if FFlagConnectionAmpUpsellOnLeave then
	local v108 = t12[t3.RECONNECT_PLACELAUNCH]

	t12[t3.RECONNECT_AGE_CHECK_REQUIRED] = v108

	if FFlagConnectionAmpParentalApprovalUpsell then
		t12[t3.RECONNECT_PARENT_APPROVAL_REQUIRED] = v108
	end
end

if v68 then
	t12[t3.RECONNECT_COLLABORATION_CORE_GATED] = function() -- line: 955
		-- upvalues: RunService (copy), v86 (copy)
		RunService:SetRobloxGuiFocused(false)
		v86.Active = true
		v86.Transparency = 0.3
	end
end

if v29 then
	t12[t3.AUTO_RECONNECTING] = t12[t3.RECONNECT_DISCONNECT]
end

local function onEnter(p11) -- line: 969
	-- upvalues: u76 (ref), v21 (copy), ErrorPrompt (copy), v86 (copy), AbsoluteSizeX (ref), AbsoluteSizeY (ref), t12 (copy), t4 (copy), t5 (copy), t11 (copy)
	if not u76 then
		local t13 = {
			MenuIsOpenKey = "ConnectionErrorPrompt",
			PlayAnimation = not v21
		}

		u76 = ErrorPrompt.new("Default", t13)
		u76:setParent(v86)
		u76:resizeWidthAndHeight(AbsoluteSizeX, AbsoluteSizeY)
	end

	if t12[p11] then
		t12[p11]()
	end

	u76:setErrorTitle(t4[p11], t5[p11])
	u76:updateButtons(t11[p11])
end
local function onExit(p12) -- line: 986
	-- upvalues: t3 (copy), u76 (ref)
	if p12 == t3.IS_RECONNECTING then
		u76:primaryShimmerStop()
	end
end
local function stateTransit(p13, p14, p15) -- line: 993
	-- upvalues: FFlagAllowDisconnectGuiForOkUnknown (copy), t3 (copy), FFlag (copy), timestamp (ref), n1 (ref), v47 (copy), OK (ref), t9 (copy), TelemetryService (copy), t1 (copy), RbxAnalyticsService (copy), v29 (copy), t10 (ref), FFlagConnectionAmpUpsellOnLeave (copy), ConnectionAmpUpsellOnLeave (ref), FFlagConnectionUpsellAnalytics (copy), FFlagConnectionAmpParentalApprovalUpsell (copy), v68 (copy), v102 (copy), v26 (copy), t6 (copy), v34 (copy)
	if FFlagAllowDisconnectGuiForOkUnknown then
		if p14 == Enum.ConnectionError.OK then
			return t3.NONE
		end
	elseif p13 == Enum.ConnectionError.OK then
		return t3.NONE
	end

	if p15 == t3.NONE then
		if FFlag then
			return t3.RECONNECT_DISABLED
		end

		timestamp = tick()

		if FFlagAllowDisconnectGuiForOkUnknown then
			assert(p14 ~= Enum.ConnectionError.OK)

			if p13 == Enum.ConnectionError.OK then
				return t3.RECONNECT_DISCONNECT
			end
		end

		if p13 == Enum.ConnectionError.ConnectErrors then
			n1 = tick() + v47
			OK = Enum.ConnectionError.ConnectErrors

			if t9[p14] then
				return t3.RECONNECT_DISABLED_CONNECT_FAILURE
			end

			TelemetryService:LogCounter(t1, {
				customFields = {
					selectedItem = "ConnectError"
				}
			}, 1)
			TelemetryService:LogCounter(t1, {
				customFields = {
					selectedItem = "ConnectFailed"
				}
			}, 1)

			return t3.RECONNECT_CONNECT_FAILURE
		end

		if p13 == Enum.ConnectionError.DisconnectErrors then
			n1 = tick() + v47
			OK = Enum.ConnectionError.DisconnectErrors

			if p14 == Enum.ConnectionError.DisconnectOutOfMemoryKeepPlayingLeave then
				return t3.OUT_OF_MEMORY_KEEPPLAYING_LEAVE
			end

			if t9[p14] then
				return t3.RECONNECT_DISABLED_DISCONNECT
			end

			TelemetryService:LogCounter(t1, {
				customFields = {
					selectedItem = "Disconnected"
				}
			}, 1)
			RbxAnalyticsService:ReportCounter("ReconnectPrompt-Disconnect")

			if v29 and t10[p14] then
				return t3.AUTO_RECONNECTING
			end

			return t3.RECONNECT_DISCONNECT
		end

		if p13 == Enum.ConnectionError.PlacelaunchErrors then
			OK = Enum.ConnectionError.PlacelaunchErrors

			if FFlagConnectionAmpUpsellOnLeave then
				local AgeVerificationRequiredEnum = ConnectionAmpUpsellOnLeave.AgeVerificationRequiredEnum

				if AgeVerificationRequiredEnum and p14 == AgeVerificationRequiredEnum then
					TelemetryService:LogCounter(t1, {
						customFields = {
							selectedItem = "PlaceLaunchAgeVerificationRequired"
						}
					}, 1)

					if FFlagConnectionUpsellAnalytics then
						ConnectionAmpUpsellOnLeave.fireImpressionAgeCheck(t1, game.PlaceId)
					end

					return t3.RECONNECT_AGE_CHECK_REQUIRED
				end
			end

			if FFlagConnectionAmpParentalApprovalUpsell then
				local ParentalApprovalRequiredEnum = ConnectionAmpUpsellOnLeave.ParentalApprovalRequiredEnum

				if ParentalApprovalRequiredEnum and p14 == ParentalApprovalRequiredEnum then
					TelemetryService:LogCounter(t1, {
						customFields = {
							selectedItem = "PlaceLaunchParentalApprovalRequired"
						}
					}, 1)

					if FFlagConnectionUpsellAnalytics then
						ConnectionAmpUpsellOnLeave.fireImpressionParentalApproval(t1, game.PlaceId)
					end

					return t3.RECONNECT_PARENT_APPROVAL_REQUIRED
				end
			end

			if v68 and v102 and p14 == v102 then
				TelemetryService:LogCounter(t1, {
					customFields = {
						selectedItem = "PlaceLaunchCollaborationCoreGated"
					}
				}, 1)

				return t3.RECONNECT_COLLABORATION_CORE_GATED
			end

			if t9[p14] then
				return t3.RECONNECT_DISABLED_PLACELAUNCH
			end

			TelemetryService:LogCounter(t1, {
				customFields = {
					selectedItem = "PlaceLaunchError"
				}
			}, 1)
			RbxAnalyticsService:ReportCounter("ReconnectPrompt-PlaceLaunch")

			return t3.RECONNECT_PLACELAUNCH
		end

		if p13 == Enum.ConnectionError.TeleportErrors then
			TelemetryService:LogCounter(t1, {
				customFields = {
					selectedItem = "TeleportError"
				}
			}, 1)
			RbxAnalyticsService:ReportCounter("ReconnectPrompt-TeleportFailed")

			return t3.TELEPORT_FAILED
		end
	end

	if p15 == t3.IS_RECONNECTING then
		TelemetryService:LogCounter(t1, {
			customFields = {
				selectedItem = "ReconnectFailed"
			}
		}, 1)
		RbxAnalyticsService:ReportCounter("ReconnectPrompt-ReconnectFailed")

		if p13 == Enum.ConnectionError.TeleportErrors then
			if tick() > timestamp + v26 then
				TelemetryService:LogCounter(t1, {
					customFields = {
						selectedItem = "ReconnectTimedOut"
					}
				}, 1)

				if OK == Enum.ConnectionError.PlacelaunchErrors then
					return t3.RECONNECT_DISABLED_PLACELAUNCH
				end

				return t3.RECONNECT_DISABLED_DISCONNECT
			end

			if OK == Enum.ConnectionError.PlacelaunchErrors then
				TelemetryService:LogCounter(t1, {
					customFields = {
						selectedItem = "PlaceLaunchReconnectFailed"
					}
				}, 1)

				return t3.RECONNECT_PLACELAUNCH
			end

			if OK == Enum.ConnectionError.DisconnectErrors then
				TelemetryService:LogCounter(t1, {
					customFields = {
						selectedItem = "DisconnectReconnectFailed"
					}
				}, 1)

				if v29 and t6.active then
					local v178 = v34

					if v178 <= 0 or tick() <= timestamp + v178 then
						return t3.AUTO_RECONNECTING
					end

					TelemetryService:LogCounter(t1, {
						customFields = {
							selectedItem = "AutoReconnectExhausted"
						}
					}, 1)
				end

				return t3.RECONNECT_DISCONNECT
			end

			if OK == Enum.ConnectionError.ConnectErrors then
				TelemetryService:LogCounter(t1, {
					customFields = {
						selectedItem = "ConnectReconnectFailed"
					}
				}, 1)

				return t3.RECONNECT_CONNECT_FAILURE
			end
		end
	end

	if v29 and p15 == t3.AUTO_RECONNECTING then
		if FFlag then
			return t3.RECONNECT_DISABLED
		end

		if p13 == Enum.ConnectionError.DisconnectErrors and t9[p14] then
			return t3.RECONNECT_DISABLED_DISCONNECT
		end

		return p15
	end

	return p15
end
local function getCreatorBanString(s4: string) -- line: 1140
	-- upvalues: GuiService (copy), translateString (copy)
	local ErrorDetails = GuiService:GetErrorDetails()

	if ErrorDetails then
		local v187

		if ErrorDetails.time then
			local minutes = ErrorDetails.minutes
			local hours = ErrorDetails.hours
			local days = ErrorDetails.days
			local v184 = if minutes ~= 1 then translateString("InGame.ConnectionError.CreatorBanMinutesPlural", {
				RBX_TIME_MINUTES = minutes
			}) else translateString("InGame.ConnectionError.CreatorBanMinutesSingular")
			local v185 = if hours ~= 1 then translateString("InGame.ConnectionError.CreatorBanHoursPlural", {
				RBX_TIME_HOURS = hours
			}) else translateString("InGame.ConnectionError.CreatorBanHoursSingular")
			local v186 = if days ~= 1 then translateString("InGame.ConnectionError.CreatorBanDaysPlural", {
				RBX_TIME_DAYS = days
			}) else translateString("InGame.ConnectionError.CreatorBanDaysSingular")

			if v184 == "" or v185 == "" or v186 == "" then
				return s4
			end

			if hours > 0 then
				v184 = v185 .. ", " .. v184
			end

			if days > 0 then
				v184 = v186 .. ", " .. v184
			end

			v187 = translateString("InGame.ConnectionError.CreatorBanWithTime", {
				RBX_TIME_REMAINING = v184
			})
		else
			v187 = translateString("InGame.ConnectionError.CreatorBanNoTime")
		end

		if v187 == "" then
			return s4
		end

		local displayReason = ErrorDetails.displayReason

		if displayReason and displayReason ~= "" then
			local v189 = translateString("InGame.ConnectionError.CreatorBanMessage", {
				RBX_STR = displayReason
			})

			if v189 ~= "" then
				return v187 .. " " .. v189
			end

			return s4
		end

		return v187
	end

	return s4
end

local v113 = game:DefineFastFlag("RemoveRefToMissingLocInConnection", false)
local t14 = {
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
	[Enum.ConnectionError.PlacelaunchCustomMessage] = not v113 and "InGame.ConnectionError.PlacelaunchCustomMessage" or nil,
	[Enum.ConnectionError.PlacelaunchOtherError] = "InGame.ConnectionError.PlacelaunchOtherError",
	[Enum.ConnectionError.TeleportErrors] = "InGame.ConnectionError.TeleportErrors",
	[Enum.ConnectionError.TeleportFailure] = "InGame.ConnectionError.TeleportFailure",
	[Enum.ConnectionError.TeleportGameNotFound] = "InGame.ConnectionError.TeleportGameNotFound",
	[Enum.ConnectionError.TeleportGameEnded] = "InGame.ConnectionError.TeleportGameEnded",
	[Enum.ConnectionError.TeleportGameFull] = "InGame.ConnectionError.TeleportGameFull",
	[Enum.ConnectionError.TeleportUnauthorized] = "InGame.ConnectionError.TeleportUnauthorized",
	[Enum.ConnectionError.TeleportFlooded] = "InGame.ConnectionError.TeleportFlooded",
	[Enum.ConnectionError.TeleportIsTeleporting] = not v113 and "InGame.ConnectionError.TeleportIsTeleporting" or nil,
	[Enum.ConnectionError.DisconnectVerboselyModeratedGame] = "InGame.ConnectionError.DisconnectVerboselyModeratedGame"
}

if v24 then
	t14[Enum.ConnectionError.ScreentimeLockoutKick] = "Feature.Screentime.Content.ScreentimeLimitDialog"
end

if v55 then
	t14[Enum.ConnectionError.PlacelaunchDeviceBlock] = "InGame.ConnectionError.PlacelaunchDeviceBlock"
end

if v56 then
	t14[Enum.ConnectionError.PlacelaunchAgeVerificationRequired] = "InGame.ConnectionError.Description.AgeCheckRequired"
	t14[Enum.ConnectionError.PlacelaunchParentalApprovalRequired] = "InGame.ConnectionError.Description.ParentalApprovalRequired"
	t14[Enum.ConnectionError.PlacelaunchCoreGated] = "InGame.ConnectionError.Description.LockedByAge"
end

if v57 then
	t14[Enum.ConnectionError.PlacelaunchVipOwnerNotPresent] = "InGame.ConnectionError.Description.VipOwnerNotPresent"
end

if v68 and v102 then
	t14[v102] = "InGame.ConnectionError.Description.CollaborationRequiresTrustedFriends"
end

if v59 and v61 then
	t14[Enum.ConnectionError.DisconnectRemoteAttestationTimeout] = "InGame.ConnectionError.RemoteAttestationTimeout"
	t14[Enum.ConnectionError.DisconnectRemoteAttestationUnsupported] = "InGame.ConnectionError.RemoteAttestationUnsupported"
	t14[Enum.ConnectionError.DisconnectRemoteAttestationGeneralFailure] = "InGame.ConnectionError.RemoteAttestationGeneralFailure"
	t14[Enum.ConnectionError.DisconnectRemoteAttestationOSOutOfDate] = "InGame.ConnectionError.RemoteAttestationOSOutOfDate"
	t14[Enum.ConnectionError.DisconnectRemoteAttestationBootValidationFailure] = "InGame.ConnectionError.RemoteAttestationBootValidationFailure"
end

local function getErrorString(s5: string, p16, p17) -- line: 1328
	-- upvalues: translateString (copy), v27 (copy), v23 (copy), t14 (copy), mutedError (copy), v22 (copy)
	if p16 == Enum.ConnectionError.OK then
		return ""
	end

	if p17 then
		local v193 = translateString("InGame.ConnectionError.ReconnectFailed")

		if v193 ~= "" then
			return v193
		end

		return "Reconnect was unsuccessful. Please try again."
	end

	if p16 == Enum.ConnectionError.DisconnectLuaKick and s5 ~= "" then
		local v194 = s5:sub(1, v27)
		local v195 = translateString("InGame.ConnectionError.DisconnectLuaKickWithMessage", {
			RBX_STR = v194
		})

		if v195 ~= "" then
			return v195
		end

		return v194
	end

	local v196

	if v23 then
		v196 = t14[p16]

		if not v196 then
			mutedError("Cannot find localization key for " .. tostring(p16))
			v196 = "InGame.ConnectionError.UnknownError"
		end
	else
		v196 = string.gsub(tostring(p16), "Enum", "InGame")
	end

	local v197 = if p16 ~= Enum.ConnectionError.DisconnectIdle then translateString(v196) else translateString(v196, {
		RBX_NUM = tostring(20)
	})

	if v197 ~= "" then
		return v197
	end

	if v22 then
		return (translateString("InGame.ConnectionError.UnknownError"))
	end

	return s5
end
local function updateErrorPrompt(p18, p19, p20) -- line: 1382
	-- upvalues: v70 (copy), FFlagUniversalFeatureRestrictionReceivers (copy), GuiService (copy), buildRobloxExperienceKickContent (copy), translateString (copy), showFeatureRestrictionDirect (copy), v90 (copy), TelemetryService (copy), t1 (copy), stateTransit (copy), NONE (ref), t3 (copy), u76 (ref), onEnter (copy), v29 (copy), scheduleAutoReconnect (copy), t6 (copy), getCreatorBanString (copy), getErrorString (copy), v52 (copy), renderAutoReconnectPrompt (copy), GetFFlagDisplayChannelNameOnErrorPrompt (copy)
	if v70 and (FFlagUniversalFeatureRestrictionReceivers and p19 == Enum.ConnectionError.DisconnectLuaKick) then
		local ErrorDetails = GuiService:GetErrorDetails()

		if ErrorDetails and ErrorDetails.moderatorType == "roblox" then
			local v202 = buildRobloxExperienceKickContent(p18, ErrorDetails, translateString)

			showFeatureRestrictionDirect(v202.abuseVector, v202.moderationDetail, {
				onDismiss = v90,
				titleOverride = v202.options.titleOverride,
				bodyOverride = v202.options.bodyOverride
			})
			TelemetryService:LogCounter(t1, {
				customFields = {
					selectedItem = "RobloxExperienceKick"
				}
			}, 1)

			return
		end
	end

	local v203 = stateTransit(p20, p19, NONE)

	if v203 ~= NONE then
		if NONE == t3.IS_RECONNECTING then
			u76:primaryShimmerStop()
		end

		NONE = v203
		onEnter(v203)

		if v29 then
			if v203 == t3.AUTO_RECONNECTING then
				scheduleAutoReconnect()
			else
				t6.active = false
				t6.attempt = 0
				t6.nextAttemptAt = 0
				t6.errorCode = nil
				t6.baseMessage = nil
				t6.lastRenderedText = nil
				t6.lastRemaining = nil

				if t6.pendingThread then
					task.cancel(t6.pendingThread)
					t6.pendingThread = nil
				end

				if t6.tickerThread then
					task.cancel(t6.tickerThread)
					t6.tickerThread = nil
				end
			end
		end
	end

	local v204

	if p19 == Enum.ConnectionError.PlacelaunchCreatorBan then
		v204 = getCreatorBanString(p18)
	elseif p20 == Enum.ConnectionError.TeleportErrors and NONE ~= t3.TELEPORT_FAILED then
		if p19 == Enum.ConnectionError.OK then
			v204 = ""
		else
			local v205 = translateString("InGame.ConnectionError.ReconnectFailed")

			v204 = v205 == "" and "Reconnect was unsuccessful. Please try again." or v205
		end
	else
		v204 = getErrorString(p18, p19)
	end

	if NONE == t3.RECONNECT_DISABLED then
		v204 = v52
	end

	if v29 and NONE == t3.AUTO_RECONNECTING then
		if t6.baseMessage == nil then
			t6.baseMessage = v204
			t6.errorCode = p19
		end

		renderAutoReconnectPrompt()

		return
	end

	if u76 then
		if GetFFlagDisplayChannelNameOnErrorPrompt() then
			u76:onErrorChanged(v204, p19, true)

			return
		end

		u76:onErrorChanged(v204, p19)
	end
end
local function onErrorMessageChanged() -- line: 1457
	-- upvalues: GuiService (copy), updateErrorPrompt (copy)
	local ErrorMessage = GuiService:GetErrorMessage()
	local ErrorCode = GuiService:GetErrorCode()
	local ErrorType = GuiService:GetErrorType()

	updateErrorPrompt(ErrorMessage, ErrorCode, ErrorType)
end
local function onScreenSizeChanged() -- line: 1464
	-- upvalues: u76 (ref), RobloxGui (copy), AbsoluteSizeX (ref), AbsoluteSizeY (ref)
	if not u76 then
		return
	end

	local AbsoluteSizeX2 = RobloxGui.AbsoluteSize.X
	local AbsoluteSizeY2 = RobloxGui.AbsoluteSize.Y

	if AbsoluteSizeX2 ~= AbsoluteSizeX or AbsoluteSizeY2 ~= AbsoluteSizeY then
		AbsoluteSizeX = AbsoluteSizeX2
		AbsoluteSizeY = AbsoluteSizeY2
		u76:resizeWidthAndHeight(AbsoluteSizeX, AbsoluteSizeY)
	end
end

RobloxGui:GetPropertyChangedSignal("AbsoluteSize"):connect(onScreenSizeChanged)
updateErrorPrompt(GuiService:GetErrorMessage(), GuiService:GetErrorCode(), (GuiService:GetErrorType()))
GuiService.ErrorMessageChanged:connect(onErrorMessageChanged)

if v21 then
	local ErrorTestSets = require(RobloxGui.Modules.ErrorTestSets)

	for k, v in pairs(ErrorTestSets) do
		for _, v2 in pairs(v) do
			updateErrorPrompt("Should show localized strings, please file a jira ticket for missing translation.", v2, k)
			wait(2)

			if v29 then
				t6.active = false
				t6.attempt = 0
				t6.nextAttemptAt = 0
				t6.errorCode = nil
				t6.baseMessage = nil
				t6.lastRenderedText = nil
				t6.lastRemaining = nil

				if t6.pendingThread then
					task.cancel(t6.pendingThread)
					t6.pendingThread = nil
				end

				if t6.tickerThread then
					task.cancel(t6.tickerThread)
					t6.tickerThread = nil
				end
			end

			NONE = t3.NONE
		end
	end
end

if EngineFeature then
	GuiService.CoreGuiRenderOverflowed:Connect(function() -- line: 1503
		-- upvalues: CoreGui (copy)
		for _, child in pairs(CoreGui:GetChildren()) do
			if child:IsA("ScreenGui") and child.Name ~= "RobloxPromptGui" then
				child.Enabled = false
			end
		end
	end)
end

if v39 then
	coroutine.wrap(function() -- line: 1520
		-- upvalues: CorePackages (copy)
		require(CorePackages.Workspace.Packages.GenericChallenges).Middleware.InitExperienceChallengeInterceptor()
	end)()
end
