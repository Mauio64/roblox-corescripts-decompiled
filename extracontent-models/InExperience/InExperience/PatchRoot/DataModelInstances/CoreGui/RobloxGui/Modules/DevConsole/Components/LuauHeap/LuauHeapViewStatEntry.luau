local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)

require(script.Parent.LuauHeapTypes)

local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local StatEntryFrameHeight = Constants.LuauHeapFormatting.StatEntryFrameHeight
local _ = Constants.LuauHeapFormatting.DepthIndent
local ValueCellWidth = Constants.LuauHeapFormatting.ValueCellWidth
local CellPadding = Constants.LuauHeapFormatting.CellPadding
local ValuePadding = Constants.LuauHeapFormatting.ValuePadding
local v14 = Roact.PureComponent:extend("LuauHeapViewStatEntry")

local function BorderedCellLabel(t1: {[any]: any}) -- line: 31
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

function v14.renderValues(_, p2) -- line: 49
	-- upvalues: ValueCellWidth (copy), ValuePadding (copy), StatEntryFrameHeight (copy), Roact (copy), BorderedCellLabel (copy)
	local t2 = {}
	local uDim2 = UDim2.new(ValueCellWidth, -ValuePadding, 0, StatEntryFrameHeight)
	local uDim2_2 = UDim2.new(1 - ValueCellWidth * #p2, ValuePadding, 0, 0)

	for v22, v23 in p2 do
		t2[tostring(v22)] = Roact.createElement(BorderedCellLabel, {
			text = tostring(v23),
			size = uDim2,
			pos = uDim2_2 + UDim2.fromScale(ValueCellWidth * (v22 - 1), 0)
		})
	end

	return t2
end
function v14.render(p3) -- line: 64
	-- upvalues: StatEntryFrameHeight (copy), ValueCellWidth (copy), Roact (copy), BannerButton (copy), CellLabel (copy), CellPadding (copy)
	local props = p3.props
	local v26 = props.size or UDim2.new(1, 0, 0, StatEntryFrameHeight)
	local v27 = props.layoutOrder or 0
	local data = props.data
	local compare = props.compare
	local v30 = string.format("%.0f", data.Size)
	local v31 = string.format("%.0f", data.Count)

	if compare then
		if compare.Size ~= data.Size then
			v30 = string.format("%d <font color=\"#%s\">(%s%d)</font>", data.Size, not (compare.Size > data.Size) and "f00" or "0f0", not (compare.Size > data.Size) and "+" or "", data.Size - compare.Size)
		end

		if compare.Count ~= data.Count then
			v31 = string.format("%d <font color=\"#%s\">(%s%d)</font>", data.Count, not (compare.Count > data.Count) and "f00" or "0f0", not (compare.Count > data.Count) and "+" or "", data.Count - compare.Count)
		end
	end

	local t3 = {
		v30,
		v31
	}
	local uDim = UDim.new(1 - ValueCellWidth * #t3, 0)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = v26,
		LayoutOrder = v27,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		button = Roact.createElement(BannerButton, {
			inset = 0,
			isExpanded = false,
			isExpandable = false,
			layoutOrder = -1,
			size = UDim2.new(1, 0, 0, StatEntryFrameHeight)
		}, {
			name = Roact.createElement(CellLabel, {
				text = data.Name,
				size = UDim2.new(uDim, UDim.new(1, 0)),
				pos = UDim2.new(0, CellPadding, 0, 0)
			}),
			values = Roact.createFragment(p3:renderValues(t3))
		})
	})
end

return v14
