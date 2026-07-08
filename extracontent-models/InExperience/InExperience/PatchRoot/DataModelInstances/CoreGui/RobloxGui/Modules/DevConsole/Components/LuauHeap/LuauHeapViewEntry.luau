local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)
local Tooltip = require(Components.Tooltip)

require(script.Parent.LuauHeapTypes)

local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local GraphEntryFrameHeight = Constants.LuauHeapFormatting.GraphEntryFrameHeight
local DepthIndent = Constants.LuauHeapFormatting.DepthIndent
local ValueCellWidth = Constants.LuauHeapFormatting.ValueCellWidth
local CellPadding = Constants.LuauHeapFormatting.CellPadding
local ValuePadding = Constants.LuauHeapFormatting.ValuePadding
local v15 = Roact.PureComponent:extend("LuauHeapViewEntry")

local function BorderedCellLabel(t1: {[any]: any}) -- line: 32
	-- upvalues: Roact (copy), CellLabel (copy), LineWidth (copy), ValuePadding (copy), LineColor (copy)
	return Roact.createFragment({
		Label = Roact.createElement(CellLabel, {
			richText = true,
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

function v15.init(p1) -- line: 50
	p1.state = {
		expandedEllipsis = false,
		showTooltip = false,
		expanded = p1.props.depth == 0,
		tooltipPos = UDim2.fromOffset(0, 0)
	}

	function p1.onButtonPress() -- line: 58
		-- upvalues: p1 (copy)
		p1:setState(function(p2) -- line: 59
			return {
				expanded = not p2.expanded
			}
		end)
	end
	function p1.onExpandEllipsis() -- line: 66
		-- upvalues: p1 (copy)
		p1:setState({
			expandedEllipsis = true
		})
	end
	function p1.onMouseEnter(_, p4, p5) -- line: 72
		-- upvalues: p1 (copy)
		p1:setState({
			showTooltip = true,
			tooltipPos = UDim2.fromOffset(p4, p5)
		})
	end
	function p1.onMouseMove(_, p7, p8) -- line: 79
		-- upvalues: p1 (copy)
		p1:setState({
			showTooltip = true,
			tooltipPos = UDim2.fromOffset(p7, p8)
		})
	end
	function p1.onMouseLeave() -- line: 86
		-- upvalues: p1 (copy)
		p1:setState({
			showTooltip = false
		})
	end
end
function v15.renderChildren(t2: {[any]: any}, t3: {[any]: any}, t4: {[any]: any}?) -- line: 93
	-- upvalues: Roact (copy), v15 (copy)
	if not t2.state.expanded then
		return {}
	end

	if #t3 == 0 and (t4 == nil or #t4 == 0) then
		return {}
	end

	local t5 = {}
	local TotalSize = t2.props.data.TotalSize
	local v24 = t2.props.depth + 1
	local n1 = 0
	local n2 = 0
	local n3 = 0

	local function getCompareInfo(p9) -- line: 117
		-- upvalues: t4 (copy)
		if t4 then
			for _, v in ipairs(t4) do
				if p9.Name == v.Name then
					return v
				end
			end
		end

		return nil
	end

	local g34 = nil
	local v33 = nil

	for _, v in ipairs(t3) do
		if t4 then
			for _, v2 in ipairs(t4) do
				if v.Name == v2.Name then
					v33 = v2
					g34 = true
				end

				if g34 then
					break
				end
			end
		end

		if not g34 then
			v33 = nil
		end

		g34 = false

		if v.TotalSize <= 128 and #t3 > 4 and not t2.state.expandedEllipsis then
			n1 += v.TotalSize

			if v33 then
				n2 += v33.TotalSize
			end
		else
			n3 += 1
			t5[n3] = Roact.createElement(v15, {
				layoutOrder = TotalSize - v.TotalSize,
				depth = v24,
				data = v,
				compare = v33
			})
		end
	end

	if n1 > 0 then
		n3 += 1
		t5[n3] = Roact.createElement(v15, {
			layoutOrder = TotalSize,
			depth = v24,
			data = {
				Name = "...",
				Size = n1,
				TotalSize = n1,
				Children = {}
			},
			compare = if not t4 then nil else {
				Name = "...",
				Size = n2,
				TotalSize = n2,
				Children = {}
			},
			customButtonPress = t2.onExpandEllipsis
		})
	end

	if t4 then
		for _, v in ipairs(t4) do
			local v37 = false

			for _, v3 in ipairs(t3) do
				if v3.Name == v.Name then
					v37 = true

					break
				end
			end

			if not v37 then
				local t6 = {
					Size = 0,
					TotalSize = 0,
					Name = v.Name,
					Source = v.Source,
					Children = {}
				}

				n3 += 1
				t5[n3] = Roact.createElement(v15, {
					layoutOrder = TotalSize,
					depth = v24,
					data = t6,
					compare = v
				})
			end
		end
	end

	return t5
end
function v15.renderValues(_, p11) -- line: 223
	-- upvalues: ValueCellWidth (copy), ValuePadding (copy), GraphEntryFrameHeight (copy), Roact (copy), BorderedCellLabel (copy)
	local t7 = {}
	local uDim2 = UDim2.new(ValueCellWidth, -ValuePadding, 0, GraphEntryFrameHeight)
	local uDim2_2 = UDim2.new(1 - ValueCellWidth * #p11, ValuePadding, 0, 0)

	for i, v in ipairs(p11) do
		t7[tostring(i)] = Roact.createElement(BorderedCellLabel, {
			text = tostring(v),
			size = uDim2,
			pos = uDim2_2 + UDim2.fromScale(ValueCellWidth * (i - 1), 0)
		})
	end

	return t7
end
function v15.render(p12) -- line: 238
	-- upvalues: GraphEntryFrameHeight (copy), DepthIndent (copy), ValueCellWidth (copy), CellPadding (copy), Roact (copy), Tooltip (copy), BannerButton (copy), CellLabel (copy)
	local props = p12.props
	local v50 = props.size or UDim2.new(1, 0, 0, GraphEntryFrameHeight)
	local depth = props.depth
	local v52 = props.layoutOrder or 0
	local v53 = depth * DepthIndent
	local data = props.data
	local compare = props.compare
	local t8 = {
		if not compare or compare.TotalSize == data.TotalSize then string.format("%.0f", data.TotalSize) else string.format("%d <font color=\"#%s\">(%s%d)</font>", data.TotalSize, not (compare.TotalSize > data.TotalSize) and "f00" or "0f0", not (compare.TotalSize > data.TotalSize) and "+" or "", data.TotalSize - compare.TotalSize),
		if not compare or compare.Size == data.Size then string.format("%.0f", data.Size) else string.format("%d <font color=\"#%s\">(%s%d)</font>", data.Size, not (compare.Size > data.Size) and "f00" or "0f0", not (compare.Size > data.Size) and "+" or "", data.Size - compare.Size)
	}
	local v57 = depth ~= 0 and "<anonymous>" or "<root>"
	local v58 = if not not data.Name and #data.Name ~= 0 then data.Name else v57
	local v59 = if not not data.Source and #data.Source ~= 0 then data.Source else v58
	local uDim = UDim.new(1 - ValueCellWidth * #t8, -(CellPadding + v53))
	local v61 = #data.Children ~= 0 or (compare ~= nil and #compare.Children ~= 0 or props.customButtonPress ~= nil)
	local v62 = if not props.customButtonPress then p12.onButtonPress else props.customButtonPress

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = v50,
		LayoutOrder = v52,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		tooltip = if not p12.state.showTooltip then nil else Roact.createElement(Tooltip, {
			text = v59,
			pos = p12.state.tooltipPos
		}),
		layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		button = Roact.createElement(BannerButton, {
			layoutOrder = -1,
			size = UDim2.new(1, 0, 0, GraphEntryFrameHeight),
			inset = v53,
			isExpanded = p12.state.expanded,
			isExpandable = v61,
			onButtonPress = v62,
			onMouseEnter = p12.onMouseEnter,
			onMouseLeave = p12.onMouseLeave,
			onMouseMove = p12.onMouseMove
		}, {
			name = Roact.createElement(CellLabel, {
				textWrapped = false,
				text = v58,
				size = UDim2.new(uDim, UDim.new(1, 0)),
				pos = UDim2.new(0, CellPadding + v53, 0, 0),
				textTruncate = Enum.TextTruncate.SplitWord
			}),
			values = Roact.createFragment(p12:renderValues(t8))
		}),
		children = Roact.createFragment(p12:renderChildren(data.Children, if not compare then nil else compare.Children))
	})
end

return v15
