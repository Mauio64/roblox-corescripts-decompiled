local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local setTimeout = require(CorePackages.Packages.LuauPolyfill).setTimeout
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)

require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)

local CreateOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.CreateOutfit)
local SaveAsMakeupLookThunk = AvatarExperienceCatalog.Thunks.SaveAsMakeupLookThunk
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

local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local avatarLastEquippedStateStore = AvatarExperienceCommon.Stores.AvatarLastEquippedStateStore.avatarLastEquippedStateStore
local useAvatarSaveContext = require(CorePackages.Workspace.Packages.AvatarExperienceSave).Context.useAvatarSaveContext
local OpenCentralOverlayForEconomicRestrictionPrompt = require(Modules.LuaApp.Thunks.Fraud.OpenCentralOverlayForEconomicRestrictionPrompt)
local IAPExperience = require(CorePackages.Workspace.Packages.IAPExperience)
local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse
local EconomicRestrictionsCounter = IAPExperience.Counters.EconomicRestrictionsCounter
local UniversalEconomicRestrictionsCounter = EconomicRestrictionsCounter.UniversalEconomicRestrictionsCounter
local EconomicRestrictionsSurface = EconomicRestrictionsCounter.EconomicRestrictionsSurface
local parseEconomicRestrictionsFailureReason = IAPExperience.Utility.parseEconomicRestrictionsFailureReason
local parseEconomicRestrictionsExpirationTimeInMinutes = IAPExperience.Utility.parseEconomicRestrictionsExpirationTimeInMinutes
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local useTriggerFeedback = require(CorePackages.Workspace.Packages.InteractionFeedback).useTriggerFeedback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local v47 = game:DefineFastString("AXDefaultCharacterName", "Avatar")
local FIntAXLookOutfitCreationDelayMs = AvatarExperienceFlags.FIntAXLookOutfitCreationDelayMs
local v49 = game:DefineFastFlag("SupportAlreadyOwnedItemPurchaseStatus", false)
local GetFFlagEnableSavePurchasedLooksWithLookName = require(Modules.AvatarExperience.Flags.GetFFlagEnableSavePurchasedLooksWithLookName)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup = AvatarExperienceFlags.FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local v56 = FFlagAXRootSlotBasedEditorFlag and game:DefineFastFlag("AXDisableCharacterSaveToast", false)

local function PurchaseResolveNav(p1) -- line: 105
	-- upvalues: NavigationUtils (copy)
	NavigationUtils.closeOverlay(p1)
end
local function formatItemForWearAfterPurchaseMIS(p2, p3, p4) -- line: 113
	-- upvalues: Constants (copy)
	local v71 = p3.itemType == Constants.ItemType.Bundle
	local t1 = {}

	if v71 then
		for _, v74 in p3.assetsInBundle do
			if v74.isIncluded then
				t1[tostring(v74.id)] = {
					assetType = tostring(v74.assetType),
					order = v74.order
				}
			end
		end
	end

	return {
		owned = true,
		assetId = if v71 then nil else p2,
		assetIsWearable = not v71,
		assetType = if not v71 then nil else Constants.ItemType.Bundle,
		bundleId = if not v71 then nil else p2,
		itemSubType = if not v71 then tostring(p3.assetType) else tostring(p3.bundleType),
		purchased = p4,
		tryOnBundleInfo = if not v71 then nil else t1
	}
end
local function formatItemForWearAfterPurchaseLegacy(p5, p6, p7) -- line: 144
	-- upvalues: Constants (copy)
	local v78 = p6.itemType == Constants.ItemType.Bundle

	return {
		owned = true,
		assetId = if v78 then nil else p5,
		assetIsWearable = not v78,
		assetType = if not v78 then nil else Constants.ItemType.Bundle,
		bundleId = if not v78 then nil else p5,
		itemSubType = p6.itemSubType,
		overrideOrder = p6.order,
		overrideAdjustments = {
			position = p6.position,
			rotation = p6.rotation,
			scale = p6.scale
		},
		purchased = p7,
		tryOnBundleInfo = if not v78 then nil else p6.bundleInfo
	}
end
local function processItem(p8, p9, p10, p11, _) -- line: 169
	-- upvalues: v49 (copy), formatItemForWearAfterPurchaseMIS (copy)
	if (p11 == "Success" or v49 and p11 == "AlreadyOwned") and p9[p10] ~= nil then
		table.insert(p8, (formatItemForWearAfterPurchaseMIS(p10, p9[p10], true)))
	end

	return p8
end
local function processItemLegacy(p13, p14, p15, p16, p17, p18) -- line: 183
	-- upvalues: v49 (copy), Constants (copy), FFlagAXCatalogMakeupSupport (copy), getTryOnItemReducerKey (copy), formatItemForWearAfterPurchaseLegacy (copy)
	local v90 = p16 == "Success" or v49 and p16 == "AlreadyOwned"
	local v91 = if p17 == nil or p18 ~= Constants.LookType.Avatar and (not FFlagAXCatalogMakeupSupport or p18 ~= Constants.LookType.Makeup) then p15 else getTryOnItemReducerKey(p15, p17)

	if v90 and p14[v91] ~= nil then
		table.insert(p13, (formatItemForWearAfterPurchaseLegacy(p15, p14[v91], true)))
	end

	return p13
end
local function ShowToasts(p19, p20: ((...any) -> ...any), p21) -- line: 216
	-- upvalues: ToastType (copy), SetCurrentToastMessage (copy)
	local successCount = p19.successCount
	local failureCount = p19.failureCount

	if successCount > 0 and failureCount <= 0 then
		local v97 = if successCount ~= 1 then p21:Format("Feature.Avatar.Message.LooksPurchaseSuccessPlural", {
			numItems = successCount
		}) else p21:Format("Feature.Avatar.Message.LooksPurchaseSuccessSingular", {
			numItems = successCount
		})
		local t2 = {
			isLocalized = true,
			toastMessage = v97,
			toastType = ToastType.PurchaseMessage
		}

		p20(SetCurrentToastMessage(t2))

		return
	end

	if successCount > 0 and failureCount > 0 then
		local v99 = if successCount ~= 1 or failureCount ~= 1 then if successCount ~= 1 or not (failureCount > 1) then (not (successCount > 1) or failureCount ~= 1) and "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericPP" or "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericPS" else "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericSP" else "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericSS"
		local t3 = {
			numSuccessItems = successCount,
			numFailureItems = failureCount
		}
		local t4 = {
			isLocalized = true,
			toastMessage = p21:Format("Feature.Avatar.Heading.LooksPurchasePartialSuccess"),
			toastSubMessage = p21:Format(v99, t3),
			toastType = ToastType.NetworkingError
		}

		p20(SetCurrentToastMessage(t4))

		return
	end

	if successCount <= 0 and failureCount > 0 then
		local t5 = {
			isLocalized = true,
			toastMessage = p21:Format("Feature.Avatar.Heading.LooksPurchaseFailed"),
			toastSubMessage = p21:Format("Feature.Avatar.Message.LooksPurchaseFailedNetworkError"),
			toastType = ToastType.NetworkingError
		}

		p20(SetCurrentToastMessage(t5))

		return
	end
end
local function selectTryOnItems(p22) -- line: 281
	return p22.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end
local function selectLookAnalyticsInfo(p23) -- line: 285
	return p23.AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo
end

local u65 = nil

if FFlagAXMISEnableMultiShoppingUnifiedEvents then
	function u65(p24) -- line: 291
		return p24.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookAnalyticsInfo
	end
end

local function PurchaseLookPrompt(t6: {[any]: any}) -- line: 296
	-- upvalues: useRoactService (copy), RoactNetworking (copy), useDispatch (copy), RoactLocalization (copy), Analytics (copy), Analytics2 (copy), useTriggerFeedback (copy), React (copy), useAvatarSaveContext (copy), useSelector (copy), selectLookAnalyticsInfo (copy), getUseSelectorDeepEquals (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), u65 (ref), selectTryOnItems (copy), CharacterManagerUtils (copy), GetFFlagEnableSavePurchasedLooksWithLookName (copy), useLocalization (copy), Constants (copy), FFlagAXCatalogMakeupSupport (copy), ToastType (copy), SetCurrentToastMessage (copy), formatItemForWearAfterPurchaseLegacy (copy), processItemLegacy (copy), formatItemForWearAfterPurchaseMIS (copy), v49 (copy), FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup (copy), avatarLastEquippedStateStore (copy), WearAfterOutfitPurchase (copy), GetFFlagAXEnableSlotBasedEditor (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), v47 (copy), SaveAsMakeupLookThunk (copy), v56 (copy), CreateOutfit (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), NavigationUtils (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy), PurchaseLooksProduct (copy), ShowToasts (copy), setTimeout (copy), FIntAXLookOutfitCreationDelayMs (copy), sendAXCounterV2 (copy), mutedError (copy), isEconomicRestrictionResponse (copy), PurchasePromptInteractiveAlert (copy)
	local v107 = useRoactService(RoactNetworking)
	local v108 = useDispatch()
	local v109 = useRoactService(RoactLocalization)
	local v110 = useRoactService(Analytics)
	local v111 = useRoactService(Analytics2)
	local v112 = useTriggerFeedback()
	local v113, v114 = React.useState(false)
	local v115, v116 = React.useState(true)
	local v117, v118 = React.useState(true)
	local v119 = useAvatarSaveContext()
	local v120 = useSelector(selectLookAnalyticsInfo, getUseSelectorDeepEquals())
	local v121 = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else useSelector(u65, getUseSelectorDeepEquals())
	local v122 = useSelector(selectTryOnItems, getUseSelectorDeepEquals())
	local v123 = useSelector(function(p25) -- line: 315
		-- upvalues: CharacterManagerUtils (copy)
		return CharacterManagerUtils.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn(p25)
	end, getUseSelectorDeepEquals())
	local v124 = useSelector(function(p26) -- line: 319
		-- upvalues: t6 (copy)
		local v137 = p26.AvatarExperience.AvatarScene.Looks[t6.lookId]

		if v137 then
			return v137.lookType
		end

		return nil
	end, getUseSelectorDeepEquals())
	local u125 = nil

	if GetFFlagEnableSavePurchasedLooksWithLookName() then
		u125 = useSelector(function(p27) -- line: 327
			-- upvalues: t6 (copy)
			local v139 = p27.AvatarExperience.AvatarScene.Looks[t6.lookId]

			if v139 and v139.name then
				return v139.name
			end

			return nil
		end, getUseSelectorDeepEquals())
	end

	local v126 = useLocalization({
		getButtonText = "Feature.Catalog.Label.Get",
		getLookQuestion = "Feature.Avatar.Label.GetLookQuestion",
		getLookTitle = "Feature.Avatar.Title.GetOutfit",
		characterSavedHeading = "Feature.Avatar.Heading.LooksCharacterSaved",
		characterSavedMsg = "Feature.Avatar.Message.LooksCharacterSaved",
		makeupLookSavedHeading = "Feature.Avatar.Heading.MakeupLookSaved",
		makeupLookSavedMsg = "Feature.Avatar.Message.MakeupLookSaved",
		buyButtonText = if v124 ~= Constants.LookType.Avatar then (not FFlagAXCatalogMakeupSupport or v124 ~= Constants.LookType.Makeup) and "Feature.Avatar.Title.BuyOutfit" or "Feature.Avatar.Title.BuyMakeup" else "Feature.Avatar.Title.BuyAvatar",
		buyLookQuestion = if v124 ~= Constants.LookType.Avatar then (not FFlagAXCatalogMakeupSupport or v124 ~= Constants.LookType.Makeup) and "Feature.Avatar.Label.BuyLookQuestion" or "Feature.Avatar.Label.BuyMakeupQuestion" else "Feature.Avatar.Label.BuyAvatarQuestion",
		buyLookTitle = if v124 ~= Constants.LookType.Avatar then (not FFlagAXCatalogMakeupSupport or v124 ~= Constants.LookType.Makeup) and "Feature.Avatar.Title.BuyOutfit" or "Feature.Avatar.Title.BuyMakeup" else "Feature.Avatar.Title.BuyAvatar"
	})

	local function v127(b1: boolean) -- line: 371
		-- upvalues: v126 (copy), ToastType (copy), v108 (copy), SetCurrentToastMessage (copy)
		if not b1 then
			return
		end

		local t7 = {
			isLocalized = true,
			toastMessage = v126.characterSavedHeading,
			toastSubMessage = v126.characterSavedMsg,
			toastType = ToastType.SuccessConfirmation
		}

		v108(SetCurrentToastMessage(t7))
	end
	local function v128() -- line: 387
		-- upvalues: v126 (copy), ToastType (copy), v108 (copy), SetCurrentToastMessage (copy)
		local t8 = {
			isLocalized = true,
			toastMessage = v126.makeupLookSavedHeading,
			toastSubMessage = v126.makeupLookSavedMsg,
			toastType = ToastType.SuccessConfirmation
		}

		v108(SetCurrentToastMessage(t8))
	end
	local function handleWearAfterPurchase(p28) -- line: 397
		-- upvalues: v115 (copy), t6 (copy), formatItemForWearAfterPurchaseLegacy (copy), v122 (copy), processItemLegacy (copy), Constants (copy), v124 (copy), formatItemForWearAfterPurchaseMIS (copy), v49 (copy), v119 (copy), FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup (copy), avatarLastEquippedStateStore (copy), v108 (copy), WearAfterOutfitPurchase (copy), GetFFlagAXEnableSlotBasedEditor (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy)
		if not v115 then
			return
		end

		local t9 = {}

		if t6.isTryOnFromOutsideAX then
			if t6.ownedTryOnItems then
				for _, v146 in t6.ownedTryOnItems do
					table.insert(t9, (formatItemForWearAfterPurchaseLegacy(v146.itemId, v146, false)))
				end
			end

			if v122 then
				for v147, v148 in p28.assetPurchaseStatus do
					t9 = processItemLegacy(t9, v122, v147, v148, Constants.ItemType.Asset, v124)
				end

				for v149, v150 in p28.bundlePurchaseStatus do
					t9 = processItemLegacy(t9, v122, v149, v150, Constants.ItemType.Bundle, v124)
				end
			end
		else
			if t6.ownedItemsInLook then
				for _, v152 in t6.ownedItemsInLook do
					table.insert(t9, (formatItemForWearAfterPurchaseMIS(v152.id, v152, false)))
				end
			end

			if t6.allLookItems then
				for v153, v154 in p28.assetPurchaseStatus do
					local allLookItems = t6.allLookItems
					local _ = Constants.ItemType.Asset

					if (v154 == "Success" or v49 and v154 == "AlreadyOwned") and allLookItems[v153] ~= nil then
						table.insert(t9, (formatItemForWearAfterPurchaseMIS(v153, allLookItems[v153], true)))
					end
				end

				for v157, v158 in p28.bundlePurchaseStatus do
					local allLookItems = t6.allLookItems
					local _ = Constants.ItemType.Bundle

					if (v158 == "Success" or v49 and v158 == "AlreadyOwned") and allLookItems[v157] ~= nil then
						table.insert(t9, (formatItemForWearAfterPurchaseMIS(v157, allLookItems[v157], true)))
					end
				end
			end
		end

		if t6.isTryOnFromOutsideAX and v119 and v119.autoSaveNextNewSaveData then
			v119.autoSaveNextNewSaveData()
		end

		if FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
			avatarLastEquippedStateStore.setShouldRevertLastEquippedState(false)
		end

		v108(WearAfterOutfitPurchase(t9, t6.navigation, nil, v124))

		if GetFFlagAXEnableSlotBasedEditor() and not t6.isTryOnFromOutsideAX then
			v108(SetTryOnManagerPeekViewState(PeekViewState.Closed))
		end
	end
	local function handleSaveAsCharacter() -- line: 498
		-- upvalues: v117 (copy), GetFFlagEnableSavePurchasedLooksWithLookName (copy), u125 (ref), v47 (copy), FFlagAXCatalogMakeupSupport (copy), v124 (copy), Constants (copy), v108 (copy), SaveAsMakeupLookThunk (copy), v107 (copy), v122 (copy), v56 (copy), v128 (copy), CreateOutfit (copy), v110 (copy), v127 (copy), v123 (copy)
		if not v117 then
			return
		end

		local v161 = if not GetFFlagEnableSavePurchasedLooksWithLookName() or not u125 then v47 else u125

		if FFlagAXCatalogMakeupSupport and v124 == Constants.LookType.Makeup then
			v108(SaveAsMakeupLookThunk(v107, v161, v122, if not v56 then v128 else nil))

			return
		end

		v108(CreateOutfit(v161, v110, function() -- line: 512
			return true
		end, if not v56 then v127 else nil, v123))
	end

	local v131 = if not t6.isTryOnFromOutsideAX then nil else function(p29) -- line: 539
		-- upvalues: parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), NavigationUtils (copy), t6 (copy), v108 (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy)
		local v163 = parseEconomicRestrictionsFailureReason(p29)
		local v164 = parseEconomicRestrictionsExpirationTimeInMinutes(p29)

		default:logRobloxTelemetryCounter(UniversalEconomicRestrictionsCounter, 1, {
			surface = EconomicRestrictionsSurface.AvatarExperienceLook,
			failureReason = v163
		})
		NavigationUtils.closeOverlay(t6.navigation)

		return v108(OpenCentralOverlayForEconomicRestrictionPrompt(v163, v164))
	end
	local getLookTitle, getLookQuestion, getButtonText

	if t6.priceInRobux == 0 then
		getLookTitle = v126.getLookTitle
		getLookQuestion = v126.getLookQuestion
		getButtonText = v126.getButtonText
	else
		getLookTitle = v126.buyLookTitle
		getLookQuestion = v126.buyLookQuestion
		getButtonText = v126.buyButtonText
	end

	return React.createElement(PurchasePromptInteractiveAlert, {
		isPurchasingOutfit = true,
		priceInRobux = t6.priceInRobux,
		showWearAfterPurchase = t6.showWearAfterPurchase,
		showSaveAsCharacter = t6.showSaveAsCharacter,
		isWearAfterPurchaseChecked = v115,
		isSaveAsCharacterChecked = v117,
		toggleWearAfterPurchase = function() -- line: 362
			-- upvalues: v116 (copy), v115 (copy)
			v116(not v115)
		end,
		toggleSaveAsCharacter = function() -- line: 366
			-- upvalues: v118 (copy), v117 (copy)
			v118(not v117)
		end,
		saveIfWearAfterPurchase = t6.isTryOnFromOutsideAX,
		lookType = v124,
		analyticsInfo = if not FFlagAXMISEnableMultiShoppingUnifiedEvents or v124 ~= Constants.LookType.Makeup then v120 else v121,
		titleText = getLookTitle,
		bodyText = getLookQuestion,
		confirmButtonText = getButtonText,
		onConfirm = function() -- line: 551
			-- upvalues: v113 (copy), v114 (copy), v112 (copy), v108 (copy), PurchaseLooksProduct (copy), v107 (copy), t6 (copy), v111 (copy), ShowToasts (copy), v109 (copy), FFlagAXCatalogMakeupSupport (copy), v124 (copy), Constants (copy), handleSaveAsCharacter (copy), handleWearAfterPurchase (copy), setTimeout (copy), FIntAXLookOutfitCreationDelayMs (copy), NavigationUtils (copy), sendAXCounterV2 (copy), mutedError (copy), v131 (copy), isEconomicRestrictionResponse (copy), SetCurrentToastMessage (copy), ToastType (copy)
			if v113 then
				return
			end

			v114(true)
			v112("MakePurchase", "Press")
			v108(PurchaseLooksProduct(v107, t6.lookId, t6.priceInRobux, v111)):andThen(function(p30) -- line: 560
				-- upvalues: v114 (copy), ShowToasts (copy), v108 (copy), v109 (copy), FFlagAXCatalogMakeupSupport (copy), v124 (copy), Constants (copy), handleSaveAsCharacter (copy), handleWearAfterPurchase (copy), setTimeout (copy), FIntAXLookOutfitCreationDelayMs (copy), t6 (copy), NavigationUtils (copy)
				v114(false)
				ShowToasts(p30, v108, v109)

				if FFlagAXCatalogMakeupSupport and v124 == Constants.LookType.Makeup then
					handleSaveAsCharacter()
				end

				handleWearAfterPurchase(p30)

				if v124 == Constants.LookType.Avatar then
					setTimeout(handleSaveAsCharacter, FIntAXLookOutfitCreationDelayMs)
				end

				local navigation = t6.navigation

				NavigationUtils.closeOverlay(navigation)
			end, function(p31) -- line: 573
				-- upvalues: sendAXCounterV2 (copy), Constants (copy), t6 (copy), mutedError (copy), v131 (copy), isEconomicRestrictionResponse (copy), v114 (copy), v108 (copy), SetCurrentToastMessage (copy), ToastType (copy), NavigationUtils (copy)
				sendAXCounterV2(Constants.Counter.Errors.PurchaseLooksProductError, {
					promptType = "PurchaseLookPromptMIS",
					lookId = t6.lookId,
					isTryOnFromOutsideAX = tostring(t6.isTryOnFromOutsideAX)
				})
				mutedError("PurchaseLooksProductMIS error", p31)

				if v131 and isEconomicRestrictionResponse(p31) then
					v131(p31)

					return
				end

				v114(false)
				v108(SetCurrentToastMessage({
					isLocalized = false,
					toastMessage = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
					toastType = ToastType.NetworkingError
				}))

				local navigation = t6.navigation

				NavigationUtils.closeOverlay(navigation)
			end)
		end,
		onCancel = function() -- line: 597
			-- upvalues: v113 (copy), NavigationUtils (copy), t6 (copy)
			if v113 then
				return
			end

			NavigationUtils.closeOverlay(t6.navigation)
		end,
		isLoading = v113,
		defaultChildRef = t6.defaultChildRef
	})
end

return (withMappedNavigationParams((withOverlayFocusHandling(PurchaseLookPrompt))))
