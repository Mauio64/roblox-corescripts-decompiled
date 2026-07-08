local uDim2 = UDim2.new(0, 10, 0.15, 0)
local uDim2_2 = UDim2.new(1, -20, 0.4, 0)
local uDim2_3 = UDim2.new(0, 10, 0.55, 0)
local uDim2_4 = UDim2.new(1, -20, 0.3, 0)
local CoreGui = game:GetService("CoreGui")
local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)

require(CoreGui.RobloxGui.Modules.Stats.StatsAggregator)

local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 43
	-- upvalues: t1 (copy), StatsUtils (copy), uDim2_2 (copy), uDim2 (copy), uDim2_4 (copy), uDim2_3 (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2._statType = p1
	t2._frame = Instance.new("Frame")
	t2._frame.Name = "StatsMiniTextPanelClass"
	t2._frame.BackgroundTransparency = 1
	t2._frame.ZIndex = StatsUtils.TextZIndex
	t2._titleLabel = Instance.new("TextLabel")
	t2._titleLabel.Name = "TitleLabel"
	t2._valueLabel = Instance.new("TextLabel")
	t2._valueLabel.Name = "ValueLabel"
	StatsUtils.StyleTextWidget(t2._titleLabel)
	StatsUtils.StyleTextWidget(t2._valueLabel)
	t2._titleLabel.FontSize = StatsUtils.MiniPanelTitleFontSize
	t2._titleLabel.Text = t2:_getTitle()
	t2._titleLabel.Parent = t2._frame
	t2._titleLabel.Size = uDim2_2
	t2._titleLabel.Position = uDim2
	t2._titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	t2._valueLabel.FontSize = StatsUtils.MiniPanelValueFontSize
	t2._valueLabel.Text = "0"
	t2._valueLabel.Parent = t2._frame
	t2._valueLabel.Size = uDim2_4
	t2._valueLabel.Position = uDim2_3
	t2._valueLabel.TextXAlignment = Enum.TextXAlignment.Left

	return t2
end
function t1.SetZIndex(p2, p3) -- line: 80
	p2._frame.ZIndex = p3
	p2._titleLabel.ZIndex = p3
	p2.ZIndex = p3
end
function t1._getTitle(p4) -- line: 86
	-- upvalues: StatsUtils (copy)
	return StatsUtils.TypeToShortName[p4._statType]
end
function t1.PlaceInParent(p5, p6, p7, p8) -- line: 90
	p5._frame.Position = p8
	p5._frame.Size = p7
	p5._frame.Parent = p6
end
function t1.SetStatsAggregator(p9, p10) -- line: 96
	if p9._aggregator then
		p9._aggregator:RemoveListener(p9._listenerId)
		p9._listenerId = nil
		p9._aggregator = nil
	end

	p9._aggregator = p10
	p9:_refreshVisibility()
end
function t1.SetVisible(p11, p12) -- line: 108
	p11.frame.Visible = p12
	p11:_refreshVisibility()
end
function t1._shouldBeVisible(p13) -- line: 113
	-- upvalues: StatsUtils (copy)
	if StatsUtils.PerformanceStatsShouldBeVisible() then
		return p13._frame.Visible
	end

	return false
end
function t1._refreshVisibility(p14) -- line: 122
	if p14:_shouldBeVisible() then
		p14:_startListening()
		p14:_updateFromAggregator()

		return
	end

	p14:_stopListening()
end
function t1._stopListening(p15) -- line: 131
	if p15._aggregator == nil then
		return
	end

	if p15._listenerId == nil then
		return
	end

	p15._aggregator:RemoveListener(p15._listenerId)
	p15._listenerId = nil
end
function t1._startListening(p16) -- line: 144
	if p16._aggregator == nil then
		return
	end

	if p16._listenerId ~= nil then
		return
	end

	p16._listenerId = p16._aggregator:AddListener(function() -- line: 153
		-- upvalues: p16 (copy)
		p16:_updateFromAggregator()
	end)
end
function t1.OnPerformanceStatsShouldBeVisibleChanged(p17) -- line: 158
	p17:_refreshVisibility()
end
function t1._updateFromAggregator(p18) -- line: 162
	-- upvalues: StatsUtils (copy)
	local v27 = p18._aggregator == nil and 0 or p18._aggregator:GetLatestValue()

	p18._valueLabel.Text = StatsUtils.FormatTypedValue(v27, p18._statType)
end

return t1
