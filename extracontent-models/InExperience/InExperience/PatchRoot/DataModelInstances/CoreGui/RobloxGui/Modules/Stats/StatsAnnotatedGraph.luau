local CoreGui = game:GetService("CoreGui")

local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)
local BarGraph = require(CoreGui.RobloxGui.Modules.Stats.BarGraph)

local StatsAnnotatedGraph = {}
StatsAnnotatedGraph.__index = StatsAnnotatedGraph

function StatsAnnotatedGraph.new(statType, isMaximized)
	local class = {}
	setmetatable(class, StatsAnnotatedGraph)

	class._statType = statType
	class._statMaxName = StatsUtils.StatMaxNames[statType]
	class._isMaximized = isMaximized

	class._values = {}

	class._average = 0

	class._target = 0

	class._axisMax = 0

	class._frame = Instance.new("Frame")
	class._frame.Name = "PS_AnnotatedGraph"
	class._frame.BackgroundTransparency = 1
	class._frame.ZIndex = StatsUtils.GraphZIndex

	class._topLabel = Instance.new("TextLabel")
	class._topLabel.Name = "PS_TopAxisLabel"
	class._topLabel.Parent = class._frame
	class._topLabel.TextXAlignment = Enum.TextXAlignment.Left
	class._topLabel.TextYAlignment = Enum.TextYAlignment.Top
	class._topLabel.FontSize = StatsUtils.PanelGraphFontSize

	class._bottomLabel = Instance.new("TextLabel")
	class._bottomLabel.Name = "PS_BottomAxisLabel"
	class._bottomLabel.Parent = class._frame
	class._bottomLabel.TextXAlignment = Enum.TextXAlignment.Left
	class._bottomLabel.TextYAlignment = Enum.TextYAlignment.Bottom
	class._bottomLabel.FontSize = StatsUtils.PanelGraphFontSize

	class._graph = BarGraph.new(isMaximized)

	StatsUtils.StyleTextWidget(class._topLabel)
	StatsUtils.StyleTextWidget(class._bottomLabel)

	class:_layoutElements()

	return class
end

function StatsAnnotatedGraph:SetZIndex(zIndex)
	self._frame.ZIndex = zIndex
	self._topLabel.ZIndex = zIndex
	self._bottomLabel.ZIndex = zIndex
	self._graph:SetZIndex(zIndex)
end

function StatsAnnotatedGraph:_layoutElements()
	local v

	if self._isMaximized then
		self._topLabel.Visible = true
		self._bottomLabel.Visible = true
		v = 30
	else
		self._topLabel.Visible = false
		self._bottomLabel.Visible = false
		v = 0
	end

	local udim = UDim2.new(0, 10, 0, 10)
	local udim2 = UDim2.new(1, -(20 + v), 1, -20)

	local udim3 = UDim2.new(1, -(10 + v), 0, 10)
	local udim4 = UDim2.new(0, v, 0.333, -20)
	local udim5 = UDim2.new(1, -(10 + v), 0.666, 10)
	local udim6 = UDim2.new(0, v, 0.333, -20)

	self._topLabel.Size = udim4
	self._topLabel.Position = udim3
	self._bottomLabel.Size = udim6
	self._bottomLabel.Position = udim5

	self._graph:PlaceInParent(self._frame, udim2, udim)
end

function StatsAnnotatedGraph:PlaceInParent(parent, size, position)
	self._frame.Position = position
	self._frame.Size = size
	self._frame.Parent = parent
end

function StatsAnnotatedGraph:_getTarget()
	if self._performanceStats == nil then
		return 0
	end

	local child = self._performanceStats:FindFirstChild(self._statMaxName)

	if child == nil then
		return 0
	end

	return child:GetValue()
end

function StatsAnnotatedGraph:_render()
	self._graph:SetAxisMax(self._axisMax)
	self._graph:SetValues(self._values)

	self._graph:SetAverage(self._average)
	self._graph:SetTarget(self._target)
	self._graph:Render()

	self._topLabel.Text = string.format("%.2f", self._axisMax)
	self._bottomLabel.Text = string.format("%.2f", 0)
end

function StatsAnnotatedGraph:_calculateAxisMax()
	local v = self._target * 2
	local recursiveGetOrderOfMagnitude = self:_recursiveGetOrderOfMagnitude(1, v)
	self._axisMax = math.floor(0.5 + v / recursiveGetOrderOfMagnitude) * recursiveGetOrderOfMagnitude
end

function StatsAnnotatedGraph:SetStatsAggregator(aggregator)
	if self._aggregator then
		self._aggregator:RemoveListener(self._listenerId)
		self._listenerId = nil
		self._aggregator = nil
	end

	self._aggregator = aggregator

	self:_refreshVisibility()
end

function StatsAnnotatedGraph:_stopListening()
	if not (self._aggregator ~= nil and self._listenerId ~= nil) then
		return
	end

	self._aggregator:RemoveListener(self._listenerId)
	self._listenerId = nil
end

function StatsAnnotatedGraph:_startListening()
	if not (self._aggregator ~= nil and self._listenerId == nil) then
		return
	end

	self._listenerId = self._aggregator:AddListener(function()
		self:_updateValuesAndRender()
	end)
end

function StatsAnnotatedGraph:_shouldBeVisible()
	if StatsUtils.PerformanceStatsShouldBeVisible() then
		return self._frame.Visible
	end

	return false
end

function StatsAnnotatedGraph:SetVisible(visible)
	self._frame.Visible = visible
	self:_refreshVisibility()
end

function StatsAnnotatedGraph:_refreshVisibility()
	if not self:_shouldBeVisible() then
		self:_stopListening()

		return
	end

	self:_startListening()
	self:_updateValuesAndRender()
end

function StatsAnnotatedGraph:OnPerformanceStatsShouldBeVisibleChanged()
	self:_refreshVisibility()
end

function StatsAnnotatedGraph:_recursiveGetOrderOfMagnitude(p, p2)
	if p2 < p then
		return self:_recursiveGetOrderOfMagnitude(p / 10, p2)
	end

	if p2 <= p * 10 then
		return p
	end

	return self:_recursiveGetOrderOfMagnitude(p * 10, p2)
end

function StatsAnnotatedGraph:_updateValuesAndRender()
	self._values = {}
	self._average = 0
	self._target = 0

	if self._aggregator ~= nil then
		self._values = self._aggregator:GetValues()
		self._average = self._aggregator:GetAverage()
		self._target = self._aggregator:GetTarget()
	end

	self:_calculateAxisMax()
	self:_render()
end

return StatsAnnotatedGraph
