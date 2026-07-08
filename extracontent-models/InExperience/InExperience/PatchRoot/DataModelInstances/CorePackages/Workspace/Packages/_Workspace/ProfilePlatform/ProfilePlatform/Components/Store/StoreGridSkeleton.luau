local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local SquareCollectionGridView = require(ProfilePlatform.BaseComponents.CollectionGridViews.SquareCollectionGridView)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Foundation = require(ProfilePlatformParent.Foundation)
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local View = Foundation.View

local function v11(n1: number) -- line: 21
	return n1 + 49
end
local function StoreGridSkeleton(t1: {[any]: any}) -- line: 25
	-- upvalues: useLocalization (copy), TextKeys (copy), React (copy), View (copy), Skeleton (copy), EnumsRadius (copy), SquareCollectionGridView (copy), v11 (copy)
	local v15 = useLocalization({
		store = TextKeys.Store
	})
	local v16 = React.useCallback(function(_, n2: number, p2) -- line: 30
		-- upvalues: React (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
		return React.createElement(View, {
			tag = "col gap-small radius-medium",
			LayoutOrder = n2,
			Size = p2
		}, {
			ThumbnailSkeleton = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromScale(1, 0.7),
				radius = EnumsRadius.Medium
			}),
			NameSkeleton = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.fromScale(0.8, 0.09),
				radius = EnumsRadius.Medium
			}),
			ButtonSkeleton = React.createElement(Skeleton, {
				LayoutOrder = 3,
				Size = UDim2.fromScale(0.6, 0.09),
				radius = EnumsRadius.Medium
			})
		}), "Skeleton_" .. n2
	end, {})
	local v17 = React.useMemo(function() -- line: 55
		-- upvalues: t1 (copy)
		local t2 = {}

		for i = 1, t1.numSkeletons do
			table.insert(t2, i)
		end

		return t2
	end, { t1.numSkeletons })

	return React.createElement(SquareCollectionGridView, {
		layoutOrder = t1.layoutOrder,
		items = v17,
		renderItem = v16,
		getItemHeight = v11,
		title = v15.store,
		overrides = {
			numColumns = t1.numColumns or 3
		}
	})
end

return StoreGridSkeleton
