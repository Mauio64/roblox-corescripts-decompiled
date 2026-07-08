local CoreGui = game:GetService("CoreGui")
local StyleWidgets = require(CoreGui.RobloxGui.Modules.StyleWidgets)
local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)
local StatsMiniTextPanel = require(CoreGui.RobloxGui.Modules.Stats.StatsMiniTextPanel)
local StatsAnnotatedGraph = require(CoreGui.RobloxGui.Modules.Stats.StatsAnnotatedGraph)
local uDim2 = UDim2.new(0, 0, 0, 0)
local uDim2_2 = UDim2.new(0.5, 0, 1, -StyleWidgets.TabSelectionHeight)
local uDim2_3 = UDim2.new(0.5, 0, 0, 0)
local uDim2_4 = UDim2.new(0.5, 0, 1, -StyleWidgets.TabSelectionHeight)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 30
	-- upvalues: t1 (copy), StatsUtils (copy), StatsMiniTextPanel (copy), uDim2_2 (copy), uDim2 (copy), StatsAnnotatedGraph (copy), uDim2_4 (copy), uDim2_3 (copy), StyleWidgets (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2._statType = p1
	t2._button = Instance.new("TextButton")
	t2._button.Name = "PS_Button"
	t2._button.Text = ""
	StatsUtils.StyleButton(t2._button)
	t2._textPanel = StatsMiniTextPanel.new(p1)
	t2._textPanel:PlaceInParent(t2._button, uDim2_2, uDim2)
	t2._graph = StatsAnnotatedGraph.new(p1, false)
	t2._graph:PlaceInParent(t2._button, uDim2_4, uDim2_3)
	t2._textPanel:SetZIndex(StatsUtils.TextZIndex)
	t2._graph:SetZIndex(StatsUtils.GraphZIndex)
	t2._tabSelection = StyleWidgets.MakeTabSelectionWidget(t2._button)
	t2._isSelected = false
	t2:_updateTabSelectionState()

	return t2
end
function t1.OnPerformanceStatsShouldBeVisibleChanged(p2) -- line: 63
	if p2._graph then
		p2._graph:OnPerformanceStatsShouldBeVisibleChanged()
	end

	if p2._textPanel then
		p2._textPanel:OnPerformanceStatsShouldBeVisibleChanged()
	end
end
function t1.SetToggleCallbackFunction(p3, p4) -- line: 73
	p3._button.MouseButton1Click:connect(function() -- line: 74
		-- upvalues: p4 (copy), p3 (copy)
		p4(p3._statType)
	end)
end
function t1.SetSizeAndPosition(p5, p6, p7) -- line: 79
	p5._button.Size = p6
	p5._button.Position = p7
end
function t1.SetIsSelected(p8, p9) -- line: 84
	p8._isSelected = p9
	p8:_updateTabSelectionState()
end
function t1._updateTabSelectionState(p10) -- line: 89
	p10._tabSelection.Visible = p10._isSelected
end
function t1.SetParent(p11, p12) -- line: 93
	p11._button.Parent = p12
end
function t1.SetStatsAggregator(p13, p14) -- line: 97
	p13._textPanel:SetStatsAggregator(p14)
	p13._graph:SetStatsAggregator(p14)
end

return t1
