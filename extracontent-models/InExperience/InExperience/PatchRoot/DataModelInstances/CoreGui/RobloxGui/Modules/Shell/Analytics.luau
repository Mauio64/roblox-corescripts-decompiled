local RobloxGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local Shell = RobloxGui:FindFirstChild("Modules"):FindFirstChild("Shell")
local EventStream = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventStream
local userInteractions = require(CorePackages.Workspace.Packages.Analytics).Events.userInteractions
local pageHeartbeat = require(CorePackages.Workspace.Packages.Analytics).Events.pageHeartbeat
local contentHistory = require(Shell.XboxPrimaryNav:FindFirstChild("contentHistory"))
local XboxPrimaryNavIXPTest = require(Shell.Experiment.XboxPrimaryNavIXPTest)
local GetFIntXboxPrimaryNavABLogging = require(Shell.Flags.GetFIntXboxPrimaryNavABLogging)
local RbxAnalyticsService = nil

pcall(function() -- line: 22
	-- upvalues: RbxAnalyticsService (ref)
	RbxAnalyticsService = game:GetService("RbxAnalyticsService")
end)

local EventIngestService = game:GetService("EventIngestService")
local UserInputService = game:GetService("UserInputService")
local v13 = EventStream.new(RbxAnalyticsService)
local t1 = {}
local t2 = {
	TenFoot = "tenFoot",
	Classic = "classic"
}

local function getNavigationVersion() -- line: 35
	-- upvalues: XboxPrimaryNavIXPTest (copy)
	if XboxPrimaryNavIXPTest.isUserEnrolled() then
		return "tenFoot"
	end

	return "classic"
end
local function setRBXEvent(p1, p2) -- line: 44
	-- upvalues: UserInputService (copy), EventIngestService (copy)
	local s1 = nil
	local s2 = nil
	local ok, _ = pcall(function() -- line: 46
		-- upvalues: UserInputService (copy), s1 (ref), s2 (ref), p1 (ref), p2 (ref), EventIngestService (copy)
		if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			s1 = "console"
			s2 = "XboxOne"
			p1 = p1 or ""
			p2 = p2 or {}
			EventIngestService:SetRBXEvent(s1, s2, p1, p2)
		end
	end)

	return ok
end
local function setRBXEventStream(p3, p4) -- line: 59
	-- upvalues: UserInputService (copy), EventIngestService (copy)
	local s3 = nil
	local s4 = nil
	local ok, _ = pcall(function() -- line: 61
		-- upvalues: UserInputService (copy), s3 (ref), s4 (ref), p3 (ref), p4 (ref), EventIngestService (copy)
		if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			s3 = "console"
			s4 = "XboxOne"
			p3 = p3 or ""
			p4 = p4 or {}
			EventIngestService:SetRBXEventStream(s3, s4, p3, p4)
		end
	end)

	return ok
end
local function releaseRBXEventStream(_) -- line: 74
	-- upvalues: UserInputService (copy), RbxAnalyticsService (ref)
	local s5 = nil
	local ok, _ = pcall(function() -- line: 76
		-- upvalues: UserInputService (copy), s5 (ref), RbxAnalyticsService (ref)
		if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			s5 = "console"
			RbxAnalyticsService:ReleaseRBXEventStream(s5)
		end
	end)

	return ok
end
local function updateHeartbeatObject(p6) -- line: 86
	-- upvalues: RbxAnalyticsService (ref)
	local ok, _ = pcall(function() -- line: 87
		-- upvalues: RbxAnalyticsService (ref), p6 (copy)
		RbxAnalyticsService:UpdateHeartbeatObject(p6)
	end)

	return ok
end
local function reportCounter(p7, p8) -- line: 94
	-- upvalues: UserInputService (copy), RbxAnalyticsService (ref)
	local ok, _ = pcall(function() -- line: 95
		-- upvalues: UserInputService (copy), p7 (ref), p8 (ref), RbxAnalyticsService (ref)
		if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			p7 = p7 or ""
			p7 = "Xbox-" .. tostring(p7)
			p8 = p8 or 1
			RbxAnalyticsService:ReportCounter(p7, p8)
		end
	end)

	return ok
end

function t1.SetRBXEvent(p9, p10) -- line: 108
	-- upvalues: UserInputService (copy), EventIngestService (copy)
	local s6 = nil
	local s7 = nil
	local _, _ = pcall(function() -- line: 46
		-- upvalues: UserInputService (copy), s6 (ref), s7 (ref), p9 (ref), p10 (ref), EventIngestService (copy)
		if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			s6 = "console"
			s7 = "XboxOne"
			p9 = p9 or ""
			p10 = p10 or {}
			EventIngestService:SetRBXEvent(s6, s7, p9, p10)
		end
	end)
end
function t1.SetRBXEventStream(p11, p12) -- line: 113
	-- upvalues: UserInputService (copy), EventIngestService (copy)
	local s8 = nil
	local s9 = nil
	local _, _ = pcall(function() -- line: 61
		-- upvalues: UserInputService (copy), s8 (ref), s9 (ref), p11 (ref), p12 (ref), EventIngestService (copy)
		if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			s8 = "console"
			s9 = "XboxOne"
			p11 = p11 or ""
			p12 = p12 or {}
			EventIngestService:SetRBXEventStream(s8, s9, p11, p12)
		end
	end)
end
function t1.UpdateHeartbeatObject(p13) -- line: 117
	-- upvalues: RbxAnalyticsService (ref)
	local _, _ = pcall(function() -- line: 87
		-- upvalues: RbxAnalyticsService (ref), p13 (copy)
		RbxAnalyticsService:UpdateHeartbeatObject(p13)
	end)
end
function t1.ReportCounter(p14, p15) -- line: 122
	-- upvalues: UserInputService (copy), RbxAnalyticsService (ref)
	local _, _ = pcall(function() -- line: 95
		-- upvalues: UserInputService (copy), p14 (ref), p15 (ref), RbxAnalyticsService (ref)
		if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			p14 = p14 or ""
			p14 = "Xbox-" .. tostring(p14)
			p15 = p15 or 1
			RbxAnalyticsService:ReportCounter(p14, p15)
		end
	end)
end
function t1.reportPageChanged() -- line: 126
	-- upvalues: userInteractions (copy), v13 (copy)
	userInteractions(v13, "luaPage")
end
function t1.reportPageHeartbeat(p16, p17) -- line: 131
	-- upvalues: pageHeartbeat (copy), v13 (copy)
	pageHeartbeat(v13, p16, p17)
end
function t1.reportNavigation(p18, p19, p20) -- line: 135
	-- upvalues: contentHistory (copy), XboxPrimaryNavIXPTest (copy), t2 (copy), UserInputService (copy), EventIngestService (copy), GetFIntXboxPrimaryNavABLogging (copy)
	local v84 = contentHistory:getLastContentName()

	if p19 ~= v84 then
		local s10 = "Navigation"
		local t3 = {
			activationType = p18,
			toContent = p19,
			fromContent = v84,
			contentType = p20,
			navigationVersion = if not XboxPrimaryNavIXPTest.isUserEnrolled() then t2.Classic else t2.TenFoot
		}
		local s11 = nil
		local s12 = nil
		local _, _ = pcall(function() -- line: 61
			-- upvalues: UserInputService (copy), s11 (ref), s12 (ref), s10 (ref), t3 (ref), EventIngestService (copy)
			if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
				s11 = "console"
				s12 = "XboxOne"
				s10 = s10 or ""
				t3 = t3 or {}
				EventIngestService:SetRBXEventStream(s11, s12, s10, t3)
			end
		end)

		if GetFIntXboxPrimaryNavABLogging() > 1 then
			print("[ANALYTICS] Navigation", "ActivationType:", p18, "| ContentName:", p19, "| ContentType:", p20, "| PrevContentName:", v84, "| NavigationVersion:", if not XboxPrimaryNavIXPTest.isUserEnrolled() then t2.Classic else t2.TenFoot)
		end
	end
end

local function reportNavigationLoaded(p21) -- line: 153
	-- upvalues: contentHistory (copy), XboxPrimaryNavIXPTest (copy), t2 (copy), UserInputService (copy), EventIngestService (copy), GetFIntXboxPrimaryNavABLogging (copy)
	local v92 = contentHistory:getLastContentName()

	if p21 ~= v92 then
		local s13 = "NavigationLoaded"
		local t4 = {
			toContent = p21,
			fromContent = v92,
			navigationVersion = if not XboxPrimaryNavIXPTest.isUserEnrolled() then t2.Classic else t2.TenFoot
		}
		local s14 = nil
		local s15 = nil
		local _, _ = pcall(function() -- line: 61
			-- upvalues: UserInputService (copy), s14 (ref), s15 (ref), s13 (ref), t4 (ref), EventIngestService (copy)
			if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
				s14 = "console"
				s15 = "XboxOne"
				s13 = s13 or ""
				t4 = t4 or {}
				EventIngestService:SetRBXEventStream(s14, s15, s13, t4)
			end
		end)

		if GetFIntXboxPrimaryNavABLogging() > 1 then
			print("[ANALYTICS] NavigationLoaded ContentName:", p21, "| PrevContentName:", v92, "| NavigationVersion:", if not XboxPrimaryNavIXPTest.isUserEnrolled() then t2.Classic else t2.TenFoot)
		end
	end
end

function t1.reportNavigationLoaded(p22) -- line: 174
	-- upvalues: XboxPrimaryNavIXPTest (copy), reportNavigationLoaded (copy)
	if XboxPrimaryNavIXPTest.isUserEnrolled() then
		reportNavigationLoaded(p22)

		return
	end

	spawn(function() -- line: 178
		-- upvalues: reportNavigationLoaded (copy), p22 (copy)
		reportNavigationLoaded(p22)
	end)
end
function t1.reportBackNavigation(p23) -- line: 182
	-- upvalues: contentHistory (copy), XboxPrimaryNavIXPTest (copy), t2 (copy), UserInputService (copy), EventIngestService (copy), GetFIntXboxPrimaryNavABLogging (copy)
	local v101 = contentHistory:getLastContentName()
	local s16 = "NavigationBack"
	local t5 = {
		fromContent = p23,
		toContent = v101,
		navigationVersion = if not XboxPrimaryNavIXPTest.isUserEnrolled() then t2.Classic else t2.TenFoot
	}
	local s17 = nil
	local s18 = nil
	local _, _ = pcall(function() -- line: 61
		-- upvalues: UserInputService (copy), s17 (ref), s18 (ref), s16 (ref), t5 (ref), EventIngestService (copy)
		if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			s17 = "console"
			s18 = "XboxOne"
			s16 = s16 or ""
			t5 = t5 or {}
			EventIngestService:SetRBXEventStream(s17, s18, s16, t5)
		end
	end)

	if GetFIntXboxPrimaryNavABLogging() > 1 then
		print("[ANALYTICS] NavigationBack FromContent:", p23, "| ToContent:", v101, "| NavigationVersion:", if not XboxPrimaryNavIXPTest.isUserEnrolled() then t2.Classic else t2.TenFoot)
	end
end

local t6 = {
	WidgetId = "WidgetName",
	AppHubId = "AppHub",
	AvatarEditorScreenId = "AvatarEditorScreen",
	AvatarPaneId = "AvatarPane",
	AvatarTileId = "AvatarTile",
	BadgeOverlayId = "BadgeOverlay",
	BaseCarouselScreenId = "BaseCarouselScreen",
	BaseOverlayId = "BaseOverlay",
	BaseTileId = "BaseTile",
	ConfirmPromptId = "ConfirmPrompt",
	DisableCrossplayOverlayId = "DisableCrossplayOverlay",
	EnableCrossplayOverlayId = "EnableCrossplayOverlay",
	EngagementScreenId = "EngagementScreen",
	ErrorOverlayId = "ErrorOverlay",
	GameDetailId = "GameDetail",
	GameGenreScreenId = "GameGenreScreen",
	GamesPaneId = "GamesPane",
	GameSearchScreenId = "GameSearchScreen",
	HomePaneId = "HomePane",
	ImageOverlayId = "ImageOverlay",
	LinkAccountScreenId = "LinkAccountScreen",
	NoActionOverlayId = "NoActionOverlay",
	OutfitTileId = "OutfitTile",
	OverscanScreenId = "OverscanScreen",
	PurchasePackagePromptId = "PurchasePackagePrompt",
	ReportOverlayId = "ReportOverlay",
	RobuxBalanceOverlayId = "RobuxBalanceOverlay",
	SetAccountCredentialsScreenId = "SetAccountCredentialsScreen",
	SettingsScreenId = "SettingsScreen",
	SideBarId = "SideBar",
	SignInScreenId = "SignInScreen",
	SocialPaneId = "SocialPane",
	StorePaneId = "StorePane",
	TabDockId = "TabDock",
	UnlinkAccountOverlayId = "UnlinkAccountOverlay",
	UnlinkAccountScreenId = "UnlinkAccountScreen",
	TwoFactorScreen = "TwoFactorScreen",
	CrossDeviceLoginScreen = "CrossDeviceLoginScreen",
	StoreScreenId = "StoreScreen",
	SearchScreenId = "SearchScreen",
	PartyUiId = "PartyUi"
}
local t7 = {
	HomeId = "HomeTab",
	AvatarId = "AvatarTab",
	DiscoverId = "DiscoverTab",
	FriendsId = "FriendsTab",
	StoreId = "StoreTab",
	SearchId = "SearchTab",
	SettingsId = "SettingsTab"
}

function t1.WidgetNames(p24) -- line: 251
	-- upvalues: t6 (copy)
	return t6 and t6[p24] or p24
end
function t1.TabNames(p25) -- line: 259
	-- upvalues: t7 (copy)
	return t7 and t7[p25] or p25
end

return t1
