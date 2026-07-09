local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local CompositionTags = require(Parent.AppComposition).CompositionTags

local function MarketplaceFeedSkeleton(t1: {[any]: any}) -- line: 44
	-- upvalues: useTokens (copy), React (copy), View (copy), Skeleton (copy), EnumsRadius (copy), CompositionTags (copy)
	local v11 = useTokens()
	local v12 = t1.numCarousels or 4
	local v13 = t1.rowHeight or v11.Size.Size_3000 * 2
	local v14 = t1.headerHeight or v11.Size.Size_400
	local v15 = t1.headerWidthFraction or 0.4
	local t2 = {}

	for i = 1, v12 do
		t2[`Carousel-{ i }`] = React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y",
			LayoutOrder = i
		}, {
			Header = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(v15, 0, 0, v14),
				radius = EnumsRadius.Medium
			}),
			Row = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v13),
				radius = EnumsRadius.Medium
			})
		})
	end

	return React.createElement(View, {
		tag = {
			["col gap-xlarge size-full auto-y padding-y-small"] = true,
			[CompositionTags.ContentRegion.Body] = true
		},
		LayoutOrder = t1.layoutOrder,
		testId = t1.testId or "--marketplace-feed-skeleton"
	}, t2)
end

return React.memo(MarketplaceFeedSkeleton)
