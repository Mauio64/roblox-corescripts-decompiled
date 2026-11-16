local CoreGui = game:GetService("CoreGui")

local StyleWidgets = require(CoreGui.RobloxGui.Modules.StyleWidgets)
local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)
local StatsMiniTextPanel = require(CoreGui.RobloxGui.Modules.Stats.StatsMiniTextPanel)
local StatsAnnotatedGraph = require(CoreGui.RobloxGui.Modules.Stats.StatsAnnotatedGraph)

local udim = UDim2.new(0, 0, 0, 0)
local udim2 = UDim2.new(0.5, 0, 1, -StyleWidgets.TabSelectionHeight)
local udim3 = UDim2.new(0.5, 0, 0, 0)
local udim4 = UDim2.new(0.5, 0, 1, -StyleWidgets.TabSelectionHeight)

local StatsButton = {}
StatsButton.__index = StatsButton

function StatsButton.new(statType)
	local class = {}
	setmetatable(class, StatsButton)

	class._statType = statType
	class._button = Instance.new("TextButton")
	class._button.Name = "PS_Button"
	class._button.Text = ""

	StatsUtils.StyleButton(class._button)

	class._textPanel = StatsMiniTextPanel.new(statType)
	class._textPanel:PlaceInParent(class._button, udim2, udim)

	class._graph = StatsAnnotatedGraph.new(statType, false)
	class._graph:PlaceInParent(class._button, udim4, udim3)

	class._textPanel:SetZIndex(StatsUtils.TextZIndex)
	class._graph:SetZIndex(StatsUtils.GraphZIndex)

	class._tabSelection = StyleWidgets.MakeTabSelectionWidget(class._button)

	class._isSelected = false

	class:_updateTabSelectionState()

	return class
end

function StatsButton:OnPerformanceStatsShouldBeVisibleChanged()
	if self._graph then
		self._graph:OnPerformanceStatsShouldBeVisibleChanged()
	end

	if self._textPanel then
		self._textPanel:OnPerformanceStatsShouldBeVisibleChanged()
	end
end

function StatsButton:SetToggleCallbackFunction(callback)
	self._button.MouseButton1Click:connect(function()
		callback(self._statType)
	end)
end

function StatsButton:SetSizeAndPosition(size, position)
	self._button.Size = size
	self._button.Position = position
end

function StatsButton:SetIsSelected(isSelected)
	self._isSelected = isSelected
	self:_updateTabSelectionState()
end

function StatsButton:_updateTabSelectionState()
	self._tabSelection.Visible = self._isSelected
end

function StatsButton:SetParent(parent)
	self._button.Parent = parent
end

function StatsButton:SetStatsAggregator(p)
	self._textPanel:SetStatsAggregator(p)
	self._graph:SetStatsAggregator(p)
end

return StatsButton
