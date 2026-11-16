local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)

local View = Foundation.View
local ScrollView = Foundation.ScrollView
local Visibility = Foundation.Enums.Visibility
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization
local SectionTitle = require(AvatarExperienceProfilePictureEditor.Components.SectionTitle.SectionTitle)
local SectionTitleWithAction = require(AvatarExperienceProfilePictureEditor.Components.SectionTitle.SectionTitleWithAction)
local AssetPickerErrorBody = require(script.Parent.AssetPickerErrorBody)
local AssetPickerTile = require(script.Parent.AssetPickerTile)
require(AvatarExperienceProfilePictureEditor.Utils.getAssetPickerStatus)
local TextKeys = require(AvatarExperienceProfilePictureEditor.Common.TextKeys)
local WidgetLayout = AvatarExperienceUIKit.WidgetComponents.WidgetLayout
local ItemCardThumbnailSkeleton = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnailSkeleton

local function AssetPickerCarousel(props)
	local status = props.status or "ready"
	local v = useTokens()
	local v2 = useLocalization({ details = TextKeys.DetailsButton })

	local tileSize = props.tileSize
	local shimmerTileCount = props.shimmerTileCount or 8
	local labels = React.useMemo(function()
		return { details = v2.details }
	end, { v2.details })

	local children = React.useMemo(function()
		local children = {}

		for k, item in props.items do
			children["Asset_" .. item.id] = React.createElement(
				View,
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
						labels = labels
					})
				}
			)
		end

		if props.trailingCarouselComponent then
			children.Trailing = props.trailingCarouselComponent
		end

		return children
	end, {
		props.items,
		props.selectedId,
		tileSize,
		props.onSelect,
		props.onDetailsActivated,
		labels,
		props.trailingCarouselComponent
	})

	local title = props.title or ""
	local v3

	if status == "ready" then
		v3 = props.onTitleActivated ~= nil
	else
		v3 = false
	end

	local layoutOrder = 1
	local children2 = {}

	if props.bannerComponent then
		children2.Banner = React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = layoutOrder
		}, {
			Banner = props.bannerComponent
		})

		layoutOrder += 1
	end

	if status == "error" then
		children2.Error = React.createElement(AssetPickerErrorBody, {
			onRetry = props.onRetry,
			layoutOrder = layoutOrder
		})
	else
		if status == "loading" then
			children = {}

			for i = 1, shimmerTileCount do
				children["Shimmer_" .. i] = React.createElement(ItemCardThumbnailSkeleton, {
					Size = UDim2.fromOffset(tileSize, tileSize),
					radius = Radius.Medium,
					LayoutOrder = i
				})
			end
		end

		local clone = table.clone(children)

		clone.CarouselStrokeInset = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v.Padding.XSmall),
			PaddingBottom = UDim.new(0, v.Padding.XSmall),
			PaddingLeft = UDim.new(0, v.Padding.XSmall),
			PaddingRight = UDim.new(0, v.Padding.XSmall)
		})

		children2.List = React.createElement(ScrollView, {
			tag = "size-full-0 auto-y",
			testId = "asset-picker-carousel-scroll",
			LayoutOrder = layoutOrder,
			selection = { Selectable = false },
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, v.Gap.Medium),
				SortOrder = Enum.SortOrder.LayoutOrder
			},
			scroll = {
				ScrollingDirection = Enum.ScrollingDirection.X,
				AutomaticSize = Enum.AutomaticSize.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				CanvasSize = UDim2.fromScale(0, 0),
				scrollBarVisibility = Visibility.None
			}
		}, clone)
	end

	local createElement = React.createElement
	local v4 = {
		LayoutOrder = props.layoutOrder,
		padding = { left = UDim.new(0, v.Padding.XLarge), right = UDim.new(0, v.Padding.XLarge) },
		headerSlot = 0,
		contentSlot = 0
	}
	local headerSlot

	if title ~= "" then
		if v3 then
			headerSlot = React.createElement(SectionTitleWithAction, {
				title = title,
				leadingIconName = props.titleLeadingIconName,
				variant = "expand",
				onActivated = props.onTitleActivated
			})
		else
			headerSlot = React.createElement(SectionTitle, {
				title = title,
				leadingIconName = props.titleLeadingIconName
			})
		end
	end

	v4.headerSlot = headerSlot

	v4.contentSlot = React.createElement(View, { tag = "col gap-small size-full-0 auto-y" }, children2)
	return createElement(WidgetLayout, v4)
end

return AssetPickerCarousel
