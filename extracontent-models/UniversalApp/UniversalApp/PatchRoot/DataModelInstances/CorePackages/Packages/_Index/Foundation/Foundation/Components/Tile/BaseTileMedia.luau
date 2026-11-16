local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local TileAspectRatio = require(Foundation.Enums.TileAspectRatio)
require(Foundation.Components.Types)
local getTestIdTag = require(Foundation.Utility.getTestIdTag)
local mapBindable = require(Foundation.Utility.mapBindable)
local useTokens = require(Foundation.Providers.Style.useTokens)

local v = {
	[TileAspectRatio.Ratio1x1] = 1,
	[TileAspectRatio.Ratio16x9] = 16 / 9,
	[TileAspectRatio.Ratio2x3] = 2 / 3
}

local udim = UDim2.fromScale(1, 1)
local udim2 = UDim.new(0, 0)

local function BaseTileMedia(props)
	local v2 = useTokens()

	local aspectRatio = v[props.aspectRatio]
	local tileSize

	if typeof(props.tileSize) == "UDim2" then
		tileSize = props.tileSize
	end

	local offset

	if not (tileSize == nil or tileSize.X.Scale ~= 0) then
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

	local udim3 = UDim.new(0, v2.Radius.Medium)
	local v4 = if props.isContained then udim2 else udim3

	local createElement = React.createElement
	local v5 = props.content == nil and "Frame" or "CanvasGroup"
	local v6 = {
		BackgroundColor3 = mapBindable(props.backgroundStyle, function(p)
			return p.Color3
		end),
		BackgroundTransparency = mapBindable(props.backgroundStyle, function(p)
			return p.Transparency
		end),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = props.LayoutOrder,
		Size = size,
		[React.Tag] = getTestIdTag(props.testId)
	}
	local v7 = {
		Corner = React.createElement("UICorner", {
			TopLeftRadius = udim3,
			TopRightRadius = udim3,
			BottomLeftRadius = v4,
			BottomRightRadius = v4,
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

	v7.AspectRatio = aspectRatio2

	v7.Content = props.content
	return createElement(v5, v6, v7)
end

return React.memo(BaseTileMedia)
