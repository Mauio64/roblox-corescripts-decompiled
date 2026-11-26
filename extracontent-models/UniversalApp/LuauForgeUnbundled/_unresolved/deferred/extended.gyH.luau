local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

local extended = Roact.PureComponent:extend("ItemListLayout")

local udims = {
	[FitChildren.FitAxis.Height] = UDim2.new(1, 0, 0, 0),
	[FitChildren.FitAxis.Width] = UDim2.new(0, 0, 1, 0),
	[FitChildren.FitAxis.Both] = UDim2.new(0, 0, 0, 0)
}

local function WrappedItem(props)
	local layoutOrder = props.layoutOrder
	local fitAxis = props.fitAxis
	local size = props.size
	local renderItem = props.renderItem

	return Roact.createElement(FitChildren.FitFrame, {
		Size = size,
		LayoutOrder = layoutOrder,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		fitAxis = fitAxis
	}, { RenderedItem = renderItem })
end

function extended.render(p2)
	local renderItemList = p2.props.renderItemList or {}
	local fitAxis = p2.props.fitAxis
	local size = p2.props.size or udims[fitAxis]

	local joined = Cryo.Dictionary.join(p2.props, {
		renderItemList = Cryo.None,
		fitAxis = Cryo.None,
		size = Cryo.None,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local v5 = {
		ListLayout = Roact.createElement("UIListLayout", joined)
	}

	for i, renderItem in ipairs(renderItemList) do
		v5["Item" .. i] = WrappedItem({
			layoutOrder = i,
			fitAxis = fitAxis,
			size = size,
			renderItem = renderItem
		})
	end

	return Roact.createElement(
		FitChildren.FitFrame,
		{
			Size = size,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			fitAxis = fitAxis
		},
		v5
	)
end

return extended
