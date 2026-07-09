local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local ItemTileEnums = require(CorePackages.Packages.UIBlox).Tile.ItemTileEnums
local React = require(CorePackages.Packages.React)
local tutils = require(CorePackages.Packages.tutils)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local addUnifiedEventLogging = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).addUnifiedEventLogging
local UnifiedEventLogConstants = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogConstants
local FFlagAXNegativeAvatarSequenceFeatures = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXNegativeAvatarSequenceFeatures
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local useTableWrappedCallbackRef = AvatarExperienceCommon.Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local CatalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local CatalogItemCardItemInfoEnum = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCardItemInfoEnum
local ItemCardThumbnail = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).ItemCardComponents.ItemCardThumbnail
local CatalogItemCardStatusIconTypeEnum = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCardStatusIconTypeEnum
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useLastInput = Responsive.useLastInput
local useIsSpatial = Responsive.useIsSpatial
local Input = Responsive.Input
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local logOnOverlayClosed = AvatarExperienceNavigation.Debug.logOnOverlayClosed

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.Common.Services.Analytics)
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)
local EquipOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.EquipOutfit)
local SendAnalytics = require(Modules.AvatarExperience.AvatarEditor.Thunks.SendAnalytics)
local ToggleEquipAsset = require(Modules.AvatarExperience.AvatarEditor.Thunks.ToggleEquipAsset)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local Constants3 = require(Modules.AvatarExperience.Common.Constants)
local Constants4 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local FullView = AvatarExperienceCommon.Enums.FullView
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local OpenItemDetails = require(Modules.AvatarExperience.Common.Thunks.OpenItemDetails)
local Analytics3 = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local ImpressionsUtil = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).ImpressionsReporter.ImpressionsUtil
local OrganicEventImpressionsSchema = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).ImpressionsReporter.OrganicEventImpressionsSchema
local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling
local selectHasAvatarData = require(Modules.AvatarExperience.Common.Selectors.selectHasAvatarData)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local useItemCardFocusNavigationBindings = require(script.Parent.useItemCardFocusNavigationBindings)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local v63 = game:DefineFastFlag("AvatarEditorItemCardWaitForData", false)
local v64 = game:DefineFastFlag("AXDoNotDoubleToggleEmoteWithGamepad", false)
local v65 = React.memo(function(t1: {[any]: any}) -- line: 103
	-- upvalues: useDispatch (copy), useNavigation (copy), useAvatarRoute (copy), useAdaptiveScrolling (copy), React (copy), useLastInput (copy), useIsSpatial (copy), useRoactService (copy), RoactAnalytics (copy), Analytics (copy), Analytics3 (copy), Analytics2 (copy), RoactNetworking (copy), GetFFlagAXEnableSlotBasedEditor (copy), useTokens (copy), Utils (copy), Constants3 (copy), ItemData (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants2 (copy), AvatarScreen (copy), FullView (copy), Constants4 (copy), selectHasAvatarData (copy), selectIsPortrait (copy), ItemTileEnums (copy), v63 (copy), useSelector (copy), tutils (copy), Input (copy), logOnOverlayClosed (copy), NavigateWithLock (copy), ToggleEquipAsset (copy), EquipOutfit (copy), Logging (copy), SendAnalytics (copy), SetFullView (copy), NavigationUtils (copy), CatalogUtils (copy), OpenItemDetails (copy), FFlagAXModeratedItemsFlow (copy), OrganicEventImpressionsSchema (copy), ImpressionsUtil (copy), addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), FFlagAXNegativeAvatarSequenceFeatures (copy), UnifiedEventLogConstants (copy), FetchAssetOrBundleInfo (copy), useItemCardFocusNavigationBindings (copy), v64 (copy), useTableWrappedCallbackRef (copy), useLocalization (copy), CatalogItemCardStatusIconTypeEnum (copy), CatalogItemCard (copy), CatalogItemCardItemInfoEnum (copy), ItemCardThumbnail (copy)
	local v67 = useDispatch()
	local v68 = useNavigation()
	local v69 = useAvatarRoute()
	local v70 = useAdaptiveScrolling()
	local v71 = React.useRef(nil)
	local v72 = React.useRef(nil)
	local v73 = useLastInput()
	local v74 = useIsSpatial()
	local v75 = useRoactService(RoactAnalytics)
	local v76 = useRoactService(Analytics)
	local v77 = useRoactService(Analytics3)
	local v78 = useRoactService(Analytics2)
	local v79 = useRoactService(RoactNetworking)
	local v80 = if not GetFFlagAXEnableSlotBasedEditor() then nil else useTokens()
	local itemId = t1.itemId
	local isOutfit = t1.isOutfit
	local v83 = not not t1.isWearingAssetOrOutfit and t1.isWearingAssetOrOutfit
	local v84 = React.useCallback(function(p1) -- line: 123
		-- upvalues: Utils (copy), itemId (copy), isOutfit (copy), Constants3 (copy), ItemData (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants2 (copy), AvatarScreen (copy), FullView (copy), GetFFlagAXEnableSlotBasedEditor (copy), v69 (copy), Constants4 (copy), t1 (copy), v83 (copy), selectHasAvatarData (copy), selectIsPortrait (copy), ItemTileEnums (copy), v63 (copy)
		local v105 = Utils.getAvatarEditorCategoryInfoFromState(p1)
		local v106 = p1.AvatarExperience.AvatarEditor.OutfitInfos[itemId]
		local v107 = nil
		local v108 = nil
		local v109 = nil
		local v110 = if not isOutfit then Constants3.ItemType.Asset else Constants3.ItemType.Bundle
		local v111 = ItemData(p1.AvatarExperience.Common, itemId, v110)

		if itemId then
			if isOutfit then
				v108 = not v105.HideTextUnderTile and (not not v106 and v106.name) or nil

				local Outfit = Constants.RbxthumbTypes.Outfit

				v109 = getRbxthumbWithTypeSizeAndOptions(itemId, Outfit, 150)

				if v106 then
					v109 ..= "&filters=" .. v106.updateCounter

					if Utils.isModerationPendingOrRejected(v106.moderationStatus) then
						v109 = Constants2.BrokenAvatarThumbnail
					end
				end
			else
				v107 = v111 and v111.assetType or nil
				v108 = not v105.HideTextUnderTile and (not not v111 and v111.name) or nil

				local Asset = Constants.RbxthumbTypes.Asset

				v109 = getRbxthumbWithTypeSizeAndOptions(itemId, Asset, 150)

				if v111 and v111.outfitModerationStatus then
					v109 ..= ("&filters=__%*__"):format(v111.outfitModerationStatus)
				end

				if v111 and v111.moderationStatus then
					v109 ..= "&filters=" .. (v111.updateCounter or 0)
				end
			end
		end

		local AvatarType = p1.AvatarExperience.AvatarEditor.Character.AvatarType
		local v115 = p1.AvatarExperience.Common.FullView[AvatarScreen.AvatarEditor] == FullView.UIFullView

		if GetFFlagAXEnableSlotBasedEditor() then
			v115 = p1.AvatarExperience.Common.FullView[v69.opaque.name] == FullView.UIFullView
		end

		local v116 = if not isOutfit or not v106 then nil else Utils.getItemStatusStyleFromOutfit(v106)
		local v117 = if not isOutfit or not v106 then nil else Utils.getItemIconTypeFromOutfit(v106)
		local v118 = if not isOutfit then v107 else Constants4.Outfits
		local v119 = not not v106 and v106.isEditable
		local v120 = not (v106 and (v106.outfitType == Constants3.OutfitTypes.DynamicHead and not v119)) and not t1.hasItemFromCurrentPageEquipped
		local v121 = v106 and (v106.creatingUniverseId ~= nil and string.len(v106.creatingUniverseId) > 0)
		local v122 = v83 and not (isOutfit and not v121)

		return {
			itemData = v111,
			itemType = v110,
			modifiedAssetType = v118,
			name = v108,
			thumbnail = v109,
			isUIFullView = v115,
			outfitInfo = v106,
			categoryInfo = v105,
			avatarTypeIsR6 = AvatarType == Constants3.AvatarType.R6,
			hasAvatarData = selectHasAvatarData(p1),
			isPortrait = selectIsPortrait(p1),
			itemStatusStyle = v116,
			isEquippable = v116 == nil,
			iconType = if v117 ~= ItemTileEnums.ItemIconType.Bundle then v117 else nil,
			shouldConfirmEquip = v120,
			canShowDetails = v122,
			dataLoaded = if not v63 then nil else if not isOutfit then v111 else v106
		}
	end, {
		itemId,
		isOutfit,
		v69
	})
	local v85 = useSelector(v84, tutils.deepEqual)
	local categoryInfo = v85.categoryInfo
	local itemType = v85.itemType
	local itemData = v85.itemData
	local v89 = if not itemData then nil else itemData.assetType
	local isPortrait = v85.isPortrait
	local v91 = v73 == Input.Directional and not v74
	local v92 = React.useCallback(function() -- line: 231
		-- upvalues: logOnOverlayClosed (copy), v91 (copy)
		logOnOverlayClosed("ItemCard", v91)
	end, { v91 })
	local v93 = React.useCallback(function(b1: boolean, b2: boolean?) -- line: 235
		-- upvalues: v70 (copy), v71 (copy)
		if not v70 then
			return
		end

		if b1 then
			v70.setSelectedItemInstance(nil)

			return
		end

		local current = v71.current

		if current and b2 then
			v70.setSelectedItemInstance(current)
		end
	end, { v70 })
	local v94 = React.useCallback(function() -- line: 256
		-- upvalues: categoryInfo (copy), Constants3 (copy), v67 (copy), NavigateWithLock (copy), v68 (copy), AvatarScreen (copy), v92 (copy)
		local v126 = false
		local s1 = nil

		if categoryInfo.PageType == Constants3.PageType.Animation then
			v126 = true
			s1 = "Feature.Avatar.Message.R15AnimationsPrompt"
		elseif categoryInfo.PageType == Constants3.PageType.Emotes then
			v126 = true
			s1 = "Feature.Avatar.Message.R15EmotesPrompt"
		end

		if v126 then
			v67(NavigateWithLock(function() -- line: 276
				-- upvalues: v68 (copy), AvatarScreen (copy), v92 (copy), s1 (ref)
				v68.navigate(AvatarScreen.R15UpgradePrompt, {
					onOverlayClosed = v92,
					bodyTextKey = s1
				})
			end))
		end
	end, {
		v68,
		v67,
		v92
	})
	local v95 = React.useCallback(function() -- line: 286
		-- upvalues: v63 (copy), v85 (copy), v94 (copy), Constants3 (copy), v83 (copy), v68 (copy), AvatarScreen (copy), v92 (copy), v67 (copy), ToggleEquipAsset (copy), itemId (copy), v93 (copy), NavigateWithLock (copy), isOutfit (copy), EquipOutfit (copy), v76 (copy), Logging (copy), SendAnalytics (copy), GetFFlagAXEnableSlotBasedEditor (copy), SetFullView (copy), v78 (copy), v69 (copy), FullView (copy)
		if v63 and not v85.dataLoaded then
			return
		end

		local modifiedAssetType = v85.modifiedAssetType

		if v85.avatarTypeIsR6 then
			v94()
		end

		local v129 = modifiedAssetType == Constants3.AssetTypeIdStrings.HairAccessory
		local v130 = Constants3.LayeredAssetTypes[modifiedAssetType] ~= nil and not v129

		if v85.avatarTypeIsR6 and not v83 and v130 then
			v67(NavigateWithLock(function() -- line: 307
				-- upvalues: v68 (copy), AvatarScreen (copy), v92 (copy), v67 (copy), ToggleEquipAsset (copy), modifiedAssetType (copy), itemId (copy), v93 (copy), v83 (copy)
				v68.navigate(AvatarScreen.R15UpgradePrompt, {
					bodyTextKey = "Feature.Avatar.Label.LayeredClothingR15Warning",
					onOverlayClosed = v92,
					onSwitchSelected = function() -- line: 311
						-- upvalues: v67 (copy), ToggleEquipAsset (copy), modifiedAssetType (copy), itemId (copy), v68 (copy), v93 (copy), v83 (copy)
						local v143 = v67(ToggleEquipAsset(modifiedAssetType, itemId, v68))

						v93(v83, v143)
					end
				})
			end))

			return
		end

		if isOutfit then
			local outfitInfo = v85.outfitInfo

			if outfitInfo then
				if v85.shouldConfirmEquip then
					v67(NavigateWithLock(function() -- line: 325
						-- upvalues: v68 (copy), AvatarScreen (copy), v92 (copy), outfitInfo (copy), v93 (copy), v83 (copy)
						v68.navigate(AvatarScreen.EquipOutfitConfirmation, {
							onOverlayClosed = v92,
							outfitInfo = outfitInfo,
							onEquip = function(b3: boolean?) -- line: 329
								-- upvalues: v93 (copy), v83 (copy)
								v93(v83, b3)
							end
						})
					end))
				else
					local v132 = v67(EquipOutfit({
						outfitInfo = outfitInfo,
						analytics = v76,
						navigation = v68,
						isSelected = v83
					}))

					v93(v83, v132)
				end
			else
				Logging.warn("Tried equipping a costume without any costume data!")
			end
		else
			if modifiedAssetType then
				v67(SendAnalytics(if v83 then v76.unequipAsset else v76.equipAsset, itemId, modifiedAssetType))
			end

			local v133 = v67(ToggleEquipAsset(modifiedAssetType, itemId, v68))

			v93(v83, v133)
		end

		if not v83 and v85.isUIFullView then
			if GetFFlagAXEnableSlotBasedEditor() then
				v67(SetFullView(v78, v69.opaque.name, FullView.None))

				return
			end

			v67(SetFullView(v78, AvatarScreen.AvatarEditor, FullView.None))
		end
	end, {
		v78,
		v83,
		v85.isUIFullView,
		v85.modifiedAssetType,
		v85.avatarTypeIsR6,
		v85.shouldConfirmEquip,
		v85.outfitInfo,
		v76,
		itemId,
		v93,
		v94,
		v68,
		v67,
		v92,
		if not v63 then nil else isOutfit,
		if not v63 then nil else v85.dataLoaded
	})
	local v96 = React.useCallback(function() -- line: 391
		-- upvalues: isOutfit (copy), itemId (copy), isPortrait (copy), t1 (copy), NavigationUtils (copy), v68 (copy), AvatarScreen (copy), v67 (copy), NavigateWithLock (copy), CatalogUtils (copy), itemType (copy), itemData (copy), v77 (copy), v69 (copy), OpenItemDetails (copy)
		if isOutfit then
			local t2 = {
				ZIndex = 2,
				renderBottomBar = false,
				outfitId = itemId,
				showFullWithNoPeekView = not isPortrait,
				NextSelectionLeft = not isPortrait and t1.resultsListRef or nil,
				outfitDetailsPeekViewRefs = t1.itemDetailsPeekViewRefs
			}

			v67(NavigateWithLock(function() -- line: 403
				-- upvalues: NavigationUtils (copy), v68 (copy), AvatarScreen (copy), t2 (copy)
				NavigationUtils.closeFiltersAndItemDetails(v68)
				NavigationUtils.closeTryOnManager(v68)
				v68.navigate(AvatarScreen.OutfitDetails, t2)
			end))

			return
		end

		local v135 = CatalogUtils.GetItemSubType(itemType, itemData)
		local v136 = if not itemData then nil else itemData.priceInRobux
		local t3 = {
			mountAsFullView = nil,
			showFullWithNoPeekView = true,
			closePreviousItemDetails = true,
			itemId = itemId,
			itemType = itemType,
			itemSubType = v135,
			priceInRobux = v136,
			isPortrait = isPortrait,
			catalogAnalytics = v77,
			avatarRoute = v69,
			navigation = v68,
			itemDetailsPeekViewRefs = t1.itemDetailsPeekViewRefs,
			resultsListRef = t1.resultsListRef
		}

		v67(OpenItemDetails(t3))
	end, {
		v67,
		v68,
		isOutfit,
		itemId,
		v77,
		v69,
		itemType,
		itemData,
		t1.itemDetailsPeekViewRefs,
		t1.resultsListRef
	})
	local v97 = React.useCallback(function() -- line: 449
		-- upvalues: itemData (copy), Utils (copy), FFlagAXModeratedItemsFlow (copy), v89 (copy), Constants3 (copy), v68 (copy), AvatarScreen (copy), itemType (copy), v85 (copy), v95 (copy), v96 (copy)
		if itemData and Utils.isModerationPendingOrRejected(itemData.moderationStatus) then
			local v138 = nil

			if FFlagAXModeratedItemsFlow then
				v138 = not v89 and "Feature.Catalog.Label.Bundle" or Constants3.AssetTypeLocalized[v89]
			end

			v68.navigate(AvatarScreen.ItemsUnavailablePrompt, {
				items = {{
					category = itemType,
					categoryLoc = v138,
					itemName = itemData.name
				}},
				messageType = Utils.getMessageTypeFromModerationStatus(itemData.moderationStatus)
			})

			return
		end

		if v85.isEquippable then
			v95()

			return
		end

		v96()
	end, {
		v85.isEquippable,
		v96,
		v95
	})
	local v98 = React.useRef(nil)

	React.useEffect(function() -- line: 479
		-- upvalues: v71 (copy), t1 (copy), itemId (copy), OrganicEventImpressionsSchema (copy), ImpressionsUtil (copy), categoryInfo (copy), addUnifiedEventLogging (copy), v72 (copy), v83 (copy), UnifiedEventLogEnums (copy), itemType (copy), v89 (copy), Utils (copy), FFlagAXNegativeAvatarSequenceFeatures (copy), UnifiedEventLogConstants (copy), isOutfit (copy), v98 (copy), Constants4 (copy), v85 (copy), v67 (copy), FetchAssetOrBundleInfo (copy), v79 (copy), v75 (copy), Constants3 (copy)
		local current = v71.current

		if t1.impressionsTag and current then
			current:SetAttribute(t1.impressionsTag, itemId)

			local v140 = OrganicEventImpressionsSchema[t1.impressionsSchema]

			ImpressionsUtil.writeItemAttributes(v140, current, t1)
		end

		local Category = categoryInfo.Category
		local Subcategory = categoryInfo.Subcategory

		addUnifiedEventLogging(v72, {
			action = if not v83 then UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED else UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_DESELECTED,
			itemId = itemId,
			itemType = if itemType ~= "Asset" then UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE else UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET,
			assetType = v89,
			gridPositionRow = if not t1.gridInformation then nil else t1.gridInformation.row,
			gridPositionColumn = if not t1.gridInformation then nil else t1.gridInformation.column,
			category = if not Category then nil else Utils.getAvatarEditorCategoryInfo(Category).Name,
			subcategory = if not Category or not Subcategory then nil else Utils.getAvatarEditorCategoryInfo(Category, Subcategory).Name,
			isOwnedItem = not not FFlagAXNegativeAvatarSequenceFeatures or nil
		}, {
			sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
		})

		if not itemId or isOutfit or v98.current == itemId or itemId == Constants4.AddOutfitButton then
			return
		end

		v98.current = itemId

		if not v85.name then
			v67(FetchAssetOrBundleInfo(v79, v75, itemId, Constants3.ItemType.Asset))
		end
	end, {
		v67,
		v79,
		v75,
		itemId,
		v85.name,
		isOutfit,
		categoryInfo.Category,
		categoryInfo.Subcategory,
		itemType,
		v83,
		t1.gridInformation,
		v89
	})

	local v99 = useItemCardFocusNavigationBindings({
		onOpenEditorDetailsPage = if not v85.canShowDetails then nil else v96,
		onSlotEmote = if categoryInfo.PageType ~= Constants3.PageType.Emotes or v83 then nil else if not v64 then v97 else function() -- line: 542
		end,
		onUnslotEmote = if categoryInfo.PageType ~= Constants3.PageType.Emotes or not v83 then nil else if not v64 then v97 else function() -- line: 549
		end
	}, v71)
	local v100 = useTableWrappedCallbackRef(v99)
	local v101 = useLocalization({
		details = "Feature.Avatar.Label.DetailsButton"
	})
	local t4 = nil

	if itemData and Utils.isModerationPendingOrRejected(itemData.moderationStatus) then
		local v103 = if itemData.moderationStatus ~= Enum.ModerationStatus.NotReviewed then CatalogItemCardStatusIconTypeEnum.Moderated else CatalogItemCardStatusIconTypeEnum.PendingModeration

		t4 = {
			type = "placeholder",
			iconType = v103
		}
	end

	return React.createElement(CatalogItemCard, {
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		isSelected = v83,
		title = v85.name,
		itemInfo = if v85.iconType ~= ItemTileEnums.ItemIconType.DynamicHead then nil else CatalogItemCardItemInfoEnum.DynamicHead,
		onActivated = if not itemId or not v85.hasAvatarData then nil else v97,
		overlayButtonText = if not v85.canShowDetails then nil else v101.details,
		onOverlayButtonActivated = if not v85.canShowDetails then nil else v96,
		ref = v100,
		titleTextSize = if not GetFFlagAXEnableSlotBasedEditor() then nil else if not t1.titleFontStyle then if not v80 then nil else v80.Typography.CaptionSmall else t1.titleFontStyle,
		presentationSlot = if not v85.thumbnail then nil else React.createElement(ItemCardThumbnail, {
			url = v85.thumbnail,
			tag = t1.impressionsTag,
			ref = v71
		}),
		itemStatus = t4
	})
end)

return (React.memo(v65, tutils.deepEqual))
