local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Localization")
local AvatarExperienceUIKit = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AvatarExperienceUIKit")

local view = Foundation.View
local scrollView = Foundation.ScrollView
local visibility = Foundation.Enums.Visibility
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization
local SectionTitle = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/SectionTitle/SectionTitle")
local SectionTitleWithAction = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/SectionTitle/SectionTitleWithAction")
local AssetPickerErrorBody = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/AssetPickerErrorBody")
local AssetPickerTile = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/AssetPickerTile")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/getAssetPickerStatus")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/TextKeys")
local widgetLayout = AvatarExperienceUIKit.WidgetComponents.WidgetLayout
local itemCardThumbnailSkeleton = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnailSkeleton

local function AssetPickerCarousel(props)
	local status = props.status or "ready"
	local v5 = useTokens()
	local v6 = useLocalization({ details = TextKeys.DetailsButton })

	local tileSize = props.tileSize
	local shimmerTileCount = props.shimmerTileCount or 8
	local v7 = React.useMemo(function()
		return { details = v6.details }
	end, { v6.details })

	local children = React.useMemo(function()
		local children2 = {}

		for k, item in props.items do
			children2["Asset_" .. item.id] = React.createElement(
				view,
				{
					tag = "size-full-0 auto-y",
					Size = UDim2.fromOffset(tileSize, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = k
				},
				{
					Tile = React.createElement(AssetPickerTile, {
						item = item,
						selectedId = props.selectedId,
						onSelect = props.onSelect,
						onDetailsActivated = props.onDetailsActivated,
						labels = v7
					})
				}
			)
		end

		if props.trailingCarouselComponent then
			children2.Trailing = props.trailingCarouselComponent
		end

		return children2
	end, {
		props.items,
		props.selectedId,
		tileSize,
		props.onSelect,
		props.onDetailsActivated,
		v7,
		props.trailingCarouselComponent
	})

	local title = props.title or ""
	local v8 = status == "ready" and props.onTitleActivated ~= nil

	local v9 = 1
	local children2 = {}

	if props.bannerComponent then
		children2.Banner = React.createElement(view, {
			tag = "size-full-0 auto-y",
			LayoutOrder = v9
		}, {
			Banner = props.bannerComponent
		})

		v9 += 1
	end

	if status == "error" then
		children2.Error = React.createElement(AssetPickerErrorBody, {
			onRetry = props.onRetry,
			layoutOrder = v9
		})
	else
		if status == "loading" then
			children = {}

			for i = 1, shimmerTileCount do
				children["Shimmer_" .. i] = React.createElement(itemCardThumbnailSkeleton, {
					Size = UDim2.fromOffset(tileSize, tileSize),
					radius = radius.Medium,
					LayoutOrder = i
				})
			end
		end

		local clone = table.clone(children)

		clone.CarouselStrokeInset = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5.Padding.XSmall),
			PaddingBottom = UDim.new(0, v5.Padding.XSmall),
			PaddingLeft = UDim.new(0, v5.Padding.XSmall),
			PaddingRight = UDim.new(0, v5.Padding.XSmall)
		})

		children2.List = React.createElement(scrollView, {
			tag = "size-full-0 auto-y",
			testId = "asset-picker-carousel-scroll",
			LayoutOrder = v9,
			selection = { Selectable = false },
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, v5.Gap.Medium),
				SortOrder = Enum.SortOrder.LayoutOrder
			},
			scroll = {
				ScrollingDirection = Enum.ScrollingDirection.X,
				AutomaticSize = Enum.AutomaticSize.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				CanvasSize = UDim2.fromScale(0, 0),
				scrollBarVisibility = visibility.None
			}
		}, clone)
	end

	local createElement = React.createElement
	local v11 = {
		LayoutOrder = props.layoutOrder,
		padding = {
			left = UDim.new(0, v5.Padding.XLarge),
			right = UDim.new(0, v5.Padding.XLarge)
		},
		headerSlot = 0,
		contentSlot = 0
	}
	local v12

	if title ~= "" then
		if v8 then
			v12 = React.createElement(SectionTitleWithAction, {
				title = title,
				leadingIconName = props.titleLeadingIconName,
				variant = "expand",
				onActivated = props.onTitleActivated
			})
		else
			v12 = React.createElement(SectionTitle, {
				title = title,
				leadingIconName = props.titleLeadingIconName
			})
		end
	end

	v11.headerSlot = v12

	v11.contentSlot = React.createElement(view, {
		tag = "col gap-small size-full-0 auto-y"
	}, children2)
	return createElement(widgetLayout, v11)
end

return AssetPickerCarousel
