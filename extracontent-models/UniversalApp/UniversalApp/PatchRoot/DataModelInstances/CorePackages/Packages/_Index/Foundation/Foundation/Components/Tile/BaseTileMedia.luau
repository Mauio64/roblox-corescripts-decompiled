local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local BaseTileMediaClipping = require(Foundation.Enums.BaseTileMediaClipping)
local TileAspectRatio = require(Foundation.Enums.TileAspectRatio)
require(Foundation.Components.Types)
local getBaseTileMediaCorners = require(script.Parent.getBaseTileMediaCorners)
local getTestIdTag = require(Foundation.Utility.getTestIdTag)
local mapBindable = require(Foundation.Utility.mapBindable)
local useTokens = require(Foundation.Providers.Style.useTokens)

local v = {
	[TileAspectRatio.Ratio1x1] = 1,
	[TileAspectRatio.Ratio16x9] = 16 / 9,
	[TileAspectRatio.Ratio2x3] = 2 / 3
}

local udim = UDim2.fromScale(1, 1)

local function BaseTileMedia(props)
	local v2 = useTokens()

	local aspectRatio = v[props.aspectRatio]
	local tileSize

	if typeof(props.tileSize) == "UDim2" then
		tileSize = props.tileSize
	end

	local offset

	if not (tileSize == nil or tileSize.X.Scale ~= 0 or props.isSizeConstrained) then
		offset = tileSize.X.Offset
	end

	local v3

	if offset == nil then
		v3 = udim
	else
		v3 = UDim2.fromOffset(offset, offset / aspectRatio)
	end

	local size

	if props.maxHeight == nil then
		size = v3
	else
		size = props.maxHeight:map(function(p: number?)
			if p == nil then
				return v3
			end

			return (UDim2.new(1, 0, 0, p))
		end)
	end

	local baseTileMediaCorners = getBaseTileMediaCorners(v2, props.isContained)

	local createElement = React.createElement
	local v4 = props.clippingStyle == BaseTileMediaClipping.Rounded and props.content ~= nil and "CanvasGroup"
		or "Frame"
	local v5 = {
		BackgroundColor3 = mapBindable(props.backgroundStyle, function(p)
			return p.Color3
		end),
		BackgroundTransparency = mapBindable(props.backgroundStyle, function(p)
			return p.Transparency
		end),
		BorderSizePixel = 0,
		ClipsDescendants = props.clippingStyle ~= BaseTileMediaClipping.None,
		LayoutOrder = props.LayoutOrder,
		Size = size,
		[React.Tag] = getTestIdTag(props.testId)
	}

	local v6 = {
		Corner = React.createElement("UICorner", {
			TopLeftRadius = baseTileMediaCorners.TopLeftRadius,
			TopRightRadius = baseTileMediaCorners.TopRightRadius,
			BottomLeftRadius = baseTileMediaCorners.BottomLeftRadius,
			BottomRightRadius = baseTileMediaCorners.BottomRightRadius,
			[React.Tag] = getTestIdTag(`{props.testId}--corner`)
		}),
		AspectRatio = 0,
		Content = 0
	}
	local aspectRatio2

	if offset == nil or props.maxHeight ~= nil then
		aspectRatio2 = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = aspectRatio,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		})
	end

	v6.AspectRatio = aspectRatio2

	v6.Content = props.content
	return createElement(v4, v5, v6)
end

return React.memo(BaseTileMedia)
