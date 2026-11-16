local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local ProfilerUtil = require(script.Parent.ProfilerUtil)

local getDurations = ProfilerUtil.getDurations
local getSourceName = ProfilerUtil.getSourceName
local getLine = ProfilerUtil.getLine
local getNativeFlag = ProfilerUtil.getNativeFlag
local getPluginFlag = ProfilerUtil.getPluginFlag
local standardizeChildren = ProfilerUtil.standardizeChildren

local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)
local Tooltip = require(Components.Tooltip)

local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor

local EntryFrameHeight = Constants.GeneralFormatting.EntryFrameHeight
local DepthIndent = Constants.ScriptProfilerFormatting.DepthIndent
local ValueCellWidth = Constants.ScriptProfilerFormatting.ValueCellWidth
local CellPadding = Constants.ScriptProfilerFormatting.CellPadding
local ValuePadding = Constants.ScriptProfilerFormatting.ValuePadding

local extended = Roact.PureComponent:extend("ProfilerFunctionViewEntry")

local function BorderedCellLabel(props)
	return Roact.createFragment({
		Label = Roact.createElement(CellLabel, {
			text = props.text,
			size = props.size,
			pos = props.pos
		}),
		LeftBorder = Roact.createElement("Frame", {
			Size = UDim2.new(UDim.new(0, LineWidth), props.size.Y),
			Position = UDim2.fromOffset(-ValuePadding, 0) + props.pos,
			AnchorPoint = Vector2.new(0, 0),
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		})
	})
end

function extended:init()
	self.state = {
		expanded = self.props.depth == 0,
		showTooltip = false,
		tooltipPos = UDim2.fromOffset(0, 0)
	}

	function self.onButtonPress()
		self:setState(function(_)
			return {
				expanded = not self.state.expanded
			}
		end)
	end

	function self.onMouseEnter(_, p, p2)
		self:setState({ showTooltip = true, tooltipPos = UDim2.fromOffset(p, p2) })
	end

	function self.onMouseMove(_, p, p2)
		self:setState({ showTooltip = true, tooltipPos = UDim2.fromOffset(p, p2) })
	end

	function self.onMouseLeave()
		self:setState({ showTooltip = false })
	end
end

function extended:renderValues(list)
	local udim = UDim2.new(ValueCellWidth, -ValuePadding, 0, EntryFrameHeight)
	local udim2 = UDim2.new(1 - ValueCellWidth * #list, ValuePadding, 0, 0)
	local children = {}

	for i, item in ipairs(list) do
		children[tostring(i)] = Roact.createElement(BorderedCellLabel, {
			text = tostring(item),
			size = udim,
			pos = udim2 + UDim2.fromScale(ValueCellWidth * (i - 1), 0)
		})
	end

	return children
end

function extended:render()
	local props = self.props

	local size = props.size or UDim2.new(1, 0, 0, EntryFrameHeight)
	local layoutOrder = props.layoutOrder or 0

	local percentageRatio = props.percentageRatio
	local data = props.data

	local functionId = props.functionId
	local v = data.Functions[functionId]

	local v2 = v.TotalDuration / self.props.average - (self.props.gcOffset or 0)

	local nativeFlag = getNativeFlag(data, v)
	local pluginFlag = getPluginFlag(data, v)
	local v3

	if percentageRatio then
		v3 = percentageRatio == 0 and "N/A" or string.format("%.3f%%", v2 / percentageRatio)
	else
		v3 = string.format("%.3f", v2 * 1000)
	end

	local v4 = { v3 }

	local nodeName = props.nodeName
	local text = (not nodeName or #nodeName == 0) and "<anonymous>" or nodeName

	local text2 = ProfilerUtil.getSourceLocationString(data, v, text)

	if text == "<anonymous>" then
		text = text2
		text2 = ""
	end

	if pluginFlag then
		text ..= " <plugin>"
	end

	if nativeFlag then
		text ..= " <native>"
	end

	local udim = UDim.new(1 - ValueCellWidth * #v4, -0)

	local createElement = Roact.createElement
	local v5 = {
		Size = size,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local tooltip

	if self.state.showTooltip then
		tooltip = Roact.createElement(Tooltip, { text = text2, pos = self.state.tooltipPos })
	end

	return createElement("Frame", v5, {
		tooltip = tooltip,
		layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		button = Roact.createElement(BannerButton, {
			size = UDim2.new(1, 0, 0, EntryFrameHeight),
			inset = 0,
			isExpanded = self.state.expanded,
			isExpandable = false,
			onButtonPress = self.onButtonPress,
			onMouseEnter = self.onMouseEnter,
			onMouseLeave = self.onMouseLeave,
			onMouseMove = self.onMouseMove,
			layoutOrder = -1
		}, {
			name = Roact.createElement(CellLabel, {
				text = text,
				size = UDim2.new(udim, UDim.new(1, 0)),
				pos = UDim2.new(0, CellPadding + 0, 0, 0)
			}),
			values = Roact.createFragment(self:renderValues(v4))
		})
	})
end

return extended
