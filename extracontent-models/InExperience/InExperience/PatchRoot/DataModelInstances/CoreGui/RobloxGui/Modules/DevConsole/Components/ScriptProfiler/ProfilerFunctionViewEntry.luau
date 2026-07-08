local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local ProfilerUtil = require(script.Parent.ProfilerUtil)
local _ = ProfilerUtil.getDurations
local _ = ProfilerUtil.getSourceName
local _ = ProfilerUtil.getLine
local getNativeFlag = ProfilerUtil.getNativeFlag
local getPluginFlag = ProfilerUtil.getPluginFlag
local _ = ProfilerUtil.standardizeChildren
local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)
local Tooltip = require(Components.Tooltip)
local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local EntryFrameHeight = Constants.GeneralFormatting.EntryFrameHeight
local _ = Constants.ScriptProfilerFormatting.DepthIndent
local ValueCellWidth = Constants.ScriptProfilerFormatting.ValueCellWidth
local CellPadding = Constants.ScriptProfilerFormatting.CellPadding
local ValuePadding = Constants.ScriptProfilerFormatting.ValuePadding
local v22 = Roact.PureComponent:extend("ProfilerFunctionViewEntry")

local function BorderedCellLabel(t1: {[any]: any}) -- line: 42
	-- upvalues: Roact (copy), CellLabel (copy), LineWidth (copy), ValuePadding (copy), LineColor (copy)
	return Roact.createFragment({
		Label = Roact.createElement(CellLabel, {
			text = t1.text,
			size = t1.size,
			pos = t1.pos
		}),
		LeftBorder = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(UDim.new(0, LineWidth), t1.size.Y),
			Position = UDim2.fromOffset(-ValuePadding, 0) + t1.pos,
			AnchorPoint = Vector2.new(0, 0),
			BackgroundColor3 = LineColor
		})
	})
end

function v22.init(p1) -- line: 59
	p1.state = {
		showTooltip = false,
		expanded = p1.props.depth == 0,
		tooltipPos = UDim2.fromOffset(0, 0)
	}

	function p1.onButtonPress() -- line: 66
		-- upvalues: p1 (copy)
		p1:setState(function(_) -- line: 67
			-- upvalues: p1 (copy)
			return {
				expanded = not p1.state.expanded
			}
		end)
	end
	function p1.onMouseEnter(_, p4, p5) -- line: 74
		-- upvalues: p1 (copy)
		p1:setState({
			showTooltip = true,
			tooltipPos = UDim2.fromOffset(p4, p5)
		})
	end
	function p1.onMouseMove(_, p7, p8) -- line: 81
		-- upvalues: p1 (copy)
		p1:setState({
			showTooltip = true,
			tooltipPos = UDim2.fromOffset(p7, p8)
		})
	end
	function p1.onMouseLeave() -- line: 88
		-- upvalues: p1 (copy)
		p1:setState({
			showTooltip = false
		})
	end
end
function v22.renderValues(_, p10) -- line: 95
	-- upvalues: ValueCellWidth (copy), ValuePadding (copy), EntryFrameHeight (copy), Roact (copy), BorderedCellLabel (copy)
	local t2 = {}
	local uDim2 = UDim2.new(ValueCellWidth, -ValuePadding, 0, EntryFrameHeight)
	local uDim2_2 = UDim2.new(1 - ValueCellWidth * #p10, ValuePadding, 0, 0)

	for i, v in ipairs(p10) do
		t2[tostring(i)] = Roact.createElement(BorderedCellLabel, {
			text = tostring(v),
			size = uDim2,
			pos = uDim2_2 + UDim2.fromScale(ValueCellWidth * (i - 1), 0)
		})
	end

	return t2
end
function v22.render(p11) -- line: 110
	-- upvalues: EntryFrameHeight (copy), getNativeFlag (copy), getPluginFlag (copy), ProfilerUtil (copy), ValueCellWidth (copy), Roact (copy), Tooltip (copy), BannerButton (copy), CellLabel (copy), CellPadding (copy)
	local props = p11.props
	local v35 = props.size or UDim2.new(1, 0, 0, EntryFrameHeight)
	local v36 = props.layoutOrder or 0
	local percentageRatio = props.percentageRatio
	local data = props.data
	local functionId = props.functionId
	local v40 = data.Functions[functionId]
	local v41 = v40.TotalDuration / p11.props.average - (p11.props.gcOffset or 0)
	local v42 = getNativeFlag(data, v40)
	local v43 = getPluginFlag(data, v40)
	local t3 = { if not percentageRatio then string.format("%.3f", v41 * 1000) else if percentageRatio ~= 0 then string.format("%.3f%%", v41 / percentageRatio) else "N/A" }
	local nodeName = props.nodeName

	if not nodeName or #nodeName == 0 then
		nodeName = "<anonymous>"
	end

	local v46 = ProfilerUtil.getSourceLocationString(data, v40, nodeName)

	if nodeName == "<anonymous>" then
		nodeName = v46
		v46 = ""
	end

	if v43 then
		nodeName ..= " <plugin>"
	end

	if v42 then
		nodeName ..= " <native>"
	end

	local uDim = UDim.new(1 - ValueCellWidth * #t3, -0)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = v35,
		LayoutOrder = v36,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		tooltip = if not p11.state.showTooltip then nil else Roact.createElement(Tooltip, {
			text = v46,
			pos = p11.state.tooltipPos
		}),
		layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		button = Roact.createElement(BannerButton, {
			inset = 0,
			isExpandable = false,
			layoutOrder = -1,
			size = UDim2.new(1, 0, 0, EntryFrameHeight),
			isExpanded = p11.state.expanded,
			onButtonPress = p11.onButtonPress,
			onMouseEnter = p11.onMouseEnter,
			onMouseLeave = p11.onMouseLeave,
			onMouseMove = p11.onMouseMove
		}, {
			name = Roact.createElement(CellLabel, {
				text = nodeName,
				size = UDim2.new(uDim, UDim.new(1, 0)),
				pos = UDim2.new(0, CellPadding + 0, 0, 0)
			}),
			values = Roact.createFragment(p11:renderValues(t3))
		})
	})
end

return v22
