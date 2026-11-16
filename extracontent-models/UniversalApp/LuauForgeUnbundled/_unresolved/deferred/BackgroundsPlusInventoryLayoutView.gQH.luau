local CorePackages = game:GetService("CorePackages")

local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local module = require("@luauforge/deferred/gQI")

local fFlagAXBackgroundGenerationAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXBackgroundGenerationAnalytics

local fFlagAXBackgroundGenerationCreateTileTooltip = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXBackgroundGenerationCreateTileTooltip

local fFlagAXBackgroundGenerationInventoryUpsellBanner = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXBackgroundGenerationInventoryUpsellBanner

local BACKGROUNDS_CREATE_TILE_ID = require("@luauforge/deferred/gQF").BACKGROUNDS_CREATE_TILE_ID
local module2 = require("@luauforge/deferred/gQE")
require("@luauforge/deferred/gRV")

local function BackgroundsPlusInventoryLayoutView(props)
	local gridConfig = props.gridConfig
	local showSubscribeCta = not fFlagAXBackgroundGenerationInventoryUpsellBanner and props.showSubscribeCta
	local showSubscribeCta2 = fFlagAXBackgroundGenerationInventoryUpsellBanner and props.showSubscribeCta
	local v5

	if fFlagAXBackgroundGenerationAnalytics then
		v5 = React.useMemo(function()
			return {
				isPlusExclusive = true,
				hasActiveSubscription = props.hasActiveSubscription,
				onActivated = props.onPlusExclusiveAnalyticsActivated,
				onSelectionChanged = props.onPlusExclusiveSelectionChanged
			}
		end, {
			props.hasActiveSubscription,
			props.onPlusExclusiveAnalyticsActivated,
			props.onPlusExclusiveSelectionChanged
		})
	else
		v5 = nil
	end

	local function renderOrdinaryItem(p2)
		return gridConfig.renderItem(p2)
	end

	local function renderPlusItem(p2)
		if p2.item.itemId == BACKGROUNDS_CREATE_TILE_ID then
			if fFlagAXBackgroundGenerationCreateTileTooltip then
				local createElement = React.createElement
				local plusCreateTileContainer = module.PlusCreateTileContainer
				local v6 = {
					LayoutOrder = p2.index,
					isDisabled = not props.createTileEnabled,
					onActivated = props.onCreateTileActivated,
					impressionRef = 0
				}
				local v7 = if fFlagAXBackgroundGenerationAnalytics then props.createTileImpressionRef else nil
				v6.impressionRef = v7
				return createElement(plusCreateTileContainer, v6)
			else
				local createElement = React.createElement
				local plusCreateTile = module.PlusCreateTile
				local v6 = {
					LayoutOrder = p2.index,
					isDisabled = not props.createTileEnabled,
					onActivated = props.onCreateTileActivated,
					impressionRef = 0
				}
				local v7 = if fFlagAXBackgroundGenerationAnalytics then props.createTileImpressionRef else nil
				v6.impressionRef = v7
				return createElement(plusCreateTile, v6)
			end
		elseif fFlagAXBackgroundGenerationAnalytics then
			return gridConfig.renderItem(p2, { plus = v5 })
		else
			return gridConfig.renderItem(p2, {
				onPlusExclusiveActivated = props.onPlusExclusiveActivated
			})
		end
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v6 = {
		tag = "col gap-medium size-full-0 auto-y",
		LayoutOrder = 1,
		ref = props.containerRef
	}
	local children = {
		ItemsGrid = #props.ordinaryItems > 0 and React.createElement(
			Foundation.View,
			{ tag = "size-full-0 auto-y", LayoutOrder = 1 },
			{
				Grid = React.createElement(module2, {
					items = props.ordinaryItems,
					itemsPerRow = gridConfig.itemsPerRow,
					itemsGap = gridConfig.itemsGap,
					renderItem = renderOrdinaryItem,
					getItemHeight = gridConfig.getItemHeight,
					screenHeight = gridConfig.screenHeight,
					totalNumItems = #props.ordinaryItems
				})
			}
		),
		RobloxPlusHeader = 0,
		RobloxPlusUpsellBanner = 0,
		RobloxPlusGrid = 0
	}

	local createElement2 = React.createElement
	local backgroundsPlusSectionHeader = module.BackgroundsPlusSectionHeader
	local v8 = {
		title = props.exclusiveWithPlusText,
		actionText = 0,
		onActionActivated = 0,
		LayoutOrder = 2,
		impressionRef = 0
	}
	local v9 = if showSubscribeCta then props.subscribeText else nil
	v8.actionText = v9
	local v10 = if showSubscribeCta then props.onSubscribeActivated else nil
	v8.onActionActivated = v10

	local v11 = if fFlagAXBackgroundGenerationAnalytics and not fFlagAXBackgroundGenerationInventoryUpsellBanner then props.headerImpressionRef else nil
	v8.impressionRef = v11
	children.RobloxPlusHeader = createElement2(backgroundsPlusSectionHeader, v8)
	local v12

	if showSubscribeCta2 then
		local createElement3 = React.createElement
		local view2 = Foundation.View

		local v14 = if fFlagAXBackgroundGenerationAnalytics then props.headerImpressionRef else nil
		v12 = createElement3(view2, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 3,
			ref = v14
		}, {
			Banner = React.createElement(module.BackgroundsPlusSubscribeBanner, {
				message = props.upsellMessageText,
				actionText = props.subscribeText,
				onActivated = props.onSubscribeActivated,
				showPlusIcon = false
			})
		})
	else
		v12 = showSubscribeCta2
	end

	children.RobloxPlusUpsellBanner = v12

	children.RobloxPlusGrid = React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = showSubscribeCta2 and 4 or 3
	}, {
		Grid = React.createElement(module2, {
			items = props.robloxPlusItems,
			itemsPerRow = gridConfig.itemsPerRow,
			itemsGap = gridConfig.itemsGap,
			renderItem = renderPlusItem,
			getItemHeight = gridConfig.getItemHeight,
			screenHeight = gridConfig.screenHeight,
			totalNumItems = #props.robloxPlusItems
		})
	})
	return createElement(view, v6, children)
end

return BackgroundsPlusInventoryLayoutView
