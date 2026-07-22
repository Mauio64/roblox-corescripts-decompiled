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
local Flags = require(Foundation.Utility.Flags)
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

local function TileMedia(t3: {[any]: any}) -- line: 58
	-- upvalues: withDefaults (copy), t2 (copy), useTile (copy), useTokens (copy), React (copy), getRbxThumb (copy), Flags (copy), MediaShape (copy), Image (copy), View (copy), t1 (copy), Gradient (copy)
	local v17 = withDefaults(t3, t2)
	local v18 = useTile()
	local v19 = useTokens()
	local v20 = if not v17.background then nil else v17.background.style
	local v21 = if not v17.background then nil else v17.background.image
	local v22 = React.useMemo(function() -- line: 67
		-- upvalues: v17 (copy), getRbxThumb (copy)
		if v17.id == nil or v17.type == nil then
			return nil
		end

		return getRbxThumb(v17.type, v17.id)
	end, {
		v17.type,
		v17.id
	})
	local v23 = if Flags.FoundationMediaRoundedCornerTags then nil else if v17.shape ~= MediaShape.Circle then UDim.new(0, v19.Radius.Medium) else UDim.new(0, v19.Radius.Circle)
	local v24 = if Flags.FoundationMediaRoundedCornerTags then nil else v18.isContained and v23

	return React.createElement(if not v21 then View else Image, {
		ZIndex = 0,
		Image = v21,
		imageStyle = if not v21 then nil else v20,
		backgroundStyle = if not v21 then v20 else nil,
		Size = if v18.fillDirection ~= Enum.FillDirection.Vertical then UDim2.fromScale(0, 1) else UDim2.fromScale(1, 0),
		LayoutOrder = v17.LayoutOrder,
		aspectRatio = {
			AspectRatio = t1[v17.shape],
			AspectType = Enum.AspectType.ScaleWithParentSize,
			DominantAxis = if v18.fillDirection ~= Enum.FillDirection.Vertical then Enum.DominantAxis.Height else Enum.DominantAxis.Width
		},
		cornerRadius = v23,
		tag = if not Flags.FoundationMediaRoundedCornerTags then nil else {
			["radius-top-medium"] = v18.fillDirection == Enum.FillDirection.Vertical and v18.isContained,
			["radius-left-medium"] = v18.fillDirection == Enum.FillDirection.Horizontal and v18.isContained,
			["radius-medium"] = v17.shape ~= MediaShape.Circle and not v18.isContained,
			["radius-circle"] = v17.shape == MediaShape.Circle and not v18.isContained
		},
		onStateChanged = v17.onStateChanged,
		testId = `{ v18.testId }--media`
	}, {
		TransparencyGradient = if not v24 then nil else React.createElement(Gradient, {
			top = true,
			fillDirection = v18.fillDirection
		}),
		MiddleCorners = if not v24 then nil else React.createElement(Image, {
			ZIndex = 0,
			tag = "size-full",
			Image = v21,
			imageStyle = if not v21 then nil else v20,
			backgroundStyle = if not v21 then v20 else nil
		}, {
			TransparencyGradient = React.createElement(Gradient, {
				top = false,
				fillDirection = v18.fillDirection
			})
		}),
		Image = React.createElement(Image, {
			Image = v22,
			cornerRadius = v23,
			imageStyle = v17.style,
			tag = if not Flags.FoundationMediaRoundedCornerTags then {
				["size-full"] = true,
				["padding-medium"] = v17.children ~= nil
			} else {
				["size-full"] = true,
				["padding-medium"] = v17.children ~= nil,
				["radius-top-medium"] = v18.fillDirection == Enum.FillDirection.Vertical and v18.isContained,
				["radius-left-medium"] = v18.fillDirection == Enum.FillDirection.Horizontal and v18.isContained,
				["radius-medium"] = v17.shape ~= MediaShape.Circle and not v18.isContained,
				["radius-circle"] = v17.shape == MediaShape.Circle
			},
			testId = `{ v18.testId }--media-image`
		}, v17.children)
	})
end

return TileMedia
