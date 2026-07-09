local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(Modules.Common.Roact)
local ButtonStripSelectorButton = require(Modules.LuaApp.Components.Search.ButtonStripSelectorButton)
local FFlagSearchTopResultsTabEnabledForAll = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSearchTopResultsTabEnabledForAll
local v7 = Roact.PureComponent:extend("ButtonStripSelector")

v7.defaultProps = {
	leftRightPadding = 0
}

function v7.renderChildrenButtonsAndLayout(p1, p2, p3, p4) -- line: 46
	-- upvalues: Roact (copy), ButtonStripSelectorButton (copy), FFlagSearchTopResultsTabEnabledForAll (copy)
	local t1 = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8)
		}),
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, p4),
			PaddingRight = UDim.new(0, p4)
		})
	}

	for i = 1, #p2 do
		local v14 = p2[i]

		if v14 then
			t1[v14.name] = Roact.createElement(ButtonStripSelectorButton, {
				layoutOrder = i,
				text = v14.text,
				handleClick = v14.onActivated,
				selected = p3 == v14.name,
				image = v14.image,
				newDesignEnabled = p1.props.newDesignEnabled or FFlagSearchTopResultsTabEnabledForAll
			})
		end
	end

	return t1
end
function v7.render(p5) -- line: 80
	-- upvalues: Roact (copy)
	local v16 = p5.props.activeSelection or 1
	local forwardRef = p5.props.forwardRef

	return Roact.createElement("Frame", {
		Size = p5.props.size,
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = p5.props.position,
		LayoutOrder = p5.props.layoutOrder,
		BackgroundColor3 = p5.props.backgroundColor3,
		BackgroundTransparency = p5.props.backgroundTransparency,
		BorderSizePixel = 0,
		[Roact.Ref] = forwardRef
	}, p5:renderChildrenButtonsAndLayout(p5.props.selections, v16, p5.props.leftRightPadding))
end

return Roact.forwardRef(function(t2: {[any]: any}, p6) -- line: 97
	-- upvalues: Roact (copy), v7 (copy), Cryo (copy)
	return Roact.createElement(v7, Cryo.Dictionary.join(t2, {
		forwardRef = p6
	}))
end)
