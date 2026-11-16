local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local view = Foundation.View
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local compositionTags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AppComposition").CompositionTags

local function MarketplaceFeedSkeleton(props)
	local v5 = useTokens()

	local numCarousels = props.numCarousels or 4
	local rowHeight = props.rowHeight or v5.Size.Size_3000 * 2
	local headerHeight = props.headerHeight or v5.Size.Size_400
	local headerWidthFraction = props.headerWidthFraction or 0.4

	local children = {}

	for i = 1, numCarousels do
		children[`Carousel-{i}`] = React.createElement(
			view,
			{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = i },
			{
				Header = React.createElement(skeleton, {
					Size = UDim2.new(headerWidthFraction, 0, 0, headerHeight),
					radius = radius.Medium,
					LayoutOrder = 1
				}),
				Row = React.createElement(skeleton, {
					Size = UDim2.new(1, 0, 0, rowHeight),
					radius = radius.Medium,
					LayoutOrder = 2
				})
			}
		)
	end

	return React.createElement(view, {
		tag = {
			["col gap-xlarge size-full auto-y padding-y-small"] = true,
			[compositionTags.ContentRegion.Body] = true
		},
		LayoutOrder = props.layoutOrder,
		testId = props.testId or "--marketplace-feed-skeleton"
	}, children)
end

return React.memo(MarketplaceFeedSkeleton)
