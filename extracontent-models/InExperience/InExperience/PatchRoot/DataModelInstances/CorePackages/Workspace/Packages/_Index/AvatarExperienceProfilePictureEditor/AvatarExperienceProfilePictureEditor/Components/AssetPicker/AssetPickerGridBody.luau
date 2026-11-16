local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)

local View = Foundation.View
local Radius = Foundation.Enums.Radius
local Grid = AvatarExperienceUIKit.GridComponents.Grid
local ItemCardThumbnailSkeleton = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnailSkeleton

local AssetPickerErrorBody = require(script.Parent.AssetPickerErrorBody)
local AssetPickerTile = require(script.Parent.AssetPickerTile)
require(AvatarExperienceProfilePictureEditor.Utils.getAssetPickerStatus)

local function buildLoadingItems(shimmerTileCount: number)
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

	local v = props.status == "loading"
	local items

	if v then
		items = buildLoadingItems(props.shimmerTileCount)
	else
		items = props.items
	end

	local renderItem

	if v then
		renderItem = function(p)
			return React.createElement(View, {
				tag = "size-full-0 auto-y",
				LayoutOrder = p.index,
				aspectRatio = {
					AspectRatio = 1,
					AspectType = Enum.AspectType.FitWithinMaxSize,
					DominantAxis = Enum.DominantAxis.Width
				}
			}, {
				Shimmer = React.createElement(ItemCardThumbnailSkeleton, { radius = Radius.Medium })
			})
		end
	else
		renderItem = function(p)
			local item = p.item
			return React.createElement(AssetPickerTile, {
				item = item,
				selectedId = props.selectedId,
				onSelect = props.onSelect,
				onDetailsActivated = props.onDetailsActivated,
				labels = props.labels,
				layoutOrder = p.index
			})
		end
	end

	return React.createElement(Grid, {
		itemsPerRow = props.itemsPerRow,
		items = items,
		gapVertical = props.gap,
		gapHorizontal = props.gap,
		getItemId = function(p)
			return p.id
		end,
		renderItem = renderItem,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	})
end

return AssetPickerGridBody
