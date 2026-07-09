local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local setTimeout = require(CorePackages.Packages.LuauPolyfill).setTimeout
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local v11 = game:DefineFastInt("AXLookOutfitCreationDelayMs1", 5000)
local ApiFetchEconomyCurrency = require(Modules.LuaApp.Thunks.ApiFetchEconomyCurrency)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local SetAssetOwned = require(Modules.AvatarExperience.Common.Actions.SetAssetOwned)
local SetBundleOwned = require(Modules.AvatarExperience.Common.Actions.SetBundleOwned)
local CreateOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.CreateOutfit)
local UpdateLookDetailsAfterSuccessfulPurchase = require(Modules.AvatarExperience.Common.Actions.UpdateLookDetailsAfterSuccessfulPurchase)
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local sendUnifiedEventForDeferredAction = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendUnifiedEventForDeferredAction
local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties
local v22 = game:DefineFastString("AXDefaultCharacterName", "Avatar")
local Enums = require(CorePackages.Workspace.Packages.PurchasePromptLite).Enums
local PurchaseLookStatusEnum = Enums.PurchaseLookStatusEnum
local PurchaseLookItemStatusEnum = Enums.PurchaseLookItemStatusEnum
local FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup = AvatarExperienceFlags.FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local v30 = game:DefineFastFlag("AXUnifiedSubsetOfLook", false)
local ItemTypeEnum = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.ItemTypeEnum
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.Types)
require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)

local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local avatarLastEquippedStateStore = AvatarExperienceCommon.Stores.AvatarLastEquippedStateStore.avatarLastEquippedStateStore
local SetTryOnManagerPeekViewState = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.SetTryOnManagerPeekViewState
local WearAfterOutfitPurchase = require(Modules.AvatarExperience.Catalog.Thunks.WearAfterOutfitPurchase)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local GetFFlagEnableSavePurchasedLooksWithLookName = require(Modules.AvatarExperience.Flags.GetFFlagEnableSavePurchasedLooksWithLookName)
local CharacterManagerUtils = require(Modules.AvatarExperience.Common.Util.CharacterManagerUtils)
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local SaveAsMakeupLookThunk = AvatarExperienceCatalog.Thunks.SaveAsMakeupLookThunk
local CartIdService = AvatarExperienceAnalytics.Lib.CartIdService
local UnifiedSelectionListStore = AvatarExperienceAnalytics.Store.UnifiedSelectionListStore
local FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType = AvatarExperienceFlags.FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType
local FFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local v49 = game:DefineFastFlag("AXFixBlockyBundleWearAfterPurchase", false)
local FFlagSkipCompletionModalForMarketplace = SharedFlags.FFlagSkipCompletionModalForMarketplace
local showLooksPurchaseToasts = require(Modules.AvatarExperience.Catalog.showLooksPurchaseToasts)

local function updateRobux(p1, p2) -- line: 73
	-- upvalues: ArgCheck (copy), ApiFetchEconomyCurrency (copy)
	local LocalUserId = p2:getState().LocalUserId

	ArgCheck.isNonEmptyString(LocalUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

	if typeof(LocalUserId) == "string" and LocalUserId ~= "" then
		p2:dispatch(ApiFetchEconomyCurrency(p1, LocalUserId, true))
	end
end

local t1 = {
	HttpError = Enum.HttpError.OK
}

local function v54(p3, p4, p5, n1: number, n2: number, t2: {[any]: any}) -- line: 83
	-- upvalues: PurchaseLookItemStatusEnum (copy)
	for v69, v70 in p4 do
		if v70 == PurchaseLookItemStatusEnum.Success or v70 == PurchaseLookItemStatusEnum.AlreadyOwned then
			n1 += 1
			p3:dispatch(p5(v69, true))

			if v70 == PurchaseLookItemStatusEnum.Success then
				table.insert(t2, (tonumber(v69)))
			end
		else
			n2 += 1
		end
	end

	return n1, n2, t2
end
local function formatItemForWearAfterPurchase(p6, p7, p8) -- line: 110
	-- upvalues: Constants (copy), v49 (copy)
	local v74 = p7.itemType == Constants.ItemType.Bundle

	if v49 and (v74 and p6 == tostring(Constants.BlockyBundleId)) then
		return nil
	end

	return {
		owned = true,
		assetId = if v74 then nil else p6,
		assetIsWearable = not v74,
		assetType = if not v74 then nil else Constants.ItemType.Bundle,
		bundleId = if not v74 then nil else p6,
		itemSubType = p7.itemSubType,
		overrideOrder = p7.order,
		overrideAdjustments = {
			position = p7.position,
			rotation = p7.rotation,
			scale = p7.scale
		},
		purchased = p8,
		tryOnBundleInfo = if not v74 then nil else p7.bundleInfo
	}
end
local function processItem(p9, p10, p11, p12, p13) -- line: 139
	-- upvalues: getTryOnItemReducerKey (copy), v49 (copy), formatItemForWearAfterPurchase (copy)
	local v80 = p12 == "Success" or p12 == "AlreadyOwned"
	local v81 = if p13 == nil then p11 else getTryOnItemReducerKey(p11, p13)

	if v80 and p10[v81] ~= nil then
		if v49 then
			local v82 = formatItemForWearAfterPurchase(p11, p10[v81], true)

			if v82 then
				table.insert(p9, v82)

				return p9
			end
		else
			table.insert(p9, (formatItemForWearAfterPurchase(p11, p10[v81], true)))
		end
	end

	return p9
end
local function handleWearAfterPurchase(p14, p15, p16, p17, p18, p19, p20) -- line: 160
	-- upvalues: v49 (copy), formatItemForWearAfterPurchase (copy), processItem (copy), Constants (copy), FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup (copy), avatarLastEquippedStateStore (copy), WearAfterOutfitPurchase (copy), GetFFlagAXEnableSlotBasedEditor (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy)
	local t3 = {}

	for _, v92 in p18 do
		if v49 then
			local v93 = formatItemForWearAfterPurchase(v92.itemId, v92, false)

			if v93 then
				table.insert(t3, v93)
			end
		else
			table.insert(t3, (formatItemForWearAfterPurchase(v92.itemId, v92, false)))
		end
	end

	for v94, v95 in p14.assetPurchaseStatus do
		t3 = processItem(t3, p17, v94, v95, Constants.ItemType.Asset)
	end

	for v96, v97 in p14.bundlePurchaseStatus do
		t3 = processItem(t3, p17, v96, v97, Constants.ItemType.Bundle)
	end

	if p19 and p20 and p20.autoSaveNextNewSaveData then
		p20.autoSaveNextNewSaveData()
	end

	if FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
		avatarLastEquippedStateStore.setShouldRevertLastEquippedState(false)
	end

	p15:dispatch(WearAfterOutfitPurchase(t3, p16, nil, Constants.LookType.Avatar))

	if GetFFlagAXEnableSlotBasedEditor() and not p19 then
		p15:dispatch(SetTryOnManagerPeekViewState(PeekViewState.Closed))
	end
end
local function handleSaveAsCharacter(p21, p22, p23, p24, p25) -- line: 220
	-- upvalues: CharacterManagerUtils (copy), GetFFlagEnableSavePurchasedLooksWithLookName (copy), v22 (copy), FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType (copy), Constants (copy), SaveAsMakeupLookThunk (copy), CreateOutfit (copy)
	local v103 = p21:getState()
	local v104 = v103.AvatarExperience.AvatarScene.Looks[p22]
	local v105 = if not v104 or not v104.name then nil else v104.name
	local v106 = CharacterManagerUtils.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn(v103)
	local v107 = GetFFlagEnableSavePurchasedLooksWithLookName() and v105 or v22

	if FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType and (v104 and v104.lookType == Constants.LookType.Makeup) then
		p21:dispatch(SaveAsMakeupLookThunk(p24, v107, p25))

		return
	end

	p21:dispatch((CreateOutfit(v107, p23, function() -- line: 240
		return true
	end, nil, v106)))
end
local function handleLooksPurchaseSuccess(p26, p27, p28, s1: string, n3: number, p29, p30, p31, p32, p33, p34, p35, p36, p37) -- line: 257
	-- upvalues: PurchaseLookStatusEnum (copy), v54 (copy), SetAssetOwned (copy), SetBundleOwned (copy), ArgCheck (copy), ApiFetchEconomyCurrency (copy), CatalogUtils (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AvatarScreenProperties (copy), v30 (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), Constants (copy), sendUnifiedEventForDeferredAction (copy), Cryo (copy), UnifiedEventLogEnums (copy), CartIdService (copy), mutedError (copy), UnifiedSelectionListStore (copy), FFlagSkipCompletionModalForMarketplace (copy), showLooksPurchaseToasts (copy), WidgetConstants (copy), ItemTypeEnum (copy), FFlagAXFixPurchaseSurfaceLogging (copy), WebApi (copy), UpdateLookDetailsAfterSuccessfulPurchase (copy), handleWearAfterPurchase (copy), handleSaveAsCharacter (copy), FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType (copy), setTimeout (copy), v11 (copy), Promise (copy), t1 (copy)
	return function(p38) -- line: 273
		-- upvalues: p26 (copy), PurchaseLookStatusEnum (copy), v54 (copy), SetAssetOwned (copy), SetBundleOwned (copy), p28 (copy), ArgCheck (copy), ApiFetchEconomyCurrency (copy), p33 (ref), CatalogUtils (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), p37 (copy), AvatarScreenProperties (copy), v30 (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), s1 (copy), Constants (copy), p27 (copy), sendUnifiedEventForDeferredAction (copy), Cryo (copy), UnifiedEventLogEnums (copy), CartIdService (copy), n3 (copy), mutedError (copy), UnifiedSelectionListStore (copy), FFlagSkipCompletionModalForMarketplace (copy), showLooksPurchaseToasts (copy), p35 (copy), WidgetConstants (copy), ItemTypeEnum (copy), FFlagAXFixPurchaseSurfaceLogging (copy), p34 (copy), WebApi (copy), UpdateLookDetailsAfterSuccessfulPurchase (copy), handleWearAfterPurchase (copy), p29 (copy), p30 (copy), p32 (copy), p31 (copy), handleSaveAsCharacter (copy), p36 (copy), FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType (copy), setTimeout (copy), v11 (copy), Promise (copy), t1 (copy)
		local v124 = p26

		if (v124.purchaseLookStatus == PurchaseLookStatusEnum.Success or v124.purchaseLookStatus == PurchaseLookStatusEnum.PartialSuccess) and type(v124) == "table" then
			local v125, v126, v127 = v54(p38, v124.assetPurchaseStatus, SetAssetOwned, 0, 0, {})
			local u128 = v127
			local v129, v130, v131 = v54(p38, v124.bundlePurchaseStatus, SetBundleOwned, v125, v126, {})
			local u132 = v131
			local v133 = p28
			local LocalUserId = p38:getState().LocalUserId

			ArgCheck.isNonEmptyString(LocalUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

			if typeof(LocalUserId) == "string" and LocalUserId ~= "" then
				p38:dispatch(ApiFetchEconomyCurrency(v133, LocalUserId, true))
			end

			local v135 = nil
			local v136 = nil
			local v137 = nil
			local v138 = nil
			local v139 = p38:getState()
			local query

			if p33 then
				query = p33.query
			else
				local v141

				v141, v135, v136, v137, v138 = CatalogUtils.getAvatarsTabAnalyticsInfo(v139)
				query = v141
			end

			local ok, result = pcall(function() -- line: 315
				-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), p38 (copy), p37 (copy), AvatarScreenProperties (copy), v30 (copy), p33 (ref), u128 (ref), u132 (ref), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), v139 (copy), s1 (copy), Constants (copy), p27 (copy), sendUnifiedEventForDeferredAction (copy), Cryo (copy), UnifiedEventLogEnums (copy), CartIdService (copy), query (ref), n3 (copy)
				local v148 = if not FFlagUseNavigationSelectors then p38:getState().Navigation and p38:getState().Navigation.currentRoute else Selectors.selectCurrentRoactNavigationRoute(p38:getState())
				local name = nil

				if p37 and (p37.current and p37.opaque) then
					name = p37.opaque.name
				elseif v148.params and v148.params.extraProps then
					name = v148.params.extraProps.routeName
				end

				local v150 = AvatarScreenProperties[name]
				local v151 = if not v30 then nil else p33 == nil
				local v152 = nil
				local v153 = nil

				if v30 and #u128 > 0 then
					v152 = table.concat(u128, ",")
				end

				if v30 and #u132 > 0 then
					v153 = table.concat(u132, ",")
				end

				local LookAnalyticsInfo = p38:getState().AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo

				if FFlagAXMISEnableMultiShoppingUnifiedEvents and v139.AvatarExperience.AvatarScene.Looks[s1].lookType == Constants.LookType.Makeup then
					LookAnalyticsInfo = p38:getState().AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookAnalyticsInfo
				end

				local v155 = false

				if p27[Constants.WearAfterPurchasePostPurchaseActionKey] then
					v155 = p27[Constants.WearAfterPurchasePostPurchaseActionKey]
				end

				local v156 = false

				if p27[Constants.SaveAsCharacterPostPurchaseActionKey] then
					v156 = p27[Constants.SaveAsCharacterPostPurchaseActionKey]
				end

				local surface = nil

				if p33 and p33.surface then
					surface = p33.surface
				elseif v150 and v150.analyticsData then
					surface = v150.analyticsData.unifiedLoggingSurface
				end

				local v158 = LookAnalyticsInfo or {
					widgetType = nil
				}

				sendUnifiedEventForDeferredAction(Cryo.Dictionary.join(p38:getState().AvatarExperience.AnalyticsMetadata, {
					action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS,
					cartId = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else CartIdService.getCartId(),
					itemId = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else s1,
					itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK,
					keyword = query,
					surface = surface,
					organicAssetIds = if not v30 or not v151 then nil else v152,
					organicBundleIds = if not v30 or not v151 then nil else v153,
					organicItemPrice = if not v30 or not v151 then nil else n3,
					assetIds = if not v30 or v151 then nil else v152,
					bundleIds = if not v30 or v151 then nil else v153,
					widgetItemPrice = if not v30 or v151 then nil else n3,
					widgetItemWearAfterPurchase = if not v158.widgetType then nil else v155,
					organicItemWearAfterPurchase = if not v158.widgetType then v155 else nil,
					widgetItemSaveToMyAvatars = if not v158.widgetType then nil else v156,
					organicItemSaveToMyAvatars = if not v158.widgetType then v156 else nil
				}))
			end)

			if not ok then
				mutedError(result)
			end

			if FFlagAXMISEnableMultiShoppingUnifiedEvents then
				CartIdService.refreshCartId()
				UnifiedSelectionListStore.clearSelectionList()
			end

			local v144 = Cryo.Dictionary.join(v124, {
				successCount = v129,
				failureCount = v130
			})

			if FFlagSkipCompletionModalForMarketplace then
				showLooksPurchaseToasts({
					successCount = v129,
					failureCount = v130
				}, function(p39) -- line: 416
					-- upvalues: p38 (copy)
					return p38:dispatch(p39)
				end)
			end

			if p33 then
				p33 = Cryo.Dictionary.join(p33, {
					assetIds = u128
				})

				if #u128 > 0 or #u132 > 0 then
					p35.widgetInteractionV2(p33, WidgetConstants.ActionType.PURCHASE_SUCCESS)
				end
			elseif not p33 then
				p35.avatarShopBuyItem(s1, ItemTypeEnum.Look, n3, v138, v137, query, v135, v136, p38:getState().AvatarExperience.AnalyticsMetadata, if not FFlagAXFixPurchaseSurfaceLogging or not p34 then nil else p34.getParam(Constants.NavigationParams.fromSurface))
			end

			if #u128 > 0 or #u132 > 0 then
				WebApi.GetLookDetailsV2(p28, s1):andThen(function(p40) -- line: 444
					-- upvalues: p38 (copy), UpdateLookDetailsAfterSuccessfulPurchase (copy), s1 (copy), u128 (ref), u132 (ref)
					local look = p40.responseBody.look

					if look then
						local v162 = true

						for _, v164 in look.items do
							if not v164.quantityOwned or v164.quantityOwned == 0 then
								v162 = false

								break
							end
						end

						p38:dispatch(UpdateLookDetailsAfterSuccessfulPurchase(s1, u128, u132, v162))
					end
				end)
			end

			if p27[Constants.WearAfterPurchasePostPurchaseActionKey] then
				handleWearAfterPurchase(v144, p38, p34, p29, p30, p32, p31)
			end

			if p27[Constants.SaveAsCharacterPostPurchaseActionKey] then
				local function handleSaveAsCharacterWrapper() -- line: 479
					-- upvalues: handleSaveAsCharacter (copy), p38 (copy), s1 (copy), p36 (copy), FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType (copy), p28 (copy), p29 (copy)
					handleSaveAsCharacter(p38, s1, p36, if not FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType then nil else p28, if not FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType then nil else p29)
				end

				if FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType then
					local v146 = p38:getState().AvatarExperience.AvatarScene.Looks[s1]

					if v146 and v146.lookType == Constants.LookType.Makeup then
						handleSaveAsCharacter(p38, s1, p36, if not FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType then nil else p28, if not FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType then nil else p29)
					else
						setTimeout(handleSaveAsCharacterWrapper, v11)
					end
				else
					setTimeout(handleSaveAsCharacterWrapper, v11)
				end
			end

			return Promise.resolve(v144)
		end

		local v147 = t1

		return Promise.reject(v147)
	end
end

return handleLooksPurchaseSuccess
