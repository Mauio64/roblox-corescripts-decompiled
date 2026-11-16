local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:FindFirstChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local shell = RobloxGui:FindFirstChild("Modules"):FindFirstChild("Shell")

local Analytics = require(CorePackages.Workspace.Packages.Analytics)
local EventStream = Analytics.AnalyticsReporters.EventStream

local Analytics2 = require(CorePackages.Workspace.Packages.Analytics)
local userInteractions = Analytics2.Events.userInteractions
local Analytics3 = require(CorePackages.Workspace.Packages.Analytics)
local pageHeartbeat = Analytics3.Events.pageHeartbeat
local contentHistory = require(shell.XboxPrimaryNav:FindFirstChild("contentHistory"))
local XboxPrimaryNavIXPTest = require(shell.Experiment.XboxPrimaryNavIXPTest)
local GetFIntXboxPrimaryNavABLogging = require(shell.Flags.GetFIntXboxPrimaryNavABLogging)

local v = nil
pcall(function()
	local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
	v = RbxAnalyticsService
end)
local EventIngestService = game:GetService("EventIngestService")
local UserInputService = game:GetService("UserInputService")

local v2 = EventStream.new(v)

local v3 = { TenFoot = "tenFoot", Classic = "classic" }

local function getNavigationVersion(): string
	if XboxPrimaryNavIXPTest.isUserEnrolled() then
		return "tenFoot"
	end

	return "classic"
end

local function setRBXEvent(value, options) -- 1 equivalent call inferred from this helper
	local v4 = nil
	local v5 = nil
	local success, _ = pcall(function()
		if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			v4 = "console"
			v5 = "XboxOne"
			value = value or ""
			options = options or {}
			EventIngestService:SetRBXEvent(v4, v5, value, options)
		end
	end)

	return success
end

local function setRBXEventStream(value, options) -- 1 equivalent call inferred from this helper
	local v4 = nil
	local v5 = nil
	local success, _ = pcall(function()
		if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			v4 = "console"
			v5 = "XboxOne"
			value = value or ""
			options = options or {}
			EventIngestService:SetRBXEventStream(v4, v5, value, options)
		end
	end)

	return success
end

local function releaseRBXEventStream(_)
	local v4 = nil
	local success, _ = pcall(function()
		if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			v4 = "console"
			v:ReleaseRBXEventStream(v4)
		end
	end)

	return success
end

local function updateHeartbeatObject(p) -- 1 equivalent call inferred from this helper
	local success, _ = pcall(function()
		v:UpdateHeartbeatObject(p)
	end)

	return success
end

local function reportCounter(value, value2) -- 1 equivalent call inferred from this helper
	local success, _ = pcall(function()
		if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			value = value or ""
			value = "Xbox-" .. tostring(value)
			value2 = value2 or 1
			v:ReportCounter(value, value2)
		end
	end)

	return success
end

local Analytics4 = {}

function Analytics4:SetRBXEvent(options)
	setRBXEvent(self, options) -- inferred equivalent call
end

function Analytics4:SetRBXEventStream(options)
	setRBXEventStream(self, options) -- inferred equivalent call
end

function Analytics4:UpdateHeartbeatObject()
	updateHeartbeatObject(self) -- inferred equivalent call
end

function Analytics4:ReportCounter(value)
	reportCounter(self, value) -- inferred equivalent call
end

function Analytics4.reportPageChanged()
	userInteractions(v2, "luaPage")
end

function Analytics4.reportPageHeartbeat(p, p2)
	pageHeartbeat(v2, p, p2)
end

function Analytics4.reportNavigation(activationType, toContent, contentType)
	local lastContentName = contentHistory:getLastContentName()

	if toContent ~= lastContentName then
		local v4 = "Navigation"
		local v5 = {
			activationType = activationType,
			toContent = toContent,
			fromContent = lastContentName,
			contentType = contentType,
			navigationVersion = 0
		}
		local navigationVersion

		if XboxPrimaryNavIXPTest.isUserEnrolled() then
			navigationVersion = v3.TenFoot
		else
			navigationVersion = v3.Classic
		end

		v5.navigationVersion = navigationVersion
		local v6 = nil
		local v7 = nil
		local _, _ = pcall(function()
			if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
				v6 = "console"
				v7 = "XboxOne"
				v4 = v4 or ""
				v5 = v5 or {}
				EventIngestService:SetRBXEventStream(v6, v7, v4, v5)
			end
		end)

		if GetFIntXboxPrimaryNavABLogging() > 1 then
			local v8

			if XboxPrimaryNavIXPTest.isUserEnrolled() then
				v8 = v3.TenFoot
			else
				v8 = v3.Classic
			end

			print(
				"[ANALYTICS] Navigation",
				"ActivationType:",
				activationType,
				"| ContentName:",
				toContent,
				"| ContentType:",
				contentType,
				"| PrevContentName:",
				lastContentName,
				"| NavigationVersion:",
				v8
			)
		end
	end
end

local function reportNavigationLoaded(toContent)
	local lastContentName = contentHistory:getLastContentName()

	if toContent ~= lastContentName then
		local v4 = "NavigationLoaded"
		local v5 = { toContent = toContent, fromContent = lastContentName, navigationVersion = 0 }
		local navigationVersion

		if XboxPrimaryNavIXPTest.isUserEnrolled() then
			navigationVersion = v3.TenFoot
		else
			navigationVersion = v3.Classic
		end

		v5.navigationVersion = navigationVersion
		local v6 = nil
		local v7 = nil
		local _, _ = pcall(function()
			if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
				v6 = "console"
				v7 = "XboxOne"
				v4 = v4 or ""
				v5 = v5 or {}
				EventIngestService:SetRBXEventStream(v6, v7, v4, v5)
			end
		end)

		if GetFIntXboxPrimaryNavABLogging() > 1 then
			local v8

			if XboxPrimaryNavIXPTest.isUserEnrolled() then
				v8 = v3.TenFoot
			else
				v8 = v3.Classic
			end

			print(
				"[ANALYTICS] NavigationLoaded ContentName:",
				toContent,
				"| PrevContentName:",
				lastContentName,
				"| NavigationVersion:",
				v8
			)
		end
	end
end

function Analytics4.reportNavigationLoaded(toContent)
	if XboxPrimaryNavIXPTest.isUserEnrolled() then
		reportNavigationLoaded(toContent)
	else
		spawn(function()
			reportNavigationLoaded(toContent)
		end)
	end
end

function Analytics4.reportBackNavigation(fromContent)
	local lastContentName = contentHistory:getLastContentName()

	local v4 = "NavigationBack"
	local v5 = { fromContent = fromContent, toContent = lastContentName, navigationVersion = 0 }
	local navigationVersion

	if XboxPrimaryNavIXPTest.isUserEnrolled() then
		navigationVersion = v3.TenFoot
	else
		navigationVersion = v3.Classic
	end

	v5.navigationVersion = navigationVersion
	local v6 = nil
	local v7 = nil
	local _, _ = pcall(function()
		if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			v6 = "console"
			v7 = "XboxOne"
			v4 = v4 or ""
			v5 = v5 or {}
			EventIngestService:SetRBXEventStream(v6, v7, v4, v5)
		end
	end)

	if GetFIntXboxPrimaryNavABLogging() > 1 then
		local v8

		if XboxPrimaryNavIXPTest.isUserEnrolled() then
			v8 = v3.TenFoot
		else
			v8 = v3.Classic
		end

		print(
			"[ANALYTICS] NavigationBack FromContent:",
			fromContent,
			"| ToContent:",
			lastContentName,
			"| NavigationVersion:",
			v8
		)
	end
end

local v4 = {
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

local v5 = {
	HomeId = "HomeTab",
	AvatarId = "AvatarTab",
	DiscoverId = "DiscoverTab",
	FriendsId = "FriendsTab",
	StoreId = "StoreTab",
	SearchId = "SearchTab",
	SettingsId = "SettingsTab"
}

function Analytics4.WidgetNames(p)
	return v4 and v4[p] or p
end

function Analytics4.TabNames(p)
	return v5 and v5[p] or p
end

return Analytics4
