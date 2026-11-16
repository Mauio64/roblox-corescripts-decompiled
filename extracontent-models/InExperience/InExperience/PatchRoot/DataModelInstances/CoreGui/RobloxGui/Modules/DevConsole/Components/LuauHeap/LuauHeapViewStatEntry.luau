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
local DepthIndent = Constants.LuauHeapFormatting.DepthIndent
local ValueCellWidth = Constants.LuauHeapFormatting.ValueCellWidth
local CellPadding = Constants.LuauHeapFormatting.CellPadding
local ValuePadding = Constants.LuauHeapFormatting.ValuePadding

local extended = Roact.PureComponent:extend("LuauHeapViewStatEntry")

local function BorderedCellLabel(props)
	return Roact.createFragment({
		Label = Roact.createElement(CellLabel, {
			text = props.text,
			size = props.size,
			pos = props.pos,
			richText = true
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

function extended:renderValues(list)
	local udim = UDim2.new(ValueCellWidth, -ValuePadding, 0, StatEntryFrameHeight)
	local udim2 = UDim2.new(1 - ValueCellWidth * #list, ValuePadding, 0, 0)
	local children = {}

	for k, item in list do
		children[tostring(k)] = Roact.createElement(BorderedCellLabel, {
			text = tostring(item),
			size = udim,
			pos = udim2 + UDim2.fromScale(ValueCellWidth * (k - 1), 0)
		})
	end

	return children
end

function extended:render()
	local props = self.props

	local size = props.size or UDim2.new(1, 0, 0, StatEntryFrameHeight)
	local layoutOrder = props.layoutOrder or 0
	local data = props.data
	local compare = props.compare

	local v = string.format("%.0f", data.Size)
	local v2 = string.format("%.0f", data.Count)

	if compare then
		if compare.Size ~= data.Size then
			v = string.format(
				"%d <font color=\"#%s\">(%s%d)</font>",
				data.Size,
				compare.Size > data.Size and "0f0" or "f00",
				compare.Size > data.Size and "" or "+",
				data.Size - compare.Size
			)
		end

		if compare.Count ~= data.Count then
			v2 = string.format(
				"%d <font color=\"#%s\">(%s%d)</font>",
				data.Count,
				compare.Count > data.Count and "0f0" or "f00",
				compare.Count > data.Count and "" or "+",
				data.Count - compare.Count
			)
		end
	end

	local v3 = { v, v2 }

	local udim = UDim.new(1 - ValueCellWidth * #v3, 0)

	return Roact.createElement(
		"Frame",
		{
			Size = size,
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder,
			AutomaticSize = Enum.AutomaticSize.Y
		},
		{
			layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			button = Roact.createElement(BannerButton, {
				size = UDim2.new(1, 0, 0, StatEntryFrameHeight),
				inset = 0,
				isExpanded = false,
				isExpandable = false,
				layoutOrder = -1
			}, {
				name = Roact.createElement(CellLabel, {
					text = data.Name,
					size = UDim2.new(udim, UDim.new(1, 0)),
					pos = UDim2.new(0, CellPadding, 0, 0)
				}),
				values = Roact.createFragment(self:renderValues(v3))
			})
		}
	)
end

return extended
