local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local view = Foundation.View
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function MarketplaceCategoryMenuSkeleton(props)
	local v5 = useTokens()

	local numCategoryChips = props.numCategoryChips or 6
	local chipHeight = props.chipHeight or v5.Size.Size_800
	local chipWidth = props.chipWidth or v5.Size.Size_2800

	local children = {}

	for i = 1, numCategoryChips do
		children[`Chip-{i}`] = React.createElement(skeleton, {
			radius = radius.Circle,
			Size = UDim2.fromOffset(chipWidth, chipHeight),
			LayoutOrder = i
		})
	end

	return React.createElement(view, {
		tag = "row gap-small size-full-0 auto-y",
		LayoutOrder = props.layoutOrder,
		testId = props.testId or "--marketplace-category-menu-skeleton"
	}, children)
end

return React.memo(MarketplaceCategoryMenuSkeleton)
