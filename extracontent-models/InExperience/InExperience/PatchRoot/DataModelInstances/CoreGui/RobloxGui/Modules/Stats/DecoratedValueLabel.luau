local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)

require(CorePackages.Workspace.Packages.RobloxTranslator)

local t1 = {}

t1.__index = t1

function t1.new(p1, p2) -- line: 19
	-- upvalues: t1 (copy), StatsUtils (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2._frame = Instance.new("Frame")
	t2._frame.Name = "PS_DecoratedValueLabel"
	t2._frame.BackgroundTransparency = 1
	t2._valueName = p2
	t2._statType = p1
	t2._decorationFrame = Instance.new("Frame")
	t2._decorationFrame.Name = "PS_Decoration"
	t2._decorationFrame.Parent = t2._frame
	t2._decorationFrame.Position = UDim2.new(0, 0, 0.5, -StatsUtils.DecorationSize / 2)
	t2._decorationFrame.Size = UDim2.new(0, StatsUtils.DecorationSize, 0, StatsUtils.DecorationSize)
	t2._decorationFrame.BackgroundTransparency = 1
	t2._label = Instance.new("TextLabel")
	t2._label.Name = "Label"
	t2._label.Parent = t2._frame
	t2._label.Position = UDim2.new(0, StatsUtils.DecorationSize + StatsUtils.DecorationMargin, 0, 0)
	t2._label.Size = UDim2.new(1, -(StatsUtils.DecorationSize + StatsUtils.DecorationMargin), 1, 0)
	t2._label.FontSize = StatsUtils.PanelValueFontSize
	t2._label.TextXAlignment = Enum.TextXAlignment.Left
	t2._label.TextYAlignment = Enum.TextYAlignment.Center
	StatsUtils.StyleTextWidget(t2._label)

	return t2
end
function t1.SetZIndex(p3, p4) -- line: 53
	p3._frame.ZIndex = p4
	p3._decorationFrame.ZIndex = p4
	p3._label.ZIndex = p4
end
function t1.PlaceInParent(p5, p6, p7, p8) -- line: 60
	p5._frame.Parent = p6
	p5._frame.Size = p7
	p5._frame.Position = p8
end
function t1.GetDecorationFrame(p9) -- line: 67
	return p9._decorationFrame
end
function t1.SetValue(p10, p11) -- line: 71
	-- upvalues: StatsUtils (copy)
	local v17 = StatsUtils.FormatTypedValue(p11, p10._statType)

	p10._label.Text = string.format("%s: %s", p10._valueName, v17)
end

return t1
