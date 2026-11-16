local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)

require(script.Parent.LuauHeapTypes)

local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor

local PathEntryFrameHeight = Constants.LuauHeapFormatting.PathEntryFrameHeight
local DepthIndent = Constants.LuauHeapFormatting.DepthIndent
local ValueCellWidth = Constants.LuauHeapFormatting.ValueCellWidth
local CellPadding = Constants.LuauHeapFormatting.CellPadding
local ValuePadding = Constants.LuauHeapFormatting.ValuePadding

local extended = Roact.PureComponent:extend("LuauHeapViewPathEntry")

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

function extended:renderChildren(list)
	local children = {}

	local v = 2 * DepthIndent + CellPadding

	if self.state.expanded and list and #list then
		for i, item in ipairs(list) do
			children[i] = Roact.createElement(CellLabel, {
				text = item,
				layoutOrder = i,
				size = UDim2.new(UDim.new(1, -v), UDim.new(0, PathEntryFrameHeight)),
				pos = UDim2.new(0, v, 0, 0)
			})
		end
	end

	return children
end

function extended:render()
	local props = self.props

	local size = props.size or UDim2.new(1, 0, 0, PathEntryFrameHeight)
	local layoutOrder = props.layoutOrder or 0
	local name = props.name
	local data = props.data

	local inset = props.depth * DepthIndent

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
				size = UDim2.new(1, 0, 0, PathEntryFrameHeight),
				inset = inset,
				isExpanded = self.state.expanded,
				isExpandable = #data ~= 0,
				onButtonPress = self.onButtonPress,
				layoutOrder = -1
			}, {
				name = Roact.createElement(CellLabel, {
					text = name,
					size = UDim2.new(UDim.new(1, -inset), UDim.new(1, 0)),
					pos = UDim2.new(0, CellPadding + inset, 0, 0)
				})
			}),
			children = Roact.createFragment(self:renderChildren(data))
		}
	)
end

return extended
