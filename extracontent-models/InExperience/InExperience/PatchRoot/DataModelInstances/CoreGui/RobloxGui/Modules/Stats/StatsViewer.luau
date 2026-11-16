local CoreGui = game:GetService("CoreGui")

local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)
local StatsTextPanel = require(CoreGui.RobloxGui.Modules.Stats.StatsTextPanel)
local StatsAnnotatedGraph = require(CoreGui.RobloxGui.Modules.Stats.StatsAnnotatedGraph)

local udim = UDim2.new(0, 0, 0, 0)
local udim2 = UDim2.new(0.4, 0, 1, 0)
local udim3 = UDim2.new(0.4, 0, 0, 0)
local udim4 = UDim2.new(0.6, 0, 1, 0)

local StatsViewer = {}
StatsViewer.__index = StatsViewer

function StatsViewer.new()
	local v = {}
	setmetatable(v, StatsViewer)

	v._frameImageLabel = Instance.new("ImageLabel")
	v._frameImageLabel.Name = "PS_Viewer"
	v._frameImageLabel.Image = "rbxasset://textures/ui/PerformanceStats/BackgroundRounded.png"
	v._frameImageLabel.ScaleType = Enum.ScaleType.Slice
	v._frameImageLabel.SliceCenter = Rect.new(10, 10, 22, 22)
	v._frameImageLabel.BackgroundTransparency = 1
	v._frameImageLabel.ImageColor3 = StatsUtils.NormalColor
	v._frameImageLabel.ImageTransparency = StatsUtils.Transparency

	v._textPanel = nil
	v._statType = nil
	v._graph = nil

	return v
end

function StatsViewer:OnPerformanceStatsShouldBeVisibleChanged()
	if self._graph then
		self._graph:OnPerformanceStatsShouldBeVisibleChanged()
	end

	if self._textPanel then
		self._textPanel:OnPerformanceStatsShouldBeVisibleChanged()
	end
end

function StatsViewer:GetIsVisible()
	return self._frameImageLabel.Visible
end

function StatsViewer:GetStatType()
	return self._statType
end

function StatsViewer:SetSizeAndPosition(size, position)
	self._frameImageLabel.Size = size
	self._frameImageLabel.Position = position
end

function StatsViewer:SetParent(parent)
	self._frameImageLabel.Parent = parent
end

function StatsViewer:SetVisible(visible)
	self._frameImageLabel.Visible = visible

	if self._graph then
		self._graph:SetVisible(visible)
	end

	if self._textPanel then
		self._textPanel:SetVisible(visible)
	end
end

function StatsViewer:SetStatType(statType)
	self._statType = statType
	self._frameImageLabel:ClearAllChildren()

	if self._textPanel then
		self._textPanel:SetVisible(false)
		self._textPanel = nil
	end

	self._textPanel = StatsTextPanel.new(statType)
	self._textPanel:PlaceInParent(self._frameImageLabel, udim2, udim)

	self._graph = StatsAnnotatedGraph.new(statType, true)
	self._graph:PlaceInParent(self._frameImageLabel, udim4, udim3)

	self._textPanel:SetZIndex(StatsUtils.TextZIndex)
	self._graph:SetZIndex(StatsUtils.GraphZIndex)

	self._graph:SetVisible(self._frameImageLabel.Visible)
	self._textPanel:SetVisible(self._frameImageLabel.Visible)

	self:_applyStatsAggregator()
end

function StatsViewer:_applyStatsAggregator()
	if self._aggregator == nil then
		return
	end

	if self._textPanel then
		self._textPanel:SetStatsAggregator(self._aggregator)
	end

	if self._graph then
		self._graph:SetStatsAggregator(self._aggregator)
	end
end

function StatsViewer:SetStatsAggregator(aggregator)
	self._aggregator = aggregator
	self:_applyStatsAggregator()
end

return StatsViewer
