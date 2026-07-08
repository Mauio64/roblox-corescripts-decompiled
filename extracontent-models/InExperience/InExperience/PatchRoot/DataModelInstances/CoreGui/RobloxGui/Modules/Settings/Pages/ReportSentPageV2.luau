local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Modules = RobloxGui:WaitForChild("Modules")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local EventIngestService = game:GetService("EventIngestService")
local v8 = require(CorePackages.Workspace.Packages.Analytics).Analytics.new(RbxAnalyticsService)
local EventIngest = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventIngest
local Roact = require(CorePackages.Packages.Roact)
local Settings = script:FindFirstAncestor("Settings")
local SettingsPageFactory = require(Modules.Settings.SettingsPageFactory)
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local ReportAbuseAnalytics = require(RobloxGui.Modules.AbuseReportMenu).ReportAbuseAnalytics
local BlockingAnalytics = require(Settings.Analytics.BlockingAnalytics)
local CoreScriptsRootProvider = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon).CoreScriptsRootProvider
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local ReportConfirmationScreen = require(Settings.Components.ReportConfirmation.ReportConfirmationScreen)
local ReportConfirmationContainer = require(Settings.Components.ReportConfirmation.ReportConfirmationContainer)
local v22 = game:DefineFastFlag("ReportAbuseThankYouPageGamepadEnable", false)
local Chrome = RobloxGui.Modules.Chrome
local v24 = require(CorePackages.Workspace.Packages.Chrome).Enabled()
local v25 = if not v24 then nil else require(Chrome.Service)
local FFlagEnableConsoleExpControls = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableConsoleExpControls
local u27 = nil
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local v29 = ReportAbuseAnalytics.new(EventIngest.new(EventIngestService), v8.Diag, ReportAbuseAnalytics.MenuContexts.LegacySentPage)
local v30 = BlockingAnalytics.new(LocalPlayer.UserId, {
	EventStream = RbxAnalyticsService
})

local function Initialize() -- line: 57
	-- upvalues: SettingsPageFactory (copy), Create (copy)
	local v33 = SettingsPageFactory:CreateNewPage()

	v33.TabHeader = nil
	v33.PageListLayout.Parent = nil
	v33.ShouldShowBottomBar = false
	v33.ShouldShowHubBar = false
	v33.IsPageClipped = false
	v33.Page.Name = "ReportSentPageV2"
	v33.Page.Size = UDim2.fromScale(1, 0)
	v33.Page.AutomaticSize = Enum.AutomaticSize.Y
	v33.Root = Create("Frame")({
		BackgroundTransparency = 1,
		Name = "ReportSentContents",
		Size = UDim2.fromScale(1, 1),
		Parent = v33.Page
	})

	return v33
end

local v32 = Initialize()

function v32.UpdateMenu(p1) -- line: 81
	-- upvalues: u27 (ref), Roact (copy), v29 (copy), v30 (copy), ReportConfirmationScreen (copy), v22 (copy), CoreScriptsRootProvider (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), ReportConfirmationContainer (copy), v24 (copy), FFlagEnableConsoleExpControls (copy), v25 (copy)
	local ReportedPlayer = p1.ReportedPlayer

	if u27 ~= nil then
		Roact.unmount(u27)
		u27 = nil
	end

	if p1.settingsShowChangedSignal then
		p1.settingsShowChangedSignal:disconnect()
		p1.settingsShowChangedSignal = nil
	end

	p1.settingsShowChangedSignal = p1.HubRef.SettingsShowSignal:connect(function(p2) -- line: 90
		-- upvalues: p1 (copy)
		if not p2 then
			p1:HandleDone()
		end
	end)

	local BindableEvent = Instance.new("BindableEvent")

	p1.SizeChangedSignal = p1.Root:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 98
		-- upvalues: BindableEvent (copy), p1 (copy)
		BindableEvent:Fire(p1.Root.AbsoluteSize)
	end)

	local t1 = {
		player = {
			UserId = ReportedPlayer.UserId,
			Name = ReportedPlayer.Name,
			DisplayName = ReportedPlayer.DisplayName
		},
		closeMenu = function() -- line: 108
			-- upvalues: p1 (copy)
			p1:HandleDone()
		end,
		isVoiceReport = p1.isVoiceReport,
		ZIndex = p1.HubRef.Shield.ZIndex + 1,
		reportAbuseAnalytics = v29,
		blockingAnalytics = v30,
		onSizeChanged = BindableEvent.Event
	}
	local v38 = Roact.createElement(ReportConfirmationScreen, t1)

	if v22 then
		v38 = Roact.createElement(CoreScriptsRootProvider, {}, {
			FocusRoot = Roact.createElement(FocusRoot, {
				isIsolated = true,
				isAutoFocusRoot = true,
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.RouterView
			}, {
				ThankYouScreenRoot = Roact.createElement(ReportConfirmationContainer, t1)
			})
		})

		if v24 and FFlagEnableConsoleExpControls then
			v25:setHideShortcutBar("ReportSentPageV2", true)
		end
	end

	u27 = Roact.mount(v38, p1.Root, "ReportSentPageV2")
end
function v32.ShowReportedPlayer(p3, p4, p5) -- line: 142
	-- upvalues: v32 (copy)
	p3.ReportedPlayer = p4
	p3.isVoiceReport = p5
	p3:UpdateMenu()
	p3.HubRef:SwitchToPage(v32, true)
end
function v32.HandleDone(p6) -- line: 150
	-- upvalues: v22 (copy), v24 (copy), FFlagEnableConsoleExpControls (copy), v25 (copy), u27 (ref), Roact (copy)
	if v22 and (v24 and FFlagEnableConsoleExpControls) then
		v25:setHideShortcutBar("ReportSentPageV2", false)
	end

	if u27 ~= nil then
		Roact.unmount(u27)
		u27 = nil
	end

	if p6.settingsShowChangedSignal then
		p6.settingsShowChangedSignal:disconnect()
		p6.settingsShowChangedSignal = nil
	end

	if p6.SizeChangedSignal then
		p6.SizeChangedSignal:disconnect()
		p6.SizeChangedSignal = nil
	end

	p6.HubRef:SetVisibility(false, true)
end

return v32
