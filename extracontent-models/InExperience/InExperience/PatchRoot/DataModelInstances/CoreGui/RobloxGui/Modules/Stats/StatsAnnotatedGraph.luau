local CoreGui = game:GetService("CoreGui")
local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)
local BarGraph = require(CoreGui.RobloxGui.Modules.Stats.BarGraph)
local t1 = {}

t1.__index = t1

function t1.new(p1, p2) -- line: 24
	-- upvalues: t1 (copy), StatsUtils (copy), BarGraph (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2._statType = p1
	t2._statMaxName = StatsUtils.StatMaxNames[p1]
	t2._isMaximized = p2
	t2._values = {}
	t2._average = 0
	t2._target = 0
	t2._axisMax = 0
	t2._frame = Instance.new("Frame")
	t2._frame.Name = "PS_AnnotatedGraph"
	t2._frame.BackgroundTransparency = 1
	t2._frame.ZIndex = StatsUtils.GraphZIndex
	t2._topLabel = Instance.new("TextLabel")
	t2._topLabel.Name = "PS_TopAxisLabel"
	t2._topLabel.Parent = t2._frame
	t2._topLabel.TextXAlignment = Enum.TextXAlignment.Left
	t2._topLabel.TextYAlignment = Enum.TextYAlignment.Top
	t2._topLabel.FontSize = StatsUtils.PanelGraphFontSize
	t2._bottomLabel = Instance.new("TextLabel")
	t2._bottomLabel.Name = "PS_BottomAxisLabel"
	t2._bottomLabel.Parent = t2._frame
	t2._bottomLabel.TextXAlignment = Enum.TextXAlignment.Left
	t2._bottomLabel.TextYAlignment = Enum.TextYAlignment.Bottom
	t2._bottomLabel.FontSize = StatsUtils.PanelGraphFontSize
	t2._graph = BarGraph.new(p2)
	StatsUtils.StyleTextWidget(t2._topLabel)
	StatsUtils.StyleTextWidget(t2._bottomLabel)
	t2:_layoutElements()

	return t2
end
function t1.SetZIndex(p3, p4) -- line: 71
	p3._frame.ZIndex = p4
	p3._topLabel.ZIndex = p4
	p3._bottomLabel.ZIndex = p4
	p3._graph:SetZIndex(p4)
end
function t1._layoutElements(p5) -- line: 78
	local n1

	if p5._isMaximized then
		n1 = 30
		p5._topLabel.Visible = true
		p5._bottomLabel.Visible = true
	else
		n1 = 0
		p5._topLabel.Visible = false
		p5._bottomLabel.Visible = false
	end

	local uDim2 = UDim2.new(0, 10, 0, 10)
	local uDim2_2 = UDim2.new(1, -(20 + n1), 1, -20)
	local uDim2_3 = UDim2.new(1, -(10 + n1), 0, 10)
	local uDim2_4 = UDim2.new(0, n1, 0.333, -20)
	local uDim2_5 = UDim2.new(1, -(10 + n1), 0.666, 10)
	local uDim2_6 = UDim2.new(0, n1, 0.333, -20)

	p5._topLabel.Size = uDim2_4
	p5._topLabel.Position = uDim2_3
	p5._bottomLabel.Size = uDim2_6
	p5._bottomLabel.Position = uDim2_5
	p5._graph:PlaceInParent(p5._frame, uDim2_2, uDim2)
end
function t1.PlaceInParent(p6, p7, p8, p9) -- line: 108
	p6._frame.Position = p9
	p6._frame.Size = p8
	p6._frame.Parent = p7
end
function t1._getTarget(p10) -- line: 114
	if p10._performanceStats == nil then
		return 0
	end

	local p10_statMaxName = p10._performanceStats:FindFirstChild(p10._statMaxName)

	if p10_statMaxName == nil then
		return 0
	end

	return p10_statMaxName:GetValue()
end
function t1._render(p11) -- line: 128
	p11._graph:SetAxisMax(p11._axisMax)
	p11._graph:SetValues(p11._values)
	p11._graph:SetAverage(p11._average)
	p11._graph:SetTarget(p11._target)
	p11._graph:Render()
	p11._topLabel.Text = string.format("%.2f", p11._axisMax)
	p11._bottomLabel.Text = string.format("%.2f", 0)
end
function t1._calculateAxisMax(p12) -- line: 140
	local v26 = p12._target * 2
	local v27 = p12:_recursiveGetOrderOfMagnitude(1, v26)

	p12._axisMax = math.floor(0.5 + v26 / v27) * v27
end
function t1.SetStatsAggregator(p13, p14) -- line: 150
	if p13._aggregator then
		p13._aggregator:RemoveListener(p13._listenerId)
		p13._listenerId = nil
		p13._aggregator = nil
	end

	p13._aggregator = p14
	p13:_refreshVisibility()
end
function t1._stopListening(p15) -- line: 162
	if p15._aggregator == nil then
		return
	end

	if p15._listenerId == nil then
		return
	end

	p15._aggregator:RemoveListener(p15._listenerId)
	p15._listenerId = nil
end
function t1._startListening(p16) -- line: 175
	if p16._aggregator == nil then
		return
	end

	if p16._listenerId ~= nil then
		return
	end

	p16._listenerId = p16._aggregator:AddListener(function() -- line: 184
		-- upvalues: p16 (copy)
		p16:_updateValuesAndRender()
	end)
end
function t1._shouldBeVisible(p17) -- line: 189
	-- upvalues: StatsUtils (copy)
	if StatsUtils.PerformanceStatsShouldBeVisible() then
		return p17._frame.Visible
	end

	return false
end
function t1.SetVisible(p18, p19) -- line: 197
	p18._frame.Visible = p19
	p18:_refreshVisibility()
end
function t1._refreshVisibility(p20) -- line: 202
	if p20:_shouldBeVisible() then
		p20:_startListening()
		p20:_updateValuesAndRender()

		return
	end

	p20:_stopListening()
end
function t1.OnPerformanceStatsShouldBeVisibleChanged(p21) -- line: 211
	p21:_refreshVisibility()
end
function t1._recursiveGetOrderOfMagnitude(p22, p23, p24) -- line: 215
	if p24 < p23 then
		return p22:_recursiveGetOrderOfMagnitude(p23 / 10, p24)
	end

	if p24 <= p23 * 10 then
		return p23
	end

	return p22:_recursiveGetOrderOfMagnitude(p23 * 10, p24)
end
function t1._updateValuesAndRender(p25) -- line: 227
	p25._values = {}
	p25._average = 0
	p25._target = 0

	if p25._aggregator ~= nil then
		p25._values = p25._aggregator:GetValues()
		p25._average = p25._aggregator:GetAverage()
		p25._target = p25._aggregator:GetTarget()
	end

	p25:_calculateAxisMax()
	p25:_render()
end

return t1
