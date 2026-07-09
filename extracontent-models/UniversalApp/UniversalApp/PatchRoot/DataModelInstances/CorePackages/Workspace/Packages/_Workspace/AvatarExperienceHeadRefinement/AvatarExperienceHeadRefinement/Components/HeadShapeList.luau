local AvatarExperienceHeadRefinement = script:FindFirstAncestor("AvatarExperienceHeadRefinement")
local AvatarExperienceHeadRefinementParent = AvatarExperienceHeadRefinement.Parent
local React = require(AvatarExperienceHeadRefinementParent.React)
local AppCommonStyle = require(AvatarExperienceHeadRefinementParent.AppCommonStyle)
local RobloxAppEnums = require(AvatarExperienceHeadRefinementParent.RobloxAppEnums)
local useDesignTokens = AppCommonStyle.useDesignTokens
local useTokens = require(AvatarExperienceHeadRefinementParent.Foundation).Hooks.useTokens
local HeadShapeTileSize = require(AvatarExperienceHeadRefinement.Enums.HeadShapeTileSize)

require(AvatarExperienceHeadRefinement.Enums.HeadShape)

local HeadShapeTile = require(AvatarExperienceHeadRefinement.Components.HeadShapeTile)
local getMappedStyleTokens = require(AvatarExperienceHeadRefinement.Utils.getMappedStyleTokens)
local getFoundationMappedStyleTokens = require(AvatarExperienceHeadRefinement.Utils.getFoundationMappedStyleTokens)

require(AvatarExperienceHeadRefinement.Enums.HeadShapeProperties)

local FFlagAXEnableResponsiveHeadRefinementMenu = require(AvatarExperienceHeadRefinementParent.AvatarExperienceFlags).FFlagAXEnableResponsiveHeadRefinementMenu

function HeadShapeListScroll(p1) -- line: 48
	-- upvalues: useDesignTokens (copy), FFlagAXEnableResponsiveHeadRefinementMenu (copy), useTokens (copy), getFoundationMappedStyleTokens (copy), getMappedStyleTokens (copy), HeadShapeTileSize (copy), React (copy)
	local v16 = useDesignTokens()
	local v17 = if not FFlagAXEnableResponsiveHeadRefinementMenu then nil else useTokens()
	local v18 = if not FFlagAXEnableResponsiveHeadRefinementMenu then getMappedStyleTokens(v16) else getFoundationMappedStyleTokens(v17)
	local smallTileContainerSize = v18.smallTileContainerSize

	if p1.tileSize == HeadShapeTileSize.Large then
		smallTileContainerSize = v18.largeTileContainerSize
	end

	return React.createElement("ScrollingFrame", {
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		CanvasSize = UDim2.fromScale(0, 1),
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.X,
		Selectable = false,
		Size = UDim2.new(1, 0, 0, smallTileContainerSize),
		LayoutOrder = p1.LayoutOrder,
		[React.Tag] = "data-testid=AvatarExperienceHeadRefinement_HeadShapeListScroll"
	}, p1.children)
end
function HeadShapeListWrap(p2) -- line: 75
	-- upvalues: React (copy)
	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		LayoutOrder = p2.LayoutOrder,
		[React.Tag] = "data-testid=AvatarExperienceHeadRefinement_HeadShapeListWrap"
	}, p2.children)
end

local u13 = nil

if FFlagAXEnableResponsiveHeadRefinementMenu then
	function u13(p3) -- line: 86
		-- upvalues: React (copy)
		return React.createElement("ScrollingFrame", {
			BorderSizePixel = 0,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			CanvasSize = UDim2.fromScale(0, 0),
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Selectable = false,
			Size = UDim2.new(1, 0, 0, p3.maxHeight),
			LayoutOrder = p3.LayoutOrder,
			[React.Tag] = "data-testid=AvatarExperienceHeadRefinement_HeadShapeListVerticalScroll"
		}, p3.children)
	end
end

local function HeadShapeList(t1: {[any]: any}) -- line: 102
	-- upvalues: useDesignTokens (copy), FFlagAXEnableResponsiveHeadRefinementMenu (copy), useTokens (copy), getFoundationMappedStyleTokens (copy), getMappedStyleTokens (copy), HeadShapeTileSize (copy), RobloxAppEnums (copy), React (copy), HeadShapeTile (copy), u13 (ref)
	local v23 = useDesignTokens()
	local v24 = if not FFlagAXEnableResponsiveHeadRefinementMenu then nil else useTokens()
	local v25 = if not FFlagAXEnableResponsiveHeadRefinementMenu then getMappedStyleTokens(v23) else getFoundationMappedStyleTokens(v24)
	local tileListPaddingBetweenItems = v25.tileListPaddingBetweenItems
	local tileListPaddingLeft = v25.tileListPaddingLeft
	local tileListPaddingRight = v25.tileListPaddingRight
	local tileListPaddingTop = v25.tileListPaddingTop
	local tileListPaddingBottom = v25.tileListPaddingBottom

	if t1.padding then
		tileListPaddingLeft = t1.padding.left or tileListPaddingLeft
		tileListPaddingRight = t1.padding.right or tileListPaddingRight
		tileListPaddingTop = t1.padding.top or tileListPaddingTop
		tileListPaddingBottom = t1.padding.bottom or tileListPaddingBottom
	end

	local v31 = t1.tileSize or HeadShapeTileSize.Small
	local v32 = t1.orientation or RobloxAppEnums.DeviceOrientationMode.Portrait
	local t2 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, tileListPaddingBetweenItems),
			Wraps = v32 == RobloxAppEnums.DeviceOrientationMode.Landscape,
			HorizontalFlex = Enum.UIFlexAlignment.None,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, tileListPaddingTop),
			PaddingRight = UDim.new(0, tileListPaddingRight),
			PaddingBottom = UDim.new(0, tileListPaddingBottom),
			PaddingLeft = UDim.new(0, tileListPaddingLeft)
		})
	}

	for v34, v35 in t1.items do
		t2[`Item-{ v35.headShapeName }`] = React.createElement(HeadShapeTile, {
			headShape = v35.headShapeName,
			headShapeData = v35.headShapeData,
			size = v31,
			isSelected = v35.isSelected,
			onActivated = v35.onActivated,
			LayoutOrder = v34,
			NextSelectionUp = if not (v34 <= 4) then nil else t1.NextSelectionUp
		})
	end

	local v36 = if v32 ~= RobloxAppEnums.DeviceOrientationMode.Landscape then HeadShapeListScroll else if not FFlagAXEnableResponsiveHeadRefinementMenu or u13 == nil then HeadShapeListWrap else u13

	return React.createElement(v36, t1, t2)
end

return HeadShapeList
