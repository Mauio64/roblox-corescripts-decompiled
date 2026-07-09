local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local ItemTileEnums = require(CorePackages.Packages.UIBlox).Tile.ItemTileEnums
local tutils = require(CorePackages.Packages.tutils)
local Cryo = require(CorePackages.Packages.Cryo)
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local getZoomedSizeAndOffset = AvatarExperienceCommon.Utils.getZoomedSizeAndOffset
local getThumbSizeVectorFromParamString = AvatarExperienceCommon.Utils.getThumbSizeVectorFromParamString
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local useMultiItemShoppingFtux = AvatarExperienceCatalog.Hooks.useMultiItemShoppingFtux
local useMakeupFtux = AvatarExperienceCatalog.Hooks.useMakeupFtux
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useLastInput = Responsive.useLastInput
local useIsSpatial = Responsive.useIsSpatial
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local UnifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local UnifiedEventLoggingUtils = AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils
local getTimedOptionForItemData = AvatarExperienceAnalytics.Utils.getTimedOptionForItemData
local getUnifiedLoggingSurface = AvatarExperienceAnalytics.Utils.getUnifiedLoggingSurface
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXLookAndFeelBackgrounds = AvatarExperienceFlags.FFlagAXLookAndFeelBackgrounds
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAddTypesToWidgetItems = AvatarExperienceFlags.FFlagAddTypesToWidgetItems
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local AddAnalyticsMetadata = AvatarExperienceRodux.Actions.AddAnalyticsMetadata
local SetTryOnManagerPeekViewState = AvatarExperienceRodux.Actions.SetTryOnManagerPeekViewState
local SetLastToggledLookType = AvatarExperienceCatalog.State.Actions.SetLastToggledLookType
local RemoveLookFromTryOn = require(Modules.AvatarExperience.Common.Actions.RemoveLookFromTryOn)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local ImpressionsUtil = AvatarExperienceAnalytics.ImpressionsReporter.ImpressionsUtil
local OrganicEventImpressionsSchema = AvatarExperienceAnalytics.ImpressionsReporter.OrganicEventImpressionsSchema
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local FullView = AvatarExperienceCommon.Enums.FullView

require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)

local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local selectEquippedLayeredMakeupAssets = AvatarExperienceCommon.State.Selectors.selectEquippedLayeredMakeupAssets
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.Common.Services.Analytics)

require(Modules.AvatarExperience.Common.Types)

local SendDetailedCatalogAnalytics = require(Modules.AvatarExperience.Catalog.Thunks.SendDetailedCatalogAnalytics)
local MaybePromptForR15Upgrade = require(Modules.AvatarExperience.Catalog.Thunks.MaybePromptForR15Upgrade)
local OpenItemDetails = require(Modules.AvatarExperience.Common.Thunks.OpenItemDetails)
local ToggleTryOnThunk = require(Modules.AvatarExperience.Common.Thunks.ToggleTryOnThunk)
local CloseAllItemDetails = require(Modules.AvatarExperience.Common.Thunks.CloseAllItemDetails)
local SetAnimationPreview = require(Modules.AvatarExperience.Common.Actions.SetAnimationPreview)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local logOnOverlayClosed = AvatarExperienceNavigation.Debug.logOnOverlayClosed
local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling
local selectIsFullViewTable = require(Modules.AvatarExperience.Common.Selectors.selectIsFullViewTable)
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local ItemTypeEnum = AvatarExperienceCommon.Enums.ItemTypeEnum
local CatalogItemCardStatusIconTypeEnum = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCardStatusIconTypeEnum
local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local MAX_MAKEUP_LAYERS = AvatarExperienceCommon.Constants.MAX_MAKEUP_LAYERS
local TryOnLookV2 = require(Modules.AvatarExperience.Common.Thunks.TryOnLookV2)
local OpenLookDetailsFromButton = require(Modules.AvatarExperience.Common.Thunks.OpenLookDetailsFromButton)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local sendUnifiedEventForDeferredAction = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendUnifiedEventForDeferredAction
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock

require(script.Parent.CatalogItemCard)

local useCatalogItemCardFocusNavigationBindings = require(script.Parent.useCatalogItemCardFocusNavigationBindings)
local useCatalogItemCardFtux = require(script.Parent.useCatalogItemCardFtux)
local useTryOnLook = require(script.Parent.useTryOnLook)
local useTryOnAssetOrBundle = require(script.Parent.useTryOnAssetOrBundle)
local useSendCatalogItemClickAnalytics = require(script.Parent.useSendCatalogItemClickAnalytics)
local getItemCardStatus = require(script.Parent.getItemCardStatus)
local GetFaeFeatureAccessStore = require(Modules.AvatarExperience.Catalog.Stores.GetFaeFeatureAccessStore)
local FFlagAXCatalogItemCardSelectedOverlayButtonLogging = AvatarExperienceFlags.FFlagAXCatalogItemCardSelectedOverlayButtonLogging
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local FFlagAXDurablesFooter = AvatarExperienceFlags.FFlagAXDurablesFooter
local v88 = game:DefineFastFlag("AXDurablesFooterWithPermanent", false)
local FFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local FFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAXWearTimeSupport = SharedFlags.FFlagAXWearTimeSupport
local FFlagAXFixClickItemDetailsSurfaceLogging = SharedFlags.FFlagAXFixClickItemDetailsSurfaceLogging
local LOOKS_IMAGE_OFFSET_MULTIPLIERS = AvatarExperienceCatalog.Constants.LOOKS_IMAGE_OFFSET_MULTIPLIERS
local LOOKS_IMAGE_ZOOM = AvatarExperienceCatalog.Constants.LOOKS_IMAGE_ZOOM
local t1 = {
	toastMessage = "Feature.Avatar.Label.LayeredClothingR15Warning",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

local function isBodyBundle(p1) -- line: 129
	-- upvalues: Constants (copy)
	if p1 then
		return p1.bundleType == Constants.BundleTypeIdStrings.BodyParts
	end

	return false
end
local function getItemTypeFromItemData(p2) -- line: 133
	-- upvalues: ItemTileEnums (copy)
	local v114 = if not p2 then nil else p2.tileRestrictionsMap

	if v114 then
		if v114[ItemTileEnums.Restriction.Limited] then
			return "Limited"
		end

		if v114[ItemTileEnums.Restriction.LimitedUnique] or v114[ItemTileEnums.Restriction.Collectible] then
			return "Collectible"
		end
	end

	return nil
end
local function getItemInfoFromItemData(p3) -- line: 149
	-- upvalues: Constants (copy)
	if p3 and p3.bundleType == Constants.BundleTypeIdStrings.DynamicHead then
		return "DynamicHead"
	end

	return nil
end
local function getTimedOptionDays(p4) -- line: 156
	-- upvalues: v88 (copy)
	for _, v118 in p4 do
		if not v88 then
			if not v118.selected or not (v118.days > 0) then
				continue
			end

			return v118.days
		end

		if v118.selected then
			return v118.days
		end
	end

	if v88 then
		return 0
	end

	return nil
end
local function getCreatorFromItemData(p5) -- line: 176
	if p5 and p5.creator then
		local v120 = p5.creator.name or p5.creatorName

		if v120 then
			return {
				name = v120,
				verified = p5.creator.hasVerifiedBadge
			}
		end
	end

	return nil
end
local function getCreatorFromLookData(p6) -- line: 186
	if p6 and (p6.curator and p6.curator.name) then
		return {
			name = p6.curator.name,
			verified = if not p6 or not p6.curator then nil else p6.curator.hasVerifiedBadge
		}
	end

	return nil
end
local function getLookStatusFromModerationStatus(s1: string?) -- line: 197
	-- upvalues: Constants (copy)
	if s1 == Constants.ModerationStatus.PendingModeration then
		return {
			type = "icon",
			iconType = "PendingModeration"
		}
	end

	if s1 == Constants.ModerationStatus.Moderated then
		return {
			type = "icon",
			iconType = "Moderated"
		}
	end

	return nil
end
local function isValidItemId(s2: string?) -- line: 206
	return s2 ~= nil and s2 ~= "0"
end
local function isValidThumbnailSize(p7, p8) -- line: 212
	-- upvalues: Constants (copy)
	if p8 ~= nil then
		for _, v127 in Constants.CatalogThumbnailTypeToSize[p8] do
			if v127 == p7 then
				return true
			end
		end
	end

	return false
end

local u106 = nil

if FFlagAXMISEnableMultiShopping then
	function u106(p9) -- line: 229
		-- upvalues: ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy)
		local t2 = {}

		for _, v131 in p9 do
			if v131.selectedInTryOnManager and v131.itemType and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[v131.itemSubType] then
				table.insert(t2, v131)
			end
		end

		return t2
	end
end

local function cardIsSelectedInTryOnOutfit(p10, s3: string?, p11) -- line: 243
	-- upvalues: FFlagAXCatalogMakeupSupport (copy), FFlagAXMISEnableMultiShopping (copy), getTryOnItemReducerKey (copy)
	if s3 and s3 == p10.AvatarExperience.AvatarScene.OutfitTryOn.LookId then
		return true
	end

	if FFlagAXCatalogMakeupSupport and FFlagAXMISEnableMultiShopping and s3 and s3 == p10.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookId then
		return true
	end

	local TryOnItems = p10.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local v136 = p10.AvatarExperience.AvatarScene.OutfitTryOn.LookId == nil

	if s3 and p11 then
		local v137 = getTryOnItemReducerKey(s3, p11)

		if FFlagAXMISEnableMultiShopping then
			return TryOnItems[v137] ~= nil
		end

		return TryOnItems[v137] ~= nil and v136
	end

	return false
end
local function selectCatalogItemCardState(p12, s4: string?, p13) -- line: 271
	-- upvalues: cardIsSelectedInTryOnOutfit (copy), ItemData (copy), CatalogUtils (copy), GetCatalogCategoriesStore (copy), Constants (copy), selectIsFullViewTable (copy), PeekViewState (copy)
	local v141 = cardIsSelectedInTryOnOutfit(p12, s4, p13)
	local LastToggledItem = p12.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem
	local v143 = nil
	local v144 = ItemData(p12.AvatarExperience.Common, s4, p13)

	if v144 then
		local v145

		v145, v143 = CatalogUtils.GetStatus(v144)
	end

	local v146 = GetCatalogCategoriesStore.getCatalogSelectionStore().selectedCategoryInfo(false)
	local v147 = v141 and (v144 and v144.bundleType == Constants.BundleTypeIdStrings.Animations)
	local PageType = v146.PageType
	local v149 = v147 and (LastToggledItem and s4 == LastToggledItem.itemId or (PageType == Constants.PageType.Animation or PageType == Constants.PageType.AllAnimation))
	local viewState = p12.AvatarExperience.Common.ItemDetailsPeekView.viewState

	return {
		itemData = v144,
		isSelected = v141,
		statusText = v143,
		avatarType = p12.AvatarExperience.AvatarEditor.Character.AvatarType,
		isAvatarR6 = p12.AvatarExperience.AvatarEditor.Character.AvatarType == Constants.AvatarType.R6,
		fullView = selectIsFullViewTable(p12),
		showAnimationTabs = v149,
		isItemDetailsViewStateFull = viewState == PeekViewState.Full
	}
end
local function v109(p14) -- line: 314
	return p14.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end
local function showDurableBadge(p15) -- line: 318
	-- upvalues: FFlagAXDurablesFooter (copy), CatalogItemCardStatusIconTypeEnum (copy)
	if FFlagAXDurablesFooter then
		return nil
	end

	if not p15 or not p15.timedOptions then
		return nil
	end

	for _, v154 in p15.timedOptions do
		if v154.selected then
			return {
				type = "badge",
				iconType = CatalogItemCardStatusIconTypeEnum.Durable,
				text = not (v154.days > 0) and "" or tostring(v154.days)
			}
		end
	end

	return {
		type = "badge",
		text = "",
		iconType = CatalogItemCardStatusIconTypeEnum.Durable
	}
end
local function useCatalogItemCardViewModel(t3: {[any]: any}) -- line: 382
	-- upvalues: React (copy), useLastInput (copy), useIsSpatial (copy), Responsive (copy), useAdaptiveScrolling (copy), useRoactService (copy), RoactNetworking (copy), Analytics2 (copy), Analytics (copy), FFlagAXMISEnableMultiShopping (copy), useMultiItemShoppingFtux (copy), FFlagAXCatalogMakeupSupport (copy), useMakeupFtux (copy), useNavigation (copy), useAvatarRoute (copy), useDispatch (copy), selectCatalogItemCardState (copy), useSelector (copy), tutils (copy), v109 (copy), selectEquippedLayeredMakeupAssets (copy), FFlagAXDurablesFooter (copy), getTimedOptionDays (copy), useLocalization (copy), CatalogUtils (copy), Constants (copy), getThumbSizeVectorFromParamString (copy), getZoomedSizeAndOffset (copy), LOOKS_IMAGE_ZOOM (copy), LOOKS_IMAGE_OFFSET_MULTIPLIERS (copy), FFlagAXCatalogItemCardSelectedOverlayButtonLogging (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLogEnums (copy), sendUnifiedEventForDeferredAction (copy), FFlagAXFixClickItemDetailsSurfaceLogging (copy), getUnifiedLoggingSurface (copy), ItemTypeEnum (copy), OpenLookDetailsFromButton (copy), AvatarScreen (copy), SetLastToggledLookType (copy), NavigateWithLock (copy), OpenItemDetails (copy), FFlagAXWearTimeSupport (copy), useCatalogItemCardFtux (copy), logOnOverlayClosed (copy), MaybePromptForR15Upgrade (copy), SetFullView (copy), FullView (copy), TryOnLookV2 (copy), PeekViewState (copy), RemoveLookFromTryOn (copy), SetTryOnManagerPeekViewState (copy), AddAnalyticsMetadata (copy), SendDetailedCatalogAnalytics (copy), WidgetConstants (copy), ToggleTryOnThunk (copy), SetCurrentToastMessage (copy), t1 (copy), SetAnimationPreview (copy), WebApi (copy), CloseAllItemDetails (copy), useSendCatalogItemClickAnalytics (copy), useTryOnAssetOrBundle (copy), useTryOnLook (copy), getTryOnItemReducerKey (copy), u106 (ref), MAX_MAKEUP_LAYERS (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), Cryo (copy), addUnifiedEventLogging (copy), UnifiedEventLoggingUtils (copy), getTimedOptionForItemData (copy), FFlagAddTypesToWidgetItems (copy), UnifiedEventLogConstants (copy), useCatalogItemCardFocusNavigationBindings (copy), OrganicEventImpressionsSchema (copy), ImpressionsUtil (copy), v88 (copy), Foundation (copy), FFlagAXShowFaeUpsell (copy), GetFaeFeatureAccessStore (copy), FFlagAXInventoryDurablesExpiredFilter (copy), getItemCardStatus (copy), ItemTileEnums (copy), getLookStatusFromModerationStatus (copy), showDurableBadge (copy), FFlagAXLookAndFeelBackgrounds (copy)
	local v156 = React.useRef(nil)
	local v157 = React.useRef(nil)
	local v158 = useLastInput()
	local v159 = useIsSpatial()
	local v160 = v158 == Responsive.Input.Directional and not v159
	local v161 = useAdaptiveScrolling()
	local v162 = useRoactService(RoactNetworking)
	local v163 = useRoactService(Analytics2)
	local v164 = useRoactService(Analytics)
	local v165 = if not FFlagAXMISEnableMultiShopping then nil else useMultiItemShoppingFtux()
	local v166 = if not FFlagAXCatalogMakeupSupport then nil else useMakeupFtux()
	local v167 = useNavigation()
	local v168 = useAvatarRoute()
	local v169 = useDispatch()
	local itemId = t3.itemId
	local itemType = t3.itemType
	local lookData = t3.lookData
	local v173 = v168 and (v168.opaque and v168.opaque.name)
	local v174 = React.useCallback(function(p16) -- line: 402
		-- upvalues: selectCatalogItemCardState (copy), itemId (copy), itemType (copy)
		return (selectCatalogItemCardState(p16, itemId, itemType))
	end, {
		itemId,
		itemType
	})
	local v175 = useSelector(v174, tutils.shallowEqual)
	local v176 = if not FFlagAXMISEnableMultiShopping and not FFlagAXCatalogMakeupSupport then nil else useSelector(v109)
	local v177 = if not FFlagAXCatalogMakeupSupport then nil else useSelector(selectEquippedLayeredMakeupAssets)
	local v178 = (not lookData or not lookData.assets) and 0 or #lookData.assets
	local v179 = (not lookData or not lookData.bundles) and 0 or #lookData.bundles
	local v180 = if not FFlagAXDurablesFooter or (not v175 or (not v175.itemData or not v175.itemData.timedOptions)) then nil else getTimedOptionDays(v175.itemData.timedOptions)
	local v181 = useLocalization({
		details = "Feature.Avatar.Label.DetailsButton",
		statusText = v175.statusText,
		detailsWithItemsCount = {
			"Feature.Avatar.Label.Details",
			quantity = v178 + v179
		},
		timedOptionDays = if not FFlagAXDurablesFooter or (not v180 or not (v180 > 0)) then nil else {
			"Feature.Durables.TimeRemaining.Days",
			number = v180
		}
	})
	local isSelected = v175.isSelected
	local itemData = v175.itemData
	local v184 = if not itemType then nil else CatalogUtils.GetRbxThumbType(itemType)
	local _150x150 = Constants.CatalogThumbnailTypeToSize.Asset._150x150

	if t3.thumbnailSize then
		local thumbnailSize = t3.thumbnailSize
		local g190 = nil
		local v189 = nil

		if v184 ~= nil then
			for _, v188 in Constants.CatalogThumbnailTypeToSize[v184] do
				if v188 == thumbnailSize then
					v189 = true
					g190 = true
				end

				if g190 then
					break
				end
			end
		end

		if not g190 then
			v189 = false
		end

		g190 = false

		if v189 then
			_150x150 = t3.thumbnailSize
		end
	end

	local v191 = getThumbSizeVectorFromParamString(_150x150)
	local v192 = if not (not not itemData and itemData.bundleType == Constants.BundleTypeIdStrings.BodyParts) or not v191 then nil else getZoomedSizeAndOffset(v191, LOOKS_IMAGE_ZOOM, LOOKS_IMAGE_OFFSET_MULTIPLIERS)
	local v193 = if not (itemId ~= nil and itemId ~= "0") then nil else `rbxthumb://type={ v184 }&id={ itemId }&{ _150x150 }`
	local v194 = React.useCallback(function(b1: boolean?) -- line: 461
		-- upvalues: itemId (copy), itemType (copy), FFlagAXCatalogItemCardSelectedOverlayButtonLogging (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLogEnums (copy), sendUnifiedEventForDeferredAction (copy), FFlagAXFixClickItemDetailsSurfaceLogging (copy), getUnifiedLoggingSurface (copy), v168 (copy), ItemTypeEnum (copy), lookData (copy), v164 (copy), v169 (copy), OpenLookDetailsFromButton (copy), FFlagAXMISEnableMultiShopping (copy), v173 (copy), AvatarScreen (copy), SetLastToggledLookType (copy), NavigateWithLock (copy), v167 (copy), OpenItemDetails (copy), CatalogUtils (copy), itemData (copy), t3 (copy)
		if itemId and itemType then
			if FFlagAXCatalogItemCardSelectedOverlayButtonLogging then
				if FFlagAXMISEnableMultiShoppingUnifiedEvents then
					local ASSET = nil

					if itemType == "Asset" then
						ASSET = UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
					elseif itemType == "Bundle" then
						ASSET = UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
					elseif itemType == "Look" then
						ASSET = UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK
					end

					sendUnifiedEventForDeferredAction({
						elementName = "CLICK_ITEM_DETAILS",
						action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
						itemId = itemId,
						itemType = ASSET,
						surface = if not FFlagAXFixClickItemDetailsSurfaceLogging then nil else getUnifiedLoggingSurface(v168)
					})
				else
					sendUnifiedEventForDeferredAction({
						elementName = "CLICK_ITEM_DETAILS",
						action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
						surface = if not FFlagAXFixClickItemDetailsSurfaceLogging then nil else getUnifiedLoggingSurface(v168)
					})
				end
			end

			if itemType == ItemTypeEnum.Look then
				local t4 = {
					lookId = lookData and lookData.id,
					valueInRobux = lookData and lookData.totalValue,
					catalogAnalytics = v164,
					avatarRoute = v168
				}

				v169(OpenLookDetailsFromButton(t4))

				if FFlagAXMISEnableMultiShopping and v173 ~= AvatarScreen.MySharedAvatars then
					if lookData then
						v169(SetLastToggledLookType({
							lastToggledLookType = lookData.lookType
						}))
					end

					v169(NavigateWithLock(function() -- line: 510
						-- upvalues: v167 (copy), AvatarScreen (copy)
						v167.navigate(AvatarScreen.LookDetails)
					end))

					return
				end
			else
				v169(OpenItemDetails({
					itemId = itemId,
					itemType = itemType,
					itemSubType = CatalogUtils.GetItemSubType(itemType, itemData),
					priceInRobux = if not itemData then nil else itemData.priceInRobux,
					catalogAnalytics = v164,
					avatarRoute = v168,
					navigation = v167,
					itemDetailsPeekViewRefs = t3.itemDetailsPeekViewRefs,
					resultsListRef = t3.resultsListRef,
					widgetInfo = t3.widgetAnalyticsInfo,
					showFullWithNoPeekView = b1
				}))
			end
		end
	end, {
		v169,
		itemId,
		itemType,
		v164,
		v168,
		v167,
		t3.itemDetailsPeekViewRefs,
		t3.resultsListRef,
		t3.widgetAnalyticsInfo,
		lookData,
		v173
	})

	if FFlagAXWearTimeSupport then
		useCatalogItemCardFtux({
			isSelected = isSelected,
			itemData = itemData
		})
	end

	local v195 = React.useCallback(function() -- line: 550
		-- upvalues: v194 (copy)
		v194(true)
	end, { v194 })
	local v196 = React.useCallback(function() -- line: 555
		-- upvalues: logOnOverlayClosed (copy), v160 (copy), itemId (copy), v194 (copy), v169 (copy), MaybePromptForR15Upgrade (copy), v167 (copy), itemType (copy)
		local function onR15PromptWillClose() -- line: 556
			-- upvalues: logOnOverlayClosed (copy), v160 (copy), itemId (copy), v194 (copy)
			logOnOverlayClosed("CatalogItemCard", v160)

			if itemId then
				v194()
			end
		end

		return v169(MaybePromptForR15Upgrade(v167, itemId, itemType, onR15PromptWillClose, nil, true))
	end, {
		itemId,
		v194,
		v169,
		v167,
		itemId,
		itemType
	})
	local v197 = React.useCallback(function(b2: boolean?) -- line: 591
		-- upvalues: itemId (copy), itemType (copy), ItemTypeEnum (copy), isSelected (copy), v161 (copy), v156 (copy), v173 (copy), v169 (copy), SetFullView (copy), v164 (copy), FullView (copy), FFlagAXMISEnableMultiShopping (copy), AvatarScreen (copy), TryOnLookV2 (copy), v162 (copy), v167 (copy), t3 (copy), PeekViewState (copy), RemoveLookFromTryOn (copy), SetTryOnManagerPeekViewState (copy), AddAnalyticsMetadata (copy), SendDetailedCatalogAnalytics (copy), WidgetConstants (copy), v196 (copy), CatalogUtils (copy), itemData (copy), ToggleTryOnThunk (copy), v168 (copy), v175 (copy), v163 (copy), Constants (copy), SetCurrentToastMessage (copy), t1 (copy), SetAnimationPreview (copy), WebApi (copy), CloseAllItemDetails (copy)
		if not itemId or not itemType then
			return
		end

		if itemType == ItemTypeEnum.Look then
			if not isSelected then
				if v161 then
					local v236 = if not v156 then nil else v156.current

					if v236 ~= nil then
						v161.setSelectedItemInstance(v236)
					end
				end

				if v173 ~= nil then
					v169(SetFullView(v164, v173, FullView.None))
				end

				local n1 = 2

				if FFlagAXMISEnableMultiShopping and v173 ~= AvatarScreen.MySharedAvatars then
					n1 = 1
				end

				v169(TryOnLookV2(v162, v167, t3.widgetAnalyticsInfo, itemId, if not FFlagAXMISEnableMultiShopping then nil else PeekViewState.SuperBrief, n1))
			else
				if v161 then
					v161.setSelectedItemInstance(nil)
				end

				if FFlagAXMISEnableMultiShopping then
					v169(RemoveLookFromTryOn(itemId))
				end

				v169(SetTryOnManagerPeekViewState(PeekViewState.Closed))
			end

			if t3.isOrganic then
				if not isSelected then
					local analyticsContext = t3.analyticsContext
					local analyticsItemCountPerPage = t3.analyticsItemCountPerPage
					local index = t3.index

					v169(AddAnalyticsMetadata({
						selectedItemIndex = index
					}))
					v169(SendDetailedCatalogAnalytics(analyticsContext, v164.clickCatalogItem, itemId, itemType, index, analyticsItemCountPerPage, false))

					return
				end
			else
				v164.widgetInteractionV2(t3.widgetAnalyticsInfo, if not isSelected then WidgetConstants.ActionType.ITEM_CLICK else WidgetConstants.ActionType.ITEM_DESELECTED)
			end

			return
		end

		if v196() then
			return
		end

		local v241 = CatalogUtils.GetItemSubType(itemType, itemData)
		local v242 = isSelected

		if FFlagAXMISEnableMultiShopping then
			v169(SetTryOnManagerPeekViewState(PeekViewState.Closed))
		end

		v169(ToggleTryOnThunk(v162, v164, itemType, v241, itemId, true, v168, v167, t3.widgetAnalyticsInfo, nil, if not FFlagAXMISEnableMultiShopping then nil else b2))

		if not FFlagAXMISEnableMultiShopping and v161 then
			v169(SetTryOnManagerPeekViewState(PeekViewState.Closed))
		end

		if v161 and v242 then
			v161.setSelectedItemInstance()
		end

		if not v242 then
			if v161 then
				v161.setSelectedItemInstance(v156.current)
			end

			if isSelected then
				return
			end

			if v175.fullView[v168.opaque.name] == FullView.UIFullView then
				v169(SetFullView(v163, v168.opaque.name, FullView.None))
			end
		end

		if isSelected then
			return
		end

		local v243 = itemData and itemData.assetType

		if v175.isAvatarR6 and v243 ~= Constants.AssetTypeIdStrings.HairAccessory and Constants.LayeredAssetTypes[v243] ~= nil then
			v169(SetCurrentToastMessage(t1))
		end

		if itemType == Constants.ItemType.Asset and Constants.AssetTypeIdToCategory[v241] == Constants.AssetCategories.Animation then
			v169(SetAnimationPreview(itemId, v243))
		end

		local analyticsContext = t3.analyticsContext
		local analyticsItemCountPerPage = t3.analyticsItemCountPerPage
		local index = t3.index
		local adTrackingData = t3.adTrackingData

		v169(AddAnalyticsMetadata({
			selectedItemIndex = index
		}))
		v169(SendDetailedCatalogAnalytics(analyticsContext, v164.clickCatalogItem, itemId, itemType, index, analyticsItemCountPerPage, false))

		if t3.widgetAnalyticsInfo then
			local widgetAnalyticsInfo = t3.widgetAnalyticsInfo

			v164.widgetInteractionV2(widgetAnalyticsInfo, WidgetConstants.ActionType.ITEM_CLICK)
		end

		if adTrackingData then
			WebApi.TrackSponsoredItemClick(v162, adTrackingData)
		end

		if v175.isItemDetailsViewStateFull then
			v169(CloseAllItemDetails(v167))
		end
	end, {
		v169,
		itemId,
		v196,
		itemData,
		v162,
		v164,
		itemType,
		v168,
		v167,
		t3.widgetAnalyticsInfo,
		v161,
		v175.fullView,
		v175.isAvatarR6,
		v175.isItemDetailsViewStateFull,
		v163,
		v168.opaque.name,
		t3.analyticsContext,
		t3.analyticsItemCountPerPage,
		t3.index,
		t3.adTrackingData,
		isSelected,
		v173
	})
	local v198 = useSendCatalogItemClickAnalytics({
		analyticsContext = t3.analyticsContext,
		itemId = itemId,
		itemType = itemType,
		index = t3.index,
		analyticsItemCountPerPage = t3.analyticsItemCountPerPage
	})
	local v199 = useTryOnAssetOrBundle({
		itemId = itemId,
		itemType = itemType,
		itemData = itemData,
		isSelected = isSelected,
		textButtonRef = v156,
		fullView = v175.fullView,
		isAvatarR6 = v175.isAvatarR6,
		isItemDetailsViewStateFull = v175.isItemDetailsViewStateFull,
		maybePromptForR15Upgrade = v196,
		widgetAnalyticsInfo = t3.widgetAnalyticsInfo,
		adTrackingData = t3.adTrackingData,
		sendCatalogItemClickAnalytics = v198
	})
	local v200 = useTryOnLook({
		itemId = itemId,
		itemType = itemType,
		itemData = itemData,
		isSelected = isSelected,
		textButtonRef = v156,
		widgetAnalyticsInfo = t3.widgetAnalyticsInfo,
		isOrganic = t3.isOrganic,
		sendCatalogItemClickAnalytics = v198
	})
	local v201 = if itemType ~= ItemTypeEnum.Look then v199 else v200
	local v202 = if not FFlagAXMISEnableMultiShopping then nil else React.useCallback(function() -- line: 860
		-- upvalues: itemType (copy), ItemTypeEnum (copy), isSelected (copy), v173 (copy), AvatarScreen (copy), v176 (copy), lookData (copy), Constants (copy), v165 (copy), v167 (copy), v201 (copy), v197 (copy)
		local v249 = itemType == ItemTypeEnum.Look

		if not isSelected and (v173 ~= AvatarScreen.MySharedAvatars and v249) and (v176 and next(v176) ~= nil and lookData and lookData.lookType ~= Constants.LookType.Makeup and v165 and v165.shouldShowWearAvatarReplaceAllItemsPrompt()) then
			v167.navigate(AvatarScreen.WearAvatarReplaceAllItemsPrompt, {
				onConfirm = function(p17) -- line: 875
					-- upvalues: v165 (copy), v201 (copy), v197 (copy)
					if p17 then
						v165.hideWearAvatarReplaceAllItemsPrompt()
					end

					if v201 then
						v201()

						return
					end

					v197()
				end
			})

			return
		end

		if v201 then
			v201()

			return
		end

		v197()
	end, {
		itemType,
		v197,
		isSelected,
		v176,
		v165,
		v173,
		v167,
		lookData,
		v201
	})
	local v203 = if not FFlagAXCatalogMakeupSupport then nil else React.useCallback(function() -- line: 910
		-- upvalues: itemId (copy), itemType (copy), getTryOnItemReducerKey (copy), v176 (copy), Constants (copy), FFlagAXMISEnableMultiShopping (copy), u106 (ref), MAX_MAKEUP_LAYERS (copy), v177 (copy), v166 (copy), itemData (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), v167 (copy), AvatarScreen (copy), v201 (copy), v197 (copy)
		local v250 = nil

		if itemId and itemType then
			v250 = getTryOnItemReducerKey(itemId, itemType)
		end

		local v251 = v176 and (not v176[v250] and itemType == Constants.ItemType.Asset)
		local v252 = if not FFlagAXMISEnableMultiShopping or (not v251 or not v176) then nil else u106(v176)
		local v253 = FFlagAXMISEnableMultiShopping and (v252 and #v252 == MAX_MAKEUP_LAYERS)
		local v254 = FFlagAXMISEnableMultiShopping and (v177 and (v252 and #v177 + #v252 >= MAX_MAKEUP_LAYERS))

		if v166 and v166.shouldShowMakeupMax6LayersPrompt() and itemData and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[itemData.assetType] and v251 and (v177 and #v177 == MAX_MAKEUP_LAYERS or v253 or v254) then
			v167.navigate(AvatarScreen.MakeupMax6LayersPrompt, {
				onConfirm = function(p18) -- line: 946
					-- upvalues: v166 (copy), v201 (copy), v197 (copy)
					if p18 then
						v166.hideMakeupMax6LayersPrompt()
					end

					if v201 then
						v201()

						return
					end

					v197()
				end
			})

			if FFlagAXMISEnableMultiShopping then
				v166.incrementSeenMakeupMax6LayersPrompt()

				return
			end
		else
			if v201 then
				v201()

				return
			end

			v197()
		end
	end, {
		v166,
		v167,
		v197,
		itemData,
		v177,
		v176,
		itemId,
		itemType,
		v201
	})
	local v204 = React.useCallback(function(_: number) -- line: 983
		-- upvalues: t3 (copy), itemId (copy)
		if t3.onThumbnailLoaded then
			t3.onThumbnailLoaded(itemId)
		end
	end, { t3.onThumbnailLoaded })
	local v205 = React.useMemo(function() -- line: 989
		-- upvalues: lookData (copy), Cryo (copy)
		if lookData then
			local v256 = Cryo.List.map(if not lookData.assets then {} else lookData.assets, function(p19) -- line: 991
				return p19.id
			end)
			local v257 = Cryo.List.map(if not lookData.bundles then {} else lookData.bundles, function(p20) -- line: 994
				return p20.id
			end)

			return {
				assetIds = v256,
				bundleIds = v257
			}
		end

		return {}
	end, { lookData })
	local v206 = t3.hydratedContent or {
		price = nil
	}
	local v207 = if not t3.gridInformation then nil else t3.gridInformation.gridPositionRow
	local v208 = if not t3.gridInformation then nil else t3.gridInformation.gridPositionColumn
	local v209 = if itemType ~= "Look" then if itemType ~= "Asset" then UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE else UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET else UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK
	local v210 = React.useCallback(function(p21) -- line: 1019
		-- upvalues: v156 (copy), t3 (copy), itemType (copy), lookData (copy), v206 (copy), itemId (copy), itemData (copy), addUnifiedEventLogging (copy), Cryo (copy), v207 (copy), v208 (copy), v209 (copy), isSelected (copy), UnifiedEventLogEnums (copy), v205 (copy), UnifiedEventLoggingUtils (copy), getTimedOptionForItemData (copy), FFlagAddTypesToWidgetItems (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLogConstants (copy)
		if p21 then
			v156.current = p21

			local v259 = nil
			local v260 = nil
			local v261 = nil

			if t3.widgetAnalyticsInfo then
				if itemType == "Look" then
					v259 = not not lookData and lookData.totalPrice ~= nil
					v260 = not not t3.widgetAnalyticsInfo and t3.widgetAnalyticsInfo.itemId ~= nil
					v261 = true
				else
					v259 = not not v206 and v206.price ~= nil
					v260 = not not t3.widgetAnalyticsInfo and t3.widgetAnalyticsInfo.itemId ~= nil
					v261 = true
				end
			elseif t3.isOrganic then
				if itemType == "Look" then
					v259 = not not lookData and lookData.totalPrice ~= nil
					v260 = itemId ~= nil
					v261 = true
				else
					v259 = not not itemData and (itemData.lowestPrice ~= nil or itemData.priceInRobux ~= nil)
					v260 = itemId ~= nil
					v261 = not not itemData and (itemData.assetType ~= nil or itemData.bundleType ~= nil and itemData.bundleType ~= "AvatarAnimations")
				end
			end

			if v259 and v260 and v261 then
				addUnifiedEventLogging(v156, Cryo.Dictionary.join(t3.widgetAnalyticsInfo or {
					itemId = itemId,
					assetType = if not itemData then nil else itemData.assetType,
					bundleType = if not itemData then nil else itemData.bundleType,
					gridPositionRow = v207,
					gridPositionColumn = v208
				}, {
					itemType = v209,
					action = if not isSelected then UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED else UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_DESELECTED,
					category = t3.impressionsCategory,
					subcategory = t3.impressionsSubcategory,
					taxonomyId = t3.impressionsTaxonomyId,
					assetIds = if not t3.widgetAnalyticsInfo or not v205 then nil else v205.assetIds,
					bundleIds = if not t3.widgetAnalyticsInfo or not v205 then nil else v205.bundleIds,
					organicAssetIds = if not t3.isOrganic or not v205 then nil else v205.assetIds,
					organicBundleIds = if not t3.isOrganic or not v205 then nil else v205.bundleIds,
					organicLookType = if not t3.isOrganic or not lookData then nil else UnifiedEventLoggingUtils.formatLookTypeAttribute(lookData.lookType),
					widgetLookType = if not lookData or t3.isOrganic then nil else UnifiedEventLoggingUtils.formatLookTypeAttribute(lookData.lookType),
					organicItemPrice = if not t3.isOrganic then nil else if not lookData then if not itemData then nil else itemData.lowestPrice or itemData.priceInRobux else lookData.totalPrice,
					widgetItemPrice = if not t3.widgetAnalyticsInfo then nil else if not lookData then v206.price else lookData.totalPrice,
					organicTimedOption = if not t3.isOrganic then nil else getTimedOptionForItemData(itemData),
					widgetTimedOption = if t3.isOrganic then nil else getTimedOptionForItemData(itemData),
					widgetAssetType = if not FFlagAddTypesToWidgetItems or (t3.isOrganic or not itemData) then nil else itemData.assetType,
					widgetBundleType = if not FFlagAddTypesToWidgetItems or (t3.isOrganic or not itemData) then nil else itemData.bundleType
				}), {
					hasDeferredActions = true,
					isSelected = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else isSelected,
					sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
				})
			end
		end
	end, {
		t3.widgetAnalyticsInfo,
		t3.hydratedContent,
		itemId,
		v209,
		itemData,
		v207,
		v208,
		isSelected,
		t3.impressionsCategory,
		t3.impressionsSubcategory,
		t3.impressionsTaxonomyId,
		v205,
		lookData
	})
	local v211 = React.useCallback(function() -- line: 1153
		-- upvalues: itemId (copy), itemType (copy), ItemTypeEnum (copy), FFlagAXMISEnableMultiShopping (copy), v173 (copy), AvatarScreen (copy), v169 (copy), TryOnLookV2 (copy), v162 (copy), v167 (copy), t3 (copy), PeekViewState (copy), OpenItemDetails (copy), CatalogUtils (copy), itemData (copy), v164 (copy), v168 (copy)
		if itemId and itemType then
			if itemType == ItemTypeEnum.Look then
				local n3 = 2

				if FFlagAXMISEnableMultiShopping and v173 ~= AvatarScreen.MySharedAvatars then
					n3 = 1
				end

				v169(TryOnLookV2(v162, v167, t3.widgetAnalyticsInfo, itemId, PeekViewState.Full, n3))

				return
			end

			v169(OpenItemDetails({
				showFullWithNoPeekView = true,
				itemId = itemId,
				itemType = itemType,
				itemSubType = CatalogUtils.GetItemSubType(itemType, itemData),
				priceInRobux = if not itemData then nil else itemData.priceInRobux,
				catalogAnalytics = v164,
				avatarRoute = v168,
				navigation = v167,
				itemDetailsPeekViewRefs = t3.itemDetailsPeekViewRefs,
				resultsListRef = t3.resultsListRef,
				widgetInfo = t3.widgetAnalyticsInfo
			}))
		end
	end, {
		v169,
		itemId,
		itemType,
		itemData,
		v162,
		v167,
		t3.widgetAnalyticsInfo,
		v164,
		v168,
		t3.itemDetailsPeekViewRefs,
		t3.resultsListRef
	})
	local v212 = useCatalogItemCardFocusNavigationBindings({
		onOpenItemDetailsPage = v211
	}, v210)

	React.useEffect(function() -- line: 1207
		-- upvalues: v157 (copy), t3 (copy), OrganicEventImpressionsSchema (copy), ImpressionsUtil (copy)
		local current = v157.current

		if current and t3.impressionsId then
			current:SetAttribute(t3.impressionsTag, t3.impressionsId)

			local v264 = OrganicEventImpressionsSchema[t3.impressionsSchema]

			ImpressionsUtil.writeItemAttributes(v264, current, t3)
		end
	end, {
		t3.impressionsId,
		t3.impressionsTag,
		t3.impressionsSchema
	})

	local cardStyle = t3.cardStyle
	local tileWidth = t3.tileWidth
	local thumbailAspectRatio = t3.thumbailAspectRatio
	local v216 = itemData and itemData.name
	local u217 = itemData and (itemData.lowestPrice or itemData.priceInRobux) or nil
	local v218 = itemData and itemData.priceStatus
	local moderationStatus = nil

	if itemData and itemData.timedOptions then
		for _, v221 in itemData.timedOptions do
			if v221.selected then
				u217 = v221.price
			end
		end
	end

	if t3.itemType == ItemTypeEnum.Look then
		u217 = lookData and lookData.totalPrice
		v216 = lookData and lookData.name

		if v173 == AvatarScreen.MySharedAvatars and lookData and lookData.owned then
			moderationStatus = lookData.moderationStatus
		end
	end

	local v222 = React.useMemo(function() -- line: 1243
		-- upvalues: t3 (copy), ItemTypeEnum (copy), lookData (copy), itemData (copy)
		if t3.isCreatorNameVisible then
			if t3.itemType == ItemTypeEnum.Look then
				local v265 = lookData

				if v265 and v265.curator and v265.curator.name then
					return {
						name = v265.curator.name,
						verified = if not v265 or not v265.curator then nil else v265.curator.hasVerifiedBadge
					}
				end

				return nil
			end

			local v266 = itemData

			if v266 and v266.creator then
				local v267 = v266.creator.name or v266.creatorName

				if v267 then
					return {
						name = v267,
						verified = v266.creator.hasVerifiedBadge
					}
				end
			end

			return nil
		end

		return nil
	end, {
		lookData,
		itemData,
		t3.itemType,
		t3.isCreatorNameVisible,
		t3.creatorNameTileFooterEnabled
	})
	local v223 = if not FFlagAXDurablesFooter or (not v180 or not (v180 > 0)) then nil else v181.timedOptionDays
	local v224 = React.useMemo(function() -- line: 1265
		-- upvalues: t3 (copy), v218 (copy), u217 (ref), v88 (copy), v180 (copy), Foundation (copy), v223 (copy), FFlagAXDurablesFooter (copy)
		local v268 = if not t3.isPriceVisible then nil else if not v218 then if not u217 then nil else {
			type = "price",
			price = u217 or 0
		} else {
			type = "text",
			text = v218
		}

		if v88 and v180 then
			return {
				type = "multi",
				contents = {
					v268,
					{
						type = "timedOption",
						icon = Foundation.Enums.IconName.Clock,
						text = v223 or ""
					}
				}
			}
		end

		if FFlagAXDurablesFooter and v223 and v268 then
			return {
				type = "multi",
				contents = {
					v268,
					{
						type = "timedOption",
						icon = Foundation.Enums.IconName.Clock,
						text = v223
					}
				}
			}
		end

		return v268
	end, {
		t3.isPriceVisible,
		v218,
		u217,
		v223,
		v180
	})
	local v225 = nil

	if FFlagAXShowFaeUpsell then
		v225 = GetFaeFeatureAccessStore.useFaeFeatureAccess()
	end

	local v226 = if not FFlagAXInventoryDurablesExpiredFilter then nil else getItemCardStatus(t3.itemStatusOverride, t3.itemType, moderationStatus, v181.statusText, itemData, if not FFlagAXShowFaeUpsell then nil else v225)
	local t5 = {
		ref = v212,
		animationTabsItemData = if not v175.showAnimationTabs then nil else itemData,
		onActivated = if not FFlagAXCatalogMakeupSupport or itemType ~= Constants.ItemType.Asset then if not FFlagAXMISEnableMultiShopping or itemType ~= ItemTypeEnum.Look then v201 else v202 else v203,
		onOverlayButtonActivated = if not v160 then v195 else nil,
		overlayButtonText = if not v160 then if not FFlagAXMISEnableMultiShopping then if t3.itemType ~= ItemTypeEnum.Look then v181.details else v181.detailsWithItemsCount else v181.details else nil,
		thumbnailRef = v157,
		thumbnailTag = t3.impressionsTag,
		thumbnailUrl = v193,
		onThumbnailLoaded = v204,
		thumbnailRect = v192,
		priceLineContent = v224,
		creator = v222,
		title = if not t3.isTitleVisible then nil else v216
	}
	local v228

	if t3.itemType == ItemTypeEnum.Look then
		v228 = nil
	else
		local v229 = if not itemData then nil else itemData.tileRestrictionsMap

		v228 = if not v229 then nil else if not v229[ItemTileEnums.Restriction.Limited] then if not v229[ItemTileEnums.Restriction.LimitedUnique] and not v229[ItemTileEnums.Restriction.Collectible] then nil else "Collectible" else "Limited"
	end

	t5.itemType = v228
	t5.itemInfo = if t3.itemType ~= ItemTypeEnum.Look then if not itemData or itemData.bundleType ~= Constants.BundleTypeIdStrings.DynamicHead then nil else "DynamicHead" else nil
	t5.itemStatus = if not FFlagAXInventoryDurablesExpiredFilter then if t3.itemType ~= ItemTypeEnum.Look then if not v181.statusText then showDurableBadge(itemData) else {
		type = "text",
		text = v181.statusText
	} else getLookStatusFromModerationStatus(moderationStatus) else v226
	t5.headerAspectRatio = if not tileWidth or not not FFlagAXLookAndFeelBackgrounds and (not not cardStyle and cardStyle.backgroundLayers) then thumbailAspectRatio else nil
	t5.headerSize = if not tileWidth or not not FFlagAXLookAndFeelBackgrounds and (not not cardStyle and cardStyle.backgroundLayers) then nil else UDim2.fromOffset(tileWidth, tileWidth / (thumbailAspectRatio or 1))
	t5.isSelected = isSelected
	t5.backgroundLayers = if not FFlagAXLookAndFeelBackgrounds or not cardStyle then nil else cardStyle.backgroundLayers
	t5.imageScaleType = if not FFlagAXLookAndFeelBackgrounds then nil else t3.imageScaleType

	return t5
end

return useCatalogItemCardViewModel
