local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local SquareCollectionGridView = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/BaseComponents/CollectionGridViews/SquareCollectionGridView")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local view = Foundation.View

local function fn(p2)
	return p2 + 49
end

local function StoreGridSkeleton(props)
	local v5 = useLocalization({ store = TextKeys.Store })

	local v6 = React.useCallback(function(p2, p3, p4)
		return
			React.createElement(
				view,
				{ tag = "col gap-small radius-medium", LayoutOrder = p3, Size = p4 },
				{
					ThumbnailSkeleton = React.createElement(skeleton, {
						LayoutOrder = 1,
						Size = UDim2.fromScale(1, 0.7),
						radius = radius.Medium
					}),
					NameSkeleton = React.createElement(skeleton, {
						LayoutOrder = 2,
						Size = UDim2.fromScale(0.8, 0.09),
						radius = radius.Medium
					}),
					ButtonSkeleton = React.createElement(skeleton, {
						LayoutOrder = 3,
						Size = UDim2.fromScale(0.6, 0.09),
						radius = radius.Medium
					})
				}
			),
			"Skeleton_" .. p3
	end, {})

	local v7 = React.useMemo(function()
		local result = {}

		for i = 1, props.numSkeletons do
			table.insert(result, i)
		end

		return result
	end, { props.numSkeletons })

	return React.createElement(SquareCollectionGridView, {
		layoutOrder = props.layoutOrder,
		items = v7,
		renderItem = v6,
		getItemHeight = fn,
		title = v5.store,
		overrides = {
			numColumns = props.numColumns or 3
		}
	})
end

return StoreGridSkeleton
