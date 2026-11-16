local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/ecR")
local module2 = require("@luauforge/deferred/hES")

local fFlagSearchTopResultsTabEnabledForAll = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSearchTopResultsTabEnabledForAll

local extended = module.PureComponent:extend("ButtonStripSelector")

extended.defaultProps = { leftRightPadding = 0 }

function extended:renderChildrenButtonsAndLayout(list, p3, p4)
	local children = {
		Layout = module.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8)
		}),
		Padding = module.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, p4),
			PaddingRight = UDim.new(0, p4)
		})
	}

	for i = 1, #list do
		local item = list[i]

		if item then
			children[item.name] = module.createElement(module2, {
				layoutOrder = i,
				text = item.text,
				name = item.name,
				handleClick = item.onActivated,
				selected = p3 == item.name,
				image = item.image,
				newDesignEnabled = self.props.newDesignEnabled or fFlagSearchTopResultsTabEnabledForAll
			})
		end
	end

	return children
end

function extended:render()
	local activeSelection = self.props.activeSelection or 1

	local forwardRef = self.props.forwardRef

	return module.createElement("Frame", {
		Size = self.props.size,
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = self.props.position,
		LayoutOrder = self.props.layoutOrder,
		BackgroundColor3 = self.props.backgroundColor3,
		BackgroundTransparency = self.props.backgroundTransparency,
		BorderSizePixel = 0,
		[module.Ref] = forwardRef
	}, self:renderChildrenButtonsAndLayout(
		self.props.selections,
		activeSelection,
		self.props.leftRightPadding
	))
end

return module.forwardRef(function(p2, p3)
	return module.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
