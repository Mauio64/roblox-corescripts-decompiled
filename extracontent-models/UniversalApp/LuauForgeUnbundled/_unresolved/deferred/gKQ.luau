local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local module5 = require("@luauforge/bundled/gJz")
local module6 = require("@luauforge/bundled/dKU")
local module7 = require("@luauforge/deferred/gKR")
local saveAsMakeupLookThunk = AvatarExperienceCatalog.Thunks.SaveAsMakeupLookThunk
local module8 = require("@luauforge/bundled/dPN")

local module9 = require("@luauforge/deferred/gKx")
local module10 = require("@luauforge/deferred/gKS")
local module11 = require("@luauforge/deferred/gKT")
local module12 = require("@luauforge/bundled/fDf")
local peekViewState = require("@luauforge/bundled/dCI").PeekViewState
local setTryOnManagerPeekViewState = module6.Actions.SetTryOnManagerPeekViewState
local module13 = require("@luauforge/bundled/dFs")

local module14 = require("@luauforge/bundled/dXh")
local module15 = require("@luauforge/deferred/gJI")

local module16 = require("@luauforge/deferred/gJH")
local module17 = require("@luauforge/bundled/gKV")

local module18 = require("@luauforge/bundled/dFm")
local module19 = require("@luauforge/bundled/dzE")
local module20 = require("@luauforge/bundled/gxM")
local module21 = require("@luauforge/bundled/eie")
local module22 = require("@luauforge/bundled/egY")
local module23 = require("@luauforge/bundled/egx")
require("@luauforge/bundled/dPs")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey

local avatarLastEquippedStateStore = AvatarExperienceCommon.Stores.AvatarLastEquippedStateStore.avatarLastEquippedStateStore
local useAvatarSaveContext = require("@luauforge/bundled/gKz").Context.useAvatarSaveContext

local module24 = require("@luauforge/deferred/gKA")
local module25 = require("@luauforge/deferred/gKv")
local isEconomicRestrictionResponse = module25.Utility.isEconomicRestrictionResponse
local economicRestrictionsCounter = module25.Counters.EconomicRestrictionsCounter
local universalEconomicRestrictionsCounter = economicRestrictionsCounter.UniversalEconomicRestrictionsCounter
local economicRestrictionsSurface = economicRestrictionsCounter.EconomicRestrictionsSurface
local parseEconomicRestrictionsFailureReason = module25.Utility.parseEconomicRestrictionsFailureReason

local parseEconomicRestrictionsExpirationTimeInMinutes = module25.Utility.parseEconomicRestrictionsExpirationTimeInMinutes
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default

local useTriggerFeedback = require("@luauforge/bundled/gKs").useTriggerFeedback

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2

local defineFastString = game:DefineFastString("AXDefaultCharacterName", "Avatar")
local fIntAXLookOutfitCreationDelayMs = AvatarExperienceFlags.FIntAXLookOutfitCreationDelayMs
local defineFastFlag = game:DefineFastFlag("SupportAlreadyOwnedItemPurchaseStatus", false)
local module26 = require("@luauforge/bundled/dRs")
local fFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport

local fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup = AvatarExperienceFlags.FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup
local fFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local defineFastFlag2 = game:DefineFastFlag("AXDisableCharacterSaveToast", false)

local function PurchaseResolveNav(p2)
	module14.closeOverlay(p2)
end

local function formatItemForWearAfterPurchaseMIS(bundleId, data, purchased)
	local v5 = data.itemType == module8.ItemType.Bundle

	local v6 = {}

	if v5 then
		for k, v7 in data.assetsInBundle do
			if v7.isIncluded then
				v6[tostring(v7.id)] = {
					assetType = tostring(v7.assetType),
					order = v7.order
				}
			end
		end
	end

	local v9 = if v5 then module8.ItemType.Bundle else nil
	local v7 = {
		assetId = if not v5 then bundleId else nil,
		assetIsWearable = not v5,
		assetType = v9,
		bundleId = nil,
		itemSubType = 0,
		owned = true,
		purchased = 0,
		tryOnBundleInfo = 0
	}

	if not v5 then
		bundleId = nil
	end

	v7.bundleId = bundleId
	local v10 = if v5 then tostring(data.bundleType) else tostring(data.assetType)
	v7.itemSubType = v10

	v7.purchased = purchased

	if not v5 then
		v6 = nil
	end

	v7.tryOnBundleInfo = v6
	return v7
end

local function formatItemForWearAfterPurchaseLegacy(bundleId, data, purchased)
	local v5 = data.itemType == module8.ItemType.Bundle

	local v8 = if v5 then module8.ItemType.Bundle else nil
	local v6 = {
		assetId = if not v5 then bundleId else nil,
		assetIsWearable = not v5,
		assetType = v8,
		bundleId = nil,
		itemSubType = 0,
		overrideOrder = 0,
		overrideAdjustments = 0,
		owned = true,
		purchased = 0,
		tryOnBundleInfo = 0
	}

	if not v5 then
		bundleId = nil
	end

	v6.bundleId = bundleId
	v6.itemSubType = data.itemSubType
	v6.overrideOrder = data.order
	v6.overrideAdjustments = {
		position = data.position,
		rotation = data.rotation,
		scale = data.scale
	}

	v6.purchased = purchased
	local v9 = if v5 then data.bundleInfo else nil
	v6.tryOnBundleInfo = v9
	return v6
end

local function processItem(list, p2, p3, p4, p5)
	if (p4 == "Success" or defineFastFlag and p4 == "AlreadyOwned") and p2[p3] ~= nil then
		table.insert(list, formatItemForWearAfterPurchaseMIS(p3, p2[p3], true))
	end

	return list
end

local function processItemLegacy(list, p2, k, p3, p4, p5)
	local v5 = p3 == "Success" or defineFastFlag and p3 == "AlreadyOwned"
	local v6

	if
		p4 == nil
		or p5 ~= module8.LookType.Avatar
		and (not fFlagAXCatalogMakeupSupport or p5 ~= module8.LookType.Makeup)
	then
		v6 = k
	else
		v6 = getTryOnItemReducerKey(k, p4)
	end

	if v5 and p2[v6] ~= nil then
		table.insert(list, formatItemForWearAfterPurchaseLegacy(k, p2[v6], true))
	end

	return list
end

local function ShowToasts(p2, callback, object)
	local successCount = p2.successCount
	local failureCount = p2.failureCount

	if successCount > 0 and failureCount <= 0 then
		local v5 = if successCount == 1 then object:Format(
			"Feature.Avatar.Message.LooksPurchaseSuccessSingular",
			{ numItems = successCount }
		) else object:Format("Feature.Avatar.Message.LooksPurchaseSuccessPlural", {
			numItems = successCount
		})

		callback(module18({
			isLocalized = true,
			toastMessage = v5,
			toastType = module19.PurchaseMessage
		}))
	elseif successCount > 0 and failureCount > 0 then
		local v5

		if successCount == 1 and failureCount == 1 then
			v5 = "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericSS"
		elseif successCount == 1 and failureCount > 1 then
			v5 = "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericSP"
		elseif successCount > 1 and failureCount == 1 then
			v5 = "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericPS"
		else
			v5 = "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericPP"
		end

		callback(module18({
			isLocalized = true,
			toastMessage = object:Format("Feature.Avatar.Heading.LooksPurchasePartialSuccess"),
			toastSubMessage = object:Format(v5, {
				numSuccessItems = successCount,
				numFailureItems = failureCount
			}),
			toastType = module19.NetworkingError
		}))
	elseif successCount <= 0 and failureCount > 0 then
		callback(module18({
			isLocalized = true,
			toastMessage = object:Format("Feature.Avatar.Heading.LooksPurchaseFailed"),
			toastSubMessage = object:Format("Feature.Avatar.Message.LooksPurchaseFailedNetworkError"),
			toastType = module19.NetworkingError
		}))
	end
end

local function selectTryOnItems(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end

local function selectLookAnalyticsInfo(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo
end

local fn = fFlagAXMISEnableMultiShoppingUnifiedEvents and function(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookAnalyticsInfo
end or nil

local function PurchaseLookPrompt(props)
	local v5 = module21(module23)
	local v6 = useDispatch()
	local v7 = module21(module22)
	local v8 = module21(module5)
	local v9 = module21(module12)
	local v10 = useTriggerFeedback()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(true)
	local state3, setState3 = React.useState(true)

	local v11 = useAvatarSaveContext()

	local v12 = useSelector(selectLookAnalyticsInfo, getUseSelectorDeepEquals())
	local v13

	if fFlagAXMISEnableMultiShoppingUnifiedEvents then
		v13 = useSelector(fn, getUseSelectorDeepEquals())
	end

	local v14 = useSelector(selectTryOnItems, getUseSelectorDeepEquals())

	local v15 = useSelector(function(p2)
		return module17.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn(p2)
	end, getUseSelectorDeepEquals())

	local v16 = useSelector(function(p2)
		local look = p2.AvatarExperience.AvatarScene.Looks[props.lookId]

		if look then
			return look.lookType
		end

		return nil
	end, getUseSelectorDeepEquals())

	local v17 = useSelector(function(p2)
		local look = p2.AvatarExperience.AvatarScene.Looks[props.lookId]

		if look and look.name then
			return look.name
		end

		return nil
	end, getUseSelectorDeepEquals())

	local v18 = module20({
		buyButtonText = v16 == module8.LookType.Avatar and "Feature.Avatar.Title.BuyAvatar" or fFlagAXCatalogMakeupSupport and v16 == module8.LookType.Makeup and "Feature.Avatar.Title.BuyMakeup" or "Feature.Avatar.Title.BuyOutfit",
		buyLookQuestion = v16 == module8.LookType.Avatar and "Feature.Avatar.Label.BuyAvatarQuestion" or fFlagAXCatalogMakeupSupport and v16 == module8.LookType.Makeup and "Feature.Avatar.Label.BuyMakeupQuestion" or "Feature.Avatar.Label.BuyLookQuestion",
		buyLookTitle = v16 == module8.LookType.Avatar and "Feature.Avatar.Title.BuyAvatar" or fFlagAXCatalogMakeupSupport and v16 == module8.LookType.Makeup and "Feature.Avatar.Title.BuyMakeup" or "Feature.Avatar.Title.BuyOutfit",
		getButtonText = "Feature.Catalog.Label.Get",
		getLookQuestion = "Feature.Avatar.Label.GetLookQuestion",
		getLookTitle = "Feature.Avatar.Title.GetOutfit",
		characterSavedHeading = "Feature.Avatar.Heading.LooksCharacterSaved",
		characterSavedMsg = "Feature.Avatar.Message.LooksCharacterSaved",
		makeupLookSavedHeading = "Feature.Avatar.Heading.MakeupLookSaved",
		makeupLookSavedMsg = "Feature.Avatar.Message.MakeupLookSaved"
	})

	local function fn2()
		setState2(not state2)
	end

	local function fn3()
		setState3(not state3)
	end

	local function fn4(p2)
		if not p2 then
			return
		end

		v6(module18({
			isLocalized = true,
			toastMessage = v18.characterSavedHeading,
			toastSubMessage = v18.characterSavedMsg,
			toastType = module19.SuccessConfirmation
		}))
	end

	local function fn5()
		v6(module18({
			isLocalized = true,
			toastMessage = v18.makeupLookSavedHeading,
			toastSubMessage = v18.makeupLookSavedMsg,
			toastType = module19.SuccessConfirmation
		}))
	end

	local function handleWearAfterPurchase(p2)
		if not state2 then
			return
		end

		local v19 = {}

		if props.isTryOnFromOutsideAX then
			if props.ownedTryOnItems then
				for k, ownedTryOnItem in props.ownedTryOnItems do
					table.insert(
						v19,
						formatItemForWearAfterPurchaseLegacy(ownedTryOnItem.itemId, ownedTryOnItem, false)
					)
				end
			end

			if v14 then
				for k, v20 in p2.assetPurchaseStatus do
					v19 = processItemLegacy(v19, v14, k, v20, module8.ItemType.Asset, v16)
				end

				for k, v20 in p2.bundlePurchaseStatus do
					v19 = processItemLegacy(v19, v14, k, v20, module8.ItemType.Bundle, v16)
				end
			end
		else
			if props.ownedItemsInLook then
				for k, v20 in props.ownedItemsInLook do
					table.insert(v19, formatItemForWearAfterPurchaseMIS(v20.id, v20, false))
				end
			end

			if props.allLookItems then
				for k, v20 in p2.assetPurchaseStatus do
					local allLookItems = props.allLookItems

					local asset = module8.ItemType.Asset

					if
						(v20 == "Success" or defineFastFlag and v20 == "AlreadyOwned")
						and allLookItems[k] ~= nil
					then
						table.insert(v19, formatItemForWearAfterPurchaseMIS(k, allLookItems[k], true))
					end
				end

				for k, v20 in p2.bundlePurchaseStatus do
					local allLookItems = props.allLookItems

					local bundle = module8.ItemType.Bundle

					if
						(v20 == "Success" or defineFastFlag and v20 == "AlreadyOwned")
						and allLookItems[k] ~= nil
					then
						table.insert(v19, formatItemForWearAfterPurchaseMIS(k, allLookItems[k], true))
					end
				end
			end
		end

		if props.isTryOnFromOutsideAX and v11 and v11.autoSaveNextNewSaveData then
			v11.autoSaveNextNewSaveData()
		end

		if fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
			avatarLastEquippedStateStore.setShouldRevertLastEquippedState(false)
		end

		v6(module11(v19, props.navigation, nil, v16))

		if module26() and not props.isTryOnFromOutsideAX then
			v6(setTryOnManagerPeekViewState(peekViewState.Closed))
		end
	end

	local function handleSaveAsCharacter()
		if not state3 then
			return
		end

		local v19 = if v17 then v17 else defineFastString

		local function fn6(): boolean
			return true
		end

		if fFlagAXCatalogMakeupSupport and v16 == module8.LookType.Makeup then
			v6(saveAsMakeupLookThunk(v5, v19, v14, if not defineFastFlag2 then fn5 else nil))
		else
			v6(module7(v19, v8, fn6, if not defineFastFlag2 then fn4 else nil, v15))
		end
	end

	local fn6 = props.isTryOnFromOutsideAX and function(p2)
		local v19 = parseEconomicRestrictionsFailureReason(p2)
		local v20 = parseEconomicRestrictionsExpirationTimeInMinutes(p2)
		default:logRobloxTelemetryCounter(universalEconomicRestrictionsCounter, 1, {
			surface = economicRestrictionsSurface.AvatarExperienceLook,
			failureReason = v19
		})

		module14.closeOverlay(props.navigation)
		return v6(module24(v19, v20))
	end or nil

	local function fn7()
		if state then
			return
		end

		setState(true)

		v10("MakePurchase", "Press")

		v6(module10(v5, props.lookId, props.priceInRobux, v9)):andThen(function(p2)
			setState(false)
			ShowToasts(p2, v6, v7)

			if fFlagAXCatalogMakeupSupport and v16 == module8.LookType.Makeup then
				handleSaveAsCharacter()
			end

			handleWearAfterPurchase(p2)

			if v16 == module8.LookType.Avatar then
				setTimeout(handleSaveAsCharacter, fIntAXLookOutfitCreationDelayMs)
			end

			local navigation = props.navigation
			module14.closeOverlay(navigation)
		end, function(p2)
			sendAXCounterV2(module8.Counter.Errors.PurchaseLooksProductError, {
				lookId = props.lookId,
				promptType = "PurchaseLookPromptMIS",
				isTryOnFromOutsideAX = tostring(props.isTryOnFromOutsideAX)
			})

			module13("PurchaseLooksProductMIS error", p2)

			if fn6 and isEconomicRestrictionResponse(p2) then
				fn6(p2)
				return
			end

			setState(false)
			v6(module18({
				isLocalized = false,
				toastType = module19.NetworkingError,
				toastMessage = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName"
			}))

			local navigation = props.navigation
			module14.closeOverlay(navigation)
		end)
	end

	local function fn8()
		if state then
			return
		end

		module14.closeOverlay(props.navigation)
	end

	local v19, v20, v21

	if props.priceInRobux == 0 then
		v19 = v18.getLookTitle
		v20 = v18.getLookQuestion
		v21 = v18.getButtonText
	else
		v19 = v18.buyLookTitle
		v20 = v18.buyLookQuestion
		v21 = v18.buyButtonText
	end

	local createElement = React.createElement
	local v23 = {
		priceInRobux = props.priceInRobux,
		showWearAfterPurchase = props.showWearAfterPurchase,
		showSaveAsCharacter = props.showSaveAsCharacter,
		isWearAfterPurchaseChecked = state2,
		isSaveAsCharacterChecked = state3,
		toggleWearAfterPurchase = fn2,
		toggleSaveAsCharacter = fn3,
		saveIfWearAfterPurchase = props.isTryOnFromOutsideAX,
		lookType = v16,
		analyticsInfo = 0,
		itemId = 0,
		titleText = 0,
		bodyText = 0,
		confirmButtonText = 0,
		onConfirm = 0,
		onCancel = 0,
		isLoading = 0,
		isPurchasingOutfit = true,
		defaultChildRef = 0
	}

	if fFlagAXMISEnableMultiShoppingUnifiedEvents then
		if v16 ~= module8.LookType.Makeup then
			v13 = v12
		end
	else
		v13 = v12
	end

	v23.analyticsInfo = v13

	local v24 = if fFlagAXUnifiedEventStrictPayloads then props.lookId else nil
	v23.itemId = v24
	v23.titleText = v19
	v23.bodyText = v20
	v23.confirmButtonText = v21
	v23.onConfirm = fn7
	v23.onCancel = fn8
	v23.isLoading = state

	v23.defaultChildRef = props.defaultChildRef
	return createElement(module9, v23)
end

return (module16((module15(PurchaseLookPrompt))))
