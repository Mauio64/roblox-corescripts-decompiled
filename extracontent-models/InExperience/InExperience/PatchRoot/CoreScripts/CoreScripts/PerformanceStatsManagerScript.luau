local Players = game:GetService("Players")
local gameSettings = UserSettings().GameSettings
local CoreGui = game:GetService("CoreGui")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local StatsAggregatorManager = require(CoreGui.RobloxGui.Modules.Stats.StatsAggregatorManager)
local StatsButton = require(CoreGui.RobloxGui.Modules.Stats.StatsButton)
local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)
local StatsViewer = require(CoreGui.RobloxGui.Modules.Stats.StatsViewer)

local GetFFlagLazyPerfStatsInit = require(CoreGui.RobloxGui.Modules.Flags.GetFFlagLazyPerfStatsInit)
local fFlagLazyPerfStatsInit = GetFFlagLazyPerfStatsInit()

local v = {}
local v2 = nil

local v3 = nil
local performanceStats, v4, v5

if fFlagLazyPerfStatsInit then
	performanceStats = nil
	v4 = nil
	v5 = nil
else
	performanceStats = Instance.new("Frame")
	performanceStats.Name = "PerformanceStats"
	v5 = StatsAggregatorManager.getSingleton()
	v4 = StatsViewer.new()

	for _, allStatType in ipairs(StatsUtils.AllStatTypes) do
		v[allStatType] = StatsButton.new(allStatType)
	end
end

function ShowMasterFrame()
	performanceStats.Visible = true
	performanceStats.Parent = CoreGui.RobloxGui
end

function HideMasterFrame()
	performanceStats.Visible = false
	performanceStats.Parent = nil
end

function ConfigureMasterFrame()
	performanceStats.Position = UDim2.new(0, 0, 0, 0)
	performanceStats.Size = UDim2.new(1, 0, 1, 0)
	performanceStats.Selectable = false
	performanceStats.BackgroundTransparency = 1
	performanceStats.Active = false
	performanceStats.ZIndex = 0

	HideMasterFrame()
end

function ConfigureStatButtonsInMasterFrame()
	for i, allStatType in ipairs(StatsUtils.AllStatTypes) do
		AddButton(allStatType, i)
	end
end

function OnButtonToggled(p)
	v2 = if not v[p]._isSelected then p else nil

	UpdateButtonSelectedStates()
	UpdateViewerVisibility()
end

function UpdateButtonSelectedStates()
	for _, allStatType in ipairs(StatsUtils.AllStatTypes) do
		v[allStatType]:SetIsSelected(allStatType == v2)
	end
end

function UpdateViewerVisibility()
	if v2 == nil then
		if v4:GetIsVisible() then
			v4:SetVisible(false)
			v4:SetStatsAggregator(nil)
		end
	else
		local flag

		if v4:GetIsVisible() then
			flag = false
		else
			v4:SetVisible(true)
			flag = true
		end

		if v2 ~= v4:GetStatType() then
			v4:SetStatType(v2)
			v4:SetStatsAggregator(v5:GetAggregator(v2))
			flag = true
		end

		if flag then
			RbxAnalyticsService:TrackEvent("Game", "Enlarge PerfStat", v2, 0)
		end
	end
end

function AddButton(p, p2)
	local v6 = v[p]

	v6:SetParent(performanceStats)
	v6:SetStatsAggregator(v5:GetAggregator(p))

	local v7 = 1 / StatsUtils.NumButtonTypes
	v6:SetSizeAndPosition(UDim2.new(v7, 0, 0, StatsUtils.ButtonHeight), (UDim2.new(v7 * (p2 - 1), 0, 0, 0)))

	v6:SetToggleCallbackFunction(OnButtonToggled)
end

function ConfigureStatViewerInMasterFrame()
	v4:SetParent(performanceStats)

	local udim = UDim2.new(0, StatsUtils.ViewerWidth, 0, StatsUtils.ViewerHeight)
	local udim2 = UDim2.new(1, -StatsUtils.ViewerWidth, 0, StatsUtils.ButtonHeight + StatsUtils.ViewerTopMargin)

	v4:SetSizeAndPosition(udim, udim2)
end

if fFlagLazyPerfStatsInit then
	function CreatePerformanceStatsUI()
		v5 = StatsAggregatorManager.getSingleton()
		v5:StartListening()

		performanceStats = Instance.new("Frame")
		performanceStats.Name = "PerformanceStats"

		v = {}

		for _, allStatType in StatsUtils.AllStatTypes do
			local v6 = StatsButton.new(allStatType)
			v[allStatType] = v6
		end

		v4 = StatsViewer.new()
		v2 = nil

		ConfigureMasterFrame()
		ConfigureStatButtonsInMasterFrame()
		ConfigureStatViewerInMasterFrame()

		UpdateButtonSelectedStates()
		UpdateViewerVisibility()

		ShowMasterFrame()
	end

	function DestroyPerformanceStatsUI()
		if v4 then
			v4:OnPerformanceStatsShouldBeVisibleChanged()
		end

		for _, allStatType in ipairs(StatsUtils.AllStatTypes) do
			local v6 = v[allStatType]

			if v6 then
				v6:OnPerformanceStatsShouldBeVisibleChanged()
			end
		end

		if performanceStats then
			performanceStats:Destroy()
			performanceStats = nil
		end

		v4 = nil
		v = {}
		v2 = nil

		if v5 then
			v5:StopListening()
		end
	end

	function UpdatePerformanceStatsVisibility()
		local performanceStatsShouldBeVisible = StatsUtils.PerformanceStatsShouldBeVisible()

		if performanceStatsShouldBeVisible == (performanceStats ~= nil) then
			return
		end

		if performanceStatsShouldBeVisible then
			CreatePerformanceStatsUI()
		else
			DestroyPerformanceStatsUI()
		end

		RbxAnalyticsService:TrackEvent(
			"Game",
			performanceStatsShouldBeVisible and "Show PerfStats" or "Hide PerfStats",
			"",
			0
		)

		if performanceStatsShouldBeVisible then
			v3 = time()
			RbxAnalyticsService:ReportCounter("OpenPerformanceProfiler", 1)
		elseif v3 then
			RbxAnalyticsService:ReportStats("TimeOpenPerformanceProfiler", time() - v3)
		end
	end
else
	function UpdatePerformanceStatsVisibility()
		local performanceStatsShouldBeVisible = StatsUtils.PerformanceStatsShouldBeVisible()

		if performanceStatsShouldBeVisible == performanceStats.Visible then
			return
		end

		if performanceStatsShouldBeVisible then
			ShowMasterFrame()
		else
			HideMasterFrame()
		end

		v4:OnPerformanceStatsShouldBeVisibleChanged()

		for _, allStatType in ipairs(StatsUtils.AllStatTypes) do
			v[allStatType]:OnPerformanceStatsShouldBeVisibleChanged()
		end

		RbxAnalyticsService:TrackEvent(
			"Game",
			performanceStatsShouldBeVisible and "Show PerfStats" or "Hide PerfStats",
			"",
			0
		)

		if performanceStatsShouldBeVisible then
			v3 = time()
			RbxAnalyticsService:ReportCounter("OpenPerformanceProfiler", 1)
		elseif v3 then
			RbxAnalyticsService:ReportStats("TimeOpenPerformanceProfiler", time() - v3)
		end
	end
end

gameSettings.PerformanceStatsVisibleChanged:connect(UpdatePerformanceStatsVisibility)

if not fFlagLazyPerfStatsInit then
	ConfigureMasterFrame()
	ConfigureStatButtonsInMasterFrame()
	ConfigureStatViewerInMasterFrame()

	UpdateButtonSelectedStates()
	UpdateViewerVisibility()
	UpdatePerformanceStatsVisibility()
end

spawn(function()
	local localPlayer = Players.LocalPlayer

	while not localPlayer do
		Players.PlayerAdded:wait()
		localPlayer = Players.LocalPlayer
	end

	UpdatePerformanceStatsVisibility()
end)
