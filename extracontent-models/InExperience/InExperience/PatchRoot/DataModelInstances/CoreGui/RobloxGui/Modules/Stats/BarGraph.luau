local CoreGui = game:GetService("CoreGui")

local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)

local BarGraph = {}
BarGraph.__index = BarGraph

function BarGraph.new(showExtras)
	local class = {}
	setmetatable(class, BarGraph)

	class._barFrame = Instance.new("Frame")
	class._barFrame.Name = "PS_BarFrame"
	class._barFrame.BackgroundTransparency = 1

	class._lineFrame = Instance.new("Frame")
	class._lineFrame.Name = "PS_LineFrame"
	class._lineFrame.BackgroundTransparency = 1

	class._showExtras = showExtras

	class._values = {}
	class._bars = {}

	class._average = 0

	class._target = 0

	if class._showExtras then
		class:_addGraphTarget()
		class:_addGraphAverage()
	end

	return class
end

function BarGraph:SetZIndex(zIndex)
	self._barFrame.ZIndex = zIndex
	self._lineFrame.ZIndex = zIndex + 1

	if self._showExtras then
		self._targetLine.ZIndex = self._lineFrame.ZIndex
		self._averageLine.ZIndex = self._lineFrame.ZIndex
	end
end

function BarGraph:PlaceInParent(parent, size, position)
	self._barFrame.Position = position
	self._barFrame.Size = size
	self._barFrame.Parent = parent
	self._lineFrame.Position = position
	self._lineFrame.Size = size
	self._lineFrame.Parent = parent
end

function BarGraph:SetAxisMax(axisMax)
	self._axisMax = axisMax
end

function BarGraph:SetValues(values)
	self._values = values
end

function BarGraph:SetAverage(average)
	self._average = average
end

function BarGraph:SetTarget(target)
	self._target = target
	self:_moveGraphTarget()
end

function BarGraph:_updateBarCount(p)
	local count = #self._bars
	local bars = {}

	for i = 1, count do
		if i <= count then
			table.insert(bars, self._bars[i])
		else
			self._bars[i].Destroy()
		end
	end

	for i = count + 1, p do
		table.insert(bars, self:_makeNthBar(i))
	end

	self._bars = bars
end

function BarGraph:Render()
	local count = #self._values

	self:_updateBarCount(count)

	for i, value in ipairs(self._values) do
		self:_updateBar(i, value, count)
	end

	if self._showExtras then
		self:_moveGraphAverage()
	end
end

function BarGraph:_addGraphTarget()
	local targetLine = Instance.new("ImageLabel")
	targetLine.Name = "TargetLine"
	targetLine.Size = UDim2.new(1, 0, 0, StatsUtils.GraphTargetLineInnerThickness)

	targetLine.Image = "rbxasset://textures/ui/PerformanceStats/TargetLine.png"
	targetLine.BackgroundTransparency = 1
	targetLine.Parent = self._lineFrame
	targetLine.ZIndex = self._lineFrame.ZIndex
	targetLine.BorderSizePixel = 0

	targetLine.Changed:connect(function()
		self:_updateTargetLineImageSize()
	end)

	self._targetLine = targetLine
	self:_updateTargetLineImageSize()
end

function BarGraph:_updateTargetLineImageSize()
	self._targetLine.ImageRectSize = self._targetLine.AbsoluteSize
end

function BarGraph:_addGraphAverage()
	local averageLine = Instance.new("Frame")
	averageLine.Name = "AverageLine"
	averageLine.Size = UDim2.new(1, 0, 0, StatsUtils.GraphAverageLineInnerThickness)

	averageLine.Parent = self._lineFrame
	averageLine.ZIndex = self._lineFrame.ZIndex

	StatsUtils.StyleAverageLine(averageLine)

	self._averageLine = averageLine
end

function BarGraph:_moveGraphTarget()
	if self._targetLine == nil then
		return
	end

	self._targetLine.Position = UDim2.new(
		0,
		0,
		(self._axisMax - self._target) / self._axisMax,
		-StatsUtils.GraphTargetLineInnerThickness / 2
	)
end

function BarGraph:_moveGraphAverage()
	if self._averageLine == nil then
		return
	end

	local v = math.min(self._average, self._axisMax)

	self._averageLine.Position = UDim2.new(
		0,
		0,
		(self._axisMax - v) / self._axisMax,
		-StatsUtils.GraphAverageLineTotalThickness / 2
	)
end

function BarGraph:_makeNthBar(p)
	local v = p - 1
	local frame = Instance.new("Frame")
	frame.Name = string.format("Bar_%d", v)
	frame.Parent = self._barFrame
	frame.ZIndex = self._barFrame.ZIndex
	frame.BorderSizePixel = 0
	return frame
end

function BarGraph:_updateBar(p, p2, p3)
	local bar = self._bars[p]
	local v = p - 1

	local v2 = math.max(0, (math.min(p2, self._axisMax)))

	bar.Position = UDim2.new(v / p3, 0, (self._axisMax - v2) / self._axisMax, 0)
	bar.Size = UDim2.new(1 / p3, 0, v2 / self._axisMax, 0)

	bar.BackgroundColor3 = StatsUtils.GetColorForValue(p2, self._target)
end

return BarGraph
