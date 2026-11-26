local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling
local fullView = AvatarExperienceCommon.Enums.FullView
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local trackSponsoredItemClick = AvatarExperienceCatalog.Api.trackSponsoredItemClick
local peekViewState = require("@luauforge/bundled/dCI").PeekViewState
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXBackgroundsEquipTryOnCounters = AvatarExperienceFlags.FFlagAXBackgroundsEquipTryOnCounters
local fFlagAXSpawnEffectPreview = AvatarExperienceFlags.FFlagAXSpawnEffectPreview
local module4 = require("@luauforge/bundled/dKU")
local setAnimationPreview = module4.Actions.SetAnimationPreview
local setSpawnEffectPreview = module4.Actions.SetSpawnEffectPreview
local setTryOnManagerPeekViewState = module4.Actions.SetTryOnManagerPeekViewState

local reportBackgroundUserActionCounter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").reportBackgroundUserActionCounter

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module5 = require("@luauforge/bundled/dzF")
local setCurrentToastMessage = module5.Actions.SetCurrentToastMessage
local toastType = module5.Enums.ToastType

local module6 = require("@luauforge/bundled/fDf")
local module7 = require("@luauforge/bundled/dPN")
local module8 = require("@luauforge/bundled/dVl")
local module9 = require("@luauforge/bundled/gSD")
local module10 = require("@luauforge/bundled/fDz")
local module11 = require("@luauforge/bundled/fCE")
require("@luauforge/bundled/dPs")

local v5 = {
	toastMessage = "Feature.Avatar.Label.LayeredClothingR15Warning",
	isLocalized = false,
	toastType = toastType.InformationMessage
}

local function useTryOnAssetOrBundle(data)
	local v6 = useNavigation()
	local v7 = useAvatarRoute()
	local v8 = useDispatch()
	local v9 = useRoactService(roactNetworking)
	local v10 = useRoactService(avatarExperienceAnalyticsService)
	local v11 = useRoactService(module6)
	local v12 = useAdaptiveScrolling()

	local itemId = data.itemId
	local itemType = data.itemType
	local itemData = data.itemData
	local isSelected = data.isSelected
	local fullView2 = data.fullView
	local isAvatarR6 = data.isAvatarR6
	local isItemDetailsViewStateFull = data.isItemDetailsViewStateFull
	local maybePromptForR15Upgrade = data.maybePromptForR15Upgrade

	local widgetAnalyticsInfo = data.widgetAnalyticsInfo
	local adTrackingData = data.adTrackingData
	local sendCatalogItemClickAnalytics = data.sendCatalogItemClickAnalytics

	local textButtonRef = data.textButtonRef

	return React.useCallback(function()
		if not (itemId and itemType) or maybePromptForR15Upgrade() then
			return
		end

		local itemSubType = module8.GetItemSubType(itemType, itemData)

		local v13 = isSelected

		if
			fFlagAXBackgroundsEquipTryOnCounters
			and itemSubType == module7.AssetTypeIdStrings.AvatarBackground
		then
			reportBackgroundUserActionCounter.report(v13 and "RemoveTryOn" or "TryOn")
		end

		v8(setTryOnManagerPeekViewState(peekViewState.Closed))

		v8(module10(v9, v11, itemType, itemSubType, itemId, true, v7, v6, widgetAnalyticsInfo, nil, false))

		if v12 and v13 then
			v12.setSelectedItemInstance()
		end

		if not v13 then
			if v12 then
				v12.setSelectedItemInstance(textButtonRef.current)
			end

			if isSelected then
				if fFlagAXSpawnEffectPreview and itemSubType == module7.AssetTypeIdStrings.SpawnEffect then
					v8(setSpawnEffectPreview(nil))
				end

				return
			elseif fullView2[v7.opaque.name] == fullView.UIFullView then
				v8(module9(v10, v7.opaque.name, fullView.None))
			end
		end

		if isSelected then
			if fFlagAXSpawnEffectPreview and itemSubType == module7.AssetTypeIdStrings.SpawnEffect then
				v8(setSpawnEffectPreview(nil))
			end
		else
			local assetType = itemData and itemData.assetType

			if
				isAvatarR6
				and assetType ~= module7.AssetTypeIdStrings.HairAccessory
				and module7.LayeredAssetTypes[assetType] ~= nil
			then
				v8(setCurrentToastMessage(v5))
			end

			if
				itemType == module7.ItemType.Asset
				and module7.AssetTypeIdToCategory[itemSubType] == module7.AssetCategories.Animation
			then
				v8(setAnimationPreview(itemId, assetType))
			end

			if fFlagAXSpawnEffectPreview and itemSubType == module7.AssetTypeIdStrings.SpawnEffect then
				v8(setSpawnEffectPreview(itemId))
			end

			if sendCatalogItemClickAnalytics then
				sendCatalogItemClickAnalytics()
			end

			if widgetAnalyticsInfo then
				v11.widgetInteractionV2(widgetAnalyticsInfo, widgetConstants.ActionType.ITEM_CLICK)
			end

			if adTrackingData then
				trackSponsoredItemClick(v9, adTrackingData)
			end

			if isItemDetailsViewStateFull then
				v8(module11(v6))
			end
		end
	end, {
		v8,
		itemId,
		maybePromptForR15Upgrade,
		itemData,
		v9,
		v11,
		itemType,
		v7,
		v6,
		widgetAnalyticsInfo,
		v12,
		fullView2,
		isAvatarR6,
		isItemDetailsViewStateFull,
		v10,
		adTrackingData,
		isSelected,
		sendCatalogItemClickAnalytics
	})
end

return useTryOnAssetOrBundle
