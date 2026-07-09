local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local setTimeout = require(CorePackages.Packages.LuauPolyfill).setTimeout
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local CreateOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.CreateOutfit)
local SaveAsMakeupLookThunk = AvatarExperienceCatalog.Thunks.SaveAsMakeupLookThunk
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local PurchasePromptInteractiveAlert = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.PurchasePromptInteractiveAlert)
local PurchaseLooksProduct = require(Modules.AvatarExperience.Catalog.Thunks.PurchaseLooksProduct)
local WearAfterOutfitPurchase = require(Modules.AvatarExperience.Catalog.Thunks.WearAfterOutfitPurchase)
local Analytics2 = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local SetTryOnManagerPeekViewState = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.SetTryOnManagerPeekViewState
local mutedError = require(Modules.LuaApp.mutedError)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local CharacterManagerUtils = require(Modules.AvatarExperience.Common.Util.CharacterManagerUtils)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)

require(Modules.AvatarExperience.Common.Types)
require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)

local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local avatarLastEquippedStateStore = AvatarExperienceCommon.Stores.AvatarLastEquippedStateStore.avatarLastEquippedStateStore
local useAvatarSaveContext = require(CorePackages.Workspace.Packages.AvatarExperienceSave).Context.useAvatarSaveContext
local useTriggerFeedback = require(CorePackages.Workspace.Packages.InteractionFeedback).useTriggerFeedback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local v39 = game:DefineFastString("AXDefaultCharacterName", "Avatar")
local FIntAXLookOutfitCreationDelayMs = AvatarExperienceFlags.FIntAXLookOutfitCreationDelayMs
local v41 = game:DefineFastFlag("SupportAlreadyOwnedItemPurchaseStatus", false)
local GetFFlagEnableSavePurchasedLooksWithLookName = require(Modules.AvatarExperience.Flags.GetFFlagEnableSavePurchasedLooksWithLookName)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup = AvatarExperienceFlags.FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup
local FFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp
local v48 = FFlagAXRootSlotBasedEditorFlag and game:DefineFastFlag("AXDisableCharacterSaveToast", false)
local OpenCentralOverlayForEconomicRestrictionPrompt = require(Modules.LuaApp.Thunks.Fraud.OpenCentralOverlayForEconomicRestrictionPrompt)
local IAPExperience = require(CorePackages.Workspace.Packages.IAPExperience)
local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse
local EconomicRestrictionsCounter = IAPExperience.Counters.EconomicRestrictionsCounter
local UniversalEconomicRestrictionsCounter = EconomicRestrictionsCounter.UniversalEconomicRestrictionsCounter
local EconomicRestrictionsSurface = EconomicRestrictionsCounter.EconomicRestrictionsSurface
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local parseEconomicRestrictionsFailureReason = IAPExperience.Utility.parseEconomicRestrictionsFailureReason
local parseEconomicRestrictionsExpirationTimeInMinutes = IAPExperience.Utility.parseEconomicRestrictionsExpirationTimeInMinutes

local function PurchaseResolveNav(p1) -- line: 100
	-- upvalues: NavigationUtils (copy)
	NavigationUtils.closeOverlay(p1)
end
local function formatItemForWearAfterPurchase(p2, p3, p4) -- line: 108
	-- upvalues: Constants (copy)
	local v67 = p3.itemType == Constants.ItemType.Bundle

	return {
		owned = true,
		assetId = if v67 then nil else p2,
		assetIsWearable = not v67,
		assetType = if not v67 then nil else Constants.ItemType.Bundle,
		bundleId = if not v67 then nil else p2,
		itemSubType = p3.itemSubType,
		overrideOrder = p3.order,
		overrideAdjustments = {
			position = p3.position,
			rotation = p3.rotation,
			scale = p3.scale
		},
		purchased = p4,
		tryOnBundleInfo = if not v67 then nil else p3.bundleInfo
	}
end
local function processItem(p5, p6, p7, p8, p9, p10) -- line: 129
	-- upvalues: v41 (copy), Constants (copy), FFlagAXCatalogMakeupSupport (copy), getTryOnItemReducerKey (copy), formatItemForWearAfterPurchase (copy)
	local v74 = p8 == "Success" or v41 and p8 == "AlreadyOwned"
	local v75 = if p9 == nil or p10 ~= Constants.LookType.Avatar and (not FFlagAXCatalogMakeupSupport or p10 ~= Constants.LookType.Makeup) then p7 else getTryOnItemReducerKey(p7, p9)

	if v74 and p6[v75] ~= nil then
		table.insert(p5, (formatItemForWearAfterPurchase(p7, p6[v75], true)))
	end

	return p5
end
local function ShowToasts(p11, p12: ((...any) -> ...any), p13) -- line: 161
	-- upvalues: ToastType (copy), SetCurrentToastMessage (copy)
	local successCount = p11.successCount
	local failureCount = p11.failureCount

	if successCount > 0 and failureCount <= 0 then
		local v81 = if successCount ~= 1 then p13:Format("Feature.Avatar.Message.LooksPurchaseSuccessPlural", {
			numItems = successCount
		}) else p13:Format("Feature.Avatar.Message.LooksPurchaseSuccessSingular", {
			numItems = successCount
		})
		local t1 = {
			isLocalized = true,
			toastMessage = v81,
			toastType = ToastType.PurchaseMessage
		}

		p12(SetCurrentToastMessage(t1))

		return
	end

	if successCount > 0 and failureCount > 0 then
		local v83 = if successCount ~= 1 or failureCount ~= 1 then if successCount ~= 1 or not (failureCount > 1) then (not (successCount > 1) or failureCount ~= 1) and "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericPP" or "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericPS" else "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericSP" else "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericSS"
		local t2 = {
			numSuccessItems = successCount,
			numFailureItems = failureCount
		}
		local t3 = {
			isLocalized = true,
			toastMessage = p13:Format("Feature.Avatar.Heading.LooksPurchasePartialSuccess"),
			toastSubMessage = p13:Format(v83, t2),
			toastType = ToastType.NetworkingError
		}

		p12(SetCurrentToastMessage(t3))

		return
	end

	if successCount <= 0 and failureCount > 0 then
		local t4 = {
			isLocalized = true,
			toastMessage = p13:Format("Feature.Avatar.Heading.LooksPurchaseFailed"),
			toastSubMessage = p13:Format("Feature.Avatar.Message.LooksPurchaseFailedNetworkError"),
			toastType = ToastType.NetworkingError
		}

		p12(SetCurrentToastMessage(t4))

		return
	end
end
local function PurchaseLookPrompt(t5: {[any]: any}) -- line: 226
	-- upvalues: useRoactService (copy), RoactNetworking (copy), useDispatch (copy), RoactLocalization (copy), Analytics (copy), Analytics2 (copy), useTriggerFeedback (copy), React (copy), useAvatarSaveContext (copy), useSelector (copy), getUseSelectorDeepEquals (copy), CharacterManagerUtils (copy), GetFFlagEnableSavePurchasedLooksWithLookName (copy), useLocalization (copy), Constants (copy), FFlagAXCatalogMakeupSupport (copy), ToastType (copy), SetCurrentToastMessage (copy), formatItemForWearAfterPurchase (copy), processItem (copy), v41 (copy), FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup (copy), avatarLastEquippedStateStore (copy), WearAfterOutfitPurchase (copy), GetFFlagAXEnableSlotBasedEditor (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), v39 (copy), Utils (copy), FFlagAXOutfitPageRevamp (copy), SaveAsMakeupLookThunk (copy), v48 (copy), CreateOutfit (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), NavigationUtils (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy), PurchaseLooksProduct (copy), ShowToasts (copy), setTimeout (copy), FIntAXLookOutfitCreationDelayMs (copy), sendAXCounterV2 (copy), mutedError (copy), isEconomicRestrictionResponse (copy), PurchasePromptInteractiveAlert (copy)
	local v88 = useRoactService(RoactNetworking)
	local v89 = useDispatch()
	local v90 = useRoactService(RoactLocalization)
	local v91 = useRoactService(Analytics)
	local v92 = useRoactService(Analytics2)
	local v93 = useTriggerFeedback()
	local v94, v95 = React.useState(false)
	local v96, v97 = React.useState(true)
	local v98, v99 = React.useState(true)
	local v100 = useAvatarSaveContext()
	local v101 = useSelector(function(p14) -- line: 239
		return p14.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	end)
	local v102 = useSelector(function(p15) -- line: 243
		return p15.AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo
	end, getUseSelectorDeepEquals())
	local v103 = useSelector(function(p16) -- line: 247
		return p16.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
	end, getUseSelectorDeepEquals())
	local v104 = useSelector(function(p17) -- line: 251
		return p17.AvatarExperience.AvatarEditor.OutfitInfos
	end, getUseSelectorDeepEquals())
	local v105 = useSelector(function(p18) -- line: 255
		-- upvalues: CharacterManagerUtils (copy)
		return CharacterManagerUtils.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn(p18)
	end, getUseSelectorDeepEquals())
	local v106 = useSelector(function(p19) -- line: 259
		-- upvalues: t5 (copy)
		local v123 = p19.AvatarExperience.AvatarScene.Looks[t5.lookId]

		if v123 then
			return v123.lookType
		end

		return nil
	end, getUseSelectorDeepEquals())
	local u107 = nil

	if GetFFlagEnableSavePurchasedLooksWithLookName() then
		u107 = useSelector(function(p20) -- line: 267
			-- upvalues: t5 (copy)
			local v125 = p20.AvatarExperience.AvatarScene.Looks[t5.lookId]

			if v125 and v125.name then
				return v125.name
			end

			return nil
		end, getUseSelectorDeepEquals())
	end

	local v108 = useLocalization({
		getButtonText = "Feature.Catalog.Label.Get",
		getLookQuestion = "Feature.Avatar.Label.GetLookQuestion",
		getLookTitle = "Feature.Avatar.Title.GetOutfit",
		characterSavedHeading = "Feature.Avatar.Heading.LooksCharacterSaved",
		characterSavedMsg = "Feature.Avatar.Message.LooksCharacterSaved",
		makeupLookSavedHeading = "Feature.Avatar.Heading.MakeupLookSaved",
		makeupLookSavedMsg = "Feature.Avatar.Message.MakeupLookSaved",
		buyButtonText = if v106 ~= Constants.LookType.Avatar then (not FFlagAXCatalogMakeupSupport or v106 ~= Constants.LookType.Makeup) and "Feature.Avatar.Title.BuyOutfit" or "Feature.Avatar.Title.BuyMakeup" else "Feature.Avatar.Title.BuyAvatar",
		buyLookQuestion = if v106 ~= Constants.LookType.Avatar then (not FFlagAXCatalogMakeupSupport or v106 ~= Constants.LookType.Makeup) and "Feature.Avatar.Label.BuyLookQuestion" or "Feature.Avatar.Label.BuyMakeupQuestion" else "Feature.Avatar.Label.BuyAvatarQuestion",
		buyLookTitle = if v106 ~= Constants.LookType.Avatar then (not FFlagAXCatalogMakeupSupport or v106 ~= Constants.LookType.Makeup) and "Feature.Avatar.Title.BuyOutfit" or "Feature.Avatar.Title.BuyMakeup" else "Feature.Avatar.Title.BuyAvatar"
	})

	local function v109(b1: boolean) -- line: 311
		-- upvalues: v108 (copy), ToastType (copy), v89 (copy), SetCurrentToastMessage (copy)
		if not b1 then
			return
		end

		local t6 = {
			isLocalized = true,
			toastMessage = v108.characterSavedHeading,
			toastSubMessage = v108.characterSavedMsg,
			toastType = ToastType.SuccessConfirmation
		}

		v89(SetCurrentToastMessage(t6))
	end
	local function v110() -- line: 327
		-- upvalues: v108 (copy), ToastType (copy), v89 (copy), SetCurrentToastMessage (copy)
		local t7 = {
			isLocalized = true,
			toastMessage = v108.makeupLookSavedHeading,
			toastSubMessage = v108.makeupLookSavedMsg,
			toastType = ToastType.SuccessConfirmation
		}

		v89(SetCurrentToastMessage(t7))
	end
	local function handleWearAfterPurchase(p21) -- line: 337
		-- upvalues: v96 (copy), t5 (copy), formatItemForWearAfterPurchase (copy), v106 (copy), Constants (copy), FFlagAXCatalogMakeupSupport (copy), processItem (copy), v101 (copy), v41 (copy), v100 (copy), FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup (copy), avatarLastEquippedStateStore (copy), v89 (copy), WearAfterOutfitPurchase (copy), GetFFlagAXEnableSlotBasedEditor (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy)
		if not v96 then
			return
		end

		local t8 = {}

		for _, v132 in t5.ownedTryOnItems do
			table.insert(t8, (formatItemForWearAfterPurchase(v132.itemId, v132, false)))
		end

		if v106 == Constants.LookType.Avatar or FFlagAXCatalogMakeupSupport and v106 == Constants.LookType.Makeup then
			for v133, v134 in p21.assetPurchaseStatus do
				t8 = processItem(t8, v101, v133, v134, Constants.ItemType.Asset, v106)
			end

			for v135, v136 in p21.bundlePurchaseStatus do
				t8 = processItem(t8, v101, v135, v136, Constants.ItemType.Bundle, v106)
			end
		else
			for v137, v138 in p21.itemPurchaseStatus do
				local v139 = v101
				local v140 = v137

				if (v138 == "Success" or v41 and v138 == "AlreadyOwned") and v139[v140] ~= nil then
					table.insert(t8, (formatItemForWearAfterPurchase(v137, v139[v140], true)))
				end
			end
		end

		if t5.isTryOnFromOutsideAX and v100 and v100.autoSaveNextNewSaveData then
			v100.autoSaveNextNewSaveData()
		end

		if FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
			avatarLastEquippedStateStore.setShouldRevertLastEquippedState(false)
		end

		v89(WearAfterOutfitPurchase(t8, t5.navigation, nil, v106))

		if GetFFlagAXEnableSlotBasedEditor() and not t5.isTryOnFromOutsideAX then
			v89(SetTryOnManagerPeekViewState(PeekViewState.Closed))
		end
	end
	local function handleSaveAsCharacter() -- line: 408
		-- upvalues: v98 (copy), v106 (copy), Constants (copy), FFlagAXCatalogMakeupSupport (copy), GetFFlagEnableSavePurchasedLooksWithLookName (copy), u107 (ref), v39 (copy), Utils (copy), v103 (copy), v104 (copy), FFlagAXOutfitPageRevamp (copy), v89 (copy), SaveAsMakeupLookThunk (copy), v88 (copy), v101 (copy), v48 (copy), v110 (copy), CreateOutfit (copy), v91 (copy), v109 (copy), v105 (copy)
		if not v98 then
			return
		end

		local v141 = nil

		if v106 == Constants.LookType.Avatar or FFlagAXCatalogMakeupSupport and v106 == Constants.LookType.Makeup then
			v141 = if not GetFFlagEnableSavePurchasedLooksWithLookName() or not u107 then v39 else u107
		else
			for i = 1, 1000 do
				v141 = "Outfit" .. i

				if not Utils.isDuplicateOutfitName(v103, v104, v141, if not FFlagAXOutfitPageRevamp then nil else if v106 ~= Constants.LookType.Makeup then Constants.OutfitTypes.Avatar else Constants.OutfitTypes.Makeup) then
					break
				end
			end
		end

		if FFlagAXCatalogMakeupSupport and v106 == Constants.LookType.Makeup then
			v89(SaveAsMakeupLookThunk(v88, v141, v101, if not v48 then v110 else nil))

			return
		end

		v89(CreateOutfit(v141, v91, function() -- line: 446
			return true
		end, if not v48 then v109 else nil, v105))
	end
	local function v113(p22) -- line: 472
		-- upvalues: parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), NavigationUtils (copy), t5 (copy), v89 (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy)
		local v144 = parseEconomicRestrictionsFailureReason(p22)
		local v145 = parseEconomicRestrictionsExpirationTimeInMinutes(p22)

		default:logRobloxTelemetryCounter(UniversalEconomicRestrictionsCounter, 1, {
			surface = EconomicRestrictionsSurface.AvatarExperienceLook,
			failureReason = v144
		})
		NavigationUtils.closeOverlay(t5.navigation)

		return v89(OpenCentralOverlayForEconomicRestrictionPrompt(v144, v145))
	end

	local getLookTitle, getLookQuestion, getButtonText

	if t5.priceInRobux == 0 then
		getLookTitle = v108.getLookTitle
		getLookQuestion = v108.getLookQuestion
		getButtonText = v108.getButtonText
	else
		getLookTitle = v108.buyLookTitle
		getLookQuestion = v108.buyLookQuestion
		getButtonText = v108.buyButtonText
	end

	return React.createElement(PurchasePromptInteractiveAlert, {
		isPurchasingOutfit = true,
		priceInRobux = t5.priceInRobux,
		showWearAfterPurchase = t5.showWearAfterPurchase,
		showSaveAsCharacter = t5.showSaveAsCharacter,
		isWearAfterPurchaseChecked = v96,
		isSaveAsCharacterChecked = v98,
		toggleWearAfterPurchase = function() -- line: 302
			-- upvalues: v97 (copy), v96 (copy)
			v97(not v96)
		end,
		toggleSaveAsCharacter = function() -- line: 306
			-- upvalues: v99 (copy), v98 (copy)
			v99(not v98)
		end,
		saveIfWearAfterPurchase = t5.isTryOnFromOutsideAX,
		lookType = v106,
		analyticsInfo = v102,
		titleText = getLookTitle,
		bodyText = getLookQuestion,
		confirmButtonText = getButtonText,
		onConfirm = function() -- line: 483
			-- upvalues: v94 (copy), v95 (copy), v93 (copy), v89 (copy), PurchaseLooksProduct (copy), v88 (copy), t5 (copy), v92 (copy), ShowToasts (copy), v90 (copy), FFlagAXCatalogMakeupSupport (copy), v106 (copy), Constants (copy), handleSaveAsCharacter (copy), handleWearAfterPurchase (copy), setTimeout (copy), FIntAXLookOutfitCreationDelayMs (copy), NavigationUtils (copy), sendAXCounterV2 (copy), mutedError (copy), v113 (copy), isEconomicRestrictionResponse (copy), SetCurrentToastMessage (copy), ToastType (copy)
			if v94 then
				return
			end

			v95(true)
			v93("MakePurchase", "Press")
			v89(PurchaseLooksProduct(v88, t5.lookId, t5.priceInRobux, v92)):andThen(function(p23) -- line: 492
				-- upvalues: v95 (copy), ShowToasts (copy), v89 (copy), v90 (copy), FFlagAXCatalogMakeupSupport (copy), v106 (copy), Constants (copy), handleSaveAsCharacter (copy), handleWearAfterPurchase (copy), setTimeout (copy), FIntAXLookOutfitCreationDelayMs (copy), t5 (copy), NavigationUtils (copy)
				v95(false)
				ShowToasts(p23, v89, v90)

				if FFlagAXCatalogMakeupSupport and v106 == Constants.LookType.Makeup then
					handleSaveAsCharacter()
				end

				handleWearAfterPurchase(p23)

				if v106 == Constants.LookType.Avatar then
					setTimeout(handleSaveAsCharacter, FIntAXLookOutfitCreationDelayMs)
				elseif v106 ~= Constants.LookType.Makeup then
					handleSaveAsCharacter()
				end

				local navigation = t5.navigation

				NavigationUtils.closeOverlay(navigation)
			end, function(p24) -- line: 511
				-- upvalues: sendAXCounterV2 (copy), Constants (copy), t5 (copy), mutedError (copy), v113 (copy), isEconomicRestrictionResponse (copy), v95 (copy), v89 (copy), SetCurrentToastMessage (copy), ToastType (copy), NavigationUtils (copy)
				sendAXCounterV2(Constants.Counter.Errors.PurchaseLooksProductError, {
					lookId = t5.lookId
				})
				mutedError("PurchaseLooksProduct error", p24)

				if v113 and isEconomicRestrictionResponse(p24) then
					v113(p24)

					return
				end

				v95(false)
				v89(SetCurrentToastMessage({
					isLocalized = false,
					toastMessage = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
					toastType = ToastType.NetworkingError
				}))

				local navigation = t5.navigation

				NavigationUtils.closeOverlay(navigation)
			end)
		end,
		onCancel = function() -- line: 532
			-- upvalues: v94 (copy), NavigationUtils (copy), t5 (copy)
			if v94 then
				return
			end

			NavigationUtils.closeOverlay(t5.navigation)
		end,
		isLoading = v94,
		defaultChildRef = t5.defaultChildRef
	})
end

return (withMappedNavigationParams((withOverlayFocusHandling(PurchaseLookPrompt))))
