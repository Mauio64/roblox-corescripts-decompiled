local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local SquareCollectionGridView = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/BaseComponents/CollectionGridViews/SquareCollectionGridView")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local view = Foundation.View
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset

local v5 = { numColumns = 3 }

local function getTextSizeAdjustedSquareExperienceTileHeight(p2)
	return function(p3)
		return p3 + 80 + 3 * p2
	end
end

local function ExperiencesSkeleton(p2)
	local v6 = useLocalization({ experiences = TextKeys.Experiences })

	local v7 = useTextSizeOffset()
	local v8 = React.useMemo(function()
		local v9 = v7
		return function(p3)
			return p3 + 80 + 3 * v9
		end
	end, { v7 })

	local v9 = React.useCallback(function(p3, p4, p5)
		return
			React.createElement(
				view,
				{ tag = "col gap-small radius-medium", LayoutOrder = p4, Size = p5 },
				{
					ThumbnailSkeleton = React.createElement(skeleton, {
						LayoutOrder = 1,
						Size = UDim2.fromScale(1, 0.6),
						radius = radius.Medium
					}),
					NameSkeleton = React.createElement(skeleton, {
						LayoutOrder = 2,
						Size = UDim2.fromScale(0.8, 0.18),
						radius = radius.Medium
					}),
					ButtonSkeleton = React.createElement(skeleton, {
						LayoutOrder = 3,
						Size = UDim2.fromScale(0.6, 0.08),
						radius = radius.Medium
					})
				}
			),
			"Skeleton_" .. p4
	end, {})

	local v10 = React.useMemo(function()
		local result = {}

		for i = 1, p2.numSkeletons do
			table.insert(result, i)
		end

		return result
	end, { p2.numSkeletons })

	return React.createElement(SquareCollectionGridView, {
		layoutOrder = p2.layoutOrder,
		items = v10,
		renderItem = v9,
		getItemHeight = v8,
		title = v6.experiences,
		overrides = v5
	})
end

return ExperiencesSkeleton
