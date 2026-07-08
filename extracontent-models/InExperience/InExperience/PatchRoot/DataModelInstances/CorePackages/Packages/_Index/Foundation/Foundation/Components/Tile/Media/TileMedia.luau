local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Enums.MediaType)
require(Foundation.Enums.ThumbnailType)
require(Foundation.Enums.ThumbnailSize)

local MediaShape = require(Foundation.Enums.MediaShape)
local Gradient = require(Foundation.Components.Gradient)
local getRbxThumb = require(Foundation.Utility.getRbxThumb)
local useTile = require(Foundation.Components.Tile.useTile)
local withDefaults = require(Foundation.Utility.withDefaults)
local Image = require(Foundation.Components.Image)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)

require(Foundation.Components.Types)

local t1 = {
	[MediaShape.Circle] = 1,
	[MediaShape.Square] = 1,
	[MediaShape.Landscape] = 1.7777777777777777,
	[MediaShape.Portrait] = 0.5625
}
local t2 = {
	LayoutOrder = 1,
	shape = MediaShape.Square
}

local function TileMedia(t3: {[any]: any}) -- line: 56
	-- upvalues: withDefaults (copy), t2 (copy), useTile (copy), useTokens (copy), React (copy), getRbxThumb (copy), MediaShape (copy), Image (copy), View (copy), t1 (copy), Gradient (copy)
	local v16 = withDefaults(t3, t2)
	local v17 = useTile()
	local v18 = useTokens()
	local v19 = if not v16.background then nil else v16.background.style
	local v20 = if not v16.background then nil else v16.background.image
	local v21 = React.useMemo(function() -- line: 65
		-- upvalues: v16 (copy), getRbxThumb (copy)
		if v16.id == nil or v16.type == nil then
			return nil
		end

		return getRbxThumb(v16.type, v16.id)
	end, {
		v16.type,
		v16.id
	})
	local v22 = if v16.shape ~= MediaShape.Circle then UDim.new(0, v18.Radius.Medium) else UDim.new(0, v18.Radius.Circle)
	local v23 = v17.isContained and v22

	return React.createElement(if not v20 then View else Image, {
		ZIndex = 0,
		Image = v20,
		imageStyle = if not v20 then nil else v19,
		backgroundStyle = if not v20 then v19 else nil,
		Size = if v17.fillDirection ~= Enum.FillDirection.Vertical then UDim2.fromScale(0, 1) else UDim2.fromScale(1, 0),
		LayoutOrder = v16.LayoutOrder,
		aspectRatio = {
			AspectRatio = t1[v16.shape],
			AspectType = Enum.AspectType.ScaleWithParentSize,
			DominantAxis = if v17.fillDirection ~= Enum.FillDirection.Vertical then Enum.DominantAxis.Height else Enum.DominantAxis.Width
		},
		cornerRadius = v22,
		onStateChanged = v16.onStateChanged,
		testId = `{ v17.testId }--media`
	}, {
		TransparencyGradient = if not v23 then nil else React.createElement(Gradient, {
			top = true,
			fillDirection = v17.fillDirection
		}),
		MiddleCorners = if not v23 then nil else React.createElement(Image, {
			ZIndex = 0,
			tag = "size-full",
			Image = v20,
			imageStyle = if not v20 then nil else v19,
			backgroundStyle = if not v20 then v19 else nil
		}, {
			TransparencyGradient = React.createElement(Gradient, {
				top = false,
				fillDirection = v17.fillDirection
			})
		}),
		Image = React.createElement(Image, {
			Image = v21,
			cornerRadius = v22,
			imageStyle = v16.style,
			tag = {
				["size-full"] = true,
				["padding-medium"] = v16.children ~= nil
			},
			testId = `{ v17.testId }--media-image`
		}, v16.children)
	})
end

return TileMedia
