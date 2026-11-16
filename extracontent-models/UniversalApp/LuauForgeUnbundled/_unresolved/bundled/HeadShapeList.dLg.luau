local module = require("@luauforge/bundled/dLe")
local module2 = require("@luauforge/bundled/dLh")
require("@luauforge/bundled/dHT")

local useTokens = require("@luauforge/bundled/dLi").Hooks.useTokens

local module3 = require("@luauforge/bundled/dLj")
local module4 = require("@luauforge/bundled/dLk")

local module5 = require("@luauforge/bundled/dLn")
require("@luauforge/bundled/dHW")

function LUAUFORGE_MODULE_GLOBALS_dLg_HeadShapeListScroll(props)
	local v6 = module5((useTokens()))

	local v7 = v6.smallTileContainerSize

	if props.tileSize == module3.Large then
		v7 = v6.largeTileContainerSize
	end

	return module.createElement("ScrollingFrame", {
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		CanvasSize = UDim2.fromScale(0, 1),
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.X,
		Selectable = false,
		Size = UDim2.new(1, 0, 0, v7),
		LayoutOrder = props.LayoutOrder,
		[module.Tag] = "data-testid=AvatarExperienceHeadRefinement_HeadShapeListScroll"
	}, props.children)
end

local function HeadShapeListVerticalScroll(props)
	return module.createElement("ScrollingFrame", {
		BorderSizePixel = 0,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Selectable = false,
		Size = UDim2.new(1, 0, 0, props.maxHeight),
		LayoutOrder = props.LayoutOrder,
		[module.Tag] = "data-testid=AvatarExperienceHeadRefinement_HeadShapeListVerticalScroll"
	}, props.children)
end

local function HeadShapeList(props)
	local v6 = module5((useTokens()))

	local tileListPaddingBetweenItems = v6.tileListPaddingBetweenItems

	local v7 = v6.tileListPaddingLeft
	local v8 = v6.tileListPaddingRight
	local v9 = v6.tileListPaddingTop
	local v10 = v6.tileListPaddingBottom

	if props.padding then
		v7 = props.padding.left or v7
		v8 = props.padding.right or v8
		v9 = props.padding.top or v9
		v10 = props.padding.bottom or v10
	end

	local tileSize = props.tileSize or module3.Small
	local orientation = props.orientation or module2.DeviceOrientationMode.Portrait

	local children = {}

	children.Layout = module.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, tileListPaddingBetweenItems),
		Wraps = orientation == module2.DeviceOrientationMode.Landscape,
		HorizontalFlex = Enum.UIFlexAlignment.None,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	children.Padding = module.createElement("UIPadding", {
		PaddingTop = UDim.new(0, v9),
		PaddingRight = UDim.new(0, v8),
		PaddingBottom = UDim.new(0, v10),
		PaddingLeft = UDim.new(0, v7)
	})

	for k, item in props.items do
		local formatted = `Item-{item.headShapeName}`
		local createElement = module.createElement
		local v12 = {
			headShape = item.headShapeName,
			headShapeData = item.headShapeData,
			size = tileSize,
			isSelected = item.isSelected,
			onActivated = item.onActivated,
			LayoutOrder = k,
			NextSelectionUp = 0
		}

		local v13 = if k <= 4 then props.NextSelectionUp else nil
		v12.NextSelectionUp = v13
		children[formatted] = createElement(module4, v12)
	end

	local v11 = if orientation == module2.DeviceOrientationMode.Landscape then HeadShapeListVerticalScroll else LUAUFORGE_MODULE_GLOBALS_dLg_HeadShapeListScroll

	return module.createElement(v11, props, children)
end

return HeadShapeList
