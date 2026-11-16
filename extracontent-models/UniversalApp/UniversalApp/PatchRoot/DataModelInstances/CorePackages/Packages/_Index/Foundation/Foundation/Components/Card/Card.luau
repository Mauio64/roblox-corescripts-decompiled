local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local CardDensity = require(Foundation.Enums.CardDensity)
local CardHeaderSize = require(Foundation.Enums.CardHeaderSize)
local CardHeight = require(Foundation.Enums.CardHeight)
local CardMediaAspectRatio = require(Foundation.Enums.CardMediaAspectRatio)
local CardMediaPlacement = require(Foundation.Enums.CardMediaPlacement)
local CardVariant = require(Foundation.Enums.CardVariant)

local CardActions = require(script.Parent.Subcomponents.CardActions)
local CardHeader = require(script.Parent.Subcomponents.CardHeader)
local CardMedia = require(script.Parent.Subcomponents.CardMedia)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

local useCardVariants = require(script.Parent.useCardVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local Ratio2x1 = CardMediaAspectRatio.Ratio2x1

local v = {
	[CardMediaAspectRatio.Ratio1x1] = 1,
	[CardMediaAspectRatio.Ratio5x4] = 1.25,
	[CardMediaAspectRatio.Ratio4x3] = 4 / 3,
	[CardMediaAspectRatio.Ratio3x2] = 1.5,
	[CardMediaAspectRatio.Ratio16x9] = 16 / 9,
	[CardMediaAspectRatio.Ratio2x1] = 2
}

local v2 = {
	variant = CardVariant.Standard,
	density = CardDensity.Default,
	height = CardHeight.Fit,
	testId = "--foundation-card"
}

local v3 = {
	[CardDensity.Compact] = CardHeaderSize.Small,
	[CardDensity.Default] = CardHeaderSize.Medium,
	[CardDensity.Comfortable] = CardHeaderSize.Large
}

local function resolveMedia(media)
	if typeof(media) == "string" then
		return {
			src = media,
			placement = CardMediaPlacement.End,
			width = 136,
			aspectRatio = v[Ratio2x1]
		}
	end

	if typeof(media) ~= "table" then
		return nil
	end

	local placement = media.placement or CardMediaPlacement.End
	local width = (placement ~= CardMediaPlacement.End or media.width == nil) and 136 or media.width
	local v4

	if placement == CardMediaPlacement.Bottom and media.aspectRatio ~= nil then
		v4 = media.aspectRatio
	else
		v4 = Ratio2x1
	end

	return { src = media.image, placement = placement, width = width, aspectRatio = v[v4] }
end

local function getBottomMediaHeight(media, state: number) -- 1 equivalent call inferred from this helper
	if media == nil or media.placement ~= CardMediaPlacement.Bottom then
		return 0
	end

	return (math.round(state / media.aspectRatio))
end

local function Card(p, ref)
	local v4 = withDefaults(p, v2)
	local v5 = useTokens()
	local headerSize = v4.headerSize or v3[v4.density]

	local v6 = v4.title ~= nil or v4.description ~= nil
	local media = resolveMedia(v4.media)
	local v7

	if media == nil then
		v7 = false
	else
		v7 = media.placement == CardMediaPlacement.End
	end

	local v8 = v4.onOverflow ~= nil or v4.onClose ~= nil
	local isInline = v6 and not v7
	local isFillHeight = v4.height == CardHeight.Fill
	local v9

	if v4.eyebrow == nil or v4.title == nil then
		v9 = v4.description == nil
	else
		v9 = false
	end

	local variantProps = useCardVariants(v5, v4.variant, v4.density, headerSize, v4.height, v7, v9, isInline)

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)

	local onAbsoluteSizeChanged = React.useCallback(function(p2)
		local x = p2.AbsoluteSize.X
		setState(function(p3)
			return if p3 == x then p3 else x
		end)
	end, {})

	local onAbsoluteSizeChanged2 = React.useCallback(function(p2)
		setState2(p2.AbsoluteSize.Y)
	end, {})
	local actions

	if v8 then
		actions = React.createElement(CardActions, {
			testId = v4.testId,
			variantProps = variantProps,
			onOverflow = v4.onOverflow,
			onClose = v4.onClose,
			overflowRef = v4.overflowRef,
			isOverMedia = v7,
			isInline = isInline
		})
	end

	local bottomMediaHeight = getBottomMediaHeight(media, state) -- inferred equivalent call
	local v10 = state2 + bottomMediaHeight

	local createElement = React.createElement

	local v11 = withCommonProps(v4, {
		tag = variantProps.container.tag,
		sizeConstraint = isFillHeight and { MinSize = Vector2.new(0, v10) } or nil,
		onActivated = v4.onActivated,
		ref = ref
	})

	local createElement2 = React.createElement
	local v12 = { tag = variantProps.body.tag, onAbsoluteSizeChanged = onAbsoluteSizeChanged }

	local createElement3 = React.createElement
	local v13 = {
		tag = variantProps.content.tag,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged2,
		LayoutOrder = 1
	}
	local header

	if v6 then
		local createElement4 = React.createElement
		local v14 = {
			testId = v4.testId,
			variantProps = variantProps,
			eyebrow = v4.eyebrow,
			icon = v4.icon,
			title = v4.title,
			description = v4.description,
			descriptionLineClamp = 0,
			actions = 0
		}
		local descriptionLineClamp

		if v4.lineClamp then
			descriptionLineClamp = v4.lineClamp.description
		end

		v14.descriptionLineClamp = descriptionLineClamp
		local actions2

		if isInline then
			actions2 = actions
		end

		v14.actions = actions2
		header = createElement4(CardHeader, v14)
	end

	local children

	if v4.children then
		children = React.createElement(
			View,
			{ tag = variantProps.children.tag, LayoutOrder = 2, testId = `{v4.testId}--content` },
			v4.children
		)
	end

	local v14 = {
		Content = createElement3(View, v13, { Header = header, Children = children }),
		Media = 0
	}
	local media2

	if media then
		media2 = React.createElement(CardMedia, {
			image = media.src,
			width = media.width,
			isEnd = v7,
			isFillHeight = isFillHeight,
			bottomHeight = bottomMediaHeight,
			tag = variantProps.media.tag,
			testId = v4.testId
		})
	end

	v14.Media = media2
	local v15 = { Body = createElement2(View, v12, v14), Actions = 0 }

	if isInline then
		actions = nil
	end

	v15.Actions = actions
	return createElement(View, v11, v15)
end

return React.memo(React.forwardRef(Card))
