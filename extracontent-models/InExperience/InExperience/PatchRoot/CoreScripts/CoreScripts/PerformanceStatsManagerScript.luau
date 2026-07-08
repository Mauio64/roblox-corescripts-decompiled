local Players = game:GetService("Players")
local GameSettings = UserSettings().GameSettings
local CoreGui = game:GetService("CoreGui")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local StatsAggregatorManager = require(CoreGui.RobloxGui.Modules.Stats.StatsAggregatorManager)
local StatsButton = require(CoreGui.RobloxGui.Modules.Stats.StatsButton)
local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)
local StatsViewer = require(CoreGui.RobloxGui.Modules.Stats.StatsViewer)
local v9 = require(CoreGui.RobloxGui.Modules.Flags.GetFFlagLazyPerfStatsInit)()
local Frame = nil
local u11 = nil
local u12 = nil
local t1 = {}
local u14 = nil
local u15 = nil

if not v9 then
	Frame = Instance.new("Frame")
	Frame.Name = "PerformanceStats"
	u11 = StatsAggregatorManager.getSingleton()
	u12 = StatsViewer.new()

	for _, v in ipairs(StatsUtils.AllStatTypes) do
		t1[v] = StatsButton.new(v)
	end
end

function ShowMasterFrame() -- line: 48
	-- upvalues: Frame (ref), CoreGui (copy)
	Frame.Visible = true
	Frame.Parent = CoreGui.RobloxGui
end
function HideMasterFrame() -- line: 53
	-- upvalues: Frame (ref)
	Frame.Visible = false
	Frame.Parent = nil
end
function ConfigureMasterFrame() -- line: 59
	-- upvalues: Frame (ref)
	Frame.Position = UDim2.new(0, 0, 0, 0)
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.Selectable = false
	Frame.BackgroundTransparency = 1
	Frame.Active = false
	Frame.ZIndex = 0
	HideMasterFrame()
end
function ConfigureStatButtonsInMasterFrame() -- line: 77
	-- upvalues: StatsUtils (copy)
	for i, v in ipairs(StatsUtils.AllStatTypes) do
		AddButton(v, i)
	end
end
function OnButtonToggled(p1) -- line: 84
	-- upvalues: t1 (ref), u14 (ref)
	if not t1[p1]._isSelected then
		u14 = p1
	else
		u14 = nil
	end

	UpdateButtonSelectedStates()
	UpdateViewerVisibility()
end
function UpdateButtonSelectedStates() -- line: 99
	-- upvalues: StatsUtils (copy), t1 (ref), u14 (ref)
	for _, v in ipairs(StatsUtils.AllStatTypes) do
		t1[v]:SetIsSelected(v == u14)
	end
end
function UpdateViewerVisibility() -- line: 106
	-- upvalues: u14 (ref), u12 (ref), u11 (ref), RbxAnalyticsService (copy)
	if u14 == nil then
		if u12:GetIsVisible() then
			u12:SetVisible(false)
			u12:SetStatsAggregator(nil)

			return
		end
	else
		local v23 = false

		if not u12:GetIsVisible() then
			v23 = true
			u12:SetVisible(true)
		end

		if u14 ~= u12:GetStatType() then
			u12:SetStatType(u14)
			u12:SetStatsAggregator(u11:GetAggregator(u14))
			v23 = true
		end

		if v23 then
			RbxAnalyticsService:TrackEvent("Game", "Enlarge PerfStat", u14, 0)
		end
	end
end
function AddButton(p2, p3) -- line: 135
	-- upvalues: t1 (ref), Frame (ref), u11 (ref), StatsUtils (copy)
	local v26 = t1[p2]

	v26:SetParent(Frame)
	v26:SetStatsAggregator(u11:GetAggregator(p2))

	local v27 = 1 / StatsUtils.NumButtonTypes

	v26:SetSizeAndPosition(UDim2.new(v27, 0, 0, StatsUtils.ButtonHeight), (UDim2.new(v27 * (p3 - 1), 0, 0, 0)))
	v26:SetToggleCallbackFunction(OnButtonToggled)
end
function ConfigureStatViewerInMasterFrame() -- line: 154
	-- upvalues: u12 (ref), Frame (ref), StatsUtils (copy)
	u12:SetParent(Frame)

	local uDim2 = UDim2.new(0, StatsUtils.ViewerWidth, 0, StatsUtils.ViewerHeight)
	local uDim2_2 = UDim2.new(1, -StatsUtils.ViewerWidth, 0, StatsUtils.ButtonHeight + StatsUtils.ViewerTopMargin)

	u12:SetSizeAndPosition(uDim2, uDim2_2)
end

if v9 then
	function CreatePerformanceStatsUI() -- line: 166
		-- upvalues: u11 (ref), StatsAggregatorManager (copy), Frame (ref), t1 (ref), StatsUtils (copy), StatsButton (copy), u12 (ref), StatsViewer (copy), u14 (ref)
		u11 = StatsAggregatorManager.getSingleton()
		u11:StartListening()
		Frame = Instance.new("Frame")
		Frame.Name = "PerformanceStats"
		t1 = {}

		for _, v31 in StatsUtils.AllStatTypes do
			t1[v31] = StatsButton.new(v31)
		end

		u12 = StatsViewer.new()
		u14 = nil
		ConfigureMasterFrame()
		ConfigureStatButtonsInMasterFrame()
		ConfigureStatViewerInMasterFrame()
		UpdateButtonSelectedStates()
		UpdateViewerVisibility()
		ShowMasterFrame()
	end
	function DestroyPerformanceStatsUI() -- line: 192
		-- upvalues: u12 (ref), StatsUtils (copy), t1 (ref), Frame (ref), u14 (ref), u11 (ref)
		if u12 then
			u12:OnPerformanceStatsShouldBeVisibleChanged()
		end

		for _, v in ipairs(StatsUtils.AllStatTypes) do
			local v34 = t1[v]

			if v34 then
				v34:OnPerformanceStatsShouldBeVisibleChanged()
			end
		end

		if Frame then
			Frame:Destroy()
			Frame = nil
		end

		u12 = nil
		t1 = {}
		u14 = nil

		if u11 then
			u11:StopListening()
		end
	end
	function UpdatePerformanceStatsVisibility() -- line: 218
		-- upvalues: StatsUtils (copy), Frame (ref), RbxAnalyticsService (copy), u15 (ref)
		local v35 = StatsUtils.PerformanceStatsShouldBeVisible()

		if v35 == (Frame ~= nil) then
			return
		end

		if v35 then
			CreatePerformanceStatsUI()
		else
			DestroyPerformanceStatsUI()
		end

		local s1 = "Hide PerfStats"

		if v35 then
			s1 = "Show PerfStats"
		end

		RbxAnalyticsService:TrackEvent("Game", s1, "", 0)

		if v35 then
			u15 = time()
			RbxAnalyticsService:ReportCounter("OpenPerformanceProfiler", 1)

			return
		end

		if u15 then
			local v37 = time() - u15

			RbxAnalyticsService:ReportStats("TimeOpenPerformanceProfiler", v37)
		end
	end
else
	function UpdatePerformanceStatsVisibility() -- line: 251
		-- upvalues: StatsUtils (copy), Frame (ref), u12 (ref), t1 (ref), RbxAnalyticsService (copy), u15 (ref)
		local v38 = StatsUtils.PerformanceStatsShouldBeVisible()

		if v38 == Frame.Visible then
			return
		end

		if v38 then
			ShowMasterFrame()
		else
			HideMasterFrame()
		end

		u12:OnPerformanceStatsShouldBeVisibleChanged()

		for _, v in ipairs(StatsUtils.AllStatTypes) do
			t1[v]:OnPerformanceStatsShouldBeVisibleChanged()
		end

		local s2 = "Hide PerfStats"

		if v38 then
			s2 = "Show PerfStats"
		end

		RbxAnalyticsService:TrackEvent("Game", s2, "", 0)

		if v38 then
			u15 = time()
			RbxAnalyticsService:ReportCounter("OpenPerformanceProfiler", 1)

			return
		end

		if u15 then
			local v42 = time() - u15

			RbxAnalyticsService:ReportStats("TimeOpenPerformanceProfiler", v42)
		end
	end
end

GameSettings.PerformanceStatsVisibleChanged:connect(UpdatePerformanceStatsVisibility)

if not v9 then
	ConfigureMasterFrame()
	ConfigureStatButtonsInMasterFrame()
	ConfigureStatViewerInMasterFrame()
	UpdateButtonSelectedStates()
	UpdateViewerVisibility()
	UpdatePerformanceStatsVisibility()
end

spawn(function() -- line: 305
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	while not LocalPlayer do
		Players.PlayerAdded:wait()
		LocalPlayer = Players.LocalPlayer
	end

	UpdatePerformanceStatsVisibility()
end)
