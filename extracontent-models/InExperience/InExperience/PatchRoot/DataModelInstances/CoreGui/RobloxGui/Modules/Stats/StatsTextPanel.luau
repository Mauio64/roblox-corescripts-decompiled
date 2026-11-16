local CoreGui = game:GetService("CoreGui")
game:GetService("CorePackages")

local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)
require(CoreGui.RobloxGui.Modules.Stats.StatsAggregator)
local DecoratedValueLabel = require(CoreGui.RobloxGui.Modules.Stats.DecoratedValueLabel)

local TextPanelTopMarginPix = StatsUtils.TextPanelTopMarginPix
local udim = UDim2.new(0, StatsUtils.TextPanelLeftMarginPix, 0, TextPanelTopMarginPix)

local v = TextPanelTopMarginPix + StatsUtils.TextPanelTitleHeightY
local udim2 = UDim2.new(0, StatsUtils.TextPanelLeftMarginPix, 0, v)

local v2 = v + StatsUtils.TextPanelLegendItemHeightY
local udim3 = UDim2.new(0, StatsUtils.TextPanelLeftMarginPix, 0, v2)

local v3 = v2 + StatsUtils.TextPanelLegendItemHeightY
local udim4 = UDim2.new(0, StatsUtils.TextPanelLeftMarginPix, 0, v3)

local udim5 = UDim2.new(1, -StatsUtils.TextPanelLeftMarginPix * 2, 0, StatsUtils.TextPanelTitleHeightY)
local udim6 = UDim2.new(1, -StatsUtils.TextPanelLeftMarginPix * 2, 0, StatsUtils.TextPanelLegendItemHeightY)

local StatsTextPanel = {}
StatsTextPanel.__index = StatsTextPanel

function StatsTextPanel.new(statType)
	local class = {}
	setmetatable(class, StatsTextPanel)

	class._statType = statType

	class._frame = Instance.new("Frame")
	class._frame.BackgroundTransparency = 1
	class._frame.ZIndex = StatsUtils.TextZIndex

	class._titleLabel = Instance.new("TextLabel")

	StatsUtils.StyleTextWidget(class._titleLabel)

	class._titleLabel.FontSize = StatsUtils.PanelTitleFontSize
	class._titleLabel.Text = class:_getTitle()

	class._titleLabel.Parent = class._frame
	class._titleLabel.Size = udim5
	class._titleLabel.Position = udim
	class._titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	class._titleLabel.TextYAlignment = Enum.TextYAlignment.Top

	class:_addCurrentValueWidget()

	class:_addTargetValueWidget()

	class:_addAverageValueWidget()

	return class
end

function StatsTextPanel:_getTarget()
	if self._performanceStats == nil then
		return 0
	end

	local child = self._performanceStats:FindFirstChild(self._statMaxName)

	if child == nil then
		return 0
	end

	return child:GetValue()
end

function StatsTextPanel:_addCurrentValueWidget()
	self._currentValueWidget = DecoratedValueLabel.new(self._statType, "Current")

	self._currentValueWidget:PlaceInParent(self._frame, udim6, udim2)

	local decorationFrame = self._currentValueWidget:GetDecorationFrame()
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Position = UDim2.new(0.5, -StatsUtils.OvalKeySize / 2, 0.5, -StatsUtils.OvalKeySize / 2)
	imageLabel.Size = UDim2.new(0, StatsUtils.OvalKeySize, 0, StatsUtils.OvalKeySize)

	imageLabel.Parent = decorationFrame
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = "rbxasset://textures/ui/PerformanceStats/OvalKey.png"
	imageLabel.BorderSizePixel = 0
	self._currentValueDecoration = imageLabel
end

function StatsTextPanel:_addTargetValueWidget()
	self._targetValueWidget = DecoratedValueLabel.new(self._statType, "Target")

	self._targetValueWidget:PlaceInParent(self._frame, udim6, udim3)

	local decorationFrame = self._targetValueWidget:GetDecorationFrame()
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Position = UDim2.new(0.5, -StatsUtils.TargetKeyWidth / 2, 0.5, -StatsUtils.TargetKeyHeight / 2)
	imageLabel.Size = UDim2.new(0, StatsUtils.TargetKeyWidth, 0, StatsUtils.TargetKeyHeight)

	imageLabel.Parent = decorationFrame
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = "rbxasset://textures/ui/PerformanceStats/TargetKey.png"
end

function StatsTextPanel:_addAverageValueWidget()
	self._averageValueWidget = DecoratedValueLabel.new(self._statType, "Average")

	self._averageValueWidget:PlaceInParent(self._frame, udim6, udim4)

	local decorationFrame = self._averageValueWidget:GetDecorationFrame()

	local frame = Instance.new("Frame")
	frame.Position = UDim2.new(0, 0, 0.5, -StatsUtils.GraphAverageLineTotalThickness / 2)
	frame.Size = UDim2.new(1, 0, 0, StatsUtils.GraphAverageLineInnerThickness)
	frame.Parent = decorationFrame

	StatsUtils.StyleAverageLine(frame)
end

function StatsTextPanel:_getTitle()
	return StatsUtils.TypeToName[self._statType]
end

function StatsTextPanel:PlaceInParent(parent, size, position)
	self._frame.Position = position
	self._frame.Size = size
	self._frame.Parent = parent
end

function StatsTextPanel:SetStatsAggregator(aggregator)
	if self._aggregator then
		self._aggregator:RemoveListener(self._listenerId)
		self._listenerId = nil
		self._aggregator = nil
	end

	self._aggregator = aggregator

	self:_refreshVisibility()
end

function StatsTextPanel:SetVisible(visible)
	self._frame.Visible = visible
	self:_refreshVisibility()
end

function StatsTextPanel:_shouldBeVisible()
	if StatsUtils.PerformanceStatsShouldBeVisible() then
		return self._frame.Visible
	end

	return false
end

function StatsTextPanel:_refreshVisibility()
	if not self:_shouldBeVisible() then
		self:_stopListening()

		return
	end

	self:_startListening()
	self:_updateFromAggregator()
end

function StatsTextPanel:OnPerformanceStatsShouldBeVisibleChanged()
	self:_refreshVisibility()
end

function StatsTextPanel:_stopListening()
	if not (self._aggregator ~= nil and self._listenerId ~= nil) then
		return
	end

	self._aggregator:RemoveListener(self._listenerId)
	self._listenerId = nil
end

function StatsTextPanel:_startListening()
	if not (self._aggregator ~= nil and self._listenerId == nil) then
		return
	end

	self._listenerId = self._aggregator:AddListener(function()
		self:_updateFromAggregator()
	end)
end

function StatsTextPanel:_updateFromAggregator()
	local v4, v5, v6

	if self._aggregator == nil then
		v4 = 0
		v5 = 0
		v6 = 0
	else
		v4 = self._aggregator:GetLatestValue()
		v6 = self._aggregator:GetAverage()
		v5 = self._aggregator:GetTarget()
	end

	self._currentValueWidget:SetValue(v4)
	self._targetValueWidget:SetValue(v5)
	self._averageValueWidget:SetValue(v6)

	self._currentValueDecoration.ImageColor3 = StatsUtils.GetColorForValue(v4, v5)
end

function StatsTextPanel:SetZIndex(zIndex)
	self._frame.ZIndex = zIndex
	self._titleLabel.ZIndex = zIndex
	self._currentValueWidget:SetZIndex(zIndex)
	self._averageValueWidget:SetZIndex(zIndex)
end

return StatsTextPanel
