local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local SquareCollectionGridView = require(ProfilePlatform.BaseComponents.CollectionGridViews.SquareCollectionGridView)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Foundation = require(parent.Foundation)
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local View = Foundation.View

local function fn(p: number)
	return p + 49
end

local function StoreGridSkeleton(props)
	local v = useLocalization({ store = TextKeys.Store })

	local renderItem = React.useCallback(function(_, layoutOrder: number, size)
		return
			React.createElement(View, {
				tag = "col gap-small radius-medium",
				LayoutOrder = layoutOrder,
				Size = size
			}, {
				ThumbnailSkeleton = React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.fromScale(1, 0.7),
					radius = Radius.Medium
				}),
				NameSkeleton = React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.fromScale(0.8, 0.09),
					radius = Radius.Medium
				}),
				ButtonSkeleton = React.createElement(Skeleton, {
					LayoutOrder = 3,
					Size = UDim2.fromScale(0.6, 0.09),
					radius = Radius.Medium
				})
			}),
			"Skeleton_" .. layoutOrder
	end, {})

	local items = React.useMemo(function()
		local result = {}

		for i = 1, props.numSkeletons do
			table.insert(result, i)
		end

		return result
	end, { props.numSkeletons })

	return React.createElement(SquareCollectionGridView, {
		layoutOrder = props.layoutOrder,
		items = items,
		renderItem = renderItem,
		getItemHeight = fn,
		title = v.store,
		overrides = {
			numColumns = props.numColumns or 3
		}
	})
end

return StoreGridSkeleton
