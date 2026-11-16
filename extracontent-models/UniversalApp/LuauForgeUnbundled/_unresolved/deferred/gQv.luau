local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local itemTileEnums = UIBlox.Tile.ItemTileEnums
local React = require(CorePackages.Packages.React)
local tutils = require(CorePackages.Packages.tutils)

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local module = require("@luauforge/bundled/cgr")
local constants = module.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = module.Utils.getRbxthumbWithTypeSizeAndOptions
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums
local addUnifiedEventLogging = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").addUnifiedEventLogging

local unifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogConstants

local fFlagAXNegativeAvatarSequenceFeatures = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXNegativeAvatarSequenceFeatures
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef
local catalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local catalogItemCardItemInfoEnum = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCardItemInfoEnum
local itemCardThumbnail = require("@luauforge/deferred/gkN").ItemCardComponents.ItemCardThumbnail

local catalogItemCardStatusIconTypeEnum = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCardStatusIconTypeEnum
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local useLastInput = Responsive.useLastInput
local useIsSpatial = Responsive.useIsSpatial
local input = Responsive.Input

local module6 = require("@luauforge/bundled/dYT")
local module7 = require("@luauforge/bundled/eda")
local logOnOverlayClosed = AvatarExperienceNavigation.Debug.logOnOverlayClosed
require("@luauforge/bundled/dHK")
local module8 = require("@luauforge/bundled/dNQ")
local module9 = require("@luauforge/bundled/geT")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module10 = require("@luauforge/bundled/fuC")
local module11 = require("@luauforge/bundled/gfg")
local module12 = require("@luauforge/deferred/gOC")
local module13 = require("@luauforge/bundled/fvg")
local module14 = require("@luauforge/bundled/fuD")
local module15 = require("@luauforge/bundled/dRQ")
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local module16 = require("@luauforge/bundled/dMx")
local module17 = require("@luauforge/bundled/dNQ")
local module18 = require("@luauforge/bundled/gnZ")
local fullView = AvatarExperienceCommon.Enums.FullView
local module19 = require("@luauforge/bundled/dTM")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock
local module20 = require("@luauforge/deferred/ggD")
local module21 = require("@luauforge/bundled/fvF")
local module22 = require("@luauforge/bundled/gfm")

local impressionsUtil = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").ImpressionsReporter.ImpressionsUtil

local organicEventImpressionsSchema = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").ImpressionsReporter.OrganicEventImpressionsSchema
local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling
local module23 = require("@luauforge/bundled/gQw")
local module24 = require("@luauforge/bundled/dOc")
local module25 = require("@luauforge/deferred/gQx")
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local fFlagAXModeratedItemsFlow = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXModeratedItemsFlow

local fFlagAXEditorEnableThumbnailLatencyStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXEditorEnableThumbnailLatencyStore

local defineFastFlag = game:DefineFastFlag("AvatarEditorItemCardWaitForData", false)
local defineFastFlag2 = game:DefineFastFlag("AXDoNotDoubleToggleEmoteWithGamepad", false)

local memo = React.memo(function(props)
	local v5 = useDispatch()
	local v6 = useNavigation()
	local v7 = useAvatarRoute()
	local v8 = useAdaptiveScrolling()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v9 = useLastInput()
	local v10 = useIsSpatial()
	local v11 = useRoactService(module6)
	local v12 = useRoactService(module9)
	local v13 = useRoactService(module21)
	local v14 = useRoactService(avatarExperienceAnalyticsService)
	local v15 = useRoactService(module7)
	local v16 = if module24() then useTokens() else nil

	local itemId = props.itemId
	local isOutfit = props.isOutfit
	local v17 = if props.isWearingAssetOrOutfit then props.isWearingAssetOrOutfit else false

	local v18 = useSelector(React.useCallback(function(p2)
		local avatarEditorCategoryInfoFromState = module14.getAvatarEditorCategoryInfoFromState(p2)
		local outfitInfo = p2.AvatarExperience.AvatarEditor.OutfitInfos[itemId]
		local v19 = nil
		local name = nil
		local v20 = nil

		local v21 = if isOutfit then module16.ItemType.Bundle else module16.ItemType.Asset
		local v22 = itemData(p2.AvatarExperience.Common, itemId, v21)

		if itemId then
			if isOutfit then
				if not (avatarEditorCategoryInfoFromState.HideTextUnderTile or not outfitInfo) then
					name = outfitInfo.name or nil
				end

				v20 = getRbxthumbWithTypeSizeAndOptions(itemId, constants.RbxthumbTypes.Outfit, 150)

				if outfitInfo then
					v20 ..= "&filters=" .. outfitInfo.updateCounter

					if module14.isModerationPendingOrRejected(outfitInfo.moderationStatus) then
						v20 = module8.BrokenAvatarThumbnail
					end
				end
			else
				if v22 then
					v19 = v22.assetType or nil
				end

				if not (avatarEditorCategoryInfoFromState.HideTextUnderTile or not v22) then
					name = v22.name or nil
				end

				v20 = getRbxthumbWithTypeSizeAndOptions(itemId, constants.RbxthumbTypes.Asset, 150)

				if v22 and v22.outfitModerationStatus then
					v20 ..= `&filters=__{v22.outfitModerationStatus}__`
				end

				if v22 and v22.moderationStatus then
					v20 ..= "&filters=" .. (v22.updateCounter or 0)
				end
			end
		end

		local avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType
		local v23 = p2.AvatarExperience.Common.FullView[avatarScreen.AvatarEditor] == fullView.UIFullView

		if module24() then
			v23 = p2.AvatarExperience.Common.FullView[v7.opaque.name] == fullView.UIFullView
		end

		local v24 = if isOutfit and outfitInfo then module14.getItemStatusStyleFromOutfit(outfitInfo) else nil

		local v25 = if isOutfit and outfitInfo then module14.getItemIconTypeFromOutfit(outfitInfo) else nil

		if isOutfit then
			v19 = module17.Outfits
		end

		local v26 = if outfitInfo then outfitInfo.isEditable else false
		local v27

		if outfitInfo then
			v27 = outfitInfo.outfitType == module16.OutfitTypes.DynamicHead and not v26
		else
			v27 = outfitInfo
		end

		local v28 = not (v27 or props.hasItemFromCurrentPageEquipped)
		local v29

		if outfitInfo then
			if outfitInfo.creatingUniverseId == nil then
				v29 = false
			else
				v29 = string.len(outfitInfo.creatingUniverseId) > 0
			end
		else
			v29 = outfitInfo
		end

		local v30 = v17

		if v30 then
			v30 = not (isOutfit and not v29)
		end

		local v31 = {
			itemData = v22,
			itemType = v21,
			modifiedAssetType = v19,
			name = name,
			thumbnail = v20,
			isUIFullView = v23,
			outfitInfo = outfitInfo,
			categoryInfo = avatarEditorCategoryInfoFromState,
			avatarTypeIsR6 = avatarType == module16.AvatarType.R6,
			hasAvatarData = module23(p2),
			isPortrait = module22(p2),
			itemStatusStyle = v24,
			isEquippable = v24 == nil,
			iconType = 0,
			shouldConfirmEquip = 0,
			canShowDetails = 0,
			dataLoaded = 0
		}

		if v25 == itemTileEnums.ItemIconType.Bundle then
			v25 = nil
		end

		v31.iconType = v25
		v31.shouldConfirmEquip = v28
		v31.canShowDetails = v30

		if defineFastFlag then
			if isOutfit then
				v22 = outfitInfo
			end
		else
			v22 = nil
		end

		v31.dataLoaded = v22
		return v31
	end, { itemId, isOutfit, v7 }), tutils.deepEqual)
	local categoryInfo = v18.categoryInfo
	local itemType = v18.itemType
	local itemData2 = v18.itemData
	local assetType = if itemData2 then itemData2.assetType else nil
	local isPortrait = v18.isPortrait

	local v19 = v9 == input.Directional and not v10

	local v20 = React.useCallback(function()
		logOnOverlayClosed("ItemCard", v19)
	end, { v19 })

	local v21 = React.useCallback(function(p2, p3)
		if not v8 then
			return
		end

		if p2 then
			v8.setSelectedItemInstance(nil)
			return
		end

		local current = ref.current

		if current and p3 then
			v8.setSelectedItemInstance(current)
		end
	end, { v8 })

	local v22 = React.useCallback(function()
		local flag = false
		local v23 = nil

		if categoryInfo.PageType == module16.PageType.Animation then
			flag = true
			v23 = "Feature.Avatar.Message.R15AnimationsPrompt"
		elseif categoryInfo.PageType == module16.PageType.Emotes then
			flag = true
			v23 = "Feature.Avatar.Message.R15EmotesPrompt"
		end

		if flag then
			v5(navigateWithLock(function()
				v6.navigate(avatarScreen.R15UpgradePrompt, {
					onOverlayClosed = v20,
					bodyTextKey = v23
				})
			end))
		end
	end, { v6, v5, v20 })

	local useCallback = React.useCallback
	local function fn()
		if defineFastFlag and not v18.dataLoaded then
			return
		end

		local modifiedAssetType = v18.modifiedAssetType

		if v18.avatarTypeIsR6 then
			v22()
		end

		local v23 = modifiedAssetType == module16.AssetTypeIdStrings.HairAccessory

		local v24 = not (module16.LayeredAssetTypes[modifiedAssetType] == nil) and not v23

		if v18.avatarTypeIsR6 and not v17 and v24 then
			v5(navigateWithLock(function()
				v6.navigate(avatarScreen.R15UpgradePrompt, {
					onOverlayClosed = v20,
					bodyTextKey = "Feature.Avatar.Label.LayeredClothingR15Warning",
					onSwitchSelected = function()
						v21(v17, (v5(module13(modifiedAssetType, itemId, v6))))
					end
				})
			end))
			return
		end

		if isOutfit then
			local outfitInfo = v18.outfitInfo

			if outfitInfo then
				if v18.shouldConfirmEquip then
					v5(navigateWithLock(function()
						v6.navigate(avatarScreen.EquipOutfitConfirmation, {
							onOverlayClosed = v20,
							outfitInfo = outfitInfo,
							onEquip = function(p2)
								v21(v17, p2)
							end
						})
					end))
				else
					v21(
						v17,
						(v5(module11({
							outfitInfo = outfitInfo,
							analytics = v12,
							navigation = v6,
							isSelected = v17
						})))
					)
				end
			else
				logging.warn("Tried equipping a costume without any costume data!")
			end
		else
			if modifiedAssetType then
				local v27 = if v17 then v12.unequipAsset else v12.equipAsset
				v5(module12(v27, itemId, modifiedAssetType))
			end

			v21(v17, (v5(module13(modifiedAssetType, itemId, v6))))
		end

		if not v17 and v18.isUIFullView then
			if module24() then
				v5(module18(v14, v7.opaque.name, fullView.None))
			else
				v5(module18(v14, avatarScreen.AvatarEditor, fullView.None))
			end
		end
	end

	local isUIFullView = v18.isUIFullView
	local modifiedAssetType = v18.modifiedAssetType
	local avatarTypeIsR6 = v18.avatarTypeIsR6
	local shouldConfirmEquip = v18.shouldConfirmEquip
	local outfitInfo = v18.outfitInfo
	local v24 = if defineFastFlag then isOutfit else nil
	local v25 = if defineFastFlag then v18.dataLoaded else nil
	local v26 = useCallback(fn, {
		v14,
		v17,
		isUIFullView,
		modifiedAssetType,
		avatarTypeIsR6,
		shouldConfirmEquip,
		outfitInfo,
		v12,
		itemId,
		v21,
		v22,
		v6,
		v5,
		v20,
		v24,
		v25
	})

	local v27 = React.useCallback(function()
		if isOutfit then
			local v28 = {
				outfitId = itemId,
				ZIndex = 2,
				showFullWithNoPeekView = not isPortrait,
				renderBottomBar = false,
				NextSelectionLeft = 0,
				outfitDetailsPeekViewRefs = 0
			}

			local v29 = if not isPortrait then props.resultsListRef or nil else nil
			v28.NextSelectionLeft = v29
			v28.outfitDetailsPeekViewRefs = props.itemDetailsPeekViewRefs

			v5(navigateWithLock(function()
				module19.closeFiltersAndItemDetails(v6)

				module19.closeTryOnManager(v6)
				v6.navigate(avatarScreen.OutfitDetails, v28)
			end))
		else
			local itemSubType = module15.GetItemSubType(itemType, itemData2)
			local v28 = if itemData2 then itemData2.priceInRobux else nil

			v5(module20({
				itemId = itemId,
				itemType = itemType,
				itemSubType = itemSubType,
				priceInRobux = v28,
				isPortrait = isPortrait,
				catalogAnalytics = v13,
				avatarRoute = v7,
				navigation = v6,
				itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
				resultsListRef = props.resultsListRef,
				mountAsFullView = nil,
				showFullWithNoPeekView = true,
				closePreviousItemDetails = true
			}))
		end
	end, {
		v5,
		v6,
		isOutfit,
		itemId,
		v13,
		v7,
		itemType,
		itemData2,
		props.itemDetailsPeekViewRefs,
		props.resultsListRef
	})

	local v28 = React.useCallback(function()
		if itemData2 and module14.isModerationPendingOrRejected(itemData2.moderationStatus) then
			local v29 = if fFlagAXModeratedItemsFlow then not assetType and "Feature.Catalog.Label.Bundle" or module16.AssetTypeLocalized[assetType] else nil

			v6.navigate(avatarScreen.ItemsUnavailablePrompt, {
				items = {
					{
						category = itemType,
						categoryLoc = v29,
						itemName = itemData2.name
					}
				},
				messageType = module14.getMessageTypeFromModerationStatus(itemData2.moderationStatus)
			})
		elseif v18.isEquippable then
			v26()
		else
			v27()
		end
	end, { v18.isEquippable, v27, v26 })

	local ref3 = React.useRef(nil)
	React.useEffect(function()
		local current = ref.current

		if props.impressionsTag and current then
			current:SetAttribute(props.impressionsTag, itemId)

			local v29 = organicEventImpressionsSchema[props.impressionsSchema]
			impressionsUtil.writeItemAttributes(v29, current, props)
		end

		local category = categoryInfo.Category
		local subcategory = categoryInfo.Subcategory

		local v32 = if v17 then unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_DESELECTED else unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED
		local v31 = {
			action = v32,
			itemId = itemId,
			itemType = 0,
			assetType = 0,
			gridPositionRow = 0,
			gridPositionColumn = 0,
			category = 0,
			subcategory = 0,
			isOwnedItem = 0
		}

		local v33 = if itemType == "Asset" then unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET else unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
		v31.itemType = v33

		v31.assetType = assetType
		local v34 = if props.gridInformation then props.gridInformation.row else nil
		v31.gridPositionRow = v34
		local v35 = if props.gridInformation then props.gridInformation.column else nil
		v31.gridPositionColumn = v35

		local v36 = if category then module14.getAvatarEditorCategoryInfo(category).Name else nil
		v31.category = v36

		local v37 = if category and subcategory then module14.getAvatarEditorCategoryInfo(category, subcategory).Name else nil
		v31.subcategory = v37

		v31.isOwnedItem = fFlagAXNegativeAvatarSequenceFeatures and true or nil
		addUnifiedEventLogging(ref2, v31, {
			sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME
		})

		if not itemId or isOutfit or ref3.current == itemId or itemId == module17.AddOutfitButton then
			return
		end

		ref3.current = itemId

		if not v18.name then
			v5(module10(v15, v11, itemId, module16.ItemType.Asset))
		end
	end, {
		v5,
		v15,
		v11,
		itemId,
		v18.name,
		isOutfit,
		categoryInfo.Category,
		categoryInfo.Subcategory,
		itemType,
		v17,
		props.gridInformation,
		assetType
	})

	local v31 = if v18.canShowDetails then v27 else nil
	local v32

	if categoryInfo.PageType == module16.PageType.Emotes and not v17 then
		v32 = defineFastFlag2 and function() end or v28
	end

	local v33

	if categoryInfo.PageType == module16.PageType.Emotes and v17 then
		v33 = defineFastFlag2 and function() end or v28
	end

	local v34 = useTableWrappedCallbackRef((module25(
		{ onOpenEditorDetailsPage = v31, onSlotEmote = v32, onUnslotEmote = v33 },
		ref
	)))

	local v35 = useLocalization({ details = "Feature.Avatar.Label.DetailsButton" })
	local v36

	if itemData2 and module14.isModerationPendingOrRejected(itemData2.moderationStatus) then
		v36 = {
			type = "placeholder",
			iconType = if itemData2.moderationStatus == Enum.ModerationStatus.NotReviewed then catalogItemCardStatusIconTypeEnum.PendingModeration else catalogItemCardStatusIconTypeEnum.Moderated
		}
	end

	local createElement = React.createElement
	local v38 = {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		isSelected = v17,
		title = v18.name,
		itemInfo = 0,
		onActivated = 0,
		overlayButtonText = 0,
		onOverlayButtonActivated = 0,
		ref = 0,
		titleTextSize = 0,
		presentationSlot = 0,
		itemStatus = 0
	}
	local v39 = if v18.iconType == itemTileEnums.ItemIconType.DynamicHead then catalogItemCardItemInfoEnum.DynamicHead else nil
	v38.itemInfo = v39

	if not (itemId and v18.hasAvatarData) then
		v28 = nil
	end

	v38.onActivated = v28
	local v40 = if v18.canShowDetails then v35.details else nil
	v38.overlayButtonText = v40
	local v41 = if v18.canShowDetails then v27 else nil
	v38.onOverlayButtonActivated = v41
	v38.ref = v34
	local v42

	if module24() then
		if props.titleFontStyle then
			v42 = props.titleFontStyle
		elseif v16 then
			v42 = v16.Typography.CaptionSmall
		end
	end

	v38.titleTextSize = v42
	local v43

	if v18.thumbnail then
		local createElement2 = React.createElement
		local v45 = {
			url = v18.thumbnail,
			tag = props.impressionsTag,
			ref = ref,
			onLoaded = 0
		}

		local v46 = if fFlagAXEditorEnableThumbnailLatencyStore then props.onThumbnailLoaded else nil
		v45.onLoaded = v46
		v43 = createElement2(itemCardThumbnail, v45)
	end

	v38.presentationSlot = v43

	v38.itemStatus = v36
	return createElement(catalogItemCard, v38)
end)

return (React.memo(memo, tutils.deepEqual))
