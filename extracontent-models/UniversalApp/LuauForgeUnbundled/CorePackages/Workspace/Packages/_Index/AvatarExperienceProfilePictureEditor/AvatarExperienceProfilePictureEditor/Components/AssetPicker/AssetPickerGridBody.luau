local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")
local AvatarExperienceUIKit = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AvatarExperienceUIKit")

local view = Foundation.View
local radius = Foundation.Enums.Radius
local grid = AvatarExperienceUIKit.GridComponents.Grid
local itemCardThumbnailSkeleton = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnailSkeleton

local AssetPickerErrorBody = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/AssetPickerErrorBody")
local AssetPickerTile = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/AssetPickerTile")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/getAssetPickerStatus")

local function buildLoadingItems(shimmerTileCount)
	local loadingItems = {}

	for i = 1, shimmerTileCount do
		table.insert(loadingItems, {
			id = "shimmer_" .. i
		})
	end

	return loadingItems
end

local function AssetPickerGridBody(props)
	if props.status == "error" then
		return React.createElement(AssetPickerErrorBody, { onRetry = props.onRetry })
	end

	local v5 = props.status == "loading"
	local v6 = if v5 then buildLoadingItems(props.shimmerTileCount) else props.items
	local v7

	if v5 then
		v7 = function(p2)
			return React.createElement(view, {
				tag = "size-full-0 auto-y",
				LayoutOrder = p2.index,
				aspectRatio = {
					AspectRatio = 1,
					AspectType = Enum.AspectType.FitWithinMaxSize,
					DominantAxis = Enum.DominantAxis.Width
				}
			}, {
				Shimmer = React.createElement(itemCardThumbnailSkeleton, {
					radius = radius.Medium
				})
			})
		end
	else
		v7 = function(p2)
			local item = p2.item
			return React.createElement(AssetPickerTile, {
				item = item,
				selectedId = props.selectedId,
				onSelect = props.onSelect,
				onDetailsActivated = props.onDetailsActivated,
				labels = props.labels,
				layoutOrder = p2.index
			})
		end
	end

	return React.createElement(grid, {
		itemsPerRow = props.itemsPerRow,
		items = v6,
		gapVertical = props.gap,
		gapHorizontal = props.gap,
		getItemId = function(p2)
			return p2.id
		end,
		renderItem = v7,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	})
end

return AssetPickerGridBody
