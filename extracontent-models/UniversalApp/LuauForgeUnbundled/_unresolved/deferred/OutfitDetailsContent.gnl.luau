local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)

local DefaultMetricsGridView = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Grid/DefaultMetricsGridView")

local module2 = require("@luauforge/deferred/gne")
local NavigationTabLayout = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Navigation/Enum/NavigationTabLayout")
local BadgeVariant = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Indicator/Enum/BadgeVariant")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local itemTypeEnum = require("@luauforge/bundled/dMd").Enums.ItemTypeEnum
require("@luauforge/bundled/dMc")
local module6 = require("@luauforge/deferred/gkv")
local catalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local backgroundHighlight = AvatarExperienceCommon.Components.BackgroundHighlight

local loadableImage = UIBlox.App.Loading.LoadableImage
local customMetricsGetter = UIBlox.App.Grid.GridMetrics.makeCustomMetricsGetter({
	minimumItemsPerRow = 3,
	minimumItemWidth = 110
})

local function renderGridItem(props)
	return React.createElement(catalogItemCard, {
		title = props.name,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		presentationSlot = React.createElement(Foundation.Image, {
			tag = "size-full radius-medium clip",
			Image = props.thumbnailUrl,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Crop
		}),
		itemStatus = props.itemStatus
	})
end

local function OutfitDetailsContent(props)
	local contentMargin = props.contentMargin
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		tag = "size-full-0 auto-y",
		LayoutOrder = 1,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 24),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		padding = UDim.new(0, contentMargin)
	}

	local v6 = props.showModerationBanner

	if v6 then
		local createElement2 = React.createElement
		local view2 = Foundation.View
		local v7 = {
			Size = UDim2.new(1, contentMargin * 2, 0, 0),
			Position = UDim2.fromOffset(-contentMargin, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 1
		}

		local v9 = if props.isModerated then React.createElement(module2, {
			contentText = props.localized.moderated,
			variant = BadgeVariant.Alert,
			placement = NavigationTabLayout.Bleed,
			actionText = props.localized.details,
			onActivated = props.onGoToAppeals
		}) else React.createElement(module2, {
			contentText = props.localized.pending,
			variant = BadgeVariant.Default,
			placement = NavigationTabLayout.Bleed
		})
		v6 = createElement2(view2, v7, { Banner = v9 })
	end

	local children = {
		ModerationBanner = v6,
		Thumbnail = React.createElement(Foundation.View, {
			LayoutOrder = 2,
			Size = UDim2.new(1, -24, 0, 300),
			aspectRatio = {
				AspectRatio = 1,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			},
			sizeConstraint = { MaxSize = Vector2.new(1e999, 300) },
			ZIndex = -5
		}, {
			GradientBackground = React.createElement(backgroundHighlight, { ZIndex = 0 }),
			LoadableImage = React.createElement(loadableImage, {
				BackgroundTransparency = 1,
				ImageTransparency = props.outfitThumbnailTransparency,
				Image = props.outfitThumbnailUrl,
				Size = UDim2.fromScale(1, 1),
				useShimmerAnimationWhileLoading = true,
				ZIndex = 1
			})
		}),
		OutfitName = 0,
		ItemsGrid = 0,
		ItemInfoList = 0
	}

	local v7 = props.showCustomOutfitNames

	if v7 then
		if props.outfitName then
			v7 = React.createElement(Foundation.Text, {
				tag = "size-full-0 auto-y text-title-large",
				Text = props.outfitName,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				LayoutOrder = 3
			})
		else
			v7 = React.createElement(Foundation.Skeleton, {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, 28)
			})
		end
	end

	children.OutfitName = v7

	children.ItemsGrid = React.createElement(
		Foundation.View,
		{ tag = "size-full-0 auto-y", LayoutOrder = 4 },
		{
			LoadableGridView = React.createElement(DefaultMetricsGridView, {
				getItemMetrics = customMetricsGetter,
				items = props.viewItems,
				totalNumItems = props.totalItemCount,
				renderItem = renderGridItem,
				getItemHeight = props.getItemHeight,
				windowHeight = props.screenHeight,
				forwardRef = ref2
			})
		}
	)

	local v8 = if props.showItemInfoList then React.createElement(module6, {
		itemId = props.outfitInfo and props.outfitInfo.outfitId or "",
		outfitInfo = props.outfitInfo,
		itemType = itemTypeEnum.Outfit,
		LayoutOrder = 5,
		attributionRef = ref
	}) else nil
	children.ItemInfoList = v8
	local element = createElement(view, v5, children)

	local element2 = React.createElement(Foundation.ScrollView, {
		tag = "fill size-full-0",
		LayoutOrder = 1,
		scroll = {
			ScrollingDirection = Enum.ScrollingDirection.Y,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(1, 0),
			scrollBarVisibility = Foundation.Enums.Visibility.None
		}
	}, { Layout = element })

	return React.createElement(Foundation.View, {
		tag = "col size-full bg-surface-0",
		LayoutOrder = 1
	}, {
		Content = element2
	})
end

return OutfitDetailsContent
