local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local FitChildren = require(Modules.LuaApp.FitChildren)
local v6 = Roact.PureComponent:extend("ItemListLayout")
local t1 = {
	[FitChildren.FitAxis.Height] = UDim2.new(1, 0, 0, 0),
	[FitChildren.FitAxis.Width] = UDim2.new(0, 0, 1, 0),
	[FitChildren.FitAxis.Both] = UDim2.new(0, 0, 0, 0)
}

local function WrappedItem(p1) -- line: 18
	-- upvalues: Roact (copy), FitChildren (copy)
	local layoutOrder = p1.layoutOrder
	local fitAxis = p1.fitAxis
	local size = p1.size
	local renderItem = p1.renderItem

	return Roact.createElement(FitChildren.FitFrame, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = size,
		LayoutOrder = layoutOrder,
		fitAxis = fitAxis
	}, {
		RenderedItem = renderItem
	})
end

function v6.render(p2) -- line: 35
	-- upvalues: t1 (copy), Cryo (copy), Roact (copy), WrappedItem (copy), FitChildren (copy)
	local v15 = p2.props.renderItemList or {}
	local fitAxis = p2.props.fitAxis
	local v17 = p2.props.size or t1[fitAxis]
	local v18 = Cryo.Dictionary.join(p2.props, {
		renderItemList = Cryo.None,
		fitAxis = Cryo.None,
		size = Cryo.None,
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	local t2 = {
		ListLayout = Roact.createElement("UIListLayout", v18)
	}

	for i, v in ipairs(v15) do
		t2["Item" .. i] = WrappedItem({
			layoutOrder = i,
			fitAxis = fitAxis,
			size = v17,
			renderItem = v
		})
	end

	return Roact.createElement(FitChildren.FitFrame, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = v17,
		fitAxis = fitAxis
	}, t2)
end

return v6
