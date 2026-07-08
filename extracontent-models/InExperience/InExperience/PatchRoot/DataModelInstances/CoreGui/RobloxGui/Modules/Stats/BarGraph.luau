local CoreGui = game:GetService("CoreGui")
local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 23
	-- upvalues: t1 (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2._barFrame = Instance.new("Frame")
	t2._barFrame.Name = "PS_BarFrame"
	t2._barFrame.BackgroundTransparency = 1
	t2._lineFrame = Instance.new("Frame")
	t2._lineFrame.Name = "PS_LineFrame"
	t2._lineFrame.BackgroundTransparency = 1
	t2._showExtras = p1
	t2._values = {}
	t2._bars = {}
	t2._average = 0
	t2._target = 0

	if t2._showExtras then
		t2:_addGraphTarget()
		t2:_addGraphAverage()
	end

	return t2
end
function t1.SetZIndex(p2, p3) -- line: 53
	p2._barFrame.ZIndex = p3
	p2._lineFrame.ZIndex = p3 + 1

	if p2._showExtras then
		p2._targetLine.ZIndex = p2._lineFrame.ZIndex
		p2._averageLine.ZIndex = p2._lineFrame.ZIndex
	end
end
function t1.PlaceInParent(p4, p5, p6, p7) -- line: 62
	p4._barFrame.Position = p7
	p4._barFrame.Size = p6
	p4._barFrame.Parent = p5
	p4._lineFrame.Position = p7
	p4._lineFrame.Size = p6
	p4._lineFrame.Parent = p5
end
function t1.SetAxisMax(p8, p9) -- line: 71
	p8._axisMax = p9
end
function t1.SetValues(p10, p11) -- line: 75
	p10._values = p11
end
function t1.SetAverage(p12, p13) -- line: 79
	p12._average = p13
end
function t1.SetTarget(p14, p15) -- line: 83
	p14._target = p15
	p14:_moveGraphTarget()
end
function t1._updateBarCount(p16, p17) -- line: 90
	local t3 = {}
	local v23 = #p16._bars

	for i = 1, v23 do
		if i <= v23 then
			table.insert(t3, p16._bars[i])
		else
			p16._bars[i].Destroy()
		end
	end

	for i = v23 + 1, p17 do
		table.insert(t3, p16:_makeNthBar(i))
	end

	p16._bars = t3
end
function t1.Render(p18) -- line: 113
	local v27 = #p18._values

	p18:_updateBarCount(v27)

	for i, v in ipairs(p18._values) do
		p18:_updateBar(i, v, v27)
	end

	if p18._showExtras then
		p18:_moveGraphAverage()
	end
end
function t1._addGraphTarget(p19) -- line: 128
	-- upvalues: StatsUtils (copy)
	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Name = "TargetLine"
	ImageLabel.Size = UDim2.new(1, 0, 0, StatsUtils.GraphTargetLineInnerThickness)
	ImageLabel.Image = "rbxasset://textures/ui/PerformanceStats/TargetLine.png"
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Parent = p19._lineFrame
	ImageLabel.ZIndex = p19._lineFrame.ZIndex
	ImageLabel.BorderSizePixel = 0
	ImageLabel.Changed:connect(function() -- line: 140
		-- upvalues: p19 (copy)
		p19:_updateTargetLineImageSize()
	end)
	p19._targetLine = ImageLabel
	p19:_updateTargetLineImageSize()
end
function t1._updateTargetLineImageSize(p20) -- line: 148
	p20._targetLine.ImageRectSize = p20._targetLine.AbsoluteSize
end
function t1._addGraphAverage(p21) -- line: 152
	-- upvalues: StatsUtils (copy)
	local Frame = Instance.new("Frame")

	Frame.Name = "AverageLine"
	Frame.Size = UDim2.new(1, 0, 0, StatsUtils.GraphAverageLineInnerThickness)
	Frame.Parent = p21._lineFrame
	Frame.ZIndex = p21._lineFrame.ZIndex
	StatsUtils.StyleAverageLine(Frame)
	p21._averageLine = Frame
end
function t1._moveGraphTarget(p22) -- line: 166
	-- upvalues: StatsUtils (copy)
	if p22._targetLine == nil then
		return
	end

	p22._targetLine.Position = UDim2.new(0, 0, (p22._axisMax - p22._target) / p22._axisMax, -StatsUtils.GraphTargetLineInnerThickness / 2)
end
function t1._moveGraphAverage(p23) -- line: 177
	-- upvalues: StatsUtils (copy)
	if p23._averageLine == nil then
		return
	end

	local v37 = math.min(p23._average, p23._axisMax)

	p23._averageLine.Position = UDim2.new(0, 0, (p23._axisMax - v37) / p23._axisMax, -StatsUtils.GraphAverageLineTotalThickness / 2)
end
function t1._makeNthBar(p24, p25) -- line: 192
	local v40 = p25 - 1
	local Frame = Instance.new("Frame")

	Frame.Name = string.format("Bar_%d", v40)
	Frame.Parent = p24._barFrame
	Frame.ZIndex = p24._barFrame.ZIndex
	Frame.BorderSizePixel = 0

	return Frame
end
function t1._updateBar(p26, p27, p28, p29) -- line: 203
	-- upvalues: StatsUtils (copy)
	local v46 = p26._bars[p27]
	local v47 = p27 - 1
	local v48 = math.max(0, (math.min(p28, p26._axisMax)))

	v46.Position = UDim2.new(v47 / p29, 0, (p26._axisMax - v48) / p26._axisMax, 0)
	v46.Size = UDim2.new(1 / p29, 0, v48 / p26._axisMax, 0)
	v46.BackgroundColor3 = StatsUtils.GetColorForValue(p28, p26._target)
end

return t1
