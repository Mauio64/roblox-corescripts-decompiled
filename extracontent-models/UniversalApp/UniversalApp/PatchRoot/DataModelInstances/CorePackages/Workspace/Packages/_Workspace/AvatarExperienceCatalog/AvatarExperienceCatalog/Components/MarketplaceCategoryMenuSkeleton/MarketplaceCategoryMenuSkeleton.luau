local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function MarketplaceCategoryMenuSkeleton(t1: {[any]: any}) -- line: 32
	-- upvalues: useTokens (copy), React (copy), Skeleton (copy), EnumsRadius (copy), View (copy)
	local v10 = useTokens()
	local v11 = t1.numCategoryChips or 6
	local v12 = t1.chipHeight or v10.Size.Size_800
	local v13 = t1.chipWidth or v10.Size.Size_2800
	local t2 = {}

	for i = 1, v11 do
		t2[`Chip-{ i }`] = React.createElement(Skeleton, {
			radius = EnumsRadius.Circle,
			Size = UDim2.fromOffset(v13, v12),
			LayoutOrder = i
		})
	end

	return React.createElement(View, {
		tag = "row gap-small size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder,
		testId = t1.testId or "--marketplace-category-menu-skeleton"
	}, t2)
end

return React.memo(MarketplaceCategoryMenuSkeleton)
