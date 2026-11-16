local udim = UDim2.new(0, 10, 0.15, 0)

local udim2 = UDim2.new(1, -20, 0.4, 0)

local udim3 = UDim2.new(0, 10, 0.55, 0)

local udim4 = UDim2.new(1, -20, 0.3, 0)

local CoreGui = game:GetService("CoreGui")

local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)
require(CoreGui.RobloxGui.Modules.Stats.StatsAggregator)

local StatsMiniTextPanel = {}
StatsMiniTextPanel.__index = StatsMiniTextPanel

function StatsMiniTextPanel.new(statType)
	local class = {}
	setmetatable(class, StatsMiniTextPanel)

	class._statType = statType

	class._frame = Instance.new("Frame")
	class._frame.Name = "StatsMiniTextPanelClass"

	class._frame.BackgroundTransparency = 1
	class._frame.ZIndex = StatsUtils.TextZIndex

	class._titleLabel = Instance.new("TextLabel")
	class._titleLabel.Name = "TitleLabel"
	class._valueLabel = Instance.new("TextLabel")
	class._valueLabel.Name = "ValueLabel"

	StatsUtils.StyleTextWidget(class._titleLabel)
	StatsUtils.StyleTextWidget(class._valueLabel)

	class._titleLabel.FontSize = StatsUtils.MiniPanelTitleFontSize
	class._titleLabel.Text = class:_getTitle()
	class._titleLabel.Parent = class._frame
	class._titleLabel.Size = udim2
	class._titleLabel.Position = udim
	class._titleLabel.TextXAlignment = Enum.TextXAlignment.Left

	class._valueLabel.FontSize = StatsUtils.MiniPanelValueFontSize
	class._valueLabel.Text = "0"
	class._valueLabel.Parent = class._frame
	class._valueLabel.Size = udim4
	class._valueLabel.Position = udim3
	class._valueLabel.TextXAlignment = Enum.TextXAlignment.Left

	return class
end

function StatsMiniTextPanel:SetZIndex(zIndex)
	self._frame.ZIndex = zIndex
	self._titleLabel.ZIndex = zIndex
	self.ZIndex = zIndex
end

function StatsMiniTextPanel:_getTitle()
	return StatsUtils.TypeToShortName[self._statType]
end

function StatsMiniTextPanel:PlaceInParent(parent, size, position)
	self._frame.Position = position
	self._frame.Size = size
	self._frame.Parent = parent
end

function StatsMiniTextPanel:SetStatsAggregator(aggregator)
	if self._aggregator then
		self._aggregator:RemoveListener(self._listenerId)
		self._listenerId = nil
		self._aggregator = nil
	end

	self._aggregator = aggregator

	self:_refreshVisibility()
end

function StatsMiniTextPanel:SetVisible(visible)
	self.frame.Visible = visible
	self:_refreshVisibility()
end

function StatsMiniTextPanel:_shouldBeVisible()
	if StatsUtils.PerformanceStatsShouldBeVisible() then
		return self._frame.Visible
	end

	return false
end

function StatsMiniTextPanel:_refreshVisibility()
	if not self:_shouldBeVisible() then
		self:_stopListening()

		return
	end

	self:_startListening()
	self:_updateFromAggregator()
end

function StatsMiniTextPanel:_stopListening()
	if not (self._aggregator ~= nil and self._listenerId ~= nil) then
		return
	end

	self._aggregator:RemoveListener(self._listenerId)
	self._listenerId = nil
end

function StatsMiniTextPanel:_startListening()
	if not (self._aggregator ~= nil and self._listenerId == nil) then
		return
	end

	self._listenerId = self._aggregator:AddListener(function()
		self:_updateFromAggregator()
	end)
end

function StatsMiniTextPanel:OnPerformanceStatsShouldBeVisibleChanged()
	self:_refreshVisibility()
end

function StatsMiniTextPanel:_updateFromAggregator()
	local v = self._aggregator == nil and 0 or self._aggregator:GetLatestValue()

	self._valueLabel.Text = StatsUtils.FormatTypedValue(v, self._statType)
end

return StatsMiniTextPanel
