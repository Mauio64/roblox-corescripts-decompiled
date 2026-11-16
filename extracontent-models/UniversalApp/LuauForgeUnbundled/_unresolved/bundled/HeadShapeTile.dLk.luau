local module = require("@luauforge/bundled/dLe")
local module2 = require("@luauforge/bundled/dLl")
local module3 = require("@luauforge/bundled/dLf")

local imageSetLabel = module3.Core.ImageSet.ImageSetLabel
local imageSetButton = module3.Core.ImageSet.ImageSetButton

local module4 = require("@luauforge/bundled/dHW")
local headShape = require("@luauforge/bundled/dHT").Enums.HeadShape
local module5 = require("@luauforge/bundled/dLj")

local module6 = require("@luauforge/bundled/dLm")

local useDesignTokens = module2.useDesignTokens

local function HeadShapeTile(props)
	local v5 = useDesignTokens()
	local v6 = module6(v5)

	local headShape2 = props.headShape or headShape.Default
	local v7 = if props.headShapeData then props.headShapeData else module4[headShape2]

	local v8 = if props.size == module5.Large then v6.largeTileImageSize else v6.smallTileImageSize
	local v9

	if props.size == module5.Large then
		v9 = v6.largeTileContainerSize
	else
		v9 = v6.smallTileContainerSize
	end

	local v10 = module.useCallback(function()
		if props.onActivated then
			props.onActivated()
		end
	end, { props.onActivated })
	local createElement = module.createElement
	local v12 = {
		BackgroundColor3 = v5.Color.Surface.Surface_300.Color3,
		BackgroundTransparency = v5.Color.Surface.Surface_300.Transparency,
		Size = UDim2.new(0, v9, 0, v9),
		[module.Tag] = "data-testid=AvatarExperienceHeadRefinement_HeadShapeTile",
		[module.Event.Activated] = v10,
		LayoutOrder = props.LayoutOrder,
		NextSelectionUp = props.NextSelectionUp
	}
	local v13 = {
		UICorner = module.createElement("UICorner", {
			CornerRadius = UDim.new(0, v5.Radius.Medium)
		}),
		UIStroke = 0,
		HeadShapeTileImage = 0
	}

	local v14 = if props.isSelected then module.createElement("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
		Thickness = 2,
		Color = v5.Color.Shift.Shift_400.Color3
	}) else nil
	v13.UIStroke = v14

	v13.HeadShapeTileImage = module.createElement(imageSetLabel, {
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = v7.image,
		Size = UDim2.new(0, v8, 0, v8),
		BackgroundTransparency = 1,
		[module.Tag] = "data-testid=AvatarExperienceHeadRefinement_HeadShapeTile_Image"
	})
	return createElement(imageSetButton, v12, v13)
end

return HeadShapeTile
