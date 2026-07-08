local CoreGui = game:GetService("CoreGui")

game:GetService("CorePackages")

local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)

require(CoreGui.RobloxGui.Modules.Stats.StatsAggregator)

local DecoratedValueLabel = require(CoreGui.RobloxGui.Modules.Stats.DecoratedValueLabel)
local TextPanelTopMarginPix = StatsUtils.TextPanelTopMarginPix
local uDim2 = UDim2.new(0, StatsUtils.TextPanelLeftMarginPix, 0, TextPanelTopMarginPix)
local v6 = TextPanelTopMarginPix + StatsUtils.TextPanelTitleHeightY
local uDim2_2 = UDim2.new(0, StatsUtils.TextPanelLeftMarginPix, 0, v6)
local v8 = v6 + StatsUtils.TextPanelLegendItemHeightY
local uDim2_3 = UDim2.new(0, StatsUtils.TextPanelLeftMarginPix, 0, v8)
local v10 = v8 + StatsUtils.TextPanelLegendItemHeightY
local uDim2_4 = UDim2.new(0, StatsUtils.TextPanelLeftMarginPix, 0, v10)
local uDim2_5 = UDim2.new(1, -StatsUtils.TextPanelLeftMarginPix * 2, 0, StatsUtils.TextPanelTitleHeightY)
local uDim2_6 = UDim2.new(1, -StatsUtils.TextPanelLeftMarginPix * 2, 0, StatsUtils.TextPanelLegendItemHeightY)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 59
	-- upvalues: t1 (copy), StatsUtils (copy), uDim2_5 (copy), uDim2 (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2._statType = p1
	t2._frame = Instance.new("Frame")
	t2._frame.BackgroundTransparency = 1
	t2._frame.ZIndex = StatsUtils.TextZIndex
	t2._titleLabel = Instance.new("TextLabel")
	StatsUtils.StyleTextWidget(t2._titleLabel)
	t2._titleLabel.FontSize = StatsUtils.PanelTitleFontSize
	t2._titleLabel.Text = t2:_getTitle()
	t2._titleLabel.Parent = t2._frame
	t2._titleLabel.Size = uDim2_5
	t2._titleLabel.Position = uDim2
	t2._titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	t2._titleLabel.TextYAlignment = Enum.TextYAlignment.Top
	t2:_addCurrentValueWidget()
	t2:_addTargetValueWidget()
	t2:_addAverageValueWidget()

	return t2
end
function t1._getTarget(p2) -- line: 92
	if p2._performanceStats == nil then
		return 0
	end

	local p2_statMaxName = p2._performanceStats:FindFirstChild(p2._statMaxName)

	if p2_statMaxName == nil then
		return 0
	end

	return p2_statMaxName:GetValue()
end
function t1._addCurrentValueWidget(p3) -- line: 108
	-- upvalues: DecoratedValueLabel (copy), uDim2_6 (copy), uDim2_2 (copy), StatsUtils (copy)
	p3._currentValueWidget = DecoratedValueLabel.new(p3._statType, "Current")
	p3._currentValueWidget:PlaceInParent(p3._frame, uDim2_6, uDim2_2)

	local DecorationFrame = p3._currentValueWidget:GetDecorationFrame()
	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Position = UDim2.new(0.5, -StatsUtils.OvalKeySize / 2, 0.5, -StatsUtils.OvalKeySize / 2)
	ImageLabel.Size = UDim2.new(0, StatsUtils.OvalKeySize, 0, StatsUtils.OvalKeySize)
	ImageLabel.Parent = DecorationFrame
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = "rbxasset://textures/ui/PerformanceStats/OvalKey.png"
	ImageLabel.BorderSizePixel = 0
	p3._currentValueDecoration = ImageLabel
end
function t1._addTargetValueWidget(p4) -- line: 129
	-- upvalues: DecoratedValueLabel (copy), uDim2_6 (copy), uDim2_3 (copy), StatsUtils (copy)
	p4._targetValueWidget = DecoratedValueLabel.new(p4._statType, "Target")
	p4._targetValueWidget:PlaceInParent(p4._frame, uDim2_6, uDim2_3)

	local DecorationFrame = p4._targetValueWidget:GetDecorationFrame()
	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Position = UDim2.new(0.5, -StatsUtils.TargetKeyWidth / 2, 0.5, -StatsUtils.TargetKeyHeight / 2)
	ImageLabel.Size = UDim2.new(0, StatsUtils.TargetKeyWidth, 0, StatsUtils.TargetKeyHeight)
	ImageLabel.Parent = DecorationFrame
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = "rbxasset://textures/ui/PerformanceStats/TargetKey.png"
end
function t1._addAverageValueWidget(p5) -- line: 148
	-- upvalues: DecoratedValueLabel (copy), uDim2_6 (copy), uDim2_4 (copy), StatsUtils (copy)
	p5._averageValueWidget = DecoratedValueLabel.new(p5._statType, "Average")
	p5._averageValueWidget:PlaceInParent(p5._frame, uDim2_6, uDim2_4)

	local DecorationFrame = p5._averageValueWidget:GetDecorationFrame()
	local Frame = Instance.new("Frame")

	Frame.Position = UDim2.new(0, 0, 0.5, -StatsUtils.GraphAverageLineTotalThickness / 2)
	Frame.Size = UDim2.new(1, 0, 0, StatsUtils.GraphAverageLineInnerThickness)
	Frame.Parent = DecorationFrame
	StatsUtils.StyleAverageLine(Frame)
end
function t1._getTitle(p6) -- line: 165
	-- upvalues: StatsUtils (copy)
	return StatsUtils.TypeToName[p6._statType]
end
function t1.PlaceInParent(p7, p8, p9, p10) -- line: 169
	p7._frame.Position = p10
	p7._frame.Size = p9
	p7._frame.Parent = p8
end
function t1.SetStatsAggregator(p11, p12) -- line: 176
	if p11._aggregator then
		p11._aggregator:RemoveListener(p11._listenerId)
		p11._listenerId = nil
		p11._aggregator = nil
	end

	p11._aggregator = p12
	p11:_refreshVisibility()
end
function t1.SetVisible(p13, p14) -- line: 188
	p13._frame.Visible = p14
	p13:_refreshVisibility()
end
function t1._shouldBeVisible(p15) -- line: 193
	-- upvalues: StatsUtils (copy)
	if StatsUtils.PerformanceStatsShouldBeVisible() then
		return p15._frame.Visible
	end

	return false
end
function t1._refreshVisibility(p16) -- line: 201
	if p16:_shouldBeVisible() then
		p16:_startListening()
		p16:_updateFromAggregator()

		return
	end

	p16:_stopListening()
end
function t1.OnPerformanceStatsShouldBeVisibleChanged(p17) -- line: 210
	p17:_refreshVisibility()
end
function t1._stopListening(p18) -- line: 214
	if p18._aggregator == nil then
		return
	end

	if p18._listenerId == nil then
		return
	end

	p18._aggregator:RemoveListener(p18._listenerId)
	p18._listenerId = nil
end
function t1._startListening(p19) -- line: 227
	if p19._aggregator == nil then
		return
	end

	if p19._listenerId ~= nil then
		return
	end

	p19._listenerId = p19._aggregator:AddListener(function() -- line: 236
		-- upvalues: p19 (copy)
		p19:_updateFromAggregator()
	end)
end
function t1._updateFromAggregator(p20) -- line: 241
	-- upvalues: StatsUtils (copy)
	local n1 = 0
	local n2 = 0
	local n3 = 0

	if p20._aggregator ~= nil then
		n1 = p20._aggregator:GetLatestValue()
		n2 = p20._aggregator:GetAverage()
		n3 = p20._aggregator:GetTarget()
	end

	p20._currentValueWidget:SetValue(n1)
	p20._targetValueWidget:SetValue(n3)
	p20._averageValueWidget:SetValue(n2)
	p20._currentValueDecoration.ImageColor3 = StatsUtils.GetColorForValue(n1, n3)
end
function t1.SetZIndex(p21, p22) -- line: 260
	p21._frame.ZIndex = p22
	p21._titleLabel.ZIndex = p22
	p21._currentValueWidget:SetZIndex(p22)
	p21._averageValueWidget:SetZIndex(p22)
end

return t1
