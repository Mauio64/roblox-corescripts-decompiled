local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)

require(CorePackages.Workspace.Packages.RobloxTranslator)

local DecoratedValueLabel = {}
DecoratedValueLabel.__index = DecoratedValueLabel

function DecoratedValueLabel.new(statType, valueName)
	local v = {}
	setmetatable(v, DecoratedValueLabel)

	v._frame = Instance.new("Frame")
	v._frame.Name = "PS_DecoratedValueLabel"
	v._frame.BackgroundTransparency = 1
	v._valueName = valueName
	v._statType = statType

	v._decorationFrame = Instance.new("Frame")
	v._decorationFrame.Name = "PS_Decoration"
	v._decorationFrame.Parent = v._frame
	v._decorationFrame.Position = UDim2.new(0, 0, 0.5, -StatsUtils.DecorationSize / 2)
	v._decorationFrame.Size = UDim2.new(0, StatsUtils.DecorationSize, 0, StatsUtils.DecorationSize)
	v._decorationFrame.BackgroundTransparency = 1

	v._label = Instance.new("TextLabel")
	v._label.Name = "Label"
	v._label.Parent = v._frame
	v._label.Position = UDim2.new(0, StatsUtils.DecorationSize + StatsUtils.DecorationMargin, 0, 0)

	v._label.Size = UDim2.new(1, -(StatsUtils.DecorationSize + StatsUtils.DecorationMargin), 1, 0)

	v._label.FontSize = StatsUtils.PanelValueFontSize
	v._label.TextXAlignment = Enum.TextXAlignment.Left
	v._label.TextYAlignment = Enum.TextYAlignment.Center

	StatsUtils.StyleTextWidget(v._label)

	return v
end

function DecoratedValueLabel:SetZIndex(zIndex)
	self._frame.ZIndex = zIndex
	self._decorationFrame.ZIndex = zIndex
	self._label.ZIndex = zIndex
end

function DecoratedValueLabel:PlaceInParent(parent, size, position)
	self._frame.Parent = parent
	self._frame.Size = size
	self._frame.Position = position
end

function DecoratedValueLabel:GetDecorationFrame()
	return self._decorationFrame
end

function DecoratedValueLabel:SetValue(p)
	local formatTypedValue = StatsUtils.FormatTypedValue(p, self._statType)
	self._label.Text = string.format("%s: %s", self._valueName, formatTypedValue)
end

return DecoratedValueLabel
