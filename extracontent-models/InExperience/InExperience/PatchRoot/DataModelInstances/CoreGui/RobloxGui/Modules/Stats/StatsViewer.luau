local CoreGui = game:GetService("CoreGui")
local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)
local StatsTextPanel = require(CoreGui.RobloxGui.Modules.Stats.StatsTextPanel)
local StatsAnnotatedGraph = require(CoreGui.RobloxGui.Modules.Stats.StatsAnnotatedGraph)
local uDim2 = UDim2.new(0, 0, 0, 0)
local uDim2_2 = UDim2.new(0.4, 0, 1, 0)
local uDim2_3 = UDim2.new(0.4, 0, 0, 0)
local uDim2_4 = UDim2.new(0.6, 0, 1, 0)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 31
	-- upvalues: t1 (copy), StatsUtils (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2._frameImageLabel = Instance.new("ImageLabel")
	t2._frameImageLabel.Name = "PS_Viewer"
	t2._frameImageLabel.Image = "rbxasset://textures/ui/PerformanceStats/BackgroundRounded.png"
	t2._frameImageLabel.ScaleType = Enum.ScaleType.Slice
	t2._frameImageLabel.SliceCenter = Rect.new(10, 10, 22, 22)
	t2._frameImageLabel.BackgroundTransparency = 1
	t2._frameImageLabel.ImageColor3 = StatsUtils.NormalColor
	t2._frameImageLabel.ImageTransparency = StatsUtils.Transparency
	t2._textPanel = nil
	t2._statType = nil
	t2._graph = nil

	return t2
end
function t1.OnPerformanceStatsShouldBeVisibleChanged(p1) -- line: 51
	if p1._graph then
		p1._graph:OnPerformanceStatsShouldBeVisibleChanged()
	end

	if p1._textPanel then
		p1._textPanel:OnPerformanceStatsShouldBeVisibleChanged()
	end
end
function t1.GetIsVisible(p2) -- line: 60
	return p2._frameImageLabel.Visible
end
function t1.GetStatType(p3) -- line: 64
	return p3._statType
end
function t1.SetSizeAndPosition(p4, p5, p6) -- line: 68
	p4._frameImageLabel.Size = p5
	p4._frameImageLabel.Position = p6
end
function t1.SetParent(p7, p8) -- line: 73
	p7._frameImageLabel.Parent = p8
end
function t1.SetVisible(p9, p10) -- line: 77
	p9._frameImageLabel.Visible = p10

	if p9._graph then
		p9._graph:SetVisible(p10)
	end

	if p9._textPanel then
		p9._textPanel:SetVisible(p10)
	end
end
function t1.SetStatType(p11, p12) -- line: 89
	-- upvalues: StatsTextPanel (copy), uDim2_2 (copy), uDim2 (copy), StatsAnnotatedGraph (copy), uDim2_4 (copy), uDim2_3 (copy), StatsUtils (copy)
	p11._statType = p12
	p11._frameImageLabel:ClearAllChildren()

	if p11._textPanel then
		p11._textPanel:SetVisible(false)
		p11._textPanel = nil
	end

	p11._textPanel = StatsTextPanel.new(p12)
	p11._textPanel:PlaceInParent(p11._frameImageLabel, uDim2_2, uDim2)
	p11._graph = StatsAnnotatedGraph.new(p12, true)
	p11._graph:PlaceInParent(p11._frameImageLabel, uDim2_4, uDim2_3)
	p11._textPanel:SetZIndex(StatsUtils.TextZIndex)
	p11._graph:SetZIndex(StatsUtils.GraphZIndex)
	p11._graph:SetVisible(p11._frameImageLabel.Visible)
	p11._textPanel:SetVisible(p11._frameImageLabel.Visible)
	p11:_applyStatsAggregator()
end
function t1._applyStatsAggregator(p13) -- line: 118
	if p13._aggregator == nil then
		return
	end

	if p13._textPanel then
		p13._textPanel:SetStatsAggregator(p13._aggregator)
	end

	if p13._graph then
		p13._graph:SetStatsAggregator(p13._aggregator)
	end
end
function t1.SetStatsAggregator(p14, p15) -- line: 132
	p14._aggregator = p15
	p14:_applyStatsAggregator()
end

return t1
