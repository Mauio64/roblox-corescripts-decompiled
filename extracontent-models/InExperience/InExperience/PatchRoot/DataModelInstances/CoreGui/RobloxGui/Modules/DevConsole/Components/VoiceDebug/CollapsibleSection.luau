local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)

local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding

local extended = Roact.PureComponent:extend("CollapsibleSection")

function extended:init()
	self.state = {
		expanded = self.props.defaultExpanded == nil or self.props.defaultExpanded
	}

	function self.onButtonPress()
		self:setState(function(p)
			return {
				expanded = not p.expanded
			}
		end)
	end
end

function extended.render(props)
	local title = props.props.title
	local layoutOrder = props.props.layoutOrder
	local expanded = props.state.expanded
	local hideLines = props.props.hideLines

	local createElement = Roact.createElement
	local v = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder
	}

	local v2 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, MainRowPadding)
		}),
		Header = Roact.createElement(BannerButton, {
			size = UDim2.new(1, 0, 0, 20),
			isExpanded = expanded,
			isExpandable = true,
			hideLines = hideLines,
			onButtonPress = props.onButtonPress,
			layoutOrder = 1
		}, {
			Label = Roact.createElement(CellLabel, {
				text = title,
				bold = true,
				size = UDim2.new(1, -20, 1, 0),
				pos = UDim2.new(0, 20, 0, 0)
			})
		}),
		Content = 0
	}
	local content

	if expanded then
		content = Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = 2
				},
				{
					UIListLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, MainRowPadding)
					}),
					Children = Roact.createFragment(props.props[Roact.Children] or {})
				}
			)
			or nil
	end

	v2.Content = content
	return createElement("Frame", v, v2)
end

return extended
