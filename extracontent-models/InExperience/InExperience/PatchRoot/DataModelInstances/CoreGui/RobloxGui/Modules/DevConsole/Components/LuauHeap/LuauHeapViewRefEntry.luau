local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)

require(script.Parent.LuauHeapTypes)

local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor

local RefEntryFrameHeight = Constants.LuauHeapFormatting.RefEntryFrameHeight
local DepthIndent = Constants.LuauHeapFormatting.DepthIndent
local ValueCellWidth = Constants.LuauHeapFormatting.ValueCellWidth
local CellPadding = Constants.LuauHeapFormatting.CellPadding
local ValuePadding = Constants.LuauHeapFormatting.ValuePadding

local LuauHeapViewPathEntry = require(script.Parent.LuauHeapViewPathEntry)

local extended = Roact.PureComponent:extend("LuauHeapViewRefEntry")

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

function extended:init()
	self.state = { expanded = false }

	function self.onButtonPress()
		self:setState(function(p)
			return {
				expanded = not p.expanded
			}
		end)
	end
end

function extended:renderValues(list)
	local udim = UDim2.new(ValueCellWidth, -ValuePadding, 0, RefEntryFrameHeight)
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

function extended:renderChildren(list)
	local children = {}

	if self.state.expanded and list and #list then
		for i, item in ipairs(list) do
			children[i] = Roact.createElement(LuauHeapViewPathEntry, {
				layoutOrder = i,
				depth = 1,
				name = `Path #{i}`,
				data = item
			})
		end
	end

	return children
end

function extended:render()
	local props = self.props

	local size = props.size or UDim2.new(1, 0, 0, RefEntryFrameHeight)
	local layoutOrder = props.layoutOrder or 0
	local data = props.data

	local v = { `{data.Count}`, `{data.Instances}` }

	local udim = UDim.new(1 - ValueCellWidth * #v, 0)

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
				size = UDim2.new(1, 0, 0, RefEntryFrameHeight),
				inset = 0,
				isExpanded = self.state.expanded,
				isExpandable = data.Paths and #data.Paths ~= 0,
				onButtonPress = self.onButtonPress,
				layoutOrder = -1
			}, {
				name = Roact.createElement(CellLabel, {
					text = data.Name,
					size = UDim2.new(udim, UDim.new(1, 0)),
					pos = UDim2.new(0, CellPadding, 0, 0)
				}),
				values = Roact.createFragment(self:renderValues(v))
			}),
			children = Roact.createFragment(self:renderChildren(data.Paths))
		}
	)
end

return extended
