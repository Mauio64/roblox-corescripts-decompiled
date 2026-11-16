local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Modules = RobloxGui:WaitForChild("Modules")

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local EventIngestService = game:GetService("EventIngestService")
local Analytics = require(CorePackages.Workspace.Packages.Analytics)
local analytics = Analytics.Analytics.new(RbxAnalyticsService)
local Analytics2 = require(CorePackages.Workspace.Packages.Analytics)
local EventIngest = Analytics2.AnalyticsReporters.EventIngest
local Roact = require(CorePackages.Packages.Roact)
local Settings = script:FindFirstAncestor("Settings")
local SettingsPageFactory = require(Modules.Settings.SettingsPageFactory)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create
local AbuseReportMenu = require(RobloxGui.Modules.AbuseReportMenu)
local ReportAbuseAnalytics = AbuseReportMenu.ReportAbuseAnalytics
local BlockingAnalytics = require(Settings.Analytics.BlockingAnalytics)
local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local ReportConfirmationContainer = require(Settings.Components.ReportConfirmation.ReportConfirmationContainer)

local Chrome = RobloxGui.Modules.Chrome
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local enabled = Chrome2.Enabled()
local Service

if enabled then
	Service = require(Chrome.Service)
else
	Service = nil
end

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls

local v = nil

local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local reportAbuseAnalytics = ReportAbuseAnalytics.new(
	EventIngest.new(EventIngestService),
	analytics.Diag,
	ReportAbuseAnalytics.MenuContexts.LegacySentPage
)

local blockingAnalytics = BlockingAnalytics.new(LocalPlayer.UserId, {
	EventStream = RbxAnalyticsService
})

local function Initialize()
	local newPage = SettingsPageFactory:CreateNewPage()

	newPage.TabHeader = nil
	newPage.PageListLayout.Parent = nil
	newPage.ShouldShowBottomBar = false
	newPage.ShouldShowHubBar = false
	newPage.IsPageClipped = false
	newPage.Page.Name = "ReportSentPageV2"
	newPage.Page.Size = UDim2.fromScale(1, 0)
	newPage.Page.AutomaticSize = Enum.AutomaticSize.Y

	newPage.Root = Create("Frame")({
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Name = "ReportSentContents",
		Parent = newPage.Page
	})

	return newPage
end

local initialize = Initialize()

local function fn() -- 2 equivalent calls inferred from this helper
	if v ~= nil then
		Roact.unmount(v)
		v = nil
	end
end

function initialize:UpdateMenu()
	local reportedPlayer = self.ReportedPlayer
	fn() -- inferred equivalent call

	if self.settingsShowChangedSignal then
		self.settingsShowChangedSignal:disconnect()
		self.settingsShowChangedSignal = nil
	end

	self.settingsShowChangedSignal = self.HubRef.SettingsShowSignal:connect(function(p)
		if not p then
			self:HandleDone()
		end
	end)

	local bindableEvent = Instance.new("BindableEvent")
	self.SizeChangedSignal = self.Root:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		bindableEvent:Fire(self.Root.AbsoluteSize)
	end)

	local v2 = {
		player = {
			UserId = reportedPlayer.UserId,
			Name = reportedPlayer.Name,
			DisplayName = reportedPlayer.DisplayName
		},
		closeMenu = function()
			self:HandleDone()
		end,
		isVoiceReport = self.isVoiceReport,
		ZIndex = self.HubRef.Shield.ZIndex + 1,
		reportAbuseAnalytics = reportAbuseAnalytics,
		blockingAnalytics = blockingAnalytics,
		onSizeChanged = bindableEvent.Event
	}

	local element = Roact.createElement(CoreScriptsRootProvider, {}, {
		FocusRoot = Roact.createElement(
			FocusRoot,
			{
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.RouterView,
				isIsolated = true,
				isAutoFocusRoot = true
			},
			{
				ThankYouScreenRoot = Roact.createElement(ReportConfirmationContainer, v2)
			}
		)
	})

	if enabled and FFlagEnableConsoleExpControls then
		Service:setHideShortcutBar("ReportSentPageV2", true)
	end

	v = Roact.mount(element, self.Root, "ReportSentPageV2")
end

function initialize:ShowReportedPlayer(reportedPlayer, isVoiceReport)
	self.ReportedPlayer = reportedPlayer
	self.isVoiceReport = isVoiceReport
	self:UpdateMenu()

	self.HubRef:SwitchToPage(initialize, true)
end

function initialize:HandleDone()
	if enabled and FFlagEnableConsoleExpControls then
		Service:setHideShortcutBar("ReportSentPageV2", false)
	end

	fn() -- inferred equivalent call

	if self.settingsShowChangedSignal then
		self.settingsShowChangedSignal:disconnect()
		self.settingsShowChangedSignal = nil
	end

	if self.SizeChangedSignal then
		self.SizeChangedSignal:disconnect()
		self.SizeChangedSignal = nil
	end

	self.HubRef:SetVisibility(false, true)
end

return initialize
