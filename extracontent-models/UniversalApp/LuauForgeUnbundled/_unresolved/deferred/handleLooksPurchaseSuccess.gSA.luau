local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dzP")
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local defineFastInt = game:DefineFastInt("AXLookOutfitCreationDelayMs1", 5000)
local module5 = require("@luauforge/bundled/fCy")
local module6 = require("@luauforge/bundled/dVl")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local module8 = require("@luauforge/bundled/dQl")
local module9 = require("@luauforge/bundled/dQz")
local module10 = require("@luauforge/deferred/gKR")

local module11 = require("@luauforge/bundled/dPw")
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums

local sendUnifiedEventForDeferredAction = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendUnifiedEventForDeferredAction

local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties
local defineFastString = game:DefineFastString("AXDefaultCharacterName", "Avatar")
local enums = require("@luauforge/deferred/fCQ").Enums
local purchaseLookStatusEnum = enums.PurchaseLookStatusEnum
local purchaseLookItemStatusEnum = enums.PurchaseLookItemStatusEnum

local fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup = AvatarExperienceFlags.FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup
local fFlagAXMomentsLookTryOnDelayAutoSave = AvatarExperienceFlags.FFlagAXMomentsLookTryOnDelayAutoSave
local fFlagAXMomentsLookTryOnCloseAfterPurchase = AvatarExperienceFlags.FFlagAXMomentsLookTryOnCloseAfterPurchase
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local defineFastFlag = game:DefineFastFlag("AXUnifiedSubsetOfLook", false)
local itemTypeEnum = require("@luauforge/bundled/dPt").Enums.ItemTypeEnum
local module14 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/dPs")
local module15 = require("@luauforge/bundled/dKU")
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey

local avatarLastEquippedStateStore = AvatarExperienceCommon.Stores.AvatarLastEquippedStateStore.avatarLastEquippedStateStore
local setTryOnManagerPeekViewState = module15.Actions.SetTryOnManagerPeekViewState
local module16 = require("@luauforge/deferred/gKT")
local module17 = require("@luauforge/bundled/dRs")
local peekViewState = require("@luauforge/bundled/dCI").PeekViewState
local module18 = require("@luauforge/bundled/gKV")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local saveAsMakeupLookThunk = AvatarExperienceCatalog.Thunks.SaveAsMakeupLookThunk
local cartIdService = AvatarExperienceAnalytics.Lib.CartIdService
local mapAnalyticsMetadataFields = AvatarExperienceAnalytics.Utils.mapAnalyticsMetadataFields
local getWidgetAttributionFields = AvatarExperienceAnalytics.Utils.getWidgetAttributionFields
local unifiedSelectionListStore = AvatarExperienceAnalytics.Store.UnifiedSelectionListStore

local fFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType = AvatarExperienceFlags.FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType
local fFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3gAvatarExperience = SharedFlags.FFlagSignalsNavP3gAvatarExperience
local getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
local fFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads
local fFlagSkipCompletionModalForMarketplace = SharedFlags.FFlagSkipCompletionModalForMarketplace
local fFlagAXFixHomeAvatarsUnifiedPurchase = SharedFlags.FFlagAXFixHomeAvatarsUnifiedPurchase
local fFlagAXEnableUnifiedLoggingAvatarMoment = SharedFlags.FFlagAXEnableUnifiedLoggingAvatarMoment
local normalizeDiscoveryPurchaseEntity = AvatarExperienceAnalytics.normalizeDiscoveryPurchaseEntity
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2

local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface

local module19 = require("@luauforge/deferred/gSB")

local function updateRobux(p2, object)
	local localUserId = object:getState().LocalUserId
	module.isNonEmptyString(localUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

	if typeof(localUserId) == "string" and localUserId ~= "" then
		object:dispatch(module5(p2, localUserId, true))
	end
end

local v5 = { HttpError = Enum.HttpError.OK }

local function fn(object, items, callback, count, count2, list)
	for k, item in items do
		if
			item == purchaseLookItemStatusEnum.Success
			or item == purchaseLookItemStatusEnum.AlreadyOwned
		then
			count += 1
			object:dispatch(callback(k, true))

			if item == purchaseLookItemStatusEnum.Success then
				table.insert(list, (tonumber(k)))
			end
		else
			count2 += 1
		end
	end

	return count, count2, list
end

local function formatItemForWearAfterPurchase(bundleId, data, purchased)
	local v6 = data.itemType == module14.ItemType.Bundle

	if v6 and bundleId == tostring(module14.BlockyBundleId) then
		return nil
	end

	local v9 = if v6 then module14.ItemType.Bundle else nil
	local v7 = {
		assetId = if not v6 then bundleId else nil,
		assetIsWearable = not v6,
		assetType = v9,
		bundleId = nil,
		itemSubType = 0,
		overrideOrder = 0,
		overrideAdjustments = 0,
		owned = true,
		purchased = 0,
		tryOnBundleInfo = 0
	}

	if not v6 then
		bundleId = nil
	end

	v7.bundleId = bundleId
	v7.itemSubType = data.itemSubType
	v7.overrideOrder = data.order
	v7.overrideAdjustments = {
		position = data.position,
		rotation = data.rotation,
		scale = data.scale
	}

	v7.purchased = purchased
	local v10 = if v6 then data.bundleInfo else nil
	v7.tryOnBundleInfo = v10
	return v7
end

local function processItem(list, p2, p3, p4, p5)
	local v6 = p4 == "Success" or p4 == "AlreadyOwned"

	local v7 = if p5 == nil then p3 else getTryOnItemReducerKey(p3, p5)
	local v8 = v6 and p2[v7] ~= nil and formatItemForWearAfterPurchase(p3, p2[v7], true)

	if v8 then
		table.insert(list, v8)
	end

	return list
end

local function handleWearAfterPurchase(p2, object, p3, p4, items, p5, p6, p7)
	local v6 = {}

	for k, item in items do
		local v7 = formatItemForWearAfterPurchase(item.itemId, item, false)

		if v7 then
			table.insert(v6, v7)
		end
	end

	for k, v7 in p2.assetPurchaseStatus do
		local asset = module14.ItemType.Asset
		local v8 = v7 == "Success" or v7 == "AlreadyOwned"

		local v9 = if asset == nil then k else getTryOnItemReducerKey(k, asset)

		if not (v8 and p4[v9] ~= nil) then
			continue
		end

		local v10 = formatItemForWearAfterPurchase(k, p4[v9], true)

		if v10 then
			table.insert(v6, v10)
		end
	end

	for k, v7 in p2.bundlePurchaseStatus do
		local bundle = module14.ItemType.Bundle
		local v8 = v7 == "Success" or v7 == "AlreadyOwned"

		local v9 = if bundle == nil then k else getTryOnItemReducerKey(k, bundle)

		if not (v8 and p4[v9] ~= nil) then
			continue
		end

		local v10 = formatItemForWearAfterPurchase(k, p4[v9], true)

		if v10 then
			table.insert(v6, v10)
		end
	end

	if p5 and p6 and p6.autoSaveNextNewSaveData then
		p6.autoSaveNextNewSaveData(p7)
	end

	if fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
		avatarLastEquippedStateStore.setShouldRevertLastEquippedState(false)
	end

	object:dispatch(module16(v6, p3, nil, module14.LookType.Avatar))

	if module17() and not p5 then
		object:dispatch(setTryOnManagerPeekViewState(peekViewState.Closed))
	end
end

local function handleSaveAsCharacter(object, p2, p3, p4, p5, p6)
	local state = object:getState()
	local look = state.AvatarExperience.AvatarScene.Looks[p2]
	local name = if look and look.name then look.name else nil

	local v6 = fFlagAXMomentsLookTryOnCloseAfterPurchase and p6
		or module18.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn(state)
	local v7 = name or defineFastString

	if
		fFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType
		and look
		and look.lookType == module14.LookType.Makeup
	then
		object:dispatch(saveAsMakeupLookThunk(p4, v7, p5))
	else
		object:dispatch(module10(v7, p3, function(): boolean
			return true
		end, nil, v6))
	end
end

local function handleLooksPurchaseSuccess(p2, p3, p4, p5, p6, p7, p8, p9, p10, data, p11, p12, p13, p14, p15)
	return function(object)
		local v6 = p2

		if
			v6.purchaseLookStatus ~= purchaseLookStatusEnum.Success
			and v6.purchaseLookStatus ~= purchaseLookStatusEnum.PartialSuccess
			or type(v6) ~= "table"
		then
			return Promise.reject(v5)
		end

		local v7, v8, v9 = fn(object, v6.assetPurchaseStatus, module8, 0, 0, {})
		local v11, v12, v13 = fn(object, v6.bundlePurchaseStatus, module9, v7, v8, {})

		local v15 = p4
		local localUserId = object:getState().LocalUserId
		module.isNonEmptyString(localUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

		if typeof(localUserId) == "string" and localUserId ~= "" then
			object:dispatch(module5(v15, localUserId, true))
		end

		local v16 = nil
		local v17 = nil
		local v18 = nil
		local v19 = nil
		local state = object:getState()
		local v20

		if data then
			v20 = data.query
		else
			v20, v16, v17, v18, v19 = module6.getAvatarsTabAnalyticsInfo(state)
		end

		local success, result = pcall(function()
			local v21

			if fFlagSignalsNavP3gAvatarExperience then
				v21 = getLegacyNavigationStore(false).getCurrentRoute(false)
			elseif fFlagUseNavigationSelectors then
				v21 = selectors.selectCurrentRoactNavigationRoute(object:getState())
			else
				v21 = object:getState().Navigation and object:getState().Navigation.currentRoute
			end

			local v22 = nil

			if p14 and p14.current and p14.opaque then
				v22 = p14.opaque.name
			elseif v21.params and v21.params.extraProps then
				v22 = v21.params.extraProps.routeName
			end

			local avatarScreenProperty = avatarScreenProperties[v22]

			local v23 = fFlagAXEnableUnifiedLoggingAvatarMoment

			if v23 then
				v23 = not (data == nil) and data.surface == unifiedLoggingSurface.SHOP_AVATAR_MOMENT
			end

			local v24 = if defineFastFlag then data == nil or v23 else nil

			local joined = nil
			local joined2 = if defineFastFlag and #v9 > 0 then table.concat(v9, ",") else nil

			if defineFastFlag and #v13 > 0 then
				joined = table.concat(v13, ",")
			end

			local v25 = object:getState().AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo

			if
				fFlagAXMISEnableMultiShoppingUnifiedEvents
				and state.AvatarExperience.AvatarScene.Looks[p5].lookType == module14.LookType.Makeup
			then
				v25 = object:getState().AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookAnalyticsInfo
			end

			local v26

			if p3[module14.WearAfterPurchasePostPurchaseActionKey] then
				v26 = p3[module14.WearAfterPurchasePostPurchaseActionKey]
			else
				v26 = false
			end

			local v27

			if p3[module14.SaveAsCharacterPostPurchaseActionKey] then
				v27 = p3[module14.SaveAsCharacterPostPurchaseActionKey]
			else
				v27 = false
			end

			local v28 = nil

			if data and data.surface then
				v28 = data.surface
			elseif avatarScreenProperty and avatarScreenProperty.analyticsData then
				v28 = avatarScreenProperty.analyticsData.unifiedLoggingSurface
			end

			local v29 = v25 or { widgetType = nil }

			local join = Cryo.Dictionary.join
			local analyticsMetadata = object:getState().AvatarExperience.AnalyticsMetadata
			local v30 = {
				action = unifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS,
				cartId = 0,
				itemId = 0,
				itemType = 0,
				keyword = 0,
				surface = 0,
				organicAssetIds = 0,
				organicBundleIds = 0,
				organicItemPrice = 0,
				assetIds = 0,
				bundleIds = 0,
				widgetItemPrice = 0,
				widgetItemWearAfterPurchase = 0,
				organicItemWearAfterPurchase = 0,
				widgetItemSaveToMyAvatars = 0,
				organicItemSaveToMyAvatars = 0
			}
			local v31 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then cartIdService.getCartId() else nil
			v30.cartId = v31
			v30.itemId = if fFlagAXMISEnableMultiShoppingUnifiedEvents then p5 else nil
			v30.itemType = unifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK
			v30.keyword = v20
			v30.surface = v28
			local v33 = if defineFastFlag and v24 then joined2 else nil
			v30.organicAssetIds = v33
			local v34 = if defineFastFlag and v24 then joined else nil
			v30.organicBundleIds = v34
			local v35 = if defineFastFlag and v24 then p6 else nil
			v30.organicItemPrice = v35

			if not defineFastFlag or v24 then
				joined2 = nil
			end

			v30.assetIds = joined2

			if not defineFastFlag or v24 then
				joined = nil
			end

			v30.bundleIds = joined
			local v36 = if defineFastFlag and not v24 then p6 else nil
			v30.widgetItemPrice = v36

			local v37 = if v29.widgetType then v26 else nil
			v30.widgetItemWearAfterPurchase = v37

			if v29.widgetType then
				v26 = nil
			end

			v30.organicItemWearAfterPurchase = v26

			local v38 = if v29.widgetType then v27 else nil
			v30.widgetItemSaveToMyAvatars = v38

			if v29.widgetType then
				v27 = nil
			end

			v30.organicItemSaveToMyAvatars = v27
			local v39 = join(analyticsMetadata, v30)

			if fFlagAXUnifiedEventStrictPayloads then
				v39 = mapAnalyticsMetadataFields(v39)
			end

			if v23 and data.shopMetadata then
				v39.elementMetadata = HttpService:JSONEncode(data.shopMetadata)
			end

			local v40 = if fFlagAXUnifiedEventStrictPayloads then getWidgetAttributionFields(v25) else nil

			if not fFlagAXFixHomeAvatarsUnifiedPurchase then
				sendUnifiedEventForDeferredAction(v39, v40)

				return
			end

			if v28 == unifiedLoggingSurface.DISCOVERY_HOMEPAGE then
				sendAXCounterV2("PurchaseSuccessLook", { Surface = "home" })
			end

			sendUnifiedEventForDeferredAction(normalizeDiscoveryPurchaseEntity(v39), v40)
		end)

		if not success then
			mutedError(result)
		end

		if fFlagAXMISEnableMultiShoppingUnifiedEvents then
			cartIdService.refreshCartId()
			unifiedSelectionListStore.clearSelectionList()
		end

		local joined = Cryo.Dictionary.join(v6, {
			successCount = v11,
			failureCount = v12
		})

		if fFlagSkipCompletionModalForMarketplace then
			module19({ successCount = v11, failureCount = v12 }, function(p16)
				return object:dispatch(p16)
			end)
		end

		if data then
			data = Cryo.Dictionary.join(data, { assetIds = v9 })

			if #v9 > 0 or #v13 > 0 then
				p12.widgetInteractionV2(data, widgetConstants.ActionType.PURCHASE_SUCCESS)
			end
		elseif not data then
			local avatarShopBuyItem = p12.avatarShopBuyItem

			local look = itemTypeEnum.Look

			local analyticsMetadata = object:getState().AvatarExperience.AnalyticsMetadata

			local v24 = if fFlagAXFixPurchaseSurfaceLogging and p11 then p11.getParam(module14.NavigationParams.fromSurface) else nil
			avatarShopBuyItem(p5, look, p6, v19, v18, v20, v16, v17, analyticsMetadata, v24)
		end

		if #v9 > 0 or #v13 > 0 then
			GetExperienceSourceLanguage.GetLookDetailsV2(p4, p5):andThen(function(p16)
				local look = p16.responseBody.look

				if look then
					local v21 = true

					for k, item in look.items do
						if not item.quantityOwned or item.quantityOwned == 0 then
							v21 = false
							break
						end
					end

					object:dispatch(module11(p5, v9, v13, v21))
				end
			end)
		end

		local v21

		if
			fFlagAXMomentsLookTryOnCloseAfterPurchase
			and p3[module14.SaveAsCharacterPostPurchaseActionKey]
		then
			v21 = module18.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn(object:getState())
		else
			v21 = nil
		end

		if p3[module14.WearAfterPurchasePostPurchaseActionKey] then
			handleWearAfterPurchase(
				joined,
				object,
				p11,
				p7,
				p8,
				p10,
				p9,
				if fFlagAXMomentsLookTryOnDelayAutoSave then p15 else nil
			)
		end

		if p3[module14.SaveAsCharacterPostPurchaseActionKey] then
			local function handleSaveAsCharacterWrapper()
				local v26 = if fFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType then p4 else nil
				local v27 = if fFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType then p7 else nil
				handleSaveAsCharacter(
					object,
					p5,
					p13,
					v26,
					v27,
					if fFlagAXMomentsLookTryOnCloseAfterPurchase then v21 else nil
				)
			end

			if fFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType then
				local look = object:getState().AvatarExperience.AvatarScene.Looks[p5]

				if look and look.lookType == module14.LookType.Makeup then
					local v25 = if fFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType then p4 else nil
					local v26 = if fFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType then p7 else nil
					handleSaveAsCharacter(
						object,
						p5,
						p13,
						v25,
						v26,
						if fFlagAXMomentsLookTryOnCloseAfterPurchase then v21 else nil
					)
				else
					setTimeout(handleSaveAsCharacterWrapper, defineFastInt)
				end
			else
				setTimeout(handleSaveAsCharacterWrapper, defineFastInt)
			end
		end

		return Promise.resolve(joined)
	end
end

return handleLooksPurchaseSuccess
