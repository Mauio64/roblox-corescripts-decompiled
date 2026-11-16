local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function MarketplaceCategoryMenuSkeleton(props)
	local v = useTokens()

	local numCategoryChips = props.numCategoryChips or 6
	local chipHeight = props.chipHeight or v.Size.Size_800
	local chipWidth = props.chipWidth or v.Size.Size_2800

	local children = {}

	for i = 1, numCategoryChips do
		children[`Chip-{i}`] = React.createElement(Skeleton, {
			radius = Radius.Circle,
			Size = UDim2.fromOffset(chipWidth, chipHeight),
			LayoutOrder = i
		})
	end

	return React.createElement(View, {
		tag = "row gap-small size-full-0 auto-y",
		LayoutOrder = props.layoutOrder,
		testId = props.testId or "--marketplace-category-menu-skeleton"
	}, children)
end

return React.memo(MarketplaceCategoryMenuSkeleton)
