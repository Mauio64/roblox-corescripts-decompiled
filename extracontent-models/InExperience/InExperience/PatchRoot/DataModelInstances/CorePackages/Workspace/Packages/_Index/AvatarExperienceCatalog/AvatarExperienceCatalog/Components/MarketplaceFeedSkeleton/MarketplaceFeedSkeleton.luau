local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local AppComposition = require(parent.AppComposition)
local CompositionTags = AppComposition.CompositionTags

local function MarketplaceFeedSkeleton(props)
	local v = useTokens()

	local numCarousels = props.numCarousels or 4
	local rowHeight = props.rowHeight or v.Size.Size_3000 * 2
	local headerHeight = props.headerHeight or v.Size.Size_400
	local headerWidthFraction = props.headerWidthFraction or 0.4

	local children = {}

	for i = 1, numCarousels do
		children[`Carousel-{i}`] = React.createElement(
			View,
			{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = i },
			{
				Header = React.createElement(Skeleton, {
					Size = UDim2.new(headerWidthFraction, 0, 0, headerHeight),
					radius = Radius.Medium,
					LayoutOrder = 1
				}),
				Row = React.createElement(Skeleton, {
					Size = UDim2.new(1, 0, 0, rowHeight),
					radius = Radius.Medium,
					LayoutOrder = 2
				})
			}
		)
	end

	return React.createElement(View, {
		tag = {
			["col gap-xlarge size-full auto-y padding-y-small"] = true,
			[CompositionTags.ContentRegion.Body] = true
		},
		LayoutOrder = props.layoutOrder,
		testId = props.testId or "--marketplace-feed-skeleton"
	}, children)
end

return React.memo(MarketplaceFeedSkeleton)
