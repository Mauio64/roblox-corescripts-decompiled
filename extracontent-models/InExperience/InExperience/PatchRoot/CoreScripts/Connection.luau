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
local v25 = game:DefineFastFlag("AddConnectionErrorLocalizationKeys", false)
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
local v27 = game:DefineFastInt("PotentialClientTimeoutSeconds", 7200)
local v28 = game:DefineFastInt("MaxKickMessageLength", 200)
local v29 = game:DefineFastFlag("RefactorReconnectUnblockTeleport", false)
local EngineFeature = game:GetEngineFeature("CoreGuiOverflowDetection")
local FFlagCoreScriptShowTeleportPrompt = require(RobloxGui.Modules.Flags.FFlagCoreScriptShowTeleportPrompt)
local FFlagAllowDisconnectGuiForOkUnknown = require(RobloxGui.Modules.Flags.FFlagAllowDisconnectGuiForOkUnknown)
local v33 = game:DefineFastFlag("EnableExperienceGenericChallengeRenderingConnection2", false)
local GetFFlagDisplayChannelNameOnErrorPrompt = require(RobloxGui.Modules.Flags.GetFFlagDisplayChannelNameOnErrorPrompt)

local function safeGetFInt(p1, p2) -- line: 62
	local ok, result = pcall(function() -- line: 63
		-- upvalues: p1 (copy)
		return (tonumber(settings():GetFVariable(p1)))
	end)

	return ok and result or p2
end
local function safeGetFString(p3, p4) -- line: 69
	local ok, result = pcall(function() -- line: 70
		-- upvalues: p3 (copy)
		return settings():GetFVariable(p3)
	end)

	return ok and result or p4
end

local s1 = "DefaultTimeoutTimeMs"
local ok, result = pcall(function() -- line: 63
	-- upvalues: s1 (copy)
	return (tonumber(settings():GetFVariable(s1)))
end)
local v40 = (ok and result or 10000) / 1000
local FFlag = settings():GetFFlag("ReconnectDisabled")
local s2 = "ReconnectDisabledReason"
local ok2, result2 = pcall(function() -- line: 70
	-- upvalues: s2 (copy)
	return settings():GetFVariable(s2)
end)
local v45 = ok2 and result2 or "We're sorry, Roblox is temporarily unavailable.  Please try again later."
local timestamp = tick()
local v47 = game:DefineFastFlag("UpdateConnectionLocWarning", false)
local v48 = game:DefineFastFlag("AddPlacelaunchDeviceBlock2", false)
local v49 = game:DefineFastFlag("AddContextualPlayabilityConnectionErrors", false)
local v50 = game:DefineFastFlag("AddVipOwnerNotPresentConnectionError", false)
local v51 = game:DefineFastFlag("VipOwnerNotPresentEnableReconnect", false)
local v52 = game:DefineFastFlag("RAKickLogic2", false)
local v53 = game:DefineFastInt("RAMinEngineVersion", 725)
local v54 = false

if v52 then
	local RobloxVersion = RunService:GetRobloxVersion()
	local num = tonumber(string.match(RobloxVersion, "%.(%d+)%."))

	if num and v53 <= num then
		v54 = true
	end
end

local FFlagConnectionAmpUpsellOnLeave = require(CorePackages.Workspace.Packages.SharedFlags).FFlagConnectionAmpUpsellOnLeave
local FFlagConnectionAmpParentalApprovalUpsell = require(CorePackages.Workspace.Packages.SharedFlags).FFlagConnectionAmpParentalApprovalUpsell
local FFlagConnectionUpsellAnalytics = require(CorePackages.Workspace.Packages.SharedFlags).FFlagConnectionUpsellAnalytics
local v60 = game:DefineFastFlag("AddCollaborationCoreGatedConnectionError2", false)
local EngineFeature2 = game:GetEngineFeature("PlacelaunchCollaborationCoreGatedConnectionError")
local ConnectionAmpUpsellOnLeave = nil

if FFlagConnectionAmpUpsellOnLeave then
	ConnectionAmpUpsellOnLeave = require(RobloxGui.Modules.ConnectionAmpUpsellOnLeave)
end

local function fetchUniverseIdFromPlaceId(p5) -- line: 128
	-- upvalues: Url (copy), HttpRbxApiService (copy), HttpService (copy)
	local v112 = string.format("%suniverses/v1/places/%d/universe", Url.APIS_URL, p5)
	local ok3, result3 = pcall(HttpRbxApiService.GetAsyncFullUrl, HttpRbxApiService, v112)

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
local function translateString(s3: string, t2: {[any]: any}?) -- line: 148
	-- upvalues: LocalizationService (copy), Localization (copy), v47 (copy), Logging (copy)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local v121 = Localization.new(RobloxLocaleId)

	v121:SetLocale(RobloxLocaleId)

	local ok5, result5 = pcall(function() -- line: 153
		-- upvalues: v121 (copy), s3 (copy), t2 (copy)
		return v121:Format(s3, t2)
	end)

	if ok5 then
		return result5
	end

	if v47 then
		Logging.warn("Failed to translate string with key: " .. s3 .. ", LocaleId: " .. RobloxLocaleId)
	else
		Logging.warn("Failed to translate string with key: " .. s3)
	end

	return ""
end

local u65 = nil
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
local n2 = 1
local OK = Enum.ConnectionError.OK
local t4 = {
	[2] = "Join Error",
	[7] = "Join Error",
	[3] = "Disconnected",
	[6] = "Disconnected",
	[4] = "Teleport Failed",
	[8] = "Error",
	[9] = "Low Memory Warning",
	[10] = "Connection Failed",
	[11] = "Connection Failed"
}

if FFlagConnectionAmpUpsellOnLeave then
	t4[12] = "Join Error"
	t4[13] = "Join Error"
end

if v60 then
	t4[14] = "Join Error"
end

local t5 = {
	[2] = "InGame.ConnectionError.Title.JoinError",
	[7] = "InGame.ConnectionError.Title.JoinError",
	[3] = "InGame.ConnectionError.Title.Disconnected",
	[6] = "InGame.ConnectionError.Title.Disconnected",
	[4] = "InGame.ConnectionError.Title.TeleportFailed",
	[8] = "InGame.CommonUI.Title.Error",
	[9] = "InGame.ConnectionError.Title.LowMemoryWarning",
	[10] = "InGame.ConnectionError.Title.ConnectionFailed",
	[11] = "InGame.ConnectionError.Title.ConnectionFailed"
}

if FFlagConnectionAmpUpsellOnLeave then
	t5[12] = "InGame.ConnectionError.Title.JoinError"
	t5[13] = "InGame.ConnectionError.Title.JoinError"
end

if v60 then
	t5[14] = "InGame.ConnectionError.Title.JoinError"
end

local v74 = Create("ScreenGui")({
	Name = "RobloxPromptGui",
	OnTopOfCoreBlur = true,
	DisplayOrder = 9,
	AutoLocalize = false,
	Parent = CoreGui
})
local v75 = Create("Frame")({
	Name = "promptOverlay",
	BackgroundTransparency = 1,
	Active = false,
	BackgroundColor3 = Color3.new(0, 0, 0),
	Size = UDim2.new(1, 0, 1, 36),
	Position = UDim2.new(0, 0, 0, -36),
	Parent = v74
})

coroutine.wrap(function() -- line: 264
	-- upvalues: RobloxGui (copy), v75 (copy)
	local Constants = require(RobloxGui.Modules.TopBar.Constants)
	local v125 = Constants.ApplyDisplayScale(Constants.TopBarHeight)

	v75.Size = UDim2.new(1, 0, 1, v125)
	v75.Position = UDim2.new(0, 0, 0, -v125)
end)()

local function openCollaboratorsPageForUniverseId(p6) -- line: 273
	-- upvalues: TelemetryService (copy), t1 (copy), Url (copy), LinkingProtocol (copy)
	TelemetryService:LogCounter(t1, {
		customFields = {
			selectedItem = "ViewCollaboratorsOpenUrl"
		}
	}, 1)

	local v127 = string.format("%sdashboard/creations/experiences/%s/safety/collaborators", Url.CREATE_URL, (tostring(p6)))

	LinkingProtocol.default:openURL(v127)
end
local function v77() -- line: 309
	-- upvalues: n2 (ref), TelemetryService (copy), t1 (copy), RbxAnalyticsService (copy), u65 (ref), TeleportService (copy), FFlagCoreScriptShowTeleportPrompt (copy), v29 (copy), GuiService (copy)
	tick()

	if n2 == 5 then
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
	n2 = 5
	u65:primaryShimmerPlay()
	TelemetryService:LogCounter(t1, {
		customFields = {
			selectedItem = "ReconnectSameServer"
		}
	}, 1)
	TeleportService:TeleportReconnect()

	if FFlagCoreScriptShowTeleportPrompt then
		if v29 then
			TeleportService:UnblockAsync()

			return
		end

		GuiService:SetMenuIsOpen(false, "ErrorPrompt")
	end
end
local function v78() -- line: 341
	-- upvalues: n2 (ref), TelemetryService (copy), t1 (copy), u65 (ref), GuiService (copy), TeleportService (copy)
	if n2 == 5 then
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
	n2 = 5
	u65:primaryShimmerPlay()
	GuiService:ClearError()
	TeleportService:Teleport(PlaceId)
end
local function v79() -- line: 361
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
local function v80() -- line: 370
	-- upvalues: GuiService (copy)
	GuiService:ClearError()
end

local t6 = {
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
	[Enum.ConnectionError.DisconnectPrivateServerKickout] = true,
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
	t6[Enum.ConnectionError.DisconnectClientFailure] = true
end

if v24 then
	t6[Enum.ConnectionError.ScreentimeLockoutKick] = true
end

if v25 then
	t6[Enum.ConnectionError.DisconnectBySecurityPolicy] = true
	t6[Enum.ConnectionError.DisconnectBlockedIP] = true
	t6[Enum.ConnectionError.DisconnectCollaboratorPermissionRevoked] = true
	t6[Enum.ConnectionError.DisconnectCollaboratorUnderage] = true
end

if v48 then
	t6[Enum.ConnectionError.PlacelaunchDeviceBlock] = true
end

if v49 then
	t6[Enum.ConnectionError.PlacelaunchAgeVerificationRequired] = true
	t6[Enum.ConnectionError.PlacelaunchParentalApprovalRequired] = true
	t6[Enum.ConnectionError.PlacelaunchCoreGated] = true
end

if v50 and not v51 then
	t6[Enum.ConnectionError.PlacelaunchVipOwnerNotPresent] = true
end

local v82 = if not v60 or not EngineFeature2 then nil else Enum.ConnectionError.PlacelaunchCollaborationCoreGated

if v60 and v82 then
	t6[v82] = true
end

if v52 and v54 then
	t6[Enum.ConnectionError.DisconnectRemoteAttestationUnsupported] = true
	t6[Enum.ConnectionError.DisconnectRemoteAttestationGeneralFailure] = true
	t6[Enum.ConnectionError.DisconnectRemoteAttestationOSOutOfDate] = true
	t6[Enum.ConnectionError.DisconnectRemoteAttestationBootValidationFailure] = true
end

local t7 = {
	[2] = {
		{
			Text = "Retry",
			LocalizationKey = "InGame.CommonUI.Button.Retry",
			LayoutOrder = 2,
			Primary = true,
			Callback = v77
		},
		{
			Text = "Cancel",
			LocalizationKey = "Feature.SettingsHub.Action.CancelSearch",
			LayoutOrder = 1,
			Callback = v79
		}
	},
	[3] = {
		{
			Text = "Reconnect",
			LocalizationKey = "InGame.ConnectionError.Button.Reconnect",
			LayoutOrder = 2,
			Primary = true,
			Callback = v77
		},
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 1,
			Callback = v79
		}
	},
	[4] = {{
		Text = "OK",
		LocalizationKey = "InGame.CommonUI.Button.Ok",
		LayoutOrder = 1,
		Primary = true,
		Callback = v80
	}},
	[6] = {{
		Text = "Leave",
		LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
		LayoutOrder = 1,
		Primary = true,
		Callback = v79
	}},
	[7] = {{
		Text = "Leave",
		LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
		LayoutOrder = 1,
		Primary = true,
		Callback = v79
	}},
	[8] = {{
		Text = "Leave",
		LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
		LayoutOrder = 1,
		Primary = true,
		Callback = v79
	}},
	[9] = {
		{
			Text = "Keep Playing",
			LocalizationKey = "InGame.CommonUI.Button.KeepPlaying",
			LayoutOrder = 1,
			Callback = v80
		},
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 2,
			Primary = true,
			Callback = v79
		}
	},
	[10] = {
		{
			Text = "Retry",
			LocalizationKey = "InGame.CommonUI.Button.Retry",
			LayoutOrder = 2,
			Primary = true,
			Callback = v77
		},
		{
			Text = "Cancel",
			LocalizationKey = "Feature.SettingsHub.Action.CancelSearch",
			LayoutOrder = 1,
			Callback = v79
		}
	},
	[11] = {{
		Text = "Leave",
		LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
		LayoutOrder = 1,
		Primary = true,
		Callback = v79
	}}
}

if FFlagConnectionAmpUpsellOnLeave then
	local v84 = ConnectionAmpUpsellOnLeave.createAgeCheckCallback(t1, v78, 9)

	t7[12] = {
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 1,
			Callback = v79
		},
		{
			LayoutOrder = 2,
			Primary = true,
			Text = ConnectionAmpUpsellOnLeave.PrimaryButtonText,
			LocalizationKey = ConnectionAmpUpsellOnLeave.PrimaryButtonLocalizationKey,
			Callback = v84
		}
	}
end

if FFlagConnectionAmpParentalApprovalUpsell then
	local v85 = ConnectionAmpUpsellOnLeave.createParentalApprovalCallback(t1, v78, 9)

	t7[13] = {
		{
			Text = "Leave",
			LocalizationKey = "Feature.SettingsHub.Label.LeaveButton",
			LayoutOrder = 1,
			Callback = v79
		},
		{
			LayoutOrder = 2,
			Primary = true,
			Text = ConnectionAmpUpsellOnLeave.PrimaryButtonText,
			LocalizationKey = ConnectionAmpUpsellOnLeave.PrimaryButtonLocalizationKey,
			Callback = v85
		}
	}
end

if v60 then
	t7[14] = {
		{
			Text = "Ok",
			LocalizationKey = "InGame.ConnectionError.Action.Ok",
			LayoutOrder = 1,
			Callback = v79
		},
		{
			Text = "View collaborators",
			LocalizationKey = "InGame.ConnectionError.Action.ViewCollaborators",
			LayoutOrder = 2,
			Primary = true,
			Callback = function() -- line: 284
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

				coroutine.wrap(function() -- line: 299
					-- upvalues: fetchUniverseIdFromPlaceId (copy), PlaceId (copy), TelemetryService (copy), t1 (copy), openCollaboratorsPageForUniverseId (copy)
					local v171 = fetchUniverseIdFromPlaceId(PlaceId)

					if not v171 then
						TelemetryService:LogCounter(t1, {
							customFields = {
								selectedItem = "ViewCollaboratorsUniverseIdLookupFailed"
							}
						}, 1)

						return
					end

					openCollaboratorsPageForUniverseId(v171)
				end)()
			end
		}
	}
end

local t8 = {
	[1] = function() -- line: 627
		-- upvalues: RunService (copy), v75 (copy)
		RunService:SetRobloxGuiFocused(false)
		v75.Active = false
		v75.Transparency = 1
	end,
	[3] = function() -- line: 632
		-- upvalues: VRService (copy), RunService (copy), v75 (copy)
		if VRService.VREnabled then
			RunService:SetRobloxGuiFocused(false)
		else
			RunService:SetRobloxGuiFocused(true)
		end

		v75.Active = true
		v75.Transparency = 1
	end,
	[2] = function() -- line: 641
		-- upvalues: RunService (copy), v75 (copy)
		RunService:SetRobloxGuiFocused(false)
		v75.Active = true
		v75.Transparency = 0.3
	end,
	[4] = function() -- line: 646
		-- upvalues: RunService (copy), v75 (copy)
		RunService:SetRobloxGuiFocused(false)
		v75.Active = true
		v75.Transparency = 0.3
	end,
	[6] = function() -- line: 651
		-- upvalues: VRService (copy), RunService (copy), v75 (copy)
		if VRService.VREnabled then
			RunService:SetRobloxGuiFocused(false)
		else
			RunService:SetRobloxGuiFocused(true)
		end

		v75.Active = true
		v75.Transparency = 1
	end,
	[7] = function() -- line: 660
		-- upvalues: RunService (copy), v75 (copy)
		RunService:SetRobloxGuiFocused(false)
		v75.Active = true
		v75.Transparency = 0.3
	end,
	[8] = function() -- line: 665
		-- upvalues: VRService (copy), RunService (copy), v75 (copy)
		if VRService.VREnabled then
			RunService:SetRobloxGuiFocused(false)
		else
			RunService:SetRobloxGuiFocused(true)
		end

		v75.Active = true
		v75.Transparency = 1
	end,
	[10] = function() -- line: 674
		-- upvalues: RunService (copy), v75 (copy)
		RunService:SetRobloxGuiFocused(false)
		v75.Active = true
		v75.Transparency = 0.3
	end,
	[11] = function() -- line: 679
		-- upvalues: RunService (copy), v75 (copy)
		RunService:SetRobloxGuiFocused(false)
		v75.Active = true
		v75.Transparency = 0.3
	end
}

if FFlagConnectionAmpUpsellOnLeave then
	local v87 = t8[2]

	t8[12] = v87

	if FFlagConnectionAmpParentalApprovalUpsell then
		t8[13] = v87
	end
end

if v60 then
	t8[14] = function() -- line: 699
		-- upvalues: RunService (copy), v75 (copy)
		RunService:SetRobloxGuiFocused(false)
		v75.Active = true
		v75.Transparency = 0.3
	end
end

local function onEnter(p7) -- line: 706
	-- upvalues: u65 (ref), v21 (copy), ErrorPrompt (copy), v75 (copy), AbsoluteSizeX (ref), AbsoluteSizeY (ref), t8 (copy), t4 (copy), t5 (copy), t7 (copy)
	if not u65 then
		local t9 = {
			MenuIsOpenKey = "ConnectionErrorPrompt",
			PlayAnimation = not v21
		}

		u65 = ErrorPrompt.new("Default", t9)
		u65:setParent(v75)
		u65:resizeWidthAndHeight(AbsoluteSizeX, AbsoluteSizeY)
	end

	if t8[p7] then
		t8[p7]()
	end

	u65:setErrorTitle(t4[p7], t5[p7])
	u65:updateButtons(t7[p7])
end
local function onExit(p8) -- line: 723
	-- upvalues: u65 (ref)
	if p8 == 5 then
		u65:primaryShimmerStop()
	end
end
local function stateTransit(p9, p10, p11) -- line: 730
	-- upvalues: FFlagAllowDisconnectGuiForOkUnknown (copy), FFlag (copy), timestamp (ref), n1 (ref), v40 (copy), OK (ref), t6 (copy), TelemetryService (copy), t1 (copy), RbxAnalyticsService (copy), FFlagConnectionAmpUpsellOnLeave (copy), ConnectionAmpUpsellOnLeave (ref), FFlagConnectionUpsellAnalytics (copy), FFlagConnectionAmpParentalApprovalUpsell (copy), v60 (copy), v82 (copy), v27 (copy)
	if FFlagAllowDisconnectGuiForOkUnknown then
		if p10 == Enum.ConnectionError.OK then
			return 1
		end
	elseif p9 == Enum.ConnectionError.OK then
		return 1
	end

	if p11 == 1 then
		if FFlag then
			return 8
		end

		timestamp = tick()

		if FFlagAllowDisconnectGuiForOkUnknown then
			assert(p10 ~= Enum.ConnectionError.OK)

			if p9 == Enum.ConnectionError.OK then
				return 3
			end
		end

		if p9 == Enum.ConnectionError.ConnectErrors then
			n1 = tick() + v40
			OK = Enum.ConnectionError.ConnectErrors

			if t6[p10] then
				return 11
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

			return 10
		end

		if p9 == Enum.ConnectionError.DisconnectErrors then
			n1 = tick() + v40
			OK = Enum.ConnectionError.DisconnectErrors

			if p10 == Enum.ConnectionError.DisconnectOutOfMemoryKeepPlayingLeave then
				return 9
			end

			if t6[p10] then
				return 6
			end

			TelemetryService:LogCounter(t1, {
				customFields = {
					selectedItem = "Disconnected"
				}
			}, 1)
			RbxAnalyticsService:ReportCounter("ReconnectPrompt-Disconnect")

			return 3
		end

		if p9 == Enum.ConnectionError.PlacelaunchErrors then
			OK = Enum.ConnectionError.PlacelaunchErrors

			if FFlagConnectionAmpUpsellOnLeave then
				local AgeVerificationRequiredEnum = ConnectionAmpUpsellOnLeave.AgeVerificationRequiredEnum

				if AgeVerificationRequiredEnum and p10 == AgeVerificationRequiredEnum then
					TelemetryService:LogCounter(t1, {
						customFields = {
							selectedItem = "PlaceLaunchAgeVerificationRequired"
						}
					}, 1)

					if FFlagConnectionUpsellAnalytics then
						ConnectionAmpUpsellOnLeave.fireImpressionAgeCheck(t1, game.PlaceId)
					end

					return 12
				end
			end

			if FFlagConnectionAmpParentalApprovalUpsell then
				local ParentalApprovalRequiredEnum = ConnectionAmpUpsellOnLeave.ParentalApprovalRequiredEnum

				if ParentalApprovalRequiredEnum and p10 == ParentalApprovalRequiredEnum then
					TelemetryService:LogCounter(t1, {
						customFields = {
							selectedItem = "PlaceLaunchParentalApprovalRequired"
						}
					}, 1)

					if FFlagConnectionUpsellAnalytics then
						ConnectionAmpUpsellOnLeave.fireImpressionParentalApproval(t1, game.PlaceId)
					end

					return 13
				end
			end

			if v60 and v82 and p10 == v82 then
				TelemetryService:LogCounter(t1, {
					customFields = {
						selectedItem = "PlaceLaunchCollaborationCoreGated"
					}
				}, 1)

				return 14
			end

			if t6[p10] then
				return 7
			end

			TelemetryService:LogCounter(t1, {
				customFields = {
					selectedItem = "PlaceLaunchError"
				}
			}, 1)
			RbxAnalyticsService:ReportCounter("ReconnectPrompt-PlaceLaunch")

			return 2
		end

		if p9 == Enum.ConnectionError.TeleportErrors then
			TelemetryService:LogCounter(t1, {
				customFields = {
					selectedItem = "TeleportError"
				}
			}, 1)
			RbxAnalyticsService:ReportCounter("ReconnectPrompt-TeleportFailed")

			return 4
		end
	end

	if p11 == 5 then
		TelemetryService:LogCounter(t1, {
			customFields = {
				selectedItem = "ReconnectFailed"
			}
		}, 1)
		RbxAnalyticsService:ReportCounter("ReconnectPrompt-ReconnectFailed")

		if p9 == Enum.ConnectionError.TeleportErrors then
			if tick() > timestamp + v27 then
				TelemetryService:LogCounter(t1, {
					customFields = {
						selectedItem = "ReconnectTimedOut"
					}
				}, 1)

				if OK == Enum.ConnectionError.PlacelaunchErrors then
					return 7
				end

				return 6
			end

			if OK == Enum.ConnectionError.PlacelaunchErrors then
				TelemetryService:LogCounter(t1, {
					customFields = {
						selectedItem = "PlaceLaunchReconnectFailed"
					}
				}, 1)

				return 2
			end

			if OK == Enum.ConnectionError.DisconnectErrors then
				TelemetryService:LogCounter(t1, {
					customFields = {
						selectedItem = "DisconnectReconnectFailed"
					}
				}, 1)

				return 3
			end

			if OK == Enum.ConnectionError.ConnectErrors then
				TelemetryService:LogCounter(t1, {
					customFields = {
						selectedItem = "ConnectReconnectFailed"
					}
				}, 1)

				return 10
			end
		end
	end

	return p11
end
local function getCreatorBanString(s4: string) -- line: 853
	-- upvalues: GuiService (copy), translateString (copy)
	local ErrorDetails = GuiService:GetErrorDetails()

	if ErrorDetails then
		local v147

		if ErrorDetails.time then
			local minutes = ErrorDetails.minutes
			local hours = ErrorDetails.hours
			local days = ErrorDetails.days
			local v144 = if minutes ~= 1 then translateString("InGame.ConnectionError.CreatorBanMinutesPlural", {
				RBX_TIME_MINUTES = minutes
			}) else translateString("InGame.ConnectionError.CreatorBanMinutesSingular")
			local v145 = if hours ~= 1 then translateString("InGame.ConnectionError.CreatorBanHoursPlural", {
				RBX_TIME_HOURS = hours
			}) else translateString("InGame.ConnectionError.CreatorBanHoursSingular")
			local v146 = if days ~= 1 then translateString("InGame.ConnectionError.CreatorBanDaysPlural", {
				RBX_TIME_DAYS = days
			}) else translateString("InGame.ConnectionError.CreatorBanDaysSingular")

			if v144 == "" or v145 == "" or v146 == "" then
				return s4
			end

			if hours > 0 then
				v144 = v145 .. ", " .. v144
			end

			if days > 0 then
				v144 = v146 .. ", " .. v144
			end

			v147 = translateString("InGame.ConnectionError.CreatorBanWithTime", {
				RBX_TIME_REMAINING = v144
			})
		else
			v147 = translateString("InGame.ConnectionError.CreatorBanNoTime")
		end

		if v147 == "" then
			return s4
		end

		local displayReason = ErrorDetails.displayReason

		if displayReason and displayReason ~= "" then
			local v149 = translateString("InGame.ConnectionError.CreatorBanMessage", {
				RBX_STR = displayReason
			})

			if v149 ~= "" then
				return v147 .. " " .. v149
			end

			return s4
		end

		return v147
	end

	return s4
end

local v92 = game:DefineFastFlag("RemoveRefToMissingLocInConnection", false)
local t10 = {
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
	[Enum.ConnectionError.DisconnectBySecurityPolicy] = not v92 and "InGame.ConnectionError.DisconnectBySecurityPolicy" or nil,
	[Enum.ConnectionError.DisconnectBlockedIP] = not v92 and "InGame.ConnectionError.DisconnectBlockedIP" or nil,
	[Enum.ConnectionError.DisconnectClientFailure] = not v92 and "InGame.ConnectionError.DisconnectClientFailure" or nil,
	[Enum.ConnectionError.DisconnectClientRequest] = not v92 and "InGame.ConnectionError.DisconnectClientRequest" or nil,
	[Enum.ConnectionError.DisconnectPrivateServerKickout] = "InGame.ConnectionError.DisconnectPrivateServerKickout",
	[Enum.ConnectionError.DisconnectModeratedGame] = not v92 and "InGame.ConnectionError.DisconnectModeratedGame" or nil,
	[Enum.ConnectionError.ServerShutdown] = not v92 and "InGame.ConnectionError.ServerShutdown" or nil,
	[Enum.ConnectionError.ReplicatorTimeout] = not v92 and "InGame.ConnectionError.ReplicatorTimeout" or nil,
	[Enum.ConnectionError.PlayerRemoved] = not v92 and "InGame.ConnectionError.PlayerRemoved" or nil,
	[Enum.ConnectionError.DisconnectOutOfMemoryKeepPlayingLeave] = "InGame.ConnectionError.DisconnectOutOfMemoryKeepPlayingLeave",
	[Enum.ConnectionError.DisconnectRomarkEndOfTest] = not v92 and "InGame.ConnectionError.DisconnectRomarkEndOfTest" or nil,
	[Enum.ConnectionError.DisconnectCollaboratorPermissionRevoked] = not v92 and "InGame.ConnectionError.DisconnectCollaboratorPermissionRevoked" or nil,
	[Enum.ConnectionError.DisconnectCollaboratorUnderage] = not v92 and "InGame.ConnectionError.DisconnectCollaboratorUnderage" or nil,
	[Enum.ConnectionError.NetworkInternal] = not v92 and "InGame.ConnectionError.NetworkInternal" or nil,
	[Enum.ConnectionError.NetworkSend] = not v92 and "InGame.ConnectionError.NetworkSend" or nil,
	[Enum.ConnectionError.NetworkTimeout] = not v92 and "InGame.ConnectionError.NetworkTimeout" or nil,
	[Enum.ConnectionError.NetworkMisbehavior] = not v92 and "InGame.ConnectionError.NetworkMisbehavior" or nil,
	[Enum.ConnectionError.NetworkSecurity] = not v92 and "InGame.ConnectionError.NetworkSecurity" or nil,
	[Enum.ConnectionError.ReplacementReady] = not v92 and "InGame.ConnectionError.ReplacementReady" or nil,
	[Enum.ConnectionError.ServerEmpty] = not v92 and "InGame.ConnectionError.ServerEmpty" or nil,
	[Enum.ConnectionError.PhantomFreeze] = not v92 and "InGame.ConnectionError.PhantomFreeze" or nil,
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
	[Enum.ConnectionError.PlacelaunchCreatorBan] = not v92 and "InGame.ConnectionError.PlacelaunchCreatorBan" or nil,
	[Enum.ConnectionError.PlacelaunchCustomMessage] = not v92 and "InGame.ConnectionError.PlacelaunchCustomMessage" or nil,
	[Enum.ConnectionError.PlacelaunchOtherError] = "InGame.ConnectionError.PlacelaunchOtherError",
	[Enum.ConnectionError.TeleportErrors] = "InGame.ConnectionError.TeleportErrors",
	[Enum.ConnectionError.TeleportFailure] = "InGame.ConnectionError.TeleportFailure",
	[Enum.ConnectionError.TeleportGameNotFound] = "InGame.ConnectionError.TeleportGameNotFound",
	[Enum.ConnectionError.TeleportGameEnded] = "InGame.ConnectionError.TeleportGameEnded",
	[Enum.ConnectionError.TeleportGameFull] = "InGame.ConnectionError.TeleportGameFull",
	[Enum.ConnectionError.TeleportUnauthorized] = "InGame.ConnectionError.TeleportUnauthorized",
	[Enum.ConnectionError.TeleportFlooded] = "InGame.ConnectionError.TeleportFlooded",
	[Enum.ConnectionError.TeleportIsTeleporting] = not v92 and "InGame.ConnectionError.TeleportIsTeleporting" or nil,
	[Enum.ConnectionError.DisconnectVerboselyModeratedGame] = "InGame.ConnectionError.DisconnectVerboselyModeratedGame"
}

if v24 then
	t10[Enum.ConnectionError.ScreentimeLockoutKick] = "Feature.Screentime.Content.ScreentimeLimitDialog"
end

if v25 then
	t10[Enum.ConnectionError.DisconnectBySecurityPolicy] = "InGame.ConnectionError.DisconnectBlockedConnection"
	t10[Enum.ConnectionError.DisconnectBlockedIP] = "InGame.ConnectionError.DisconnectBlockedConnection"
	t10[Enum.ConnectionError.DisconnectClientFailure] = "InGame.ConnectionError.DisconnectClientFailure"
	t10[Enum.ConnectionError.DisconnectClientRequest] = "InGame.ConnectionError.DisconnectClientRequest"
	t10[Enum.ConnectionError.DisconnectModeratedGame] = "InGame.ConnectionError.ServerShutdown"
	t10[Enum.ConnectionError.ServerShutdown] = "InGame.ConnectionError.ServerShutdown"
	t10[Enum.ConnectionError.ReplicatorTimeout] = "InGame.ConnectionError.DisconnectTryAgain"
	t10[Enum.ConnectionError.PlayerRemoved] = "InGame.ConnectionError.DisconnectTryAgain"
	t10[Enum.ConnectionError.DisconnectRomarkEndOfTest] = "InGame.ConnectionError.DisconnectTryAgain"
	t10[Enum.ConnectionError.DisconnectCollaboratorPermissionRevoked] = "InGame.ConnectionError.DisconnectCollaboratorPermissionRevoked"
	t10[Enum.ConnectionError.DisconnectCollaboratorUnderage] = "InGame.ConnectionError.DisconnectCollaboratorUnderage"
	t10[Enum.ConnectionError.NetworkInternal] = "InGame.ConnectionError.DisconnectTryAgain"
	t10[Enum.ConnectionError.NetworkSend] = "InGame.ConnectionError.DisconnectTryAgain"
	t10[Enum.ConnectionError.NetworkTimeout] = "InGame.ConnectionError.DisconnectTryAgain"
	t10[Enum.ConnectionError.NetworkMisbehavior] = "InGame.ConnectionError.DisconnectTryAgain"
	t10[Enum.ConnectionError.NetworkSecurity] = "InGame.ConnectionError.DisconnectTryAgain"
	t10[Enum.ConnectionError.ReplacementReady] = "InGame.ConnectionError.DisconnectTryAgain"
	t10[Enum.ConnectionError.ServerEmpty] = "InGame.ConnectionError.DisconnectTryAgain"
	t10[Enum.ConnectionError.PhantomFreeze] = "InGame.ConnectionError.DisconnectTryAgain"
	t10[Enum.ConnectionError.PlacelaunchCreatorBan] = "InGame.ConnectionError.CreatorBanNoTime"
end

if v48 then
	t10[Enum.ConnectionError.PlacelaunchDeviceBlock] = "InGame.ConnectionError.PlacelaunchDeviceBlock"
end

if v49 then
	t10[Enum.ConnectionError.PlacelaunchAgeVerificationRequired] = "InGame.ConnectionError.Description.AgeCheckRequired"
	t10[Enum.ConnectionError.PlacelaunchParentalApprovalRequired] = "InGame.ConnectionError.Description.ParentalApprovalRequired"
	t10[Enum.ConnectionError.PlacelaunchCoreGated] = "InGame.ConnectionError.Description.LockedByAge"
end

if v50 then
	t10[Enum.ConnectionError.PlacelaunchVipOwnerNotPresent] = "InGame.ConnectionError.Description.VipOwnerNotPresent"
end

if v60 and v82 then
	t10[v82] = "InGame.ConnectionError.Description.CollaborationRequiresTrustedFriends"
end

if v52 and v54 then
	t10[Enum.ConnectionError.DisconnectRemoteAttestationTimeout] = "InGame.ConnectionError.RemoteAttestationTimeout"
	t10[Enum.ConnectionError.DisconnectRemoteAttestationUnsupported] = "InGame.ConnectionError.RemoteAttestationUnsupported"
	t10[Enum.ConnectionError.DisconnectRemoteAttestationGeneralFailure] = "InGame.ConnectionError.RemoteAttestationGeneralFailure"
	t10[Enum.ConnectionError.DisconnectRemoteAttestationOSOutOfDate] = "InGame.ConnectionError.RemoteAttestationOSOutOfDate"
	t10[Enum.ConnectionError.DisconnectRemoteAttestationBootValidationFailure] = "InGame.ConnectionError.RemoteAttestationBootValidationFailure"
end

local function getErrorString(s5: string, p12, p13) -- line: 1064
	-- upvalues: translateString (copy), v28 (copy), v23 (copy), t10 (copy), mutedError (copy), v22 (copy)
	if p12 == Enum.ConnectionError.OK then
		return ""
	end

	if p13 then
		local v153 = translateString("InGame.ConnectionError.ReconnectFailed")

		if v153 ~= "" then
			return v153
		end

		return "Reconnect was unsuccessful. Please try again."
	end

	if p12 == Enum.ConnectionError.DisconnectLuaKick and s5 ~= "" then
		local v154 = s5:sub(1, v28)
		local v155 = translateString("InGame.ConnectionError.DisconnectLuaKickWithMessage", {
			RBX_STR = v154
		})

		if v155 ~= "" then
			return v155
		end

		return v154
	end

	local v156

	if v23 then
		v156 = t10[p12]

		if not v156 then
			mutedError("Cannot find localization key for " .. tostring(p12))
			v156 = "InGame.ConnectionError.UnknownError"
		end
	else
		v156 = string.gsub(tostring(p12), "Enum", "InGame")
	end

	local v157 = if p12 ~= Enum.ConnectionError.DisconnectIdle then translateString(v156) else translateString(v156, {
		RBX_NUM = tostring(20)
	})

	if v157 ~= "" then
		return v157
	end

	if v22 then
		return (translateString("InGame.ConnectionError.UnknownError"))
	end

	return s5
end
local function updateErrorPrompt(p14, p15, p16) -- line: 1118
	-- upvalues: stateTransit (copy), n2 (ref), t3 (copy), u65 (ref), onEnter (copy), getCreatorBanString (copy), translateString (copy), getErrorString (copy), v45 (copy), GetFFlagDisplayChannelNameOnErrorPrompt (copy)
	local v161 = stateTransit(p16, p15, n2)

	if v161 ~= n2 then
		if n2 == t3.IS_RECONNECTING then
			u65:primaryShimmerStop()
		end

		n2 = v161
		onEnter(v161)
	end

	local v162

	if p15 == Enum.ConnectionError.PlacelaunchCreatorBan then
		v162 = getCreatorBanString(p14)
	elseif p16 == Enum.ConnectionError.TeleportErrors and n2 ~= 4 then
		if p15 == Enum.ConnectionError.OK then
			v162 = ""
		else
			local v163 = translateString("InGame.ConnectionError.ReconnectFailed")

			v162 = v163 == "" and "Reconnect was unsuccessful. Please try again." or v163
		end
	else
		v162 = getErrorString(p14, p15)
	end

	if n2 == 8 then
		v162 = v45
	end

	if u65 then
		if GetFFlagDisplayChannelNameOnErrorPrompt() then
			u65:onErrorChanged(v162, p15, true)

			return
		end

		u65:onErrorChanged(v162, p15)
	end
end
local function onErrorMessageChanged() -- line: 1149
	-- upvalues: GuiService (copy), updateErrorPrompt (copy)
	local ErrorMessage = GuiService:GetErrorMessage()
	local ErrorCode = GuiService:GetErrorCode()
	local ErrorType = GuiService:GetErrorType()

	updateErrorPrompt(ErrorMessage, ErrorCode, ErrorType)
end
local function onScreenSizeChanged() -- line: 1156
	-- upvalues: u65 (ref), RobloxGui (copy), AbsoluteSizeX (ref), AbsoluteSizeY (ref)
	if not u65 then
		return
	end

	local AbsoluteSizeX2 = RobloxGui.AbsoluteSize.X
	local AbsoluteSizeY2 = RobloxGui.AbsoluteSize.Y

	if AbsoluteSizeX2 ~= AbsoluteSizeX or AbsoluteSizeY2 ~= AbsoluteSizeY then
		AbsoluteSizeX = AbsoluteSizeX2
		AbsoluteSizeY = AbsoluteSizeY2
		u65:resizeWidthAndHeight(AbsoluteSizeX, AbsoluteSizeY)
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
			n2 = 1
		end
	end
end

if EngineFeature then
	GuiService.CoreGuiRenderOverflowed:Connect(function() -- line: 1192
		-- upvalues: CoreGui (copy)
		for _, child in pairs(CoreGui:GetChildren()) do
			if child:IsA("ScreenGui") and child.Name ~= "RobloxPromptGui" then
				child.Enabled = false
			end
		end
	end)
end

if v33 then
	coroutine.wrap(function() -- line: 1209
		-- upvalues: CorePackages (copy)
		require(CorePackages.Workspace.Packages.GenericChallenges).Middleware.InitExperienceChallengeInterceptor()
	end)()
end
