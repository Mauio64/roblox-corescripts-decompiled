local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/deferred/hcO")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

require("@luauforge/deferred/hcN")
require("@luauforge/deferred/heh")
local module4 = require("@luauforge/deferred/hej")
local BACKGROUNDS_CREATE_TILE_ID = require("@luauforge/deferred/hcL").BACKGROUNDS_CREATE_TILE_ID

local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local navigateWithLock = AvatarExperienceNavigation.Thunks.NavigateWithLock
local backgroundsPlusAnalytics = module.BackgroundsPlusAnalytics
local backgroundGenerationAnalytics = module.BackgroundGenerationAnalytics
local entrySource = backgroundsPlusAnalytics.EntrySource
local fFlagAXBackgroundGenerationAnalytics = AvatarExperienceFlags.FFlagAXBackgroundGenerationAnalytics
local fFlagAXPlusExclusiveBackgroundTryOn = AvatarExperienceFlags.FFlagAXPlusExclusiveBackgroundTryOn

local function useBackgroundsPlusInventoryLayoutViewModel(data)
	local v5 = module.useBackgroundsPlusAccess()
	local v6 = useDispatch()
	local v7 = useNavigation()
	local v8 = React.useMemo(function()
		local v9, v10 = module4(data.items)
		return { ordinaryItems = v9, robloxPlusItems = v10 }
	end, { data.items })

	local backgroundVariants = v5.backgroundVariants
	local inventoryCreateTileEnabled = backgroundVariants.inventoryCreateTileEnabled
	local showInventorySubscribeCta = backgroundVariants.showInventorySubscribeCta
	local v9, v10

	if fFlagAXBackgroundGenerationAnalytics then
		local v11 = false

		for k, robloxPlusItem in v8.robloxPlusItems do
			if robloxPlusItem.itemId == BACKGROUNDS_CREATE_TILE_ID then
				v11 = true
				break
			end
		end

		v9 = backgroundsPlusAnalytics.useUpsellImpressionTarget(
			entrySource.InventoryHeader,
			nil,
			showInventorySubscribeCta,
			true
		)
		v10 = backgroundsPlusAnalytics.useUpsellImpressionTarget(
			entrySource.InventoryCreateTile,
			nil,
			showInventorySubscribeCta and v11,
			true
		)

		local v13 = backgroundGenerationAnalytics.useCreateTileImpressionTarget(inventoryCreateTileEnabled and v11)

		if inventoryCreateTileEnabled then
			v10 = v13
		end
	else
		v9 = nil
		v10 = nil
	end

	local v11 = useLocalization({
		subscribe = module.BackgroundsPlusLocalizationKeys.Subscribe,
		exclusiveWithPlus = module.BackgroundsPlusLocalizationKeys.ExclusiveWithPlus,
		upsellMessage = module.BackgroundsPlusLocalizationKeys.UnlockExclusiveBackgroundsWithPlus
	})

	local openUpsellSubscriptionPurchase = if fFlagAXBackgroundGenerationAnalytics then v5.openUpsellSubscriptionPurchase else nil

	local v12 = React.useCallback(function(p2, p3, p4)
		if fFlagAXBackgroundGenerationAnalytics then
			if openUpsellSubscriptionPurchase then
				openUpsellSubscriptionPurchase(entrySource.InventoryHeader, nil)
			end
		elseif fFlagAXPlusExclusiveBackgroundTryOn then
			v5.openSubscriptionPurchase(p3, p4)
		else
			v5.openSubscriptionPurchase()
		end
	end, { openUpsellSubscriptionPurchase, v5.openSubscriptionPurchase })

	local v13 = React.useCallback(function()
		if fFlagAXBackgroundGenerationAnalytics then
			if openUpsellSubscriptionPurchase then
				openUpsellSubscriptionPurchase(entrySource.InventoryCreateTile, nil)
			end
		else
			v5.openSubscriptionPurchase()
		end
	end, { openUpsellSubscriptionPurchase, v5.openSubscriptionPurchase })
	local v14 = React.useCallback(function(p2, p3, p4)
		if fFlagAXBackgroundGenerationAnalytics and openUpsellSubscriptionPurchase then
			if fFlagAXPlusExclusiveBackgroundTryOn then
				openUpsellSubscriptionPurchase(entrySource.InventoryExclusiveTile, p2, p3, p4)
			else
				openUpsellSubscriptionPurchase(entrySource.InventoryExclusiveTile, p2)
			end
		end
	end, { openUpsellSubscriptionPurchase })

	local v15 = React.useCallback(function(p2, p3, p4)
		if fFlagAXBackgroundGenerationAnalytics then
			backgroundsPlusAnalytics.sendExclusiveTileInteraction(p2, p3 and "selected" or "deselected", p4)
		end
	end, {})

	local v16 = React.useCallback(function()
		if fFlagAXBackgroundGenerationAnalytics then
			backgroundGenerationAnalytics.sendCreateTileClick()
		end

		v6(navigateWithLock(function()
			v7.navigate(avatarScreen.BackgroundGeneration)
		end))
	end, { v6, v7 })

	local useMemo = React.useMemo
	local function fn()
		local v17 = {
			ordinaryItems = v8.ordinaryItems,
			robloxPlusItems = v8.robloxPlusItems,
			containerRef = data.containerRef,
			gridConfig = data.gridConfig,
			showSubscribeCta = showInventorySubscribeCta,
			createTileEnabled = inventoryCreateTileEnabled,
			hasActiveSubscription = 0,
			headerImpressionRef = 0,
			createTileImpressionRef = 0,
			subscribeText = 0,
			exclusiveWithPlusText = 0,
			upsellMessageText = 0,
			onSubscribeActivated = 0,
			onCreateTileActivated = 0,
			onPlusExclusiveActivated = 0,
			onPlusExclusiveAnalyticsActivated = 0,
			onPlusExclusiveSelectionChanged = 0
		}

		local v18 = if fFlagAXBackgroundGenerationAnalytics then v5.hasActiveSubscription else nil
		v17.hasActiveSubscription = v18

		v17.headerImpressionRef = if fFlagAXBackgroundGenerationAnalytics then v9 else nil
		v17.createTileImpressionRef = if fFlagAXBackgroundGenerationAnalytics then v10 else nil
		v17.subscribeText = v11.subscribe
		v17.exclusiveWithPlusText = v11.exclusiveWithPlus
		v17.upsellMessageText = v11.upsellMessage
		v17.onSubscribeActivated = v12
		local v21

		if inventoryCreateTileEnabled then
			v21 = v16
		else
			v21 = if fFlagAXBackgroundGenerationAnalytics then v13 else v12
		end

		v17.onCreateTileActivated = v21

		local v22 = if not (fFlagAXBackgroundGenerationAnalytics or v5.hasActiveSubscription) then v12 else nil
		v17.onPlusExclusiveActivated = v22

		v17.onPlusExclusiveAnalyticsActivated = if fFlagAXBackgroundGenerationAnalytics then v14 else nil

		v17.onPlusExclusiveSelectionChanged = if fFlagAXBackgroundGenerationAnalytics then v15 else nil
		return v17
	end

	local containerRef = data.containerRef
	local gridConfig = data.gridConfig
	local hasActiveSubscription = v5.hasActiveSubscription
	local v18 = if fFlagAXBackgroundGenerationAnalytics then v9 else nil
	local v19 = if fFlagAXBackgroundGenerationAnalytics then v10 else nil
	local subscribe = v11.subscribe
	local exclusiveWithPlus = v11.exclusiveWithPlus
	local upsellMessage = v11.upsellMessage
	local v20 = if fFlagAXBackgroundGenerationAnalytics then v13 else nil
	local v21 = if fFlagAXBackgroundGenerationAnalytics then v14 else nil
	return useMemo(fn, {
		showInventorySubscribeCta,
		inventoryCreateTileEnabled,
		v8,
		containerRef,
		gridConfig,
		hasActiveSubscription,
		v18,
		v19,
		subscribe,
		exclusiveWithPlus,
		upsellMessage,
		v12,
		v20,
		v21,
		if fFlagAXBackgroundGenerationAnalytics then v15 else nil,
		v16
	})
end

return useBackgroundsPlusInventoryLayoutViewModel
