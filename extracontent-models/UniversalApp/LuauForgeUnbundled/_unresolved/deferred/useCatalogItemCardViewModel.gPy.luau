local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local itemTileEnums = UIBlox.Tile.ItemTileEnums
local tutils = require(CorePackages.Packages.tutils)
local Cryo = require(CorePackages.Packages.Cryo)

local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module2 = require("@luauforge/bundled/dMd")
local getZoomedSizeAndOffset = AvatarExperienceCommon.Utils.getZoomedSizeAndOffset
local getThumbSizeVectorFromParamString = AvatarExperienceCommon.Utils.getThumbSizeVectorFromParamString
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local useMultiItemShoppingFtux = AvatarExperienceCatalog.Hooks.useMultiItemShoppingFtux
local useMakeupFtux = AvatarExperienceCatalog.Hooks.useMakeupFtux
local getFaeFeatureAccessStore = AvatarExperienceCatalog.Stores.GetFaeFeatureAccessStore
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local peekViewState = require("@luauforge/bundled/dzD").PeekViewState
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local useLastInput = Responsive.useLastInput
local useIsSpatial = Responsive.useIsSpatial
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local unifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local unifiedEventLoggingUtils = AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils
local getTimedOptionForItemData = AvatarExperienceAnalytics.Utils.getTimedOptionForItemData
local getUnifiedLoggingSurface = AvatarExperienceAnalytics.Utils.getUnifiedLoggingSurface
local mapAnalyticsMetadataFields = AvatarExperienceAnalytics.Utils.mapAnalyticsMetadataFields
local avatarExperienceAnalyticsService = AvatarExperienceAnalytics.AvatarExperienceAnalyticsService
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local module10 = require("@luauforge/bundled/dHL")
local addAnalyticsMetadata = module10.Actions.AddAnalyticsMetadata
local removeLookFromTryOn = module10.Actions.RemoveLookFromTryOn
local setAnimationPreview = module10.Actions.SetAnimationPreview
local setTryOnManagerPeekViewState = module10.Actions.SetTryOnManagerPeekViewState
local setLastToggledLookType = module10.Actions.SetLastToggledLookType
local module11 = require("@luauforge/bundled/dwC")
local setCurrentToastMessage = module11.Actions.SetCurrentToastMessage
local toastType = module11.Enums.ToastType
require("@luauforge/bundled/dHK")
local module12 = require("@luauforge/bundled/dMx")
local module13 = require("@luauforge/bundled/dRQ")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local trackSponsoredItemClick = AvatarExperienceCatalog.Api.trackSponsoredItemClick
local impressionsUtil = AvatarExperienceAnalytics.ImpressionsReporter.ImpressionsUtil
local organicEventImpressionsSchema = AvatarExperienceAnalytics.ImpressionsReporter.OrganicEventImpressionsSchema
local fullView = AvatarExperienceCommon.Enums.FullView
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local selectEquippedLayeredMakeupAssets = AvatarExperienceCommon.State.Selectors.selectEquippedLayeredMakeupAssets
local selectEquippedAssets = AvatarExperienceCommon.State.Selectors.selectEquippedAssets
local getEquippedLayeredMakeupAssets = AvatarExperienceCommon.Utils.getEquippedLayeredMakeupAssets
local module14 = require("@luauforge/bundled/fvF")
require("@luauforge/bundled/dMc")
local module15 = require("@luauforge/deferred/gkQ")
local module16 = require("@luauforge/deferred/gkR")
local module17 = require("@luauforge/deferred/ggD")
local module18 = require("@luauforge/bundled/fvZ")
local module19 = require("@luauforge/bundled/fvd")
local module20 = require("@luauforge/bundled/gnZ")
local logOnOverlayClosed = AvatarExperienceNavigation.Debug.logOnOverlayClosed
local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling
local module21 = require("@luauforge/deferred/gPz")
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local itemTypeEnum = module2.Enums.ItemTypeEnum

local catalogItemCardStatusIconTypeEnum = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCardStatusIconTypeEnum
local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local MAX_MAKEUP_LAYERS = AvatarExperienceCommon.Constants.MAX_MAKEUP_LAYERS
local module22 = require("@luauforge/deferred/goJ")
local module23 = require("@luauforge/deferred/gPA")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local sendUnifiedEventForDeferredAction = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendUnifiedEventForDeferredAction
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

require("@luauforge/deferred/gPB")
local module24 = require("@luauforge/deferred/gPE")
local module25 = require("@luauforge/deferred/gPF")
local module26 = require("@luauforge/deferred/gPG")
local module27 = require("@luauforge/deferred/gPH")
local module28 = require("@luauforge/deferred/gPI")
local module29 = require("@luauforge/deferred/gPJ")

local fFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads
local fFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local fFlagAXMemoizeEquippedLayeredMakeupAssets = AvatarExperienceFlags.FFlagAXMemoizeEquippedLayeredMakeupAssets
local module30 = require("@luauforge/bundled/dPG")
local fFlagAXDurablesFooter = AvatarExperienceFlags.FFlagAXDurablesFooter
local defineFastFlag = game:DefineFastFlag("AXDurablesFooterWithPermanent", false)
local fFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local fFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell
local fFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local fFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail
local fFlagAXSponsoredItemsWidgetUnifiedLogging = AvatarExperienceFlags.FFlagAXSponsoredItemsWidgetUnifiedLogging

local fFlagAXEditorRecommendedItemsUnifiedImpressions = AvatarExperienceFlags.FFlagAXEditorRecommendedItemsUnifiedImpressions
local fFlagAXFixCatalogTileThumbnailFlash = AvatarExperienceFlags.FFlagAXFixCatalogTileThumbnailFlash
local fFlagAXRecommendedItemsUnifiedSelectParity = AvatarExperienceFlags.FFlagAXRecommendedItemsUnifiedSelectParity
local fFlagAXMarketplaceLicensingItemCards = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemCards

local unifiedLoggingSurface = if fFlagAXUnifiedImpressionsOnThumbnail then AvatarExperienceNavigation.Enums.UnifiedLoggingSurface else nil
local selectSearchKeyword

if fFlagAXUnifiedImpressionsOnThumbnail then
	selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword
else
	selectSearchKeyword = nil
end

local fFlagAXFixClickItemDetailsSurfaceLogging = SharedFlags.FFlagAXFixClickItemDetailsSurfaceLogging

local LOOKS_IMAGE_OFFSET_MULTIPLIERS = AvatarExperienceCatalog.Constants.LOOKS_IMAGE_OFFSET_MULTIPLIERS
local LOOKS_IMAGE_ZOOM = AvatarExperienceCatalog.Constants.LOOKS_IMAGE_ZOOM

local v5 = {
	toastMessage = "Feature.Avatar.Label.LayeredClothingR15Warning",
	isLocalized = false,
	toastType = toastType.InformationMessage
}

local function isBodyBundle(p2): boolean
	if p2 then
		return p2.bundleType == module12.BundleTypeIdStrings.BodyParts
	end

	return false
end

local function getItemTypeFromItemData(p2): nil | string
	local tileRestrictionsMap = if p2 then p2.tileRestrictionsMap else nil

	if not tileRestrictionsMap then
		return nil
	end

	if tileRestrictionsMap[itemTileEnums.Restriction.Limited] then
		return "Limited"
	end

	if
		tileRestrictionsMap[itemTileEnums.Restriction.LimitedUnique]
		or tileRestrictionsMap[itemTileEnums.Restriction.Collectible]
	then
		return "Collectible"
	end

	return nil
end

local function getItemInfoFromItemData(p2): nil | string
	if p2 and p2.bundleType == module12.BundleTypeIdStrings.DynamicHead then
		return "DynamicHead"
	end

	return nil
end

local function getTimedOptionDays(timedOptions)
	for k, item in timedOptions do
		if defineFastFlag then
			if item.selected then
				return item.days
			end
		elseif item.selected and item.days > 0 then
			return item.days
		end
	end

	if defineFastFlag then
		return 0
	end

	return nil
end

local function getCreatorFromItemData(p2)
	local name = p2 and p2.creator and (p2.creator.name or p2.creatorName)

	if name then
		return { name = name, verified = p2.creator.hasVerifiedBadge }
	end

	return nil
end

local function getCreatorFromLookData(p2)
	if not (p2 and p2.curator and p2.curator.name) then
		return nil
	end

	local v6 = { name = p2.curator.name, verified = 0 }
	local v7 = if p2 and p2.curator then p2.curator.hasVerifiedBadge else nil
	v6.verified = v7
	return v6
end

local function getLookStatusFromModerationStatus(moderationStatus)
	if moderationStatus == module12.ModerationStatus.PendingModeration then
		return { type = "icon", iconType = "PendingModeration" }
	end

	if moderationStatus == module12.ModerationStatus.Moderated then
		return { type = "icon", iconType = "Moderated" }
	end

	return nil
end

local function isValidItemId(p2): boolean
	return p2 ~= nil and p2 ~= "0"
end

local function isValidThumbnailSize(p2, p3): boolean
	if p3 ~= nil then
		for k, v6 in module12.CatalogThumbnailTypeToSize[p3] do
			if v6 == p2 then
				return true
			end
		end
	end

	return false
end

local fn = fFlagAXMISEnableMultiShopping and function(items)
	local result = {}

	for k, item in items do
		if
			item.selectedInTryOnManager
			and item.itemType
			and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[item.itemSubType]
		then
			table.insert(result, item)
		end
	end

	return result
end or nil

local function cardIsSelectedInTryOnOutfit(p2, p3, p4)
	if
		p3 and p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId == p3
		or fFlagAXCatalogMakeupSupport
		and fFlagAXMISEnableMultiShopping
		and p3
		and p2.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookId == p3
	then
		return true
	end

	local tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local v6 = p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId == nil

	if not (p3 and p4) then
		return false
	end

	local tryOnItemReducerKey = getTryOnItemReducerKey(p3, p4)

	if fFlagAXMISEnableMultiShopping then
		return tryOnItems[tryOnItemReducerKey] ~= nil
	end

	if tryOnItems[tryOnItemReducerKey] == nil then
		v6 = false
	end

	return v6
end

local function selectCatalogItemCardState(p2, itemId, itemType)
	local v6 = cardIsSelectedInTryOnOutfit(p2, itemId, itemType)
	local lastToggledItem = p2.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem

	local v7 = itemData(p2.AvatarExperience.Common, itemId, itemType)
	local v8

	if v7 then
		local v9
		v9, v8 = module13.GetStatus(v7)
	end

	local selectedCategoryInfo = module30.getCatalogSelectionStore().selectedCategoryInfo(false)

	local v9 = v6 and v7 and v7.bundleType == module12.BundleTypeIdStrings.Animations
	local pageType = selectedCategoryInfo.PageType

	local v10 = v9
		and (lastToggledItem and lastToggledItem.itemId == itemId and true or pageType == module12.PageType.Animation or pageType == module12.PageType.AllAnimation)

	local viewState = p2.AvatarExperience.Common.ItemDetailsPeekView.viewState

	return {
		itemData = v7,
		isSelected = v6,
		statusText = v8,
		avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType,
		isAvatarR6 = p2.AvatarExperience.AvatarEditor.Character.AvatarType == module12.AvatarType.R6,
		fullView = module21(p2),
		showAnimationTabs = v10,
		isItemDetailsViewStateFull = viewState == peekViewState.Full
	}
end

local function fn2(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end

local function selectAnalyticsMetadata(p2)
	return p2.AvatarExperience.AnalyticsMetadata
end

local function showDurableBadge(itemData2)
	if fFlagAXDurablesFooter or not (itemData2 and itemData2.timedOptions) then
		return nil
	end

	for k, timedOption in itemData2.timedOptions do
		if timedOption.selected then
			return {
				type = "badge",
				iconType = catalogItemCardStatusIconTypeEnum.Durable,
				text = not (timedOption.days > 0) and "" or tostring(timedOption.days)
			}
		end
	end

	return {
		type = "badge",
		iconType = catalogItemCardStatusIconTypeEnum.Durable,
		text = ""
	}
end

local function useCatalogItemCardViewModel(data)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v6 = useLastInput()
	local v7 = useIsSpatial()
	local v8 = v6 == Responsive.Input.Directional and not v7
	local v9 = useAdaptiveScrolling()
	local v10 = useRoactService(roactNetworking)
	local v11 = useRoactService(avatarExperienceAnalyticsService)
	local v12 = useRoactService(module14)
	local v13 = if fFlagAXMISEnableMultiShopping then useMultiItemShoppingFtux() else nil
	local v14 = if fFlagAXCatalogMakeupSupport then useMakeupFtux() else nil
	local v15 = useNavigation()
	local v16 = useAvatarRoute()
	local v17 = useDispatch()
	local itemId = data.itemId
	local itemType = data.itemType
	local lookData = data.lookData
	local name = v16 and v16.opaque and v16.opaque.name

	local v18 = useSelector(React.useCallback(function(p2)
		return selectCatalogItemCardState(p2, itemId, itemType)
	end, { itemId, itemType }), tutils.shallowEqual)

	local v19 = if fFlagAXUnifiedImpressionsOnThumbnail then useSelector(selectAnalyticsMetadata) else nil

	local v20 = if fFlagAXUnifiedImpressionsOnThumbnail then useSelector(selectSearchKeyword) else nil
	local v21

	if fFlagAXMISEnableMultiShopping or fFlagAXCatalogMakeupSupport then
		v21 = useSelector(fn2)
	else
		v21 = nil
	end

	local v22

	if fFlagAXCatalogMakeupSupport then
		if fFlagAXMemoizeEquippedLayeredMakeupAssets then
			v22 = useSelector(selectEquippedAssets)
		else
			v22 = useSelector(selectEquippedLayeredMakeupAssets)
		end
	else
		v22 = nil
	end

	local v23

	if fFlagAXCatalogMakeupSupport and fFlagAXMemoizeEquippedLayeredMakeupAssets then
		v23 = React.useMemo(function()
			return getEquippedLayeredMakeupAssets(v22)
		end, { v22 })
	else
		v23 = v22
	end

	local v24 = lookData and lookData.assets and #lookData.assets or 0
	local v25 = lookData and lookData.bundles and #lookData.bundles or 0
	local v26

	if fFlagAXDurablesFooter and v18 and v18.itemData and v18.itemData.timedOptions then
		v26 = getTimedOptionDays(v18.itemData.timedOptions)
	else
		v26 = nil
	end

	local v27 = useLocalization({
		statusText = v18.statusText,
		details = "Feature.Avatar.Label.DetailsButton",
		detailsWithItemsCount = {
			"Feature.Avatar.Label.Details",
			quantity = v24 + v25
		},
		timedOptionDays = fFlagAXDurablesFooter and v26 and v26 > 0 and {
			"Feature.Durables.TimeRemaining.Days",
			number = v26
		} or nil
	})

	local isSelected = v18.isSelected
	local itemData2 = v18.itemData

	local v28 = if itemType then module13.GetRbxThumbType(itemType) else nil

	local v29 = module12.CatalogThumbnailTypeToSize.Asset._150x150

	if data.thumbnailSize then
		local thumbnailSize = data.thumbnailSize
		local flag

		if v28 == nil then
			flag = false
		else
			local flag2 = true

			for k, v30 in module12.CatalogThumbnailTypeToSize[v28] do
				if v30 == thumbnailSize then
					flag = true
					flag2 = false
					break
				end
			end

			if flag2 then
				flag = false
			end
		end

		if flag then
			v29 = data.thumbnailSize
		end
	end

	local thumbSizeVectorFromParamString = getThumbSizeVectorFromParamString(v29)
	local v30

	if itemData2 then
		v30 = itemData2.bundleType == module12.BundleTypeIdStrings.BodyParts
	else
		v30 = false
	end

	local v31

	if v30 and thumbSizeVectorFromParamString then
		v31 = getZoomedSizeAndOffset(
			thumbSizeVectorFromParamString,
			LOOKS_IMAGE_ZOOM,
			LOOKS_IMAGE_OFFSET_MULTIPLIERS
		)
	end

	local v32 = not (itemId == nil) and itemId ~= "0"

	local v33 = if v32 then `rbxthumb://type={v28}&id={itemId}&{v29}` else nil

	local useCallback = React.useCallback
	local function fn3(showFullWithNoPeekView)
		if itemId and itemType then
			if fFlagAXMISEnableMultiShoppingUnifiedEvents then
				local v34 = nil

				if itemType == "Asset" then
					v34 = unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
				elseif itemType == "Bundle" then
					v34 = unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
				elseif itemType == "Look" then
					v34 = unifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK
				end

				if fFlagAXUnifiedImpressionsOnThumbnail then
					local v35 = if fFlagAXFixClickItemDetailsSurfaceLogging then getUnifiedLoggingSurface(v16) else nil

					local joined = {
						action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
						elementName = "CLICK_ITEM_DETAILS",
						itemId = itemId,
						itemType = v34,
						surface = v35
					}

					if v19 then
						if fFlagAXUnifiedEventStrictPayloads then
							joined = Cryo.Dictionary.join(mapAnalyticsMetadataFields(v19), joined)
						end

						joined = Cryo.Dictionary.join(v19, joined)
					end

					local v36

					if data.impressionsSearch == nil or data.impressionsSearch == "" then
						if not (v20 == nil or v20 == "") then
							v36 = v20
						end
					else
						v36 = data.impressionsSearch
					end

					if
						unifiedLoggingSurface
						and v35 == unifiedLoggingSurface.SEARCH_RESULTS
						and v36 ~= nil
					then
						joined.keyword = v36
					end

					sendUnifiedEventForDeferredAction(joined)
				else
					local v36 = {
						action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
						elementName = "CLICK_ITEM_DETAILS",
						itemId = itemId,
						itemType = v34,
						surface = 0
					}

					local v37 = if fFlagAXFixClickItemDetailsSurfaceLogging then getUnifiedLoggingSurface(v16) else nil
					v36.surface = v37
					sendUnifiedEventForDeferredAction(v36)
				end
			elseif fFlagAXUnifiedImpressionsOnThumbnail then
				local v34 = if fFlagAXFixClickItemDetailsSurfaceLogging then getUnifiedLoggingSurface(v16) else nil

				local joined = {
					action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
					elementName = "CLICK_ITEM_DETAILS",
					surface = v34
				}

				if v19 then
					if fFlagAXUnifiedEventStrictPayloads then
						joined = Cryo.Dictionary.join(mapAnalyticsMetadataFields(v19), joined)
					end

					joined = Cryo.Dictionary.join(v19, joined)
				end

				local v35

				if data.impressionsSearch == nil or data.impressionsSearch == "" then
					if not (v20 == nil or v20 == "") then
						v35 = v20
					end
				else
					v35 = data.impressionsSearch
				end

				if unifiedLoggingSurface and v34 == unifiedLoggingSurface.SEARCH_RESULTS and v35 ~= nil then
					joined.keyword = v35
				end

				sendUnifiedEventForDeferredAction(joined)
			else
				local v35 = {
					action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
					elementName = "CLICK_ITEM_DETAILS",
					surface = 0
				}

				local v36 = if fFlagAXFixClickItemDetailsSurfaceLogging then getUnifiedLoggingSurface(v16) else nil
				v35.surface = v36
				sendUnifiedEventForDeferredAction(v35)
			end

			if itemType == itemTypeEnum.Look then
				v17(module23({
					lookId = lookData and lookData.id,
					valueInRobux = lookData and lookData.totalValue,
					catalogAnalytics = v12,
					avatarRoute = v16
				}))

				if fFlagAXMISEnableMultiShopping and name ~= avatarScreen.MySharedAvatars then
					if lookData then
						v17(setLastToggledLookType({
							lastToggledLookType = lookData.lookType
						}))
					end

					v17(navigateWithLock(function()
						v15.navigate(avatarScreen.LookDetails)
					end))
				end
			else
				local v36 = {
					itemId = itemId,
					itemType = itemType,
					itemSubType = module13.GetItemSubType(itemType, itemData2),
					priceInRobux = 0,
					catalogAnalytics = 0,
					avatarRoute = 0,
					navigation = 0,
					itemDetailsPeekViewRefs = 0,
					resultsListRef = 0,
					widgetInfo = 0,
					showFullWithNoPeekView = 0
				}
				local v37 = if itemData2 then itemData2.priceInRobux else nil
				v36.priceInRobux = v37
				v36.catalogAnalytics = v12
				v36.avatarRoute = v16
				v36.navigation = v15
				v36.itemDetailsPeekViewRefs = data.itemDetailsPeekViewRefs
				v36.resultsListRef = data.resultsListRef
				v36.widgetInfo = data.widgetAnalyticsInfo
				v36.showFullWithNoPeekView = showFullWithNoPeekView
				v17(module17(v36))
			end
		end
	end

	local itemDetailsPeekViewRefs = data.itemDetailsPeekViewRefs
	local resultsListRef = data.resultsListRef
	local widgetAnalyticsInfo = data.widgetAnalyticsInfo
	local v35 = if fFlagAXUnifiedImpressionsOnThumbnail then v19 else nil
	local v36 = if fFlagAXUnifiedImpressionsOnThumbnail then v20 else nil
	local v37 = if fFlagAXUnifiedImpressionsOnThumbnail then data.impressionsSearch else nil
	local v38 = useCallback(fn3, {
		v17,
		itemId,
		itemType,
		v12,
		v16,
		v15,
		itemDetailsPeekViewRefs,
		resultsListRef,
		widgetAnalyticsInfo,
		lookData,
		name,
		v35,
		v36,
		v37
	})

	local v39 = React.useCallback(function()
		v38(true)
	end, { v38 })

	local v40 = React.useCallback(function()
		local function onR15PromptWillClose()
			logOnOverlayClosed("CatalogItemCard", v8)

			if itemId then
				v38()
			end
		end

		return v17(module16(v15, itemId, itemType, onR15PromptWillClose, nil, true))
	end, { itemId, v38, v17, v15, itemId, itemType })

	local v41 = React.useCallback(function(p2)
		if not (itemId and itemType) then
			return
		end

		if itemType == itemTypeEnum.Look then
			if isSelected then
				if v9 then
					v9.setSelectedItemInstance(nil)
				end

				if fFlagAXMISEnableMultiShopping then
					v17(removeLookFromTryOn(itemId))
				end

				v17(setTryOnManagerPeekViewState(peekViewState.Closed))
			else
				if v9 then
					local current = if ref then ref.current else nil

					if current ~= nil then
						v9.setSelectedItemInstance(current)
					end
				end

				if name ~= nil then
					v17(module20(v12, name, fullView.None))
				end

				local v42 = fFlagAXMISEnableMultiShopping and name ~= avatarScreen.MySharedAvatars and 1
					or 2

				local widgetAnalyticsInfo2 = data.widgetAnalyticsInfo

				local v48 = if fFlagAXMISEnableMultiShopping then peekViewState.SuperBrief else nil
				v17(module22(v10, v15, widgetAnalyticsInfo2, itemId, v48, v42))
			end

			if data.isOrganic then
				if not isSelected then
					local analyticsContext = data.analyticsContext
					local analyticsItemCountPerPage = data.analyticsItemCountPerPage
					local index = data.index
					v17(addAnalyticsMetadata({ selectedItemIndex = index }))

					v17(module15(
						analyticsContext,
						v12.clickCatalogItem,
						itemId,
						itemType,
						index,
						analyticsItemCountPerPage,
						false
					))
				end
			else
				local widgetInteractionV2 = v12.widgetInteractionV2
				local widgetAnalyticsInfo2 = data.widgetAnalyticsInfo

				local v42 = if isSelected then widgetConstants.ActionType.ITEM_DESELECTED else widgetConstants.ActionType.ITEM_CLICK
				widgetInteractionV2(widgetAnalyticsInfo2, v42)
			end
		else
			if v40() then
				return
			end

			local itemSubType = module13.GetItemSubType(itemType, itemData2)

			local v42 = isSelected

			if fFlagAXMISEnableMultiShopping then
				v17(setTryOnManagerPeekViewState(peekViewState.Closed))
			end

			local widgetAnalyticsInfo2 = data.widgetAnalyticsInfo

			if not fFlagAXMISEnableMultiShopping then
				p2 = nil
			end

			v17(module18(
				v10,
				v12,
				itemType,
				itemSubType,
				itemId,
				true,
				v16,
				v15,
				widgetAnalyticsInfo2,
				nil,
				p2
			))

			if not fFlagAXMISEnableMultiShopping and v9 then
				v17(setTryOnManagerPeekViewState(peekViewState.Closed))
			end

			if v9 and v42 then
				v9.setSelectedItemInstance()
			end

			if not v42 then
				if v9 then
					v9.setSelectedItemInstance(ref.current)
				end

				if isSelected then
					return
				end

				if v18.fullView[v16.opaque.name] == fullView.UIFullView then
					v17(module20(v11, v16.opaque.name, fullView.None))
				end
			end

			if isSelected then
				return
			end

			local assetType = itemData2 and itemData2.assetType

			if
				v18.isAvatarR6
				and assetType ~= module12.AssetTypeIdStrings.HairAccessory
				and module12.LayeredAssetTypes[assetType] ~= nil
			then
				v17(setCurrentToastMessage(v5))
			end

			if
				itemType == module12.ItemType.Asset
				and module12.AssetTypeIdToCategory[itemSubType] == module12.AssetCategories.Animation
			then
				v17(setAnimationPreview(itemId, assetType))
			end

			local analyticsContext = data.analyticsContext
			local analyticsItemCountPerPage = data.analyticsItemCountPerPage
			local index = data.index
			local adTrackingData = data.adTrackingData
			v17(addAnalyticsMetadata({ selectedItemIndex = index }))

			v17(module15(
				analyticsContext,
				v12.clickCatalogItem,
				itemId,
				itemType,
				index,
				analyticsItemCountPerPage,
				false
			))

			if data.widgetAnalyticsInfo then
				local widgetAnalyticsInfo3 = data.widgetAnalyticsInfo
				v12.widgetInteractionV2(widgetAnalyticsInfo3, widgetConstants.ActionType.ITEM_CLICK)
			end

			if adTrackingData then
				trackSponsoredItemClick(v10, adTrackingData)
			end

			if v18.isItemDetailsViewStateFull then
				v17(module19(v15))
			end
		end
	end, {
		v17,
		itemId,
		v40,
		itemData2,
		v10,
		v12,
		itemType,
		v16,
		v15,
		data.widgetAnalyticsInfo,
		v9,
		v18.fullView,
		v18.isAvatarR6,
		v18.isItemDetailsViewStateFull,
		v11,
		v16.opaque.name,
		data.analyticsContext,
		data.analyticsItemCountPerPage,
		data.index,
		data.adTrackingData,
		isSelected,
		name
	})

	local v42 = module28({
		analyticsContext = data.analyticsContext,
		itemId = itemId,
		itemType = itemType,
		index = data.index,
		analyticsItemCountPerPage = data.analyticsItemCountPerPage
	})

	local v43 = module27({
		itemId = itemId,
		itemType = itemType,
		itemData = itemData2,
		isSelected = isSelected,
		textButtonRef = ref,
		fullView = v18.fullView,
		isAvatarR6 = v18.isAvatarR6,
		isItemDetailsViewStateFull = v18.isItemDetailsViewStateFull,
		maybePromptForR15Upgrade = v40,
		widgetAnalyticsInfo = data.widgetAnalyticsInfo,
		adTrackingData = data.adTrackingData,
		sendCatalogItemClickAnalytics = v42
	})

	local v44 = module26({
		itemId = itemId,
		itemType = itemType,
		itemData = itemData2,
		isSelected = isSelected,
		textButtonRef = ref,
		widgetAnalyticsInfo = data.widgetAnalyticsInfo,
		isOrganic = data.isOrganic,
		sendCatalogItemClickAnalytics = v42
	})

	if itemType == itemTypeEnum.Look then
		v43 = v44
	end

	local v45

	if fFlagAXMISEnableMultiShopping then
		v45 = React.useCallback(function()
			local v46 = itemType == itemTypeEnum.Look
			local v47 = not isSelected

			if v47 then
				v47 = not (name == avatarScreen.MySharedAvatars) and v46
			end

			if
				v47
				and v21
				and next(v21) ~= nil
				and lookData
				and lookData.lookType ~= module12.LookType.Makeup
				and v13
				and v13.shouldShowWearAvatarReplaceAllItemsPrompt()
			then
				v15.navigate(avatarScreen.WearAvatarReplaceAllItemsPrompt, {
					onConfirm = function(p2)
						if p2 then
							v13.hideWearAvatarReplaceAllItemsPrompt()
						end

						if v43 then
							v43()
						else
							v41()
						end
					end
				})
			elseif v43 then
				v43()
			else
				v41()
			end
		end, {
			itemType,
			v41,
			isSelected,
			v21,
			v13,
			name,
			v15,
			lookData,
			v43
		})
	end

	local v46

	if fFlagAXCatalogMakeupSupport then
		v46 = React.useCallback(function()
			local v47 = if itemId and itemType then getTryOnItemReducerKey(itemId, itemType) else nil

			local v48 = v21 and not v21[v47] and itemType == module12.ItemType.Asset

			local v49 = if fFlagAXMISEnableMultiShopping and v48 and v21 then fn(v21) else nil

			local v50 = fFlagAXMISEnableMultiShopping and v49 and #v49 == MAX_MAKEUP_LAYERS

			local v51 = fFlagAXMISEnableMultiShopping and v23 and v49 and MAX_MAKEUP_LAYERS <= #v23 + #v49

			if
				v14
				and v14.shouldShowMakeupMax6LayersPrompt()
				and itemData2
				and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[itemData2.assetType]
				and v48
				and (v23 and #v23 == MAX_MAKEUP_LAYERS or v50 or v51)
			then
				v15.navigate(avatarScreen.MakeupMax6LayersPrompt, {
					onConfirm = function(p2)
						if p2 then
							v14.hideMakeupMax6LayersPrompt()
						end

						if v43 then
							v43()
						else
							v41()
						end
					end
				})

				if fFlagAXMISEnableMultiShopping then
					v14.incrementSeenMakeupMax6LayersPrompt()
				end
			elseif v43 then
				v43()
			else
				v41()
			end
		end, {
			v14,
			v15,
			v41,
			itemData2,
			v23,
			v21,
			itemId,
			itemType,
			v43
		})
	end

	local useCallback2 = React.useCallback
	local function fn4(p2)
		if data.onThumbnailLoaded then
			data.onThumbnailLoaded(itemId)
		end
	end

	local v47

	if fFlagAXFixCatalogTileThumbnailFlash then
		v47 = { data.onThumbnailLoaded, itemId }
	else
		v47 = { data.onThumbnailLoaded }
	end

	local v48 = useCallback2(fn4, v47)

	local v49 = React.useMemo(function()
		if lookData then
			return {
				assetIds = Cryo.List.map(not lookData.assets and {} or lookData.assets, function(p2)
					return p2.id
				end),
				bundleIds = Cryo.List.map(not lookData.bundles and {} or lookData.bundles, function(p2)
					return p2.id
				end)
			}
		end

		return {}
	end, { lookData })

	local hydratedContent = data.hydratedContent or { price = nil }
	local lowestPrice

	if
		fFlagAXSponsoredItemsWidgetUnifiedLogging
		and data.isSponsoredItem
		and data.widgetAnalyticsInfo
		and itemData2
	then
		lowestPrice = itemData2.lowestPrice or itemData2.priceInRobux
	else
		lowestPrice = nil
	end

	local gridPositionRow = if data.gridInformation then data.gridInformation.gridPositionRow else nil
	local gridPositionColumn = if data.gridInformation then data.gridInformation.gridPositionColumn else nil
	local v50

	if itemType == "Look" then
		v50 = unifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK
	elseif itemType == "Asset" then
		v50 = unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
	else
		v50 = unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
	end

	local v51

	if fFlagAXUnifiedImpressionsOnThumbnail then
		local v53 = {
			itemType = itemType,
			itemId = itemId,
			itemData = itemData2,
			lookData = lookData,
			hydratedContentPrice = hydratedContent.price,
			fallbackHydratedContentPrice = if fFlagAXSponsoredItemsWidgetUnifiedLogging then lowestPrice else nil,
			isSelected = isSelected,
			assetAndBundleIds = v49,
			gridPositionRow = gridPositionRow,
			gridPositionColumn = gridPositionColumn,
			avatarRoute = v16,
			searchKeyword = v20,
			thumbnailRef = ref2,
			widgetAnalyticsInfo = data.widgetAnalyticsInfo,
			isOrganic = data.isOrganic,
			impressionsCategory = data.impressionsCategory,
			impressionsSubcategory = data.impressionsSubcategory,
			impressionsTaxonomyId = data.impressionsTaxonomyId,
			index = data.index,
			impressionsSearch = data.impressionsSearch,
			section = 0,
			skipThumbnailTagging = 0
		}
		local v55 = if fFlagAXEditorRecommendedItemsUnifiedImpressions then data.section else nil
		v53.section = v55

		local v56 = if fFlagAXRecommendedItemsUnifiedSelectParity then data.skipUnifiedImpressions else nil
		v53.skipThumbnailTagging = v56
		v51 = module25(v53)
	end

	local applyUnifiedEventLoggingToRef = if v51 then v51.applyUnifiedEventLoggingToRef else nil
	local assignThumbnailRef = if v51 then v51.assignThumbnailRef else nil

	local useCallback3 = React.useCallback
	local function fn5(current)
		if current then
			ref.current = current

			if fFlagAXUnifiedImpressionsOnThumbnail and applyUnifiedEventLoggingToRef then
				applyUnifiedEventLoggingToRef(ref, true)
				return
			end

			local v52 = nil
			local v53 = nil
			local v54 = nil

			if data.widgetAnalyticsInfo then
				if itemType == "Look" then
					v52 = if lookData then lookData.totalPrice ~= nil else false
				elseif fFlagAXSponsoredItemsWidgetUnifiedLogging and lowestPrice ~= nil then
					v52 = true
				else
					v52 = if hydratedContent then hydratedContent.price ~= nil else false
				end

				v53 = if data.widgetAnalyticsInfo then data.widgetAnalyticsInfo.itemId ~= nil else false
				v54 = true
			elseif data.isOrganic then
				if itemType == "Look" then
					v52 = if lookData then lookData.totalPrice ~= nil else false
					v53 = itemId ~= nil
					v54 = true
				else
					v52 = if itemData2 then itemData2.lowestPrice ~= nil or itemData2.priceInRobux ~= nil else false
					v53 = itemId ~= nil

					if itemData2 then
						if itemData2.assetType == nil then
							v54 = not (itemData2.bundleType == nil)
								and itemData2.bundleType ~= "AvatarAnimations"
						else
							v54 = true
						end
					else
						v54 = false
					end
				end
			end

			if v52 and v53 and v54 then
				local join = Cryo.Dictionary.join
				local v57 = data.widgetAnalyticsInfo

				if not v57 then
					v57 = {
						itemId = itemId,
						assetType = 0,
						bundleType = 0,
						gridPositionRow = 0,
						gridPositionColumn = 0
					}

					local v58 = if itemData2 then itemData2.assetType else nil
					v57.assetType = v58
					local v59 = if itemData2 then itemData2.bundleType else nil
					v57.bundleType = v59
					v57.gridPositionRow = gridPositionRow
					v57.gridPositionColumn = gridPositionColumn
				end

				local v58 = {
					itemType = v50,
					action = 0,
					category = 0,
					subcategory = 0,
					taxonomyId = 0,
					section = 0,
					assetIds = 0,
					bundleIds = 0,
					organicAssetIds = 0,
					organicBundleIds = 0,
					organicLookType = 0,
					widgetLookType = 0,
					organicItemPrice = 0,
					widgetItemPrice = 0,
					organicTimedOption = 0,
					widgetTimedOption = 0,
					widgetAssetType = 0,
					widgetBundleType = 0
				}

				local v59 = if isSelected then unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_DESELECTED else unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED
				v58.action = v59

				v58.category = data.impressionsCategory
				v58.subcategory = data.impressionsSubcategory
				v58.taxonomyId = data.impressionsTaxonomyId

				local v60 = if fFlagAXEditorRecommendedItemsUnifiedImpressions then data.section else nil
				v58.section = v60

				local v61 = if data.widgetAnalyticsInfo and v49 then v49.assetIds else nil
				v58.assetIds = v61

				local v62 = if data.widgetAnalyticsInfo and v49 then v49.bundleIds else nil
				v58.bundleIds = v62

				local v63 = if data.isOrganic and v49 then v49.assetIds else nil
				v58.organicAssetIds = v63

				local v64 = if data.isOrganic and v49 then v49.bundleIds else nil
				v58.organicBundleIds = v64

				local v65 = if data.isOrganic and lookData then unifiedEventLoggingUtils.formatLookTypeAttribute(lookData.lookType) else nil
				v58.organicLookType = v65

				local v66 = if lookData and not data.isOrganic then unifiedEventLoggingUtils.formatLookTypeAttribute(lookData.lookType) else nil
				v58.widgetLookType = v66
				local v67

				if data.isOrganic then
					if lookData then
						v67 = lookData.totalPrice
					elseif itemData2 then
						v67 = itemData2.lowestPrice or itemData2.priceInRobux
					end
				end

				v58.organicItemPrice = v67
				local v68

				if data.widgetAnalyticsInfo then
					if lookData then
						v68 = lookData.totalPrice
					elseif fFlagAXSponsoredItemsWidgetUnifiedLogging and lowestPrice ~= nil then
						v68 = lowestPrice
					else
						v68 = hydratedContent.price
					end
				end

				v58.widgetItemPrice = v68

				local v69 = if data.isOrganic then getTimedOptionForItemData(itemData2) else nil
				v58.organicTimedOption = v69
				local v70 = if not data.isOrganic then getTimedOptionForItemData(itemData2) else nil
				v58.widgetTimedOption = v70

				local v71 = if not (data.isOrganic or not itemData2) then itemData2.assetType else nil
				v58.widgetAssetType = v71
				local v72 = if not (data.isOrganic or not itemData2) then itemData2.bundleType else nil
				v58.widgetBundleType = v72
				addUnifiedEventLogging(ref, join(v57, v58), {
					hasDeferredActions = true,
					isSelected = if fFlagAXMISEnableMultiShoppingUnifiedEvents then isSelected else nil,
					sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME
				})
			end
		end
	end

	local widgetAnalyticsInfo2 = data.widgetAnalyticsInfo
	local hydratedContent2 = data.hydratedContent

	local impressionsCategory = data.impressionsCategory
	local impressionsSubcategory = data.impressionsSubcategory
	local impressionsTaxonomyId = data.impressionsTaxonomyId
	local v53 = if fFlagAXUnifiedImpressionsOnThumbnail then applyUnifiedEventLoggingToRef else nil
	local v55 = useCallback3(fn5, {
		widgetAnalyticsInfo2,
		hydratedContent2,
		itemId,
		v50,
		itemData2,
		gridPositionRow,
		gridPositionColumn,
		isSelected,
		impressionsCategory,
		impressionsSubcategory,
		impressionsTaxonomyId,
		v49,
		lookData,
		v53,
		if fFlagAXSponsoredItemsWidgetUnifiedLogging then lowestPrice else nil
	})

	local v56 = module24({
		onOpenItemDetailsPage = React.useCallback(function()
			if itemId and itemType then
				if itemType == itemTypeEnum.Look then
					local v57 = fFlagAXMISEnableMultiShopping
						and name ~= avatarScreen.MySharedAvatars
						and 1
						or 2

					v17(module22(v10, v15, data.widgetAnalyticsInfo, itemId, peekViewState.Full, v57))
				else
					local v59 = {
						itemId = itemId,
						itemType = itemType,
						itemSubType = module13.GetItemSubType(itemType, itemData2),
						priceInRobux = 0,
						catalogAnalytics = 0,
						avatarRoute = 0,
						navigation = 0,
						itemDetailsPeekViewRefs = 0,
						resultsListRef = 0,
						widgetInfo = 0,
						showFullWithNoPeekView = true
					}
					local v60 = if itemData2 then itemData2.priceInRobux else nil
					v59.priceInRobux = v60
					v59.catalogAnalytics = v12
					v59.avatarRoute = v16
					v59.navigation = v15
					v59.itemDetailsPeekViewRefs = data.itemDetailsPeekViewRefs
					v59.resultsListRef = data.resultsListRef
					v59.widgetInfo = data.widgetAnalyticsInfo
					v17(module17(v59))
				end
			end
		end, {
			v17,
			itemId,
			itemType,
			itemData2,
			v10,
			v15,
			data.widgetAnalyticsInfo,
			v12,
			v16,
			data.itemDetailsPeekViewRefs,
			data.resultsListRef
		})
	}, v55)

	React.useEffect(function()
		local current = ref2.current

		if current and data.impressionsId then
			current:SetAttribute(data.impressionsTag, data.impressionsId)
			local v57 = organicEventImpressionsSchema[data.impressionsSchema]

			impressionsUtil.writeItemAttributes(v57, current, data)
		end
	end, { data.impressionsId, data.impressionsTag, data.impressionsSchema })

	local cardStyle = data.cardStyle
	local tileWidth = data.tileWidth
	local thumbailAspectRatio = data.thumbailAspectRatio
	local name2 = itemData2 and itemData2.name
	local v57 = if itemData2 then itemData2.lowestPrice or itemData2.priceInRobux or nil else nil
	local priceStatus = itemData2 and itemData2.priceStatus
	local moderationStatus = nil

	if itemData2 and itemData2.timedOptions then
		for k, timedOption in itemData2.timedOptions do
			if timedOption.selected then
				v57 = timedOption.price
			end
		end
	end

	if data.itemType == itemTypeEnum.Look then
		v57 = lookData and lookData.totalPrice
		name2 = lookData and lookData.name

		if name == avatarScreen.MySharedAvatars and lookData and lookData.owned then
			moderationStatus = lookData.moderationStatus
		end
	end

	local v58 = React.useMemo(function()
		if not data.isCreatorNameVisible then
			return nil
		end

		if data.itemType == itemTypeEnum.Look then
			local v59 = lookData

			if not (v59 and v59.curator and v59.curator.name) then
				return nil
			end

			local v60 = { name = v59.curator.name, verified = 0 }
			local v61 = if v59 and v59.curator then v59.curator.hasVerifiedBadge else nil
			v60.verified = v61
			return v60
		else
			local v59 = itemData2
			local name3 = v59 and v59.creator and (v59.creator.name or v59.creatorName)

			if name3 then
				return { name = name3, verified = v59.creator.hasVerifiedBadge }
			end

			return nil
		end
	end, {
		lookData,
		itemData2,
		data.itemType,
		data.isCreatorNameVisible,
		data.creatorNameTileFooterEnabled
	})

	local timedOptionDays = if fFlagAXDurablesFooter and v26 and v26 > 0 then v27.timedOptionDays else nil

	local v59 = React.useMemo(function()
		local v60

		if data.isPriceVisible then
			if priceStatus then
				v60 = { type = "text", text = priceStatus }
			else
				v60 = v57 and {
					type = "price",
					price = v57 or 0
				} or nil
			end
		end

		if defineFastFlag and v26 then
			return {
				type = "multi",
				contents = {
					v60,
					{
						type = "timedOption",
						icon = Foundation.Enums.IconName.Clock,
						text = timedOptionDays or ""
					}
				}
			}
		end

		if fFlagAXDurablesFooter and timedOptionDays and v60 then
			return {
				type = "multi",
				contents = {
					v60,
					{
						type = "timedOption",
						icon = Foundation.Enums.IconName.Clock,
						text = timedOptionDays
					}
				}
			}
		end

		return v60
	end, { data.isPriceVisible, priceStatus, v57, timedOptionDays, v26 })

	if v8 then
		v39 = nil
	end

	local v60 = if fFlagAXShowFaeUpsell then getFaeFeatureAccessStore.useFaeFeatureAccess() else nil
	local v61

	if fFlagAXInventoryDurablesExpiredFilter then
		local itemStatusOverride = data.itemStatusOverride
		local itemType2 = data.itemType

		local statusText = v27.statusText

		if not fFlagAXShowFaeUpsell then
			v60 = nil
		end

		v61 = module29(itemStatusOverride, itemType2, moderationStatus, statusText, itemData2, v60)
	end

	local v63 = if v18.showAnimationTabs then itemData2 else nil

	if fFlagAXCatalogMakeupSupport and itemType == module12.ItemType.Asset then
		v45 = v46
	elseif fFlagAXMISEnableMultiShopping then
		if itemType ~= itemTypeEnum.Look then
			v45 = v43
		end
	else
		v45 = v43
	end

	local v64

	if not v8 then
		if fFlagAXMISEnableMultiShopping then
			v64 = v27.details
		else
			v64 = if data.itemType == itemTypeEnum.Look then v27.detailsWithItemsCount else v27.details
		end
	end

	local v65 = if fFlagAXUnifiedImpressionsOnThumbnail then assignThumbnailRef or ref2 else ref2
	local v62 = {
		ref = v56,
		animationTabsItemData = v63,
		onActivated = v45,
		onOverlayButtonActivated = v39,
		overlayButtonText = v64,
		thumbnailRef = v65,
		thumbnailTag = data.impressionsTag,
		thumbnailUrl = v33,
		onThumbnailLoaded = v48,
		thumbnailRect = v31,
		priceLineContent = v59,
		creator = v58,
		itemLicensingInfo = 0,
		title = 0,
		itemType = 0,
		itemInfo = 0,
		itemStatus = 0,
		headerAspectRatio = 0,
		headerSize = 0,
		isSelected = 0,
		backgroundLayers = 0,
		imageScaleType = 0
	}

	local v66 = if fFlagAXMarketplaceLicensingItemCards and itemData2 and not v18.showAnimationTabs then itemData2.itemLicensingInfo else nil
	v62.itemLicensingInfo = v66

	if not data.isTitleVisible then
		name2 = nil
	end

	v62.title = name2
	local v67

	if data.itemType ~= itemTypeEnum.Look then
		local tileRestrictionsMap = if itemData2 then itemData2.tileRestrictionsMap else nil

		if tileRestrictionsMap then
			v67 = tileRestrictionsMap[itemTileEnums.Restriction.Limited] and "Limited"
				or (tileRestrictionsMap[itemTileEnums.Restriction.LimitedUnique] or tileRestrictionsMap[itemTileEnums.Restriction.Collectible])
				and "Collectible"
				or nil
		end
	end

	v62.itemType = v67
	local v68 = if data.itemType ~= itemTypeEnum.Look then itemData2 and itemData2.bundleType == module12.BundleTypeIdStrings.DynamicHead and "DynamicHead" or nil else nil
	v62.itemInfo = v68

	if not fFlagAXInventoryDurablesExpiredFilter then
		if data.itemType == itemTypeEnum.Look then
			v61 = getLookStatusFromModerationStatus(moderationStatus)
		elseif v27.statusText then
			v61 = { type = "text", text = v27.statusText }
		else
			v61 = showDurableBadge(itemData2)
		end
	end

	v62.itemStatus = v61

	local v69 = if not (tileWidth and not (cardStyle and cardStyle.backgroundLayers)) then thumbailAspectRatio else nil
	v62.headerAspectRatio = v69

	local v70 = if tileWidth and not (cardStyle and cardStyle.backgroundLayers) then UDim2.fromOffset(
		tileWidth,
		tileWidth / (thumbailAspectRatio or 1)
	) else nil
	v62.headerSize = v70

	v62.isSelected = isSelected
	local v71 = if cardStyle then cardStyle.backgroundLayers else nil
	v62.backgroundLayers = v71
	v62.imageScaleType = data.imageScaleType
	return v62
end

return useCatalogItemCardViewModel
