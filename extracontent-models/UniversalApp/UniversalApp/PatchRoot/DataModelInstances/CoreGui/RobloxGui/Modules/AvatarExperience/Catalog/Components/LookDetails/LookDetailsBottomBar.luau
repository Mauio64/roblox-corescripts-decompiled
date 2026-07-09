local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local isGamepadInput = require(CorePackages.Workspace.Packages.RoactUtils).isGamepadInput
local Images = UIBlox.App.ImageSet.Images
local Modules = CoreGui.RobloxGui.Modules
local Utils = require(Modules.AvatarExperience.Common.Utils)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local SetLookFavorite = require(Modules.AvatarExperience.Catalog.Thunks.SetLookFavorite)
local ActionBar = require(Modules.AvatarExperience.Catalog.Components.ActionBar.ActionBar)
local logOnOverlayClosed = AvatarExperienceNavigation.Debug.logOnOverlayClosed
local ReportLook = require(Modules.AvatarExperience.Catalog.Thunks.ReportLook)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)

require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.ContextFrame)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local useLookUnifiedPurchaseFlow = require(Modules.AvatarExperience.Catalog.Hooks.useLookUnifiedPurchaseFlow)
local AvatarEditorSubcategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorSubcategories
local AvatarEditorCategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorCategories
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local Constants3 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SetTryOnManagerPeekViewState = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.SetTryOnManagerPeekViewState
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local FullView = AvatarExperienceCommon.Enums.FullView
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local LookDetailsBottomBarUtils = require(Modules.AvatarExperience.Catalog.Components.LookDetails.LookDetailsBottomBarUtils)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local React = require(CorePackages.Packages.React)
local useStyle = UIBlox.Core.Style.useStyle
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useShareButton = require(Modules.AvatarExperience.Common.Hooks.useShareButton)
local useFavoriteButton = require(Modules.AvatarExperience.Common.Hooks.useFavoriteButton)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local GetFFlagEnableLookFavoriting = require(Modules.AvatarExperience.Flags.GetFFlagEnableLookFavoriting)
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local selectTryOnsLookId = AvatarExperienceCommon.State.Selectors.selectTryOnsLookId

require(Modules.AvatarExperience.Common.Reducers.CollectiblesItemInfo)
require(Modules.AvatarExperience.Common.Reducers.CollectiblesResellableInstances)
require(Modules.AvatarExperience.Common.Reducers.CollectiblesResellersInstances)

local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local v55 = game:DefineFastFlag("AXHideShareButtonForContextMenu", false)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXEnableUnifiedPurchaseFlowForLooks = AvatarExperienceFlags.FFlagAXEnableUnifiedPurchaseFlowForLooks
local FFlagAXCatalogMakeupSupport = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCatalogMakeupSupport
local PurchasePromptLite = require(CorePackages.Workspace.Packages.PurchasePromptLite)
local getTTIEventName = PurchasePromptLite.getTTIEventName
local TimeToInteractiveTracker = require(CorePackages.Workspace.Packages.TimeToInteractiveTracker).TimeToInteractiveTracker
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local getIsUserEligibleForUnifiedPurchaseFlow = PurchasePromptLite.getIsUserEligibleForUnifiedPurchaseFlow

require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)
require(Modules.AvatarExperience.Common.Reducers.Looks)
require(Modules.AvatarExperience.Common.Types)

local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local FFlagAXFixLookDetailsContextualMenu = AvatarExperienceFlags.FFlagAXFixLookDetailsContextualMenu
local FFlagAddPerformanceMetricsToUnifiedPurchaseModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAddPerformanceMetricsToUnifiedPurchaseModal
local FFlagAXLaunchUnifiedPurchaseFlowMarketplaceLooks = AvatarExperienceFlags.FFlagAXLaunchUnifiedPurchaseFlowMarketplaceLooks
local FFlagAXFixLookLinkToCustomize = AvatarExperienceFlags.FFlagAXFixLookLinkToCustomize
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local v71 = game:DefineFastFlag("HideLookDiscountPercentWithIneligibleItems", false)
local FIntBlackbirdUpsellMinPriceForDiscountInclusive = require(CorePackages.Workspace.Packages.SharedFlags).FIntBlackbirdUpsellMinPriceForDiscountInclusive
local FIntBlackbirdUpsellMaxPriceForDiscountInclusive = require(CorePackages.Workspace.Packages.SharedFlags).FIntBlackbirdUpsellMaxPriceForDiscountInclusive
local v74 = Images["icons/common/robux"]
local v75 = Images["icons/actions/block"]
local v76 = Images["icons/menu/avatar_on"]
local v77 = Images["icons/actions/feedback"]
local v78 = Images["icons/actions/info"]
local v79 = Images["icons/actions/edit/delete"]

local function selectTryOnItems(p1) -- line: 134
	return p1.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end
local function selectLookId(p2) -- line: 137
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId
end
local function selectLookDetails(p3) -- line: 140
	return p3.AvatarExperience.AvatarScene.Looks
end
local function selectLocalUserId(p4) -- line: 143
	return p4.LocalUserId
end
local function selectUserRobux(p5) -- line: 146
	return p5.UserRobux
end
local function selectCollectiblesItemInfo(p6) -- line: 149
	return p6.AvatarExperience.Common.Collectibles.CollectiblesItemInfo
end
local function selectCollectiblesResellersInstances(p7) -- line: 152
	return p7.AvatarExperience.Common.Collectibles.CollectiblesResellersInstances
end
local function selectResellableInstances(p8) -- line: 155
	return p8.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances
end
local function selectPeekViewState(p9) -- line: 158
	return p9.AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState
end

local u89 = nil

if FFlagAXEnableUnifiedPurchaseFlowForLooks then
	function u89(p10) -- line: 163
		return p10.AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo
	end
end

local u90 = nil

if FFlagAXMISEnableMultiShoppingUnifiedEvents then
	function u90(p11) -- line: 170
		return p11.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookAnalyticsInfo
	end
end

local function getAvatarEditorCategoryIndexesByName(s1: string, s2: string?) -- line: 175
	-- upvalues: GetAvatarEditorCategories (copy)
	local v108 = nil
	local v109 = nil

	for v110, v111 in (GetAvatarEditorCategories()) do
		if s1 == v111.Name then
			v108 = v110

			if not s2 or not v111.Subcategories then
				return v108, v109
			end

			for v112, v113 in v111.Subcategories do
				if s2 == v113.Name then
					return v108, v112
				end
			end

			return v108, v109
		end
	end

	return v108, v109
end
local function v92(p12, p13, p14, p15, p16, s3: string?) -- line: 196
	-- upvalues: LookDetailsBottomBarUtils (copy), v71 (copy), FIntBlackbirdUpsellMaxPriceForDiscountInclusive (copy), FIntBlackbirdUpsellMinPriceForDiscountInclusive (copy), Cryo (copy)
	local n1 = 0
	local n2 = 0
	local n3 = 0
	local t1 = {}
	local v124 = false
	local v125 = false
	local v126 = false

	for _, v128 in p12 do
		if v128.selectedInTryOnManager then
			n1 += 1

			local v129 = LookDetailsBottomBarUtils.getItemInfo(v128.itemId, v128.itemType, p16, s3)

			if not v129 then
				if not v124 then
					v124 = true
				end
			elseif not v129 or not v129.quantityOwned or not (v129.quantityOwned > 0) then
				local v130 = LookDetailsBottomBarUtils.getPriceForItem(v129, p13, p14, p15, v128.selectedTimedOptionIndex)

				if v130 ~= nil then
					if v129 and v129.discountInformation then
						local v131 = false

						if v128.selectedTimedOptionIndex and v129.timedOptions then
							local v132 = v129.timedOptions[v128.selectedTimedOptionIndex]

							if v132 and v132.discountInformation then
								n3 += v132.discountInformation.originalPrice
								v131 = true
							elseif v132 and not v132.discountInformation and v132.days ~= 0 then
								n3 += v132.price
								v131 = true
							end
						end

						if not v131 then
							n3 += v129.discountInformation.originalPrice
						end
					else
						n3 += v130
					end

					if v71 then
						local v133 = if not v129 or not v129.discountInformation then v130 else v129.discountInformation.originalPrice
						local v134 = FIntBlackbirdUpsellMaxPriceForDiscountInclusive
						local v135 = v133 <= FIntBlackbirdUpsellMinPriceForDiscountInclusive or v134 ~= 0 and v134 <= v133

						if v129 and v129.discountInformation and not v135 then
							v125 = true
						else
							v126 = true
						end
					end

					n2 += v130
					t1[v128.itemId] = Cryo.Dictionary.join(v128, {
						expectedPrice = v130
					})
				end
			end
		end
	end

	if v71 then
		return n2, n1, t1, v124, n3, v125 and v126
	end

	return n2, n1, t1, v124, n3, nil
end

local t2 = {
	freeText = "Feature.Catalog.LabelFree",
	reportText = "Feature.Catalog.Action.Report",
	viewDetailsPageLabel = "Feature.Catalog.Action.ViewDetailsPage",
	deleteAvatarLabel = "Feature.Catalog.Action.DeleteAvatar",
	addToMyAvatarsLabel = if not FFlagAXEnableUnifiedPurchaseFlowForLooks then nil else "Feature.Avatar.Label.Title.AddToMyAvatars",
	wearAfterPurchaseLabel = if not FFlagAXEnableUnifiedPurchaseFlowForLooks then nil else "Feature.Catalog.Label.WearAfterPurchase",
	wearAvatarAfterPurchaseLabel = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else "Feature.Catalog.Label.WearAvatarAfterPurchase",
	saveAsCharacterLabel = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else "Feature.Catalog.Label.SaveAsCharacter",
	saveAsMakeupLookLabel = if not FFlagAXCatalogMakeupSupport then nil else "Feature.Avatar.Label.Title.AddToMyMakeupLooks",
	wearAfterPurchaseMakeupLabel = if not FFlagAXCatalogMakeupSupport then nil else "Feature.Avatar.Label.Title.WearAfterPurchase"
}

local function LookDetailsBottomBar(t3: {[any]: any}) -- line: 321
	-- upvalues: UserInputService (copy), React (copy), isGamepadInput (copy), FFlagAXEnableUnifiedPurchaseFlowForLooks (copy), FFlagAXLaunchUnifiedPurchaseFlowMarketplaceLooks (copy), useAvatarRoute (copy), useDispatch (copy), useSelector (copy), selectLookDetails (copy), getUseSelectorDeepEquals (copy), FFlagAXCatalogMakeupSupport (copy), FFlagAXMISEnableMultiShopping (copy), selectTryOnsLookId (copy), selectLookId (copy), GetFFlagEnableLookFavoriting (copy), useNavigation (copy), useRoactService (copy), RoactNetworking (copy), RoactLocalization (copy), Analytics (copy), u89 (ref), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), u90 (ref), Constants (copy), useLocalization (copy), t2 (copy), useStyle (copy), useDesignTokens (copy), selectTryOnItems (copy), selectLocalUserId (copy), selectUserRobux (copy), selectCollectiblesItemInfo (copy), selectCollectiblesResellersInstances (copy), selectResellableInstances (copy), selectPeekViewState (copy), NavigationUtils (copy), SetLookFavorite (copy), SetCurrentToastMessage (copy), ToastType (copy), useFavoriteButton (copy), Cryo (copy), getIsUserEligibleForUnifiedPurchaseFlow (copy), AvatarScreen (copy), useShareButton (copy), SetFullView (copy), FullView (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), CatalogConstants (copy), logOnOverlayClosed (copy), NavigateWithLock (copy), FFlagAXFixLookDetailsContextualMenu (copy), v78 (copy), v55 (copy), v79 (copy), v77 (copy), ReportLook (copy), LookDetailsBottomBarUtils (copy), v92 (copy), Constants2 (copy), FFlagAXFixLookLinkToCustomize (copy), Utils (copy), AvatarEditorSubcategories (copy), AvatarEditorCategories (copy), Constants3 (copy), GetAvatarEditorCategories (copy), FFlagAddPerformanceMetricsToUnifiedPurchaseModal (copy), getTTIEventName (copy), ProductPurchaseSurface (copy), TimeToInteractiveTracker (copy), useLookUnifiedPurchaseFlow (copy), v74 (copy), v76 (copy), v75 (copy), NumberLocalization (copy), Roact (copy), FFlagRenameDeprecatedUIBloxTokens (copy), ActionBar (copy)
	local LastInputType = UserInputService:GetLastInputType()
	local v138, _ = React.useState(isGamepadInput(LastInputType))
	local v140, v141 = React.useState(false)
	local v142 = nil
	local u143 = nil

	if FFlagAXEnableUnifiedPurchaseFlowForLooks and not FFlagAXLaunchUnifiedPurchaseFlowMarketplaceLooks then
		local v144

		v142, v144 = React.useState(false)
		u143 = v144
	end

	local v145 = useAvatarRoute()
	local v146 = useDispatch()
	local v147 = useSelector(selectLookDetails, getUseSelectorDeepEquals())
	local v148 = useSelector(if not FFlagAXCatalogMakeupSupport or not FFlagAXMISEnableMultiShopping then selectLookId else selectTryOnsLookId, getUseSelectorDeepEquals())
	local v149 = not not GetFFlagEnableLookFavoriting() and (v148 ~= nil and (v147[v148] ~= nil and (v147[v148].isFavorited or false)))
	local v150 = useNavigation()
	local v151 = useRoactService(RoactNetworking)
	local v152 = useRoactService(RoactLocalization)
	local v153 = useRoactService(Analytics)
	local v154 = nil

	if FFlagAXEnableUnifiedPurchaseFlowForLooks then
		v154 = useSelector(u89, getUseSelectorDeepEquals())
	end

	local v155 = nil
	local v156 = nil

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		v156 = useSelector(u90, getUseSelectorDeepEquals())
		v155 = not not v148 and (not not v147 and (not not v147[v148] and v147[v148].lookType == Constants.LookType.Makeup))
	end

	local v157 = useLocalization(t2)
	local v158 = useStyle()
	local Theme = v158.Theme
	local Font = v158.Font
	local v161 = useDesignTokens()
	local v162 = useSelector(selectTryOnItems, getUseSelectorDeepEquals())
	local v163 = useSelector(selectLocalUserId, getUseSelectorDeepEquals())
	local v164 = useSelector(selectUserRobux, getUseSelectorDeepEquals())[v163]
	local v165 = useSelector(selectCollectiblesItemInfo, getUseSelectorDeepEquals())
	local v166 = useSelector(selectCollectiblesResellersInstances, getUseSelectorDeepEquals())
	local v167 = useSelector(selectResellableInstances, getUseSelectorDeepEquals())
	local v168 = useSelector(selectPeekViewState, getUseSelectorDeepEquals())
	local v169 = if not GetFFlagEnableLookFavoriting() then nil else React.useCallback(function(p17) -- line: 385
		-- upvalues: NavigationUtils (copy), v149 (copy), FFlagAXCatalogMakeupSupport (copy), v148 (copy), v147 (copy), v146 (copy), SetLookFavorite (copy), v151 (copy), SetCurrentToastMessage (copy), ToastType (copy)
		NavigationUtils.closeOverlay(p17)

		local v210 = not v149
		local v212

		if FFlagAXCatalogMakeupSupport then
			local v211 = if not v148 or not v147[v148] then nil else v147[v148].lookType

			v212 = v146(SetLookFavorite(v151, v148, v210, v211))
		else
			v212 = v146(SetLookFavorite(v151, v148, v210))
		end

		if v212 ~= nil and type(v212.catch) == "function" then
			v212:catch(function() -- line: 401
			end)
		end

		v146(SetCurrentToastMessage({
			toastMessage = not v210 and "Feature.Catalog.Toast.UnfavoritedLook" or "Feature.Catalog.Toast.FavoritedLook",
			toastType = ToastType.SuccessConfirmation
		}))
	end, {
		v146,
		SetCurrentToastMessage,
		SetLookFavorite,
		v148,
		v147,
		v151,
		v149,
		v150
	})
	local v170 = if not GetFFlagEnableLookFavoriting() then nil else useFavoriteButton(v148, v149, v169)
	local v171 = if not FFlagAXMISEnableMultiShopping then nil else React.useMemo(function() -- line: 428
		-- upvalues: t3 (copy), v148 (copy), v147 (copy), Cryo (copy)
		if not t3.alwaysBuyAll then
			return nil
		end

		if v148 and v147 then
			return Cryo.Dictionary.union(v147[v148].lookAssetInfos or {}, v147[v148].lookBundleInfos or {})
		end

		return {}
	end, {
		v148,
		v147,
		t3.alwaysBuyAll
	})

	if FFlagAXEnableUnifiedPurchaseFlowForLooks and not FFlagAXLaunchUnifiedPurchaseFlowMarketplaceLooks then
		React.useEffect(function() -- line: 447
			-- upvalues: getIsUserEligibleForUnifiedPurchaseFlow (copy), v151 (copy), u143 (ref)
			getIsUserEligibleForUnifiedPurchaseFlow(v151):andThen(function(b1: boolean) -- line: 449
				-- upvalues: u143 (ref)
				u143(b1)
			end):catch(function(_) -- line: 452
				-- upvalues: u143 (ref)
				u143(false)
			end)
		end, { v151 })
	end

	local v172 = React.useCallback(function() -- line: 460
		-- upvalues: v146 (copy), SetCurrentToastMessage (copy), ToastType (copy)
		v146(SetCurrentToastMessage({
			toastMessage = "Feature.Catalog.Toast.AvatarUnderReview",
			toastType = ToastType.NetworkingError
		}))
	end, { v146 })
	local v173 = React.useMemo(function() -- line: 466
		-- upvalues: v147 (copy), v148 (copy), Constants (copy)
		if v147 and v148 then
			return v147[v148].moderationStatus == Constants.ModerationStatus.Moderated
		end

		return false
	end, {
		v147,
		v148
	})
	local v174 = React.useMemo(function() -- line: 473
		-- upvalues: v147 (copy), v148 (copy), Constants (copy)
		if v147 and v148 then
			return v147[v148].moderationStatus == Constants.ModerationStatus.PendingModeration
		end

		return false
	end, {
		v147,
		v148
	})
	local v175 = React.useMemo(function() -- line: 480
		-- upvalues: v145 (copy), AvatarScreen (copy)
		return v145 and (v145.opaque and v145.opaque.name == AvatarScreen.MySharedAvatars)
	end, { v145 })
	local v176 = useShareButton(v148, Constants.ItemType.Look, true, nil, v174 and v172 or nil)
	local v177 = React.useCallback(function(p19) -- line: 497
		-- upvalues: v153 (copy), Constants (copy), v146 (copy), SetFullView (copy), v145 (copy), FullView (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), NavigationUtils (copy)
		v153.sendAXCounter(Constants.Counter.ContextFrame.ViewDetailsPageClick)
		v146(SetFullView(v153, v145.opaque.name, FullView.None))
		v146(SetTryOnManagerPeekViewState(PeekViewState.Brief))
		NavigationUtils.closeOverlay(p19)
	end, {
		v153,
		v146,
		v145
	})
	local v178 = React.useMemo(function() -- line: 504
		-- upvalues: v163 (copy), v147 (copy), v148 (copy), CatalogConstants (copy)
		if v163 and (v147 and v148) then
			local v214 = v147[v148]

			return v214 and (v214.curator and (tostring(v214.curator.id) == tostring(v163) and v214.curator.type == CatalogConstants.CreatorType.User))
		end

		return false
	end, {
		v147,
		v148,
		v163
	})
	local v179 = React.useCallback(function() -- line: 517
		-- upvalues: v138 (copy), v145 (copy), AvatarScreen (copy), logOnOverlayClosed (copy)
		if v138 and v145.current.name == AvatarScreen.LookDetails then
			logOnOverlayClosed("LookDetails")
		end
	end, {
		v138,
		v145
	})
	local v180 = React.useCallback(function(p20) -- line: 530
		-- upvalues: v153 (copy), Constants (copy), NavigationUtils (copy), AvatarScreen (copy), v179 (copy), v148 (copy), v150 (copy), v146 (copy), NavigateWithLock (copy)
		v153.sendAXCounter(Constants.Counter.ContextFrame.DeleteAvatarClick)
		NavigationUtils.closeOverlay(p20)
		v146(NavigateWithLock(function() -- line: 533
			-- upvalues: AvatarScreen (copy), v179 (copy), v148 (copy), v150 (copy)
			local DeleteAvatarConfirmationPrompt = AvatarScreen.DeleteAvatarConfirmationPrompt
			local t4 = {
				onOverlayClosed = v179,
				lookId = v148
			}

			v150.navigate(DeleteAvatarConfirmationPrompt, t4)
		end))
	end, {
		v153,
		v146,
		v148,
		v179
	})
	local v181 = React.useCallback(function() -- line: 545
		-- upvalues: v168 (copy), PeekViewState (copy), FFlagAXFixLookDetailsContextualMenu (copy), v78 (copy), v157 (copy), v177 (copy), GetFFlagEnableLookFavoriting (copy), v173 (copy), v170 (copy), v55 (copy), v175 (copy), v176 (copy), v178 (copy), v79 (copy), v180 (copy), v77 (copy), v146 (copy), ReportLook (copy), v151 (copy), NavigationUtils (copy)
		local v216 = v168 == PeekViewState.SuperBrief

		if FFlagAXFixLookDetailsContextualMenu then
			local t5 = {}

			if v216 then
				table.insert(t5, {
					icon = v78,
					text = v157.viewDetailsPageLabel,
					onActivated = v177
				})
			end

			if GetFFlagEnableLookFavoriting() and not v173 then
				table.insert(t5, v170)
			end

			if not v55 and not v173 and not v175 then
				table.insert(t5, v176)
			end

			if v178 and v175 then
				table.insert(t5, {
					icon = v79,
					text = v157.deleteAvatarLabel,
					onActivated = v180
				})
			end

			if not v178 then
				table.insert(t5, {
					icon = v77,
					text = v157.reportText,
					onActivated = function(p21) -- line: 580
						-- upvalues: v146 (copy), ReportLook (copy), v151 (copy), NavigationUtils (copy)
						v146(ReportLook(v151))
						NavigationUtils.closeOverlay(p21)
					end
				})
			end

			return t5
		end

		return {
			if v216 then {
				icon = v78,
				text = v157.viewDetailsPageLabel,
				onActivated = v177
			} else nil,
			if not GetFFlagEnableLookFavoriting() or v173 then nil else v170,
			if v55 or (v173 or v175) then nil else v176,
			if not v178 or not v175 then nil else {
				icon = v79,
				text = v157.deleteAvatarLabel,
				onActivated = v180
			},
			if not v178 then {
				icon = v77,
				text = v157.reportText,
				onActivated = function(p22) -- line: 615
					-- upvalues: v146 (copy), ReportLook (copy), v151 (copy), NavigationUtils (copy)
					v146(ReportLook(v151))
					NavigationUtils.closeOverlay(p22)
				end
			} else nil
		}
	end, {
		v151,
		v157,
		v177,
		v180,
		v178,
		v146,
		v176,
		if not GetFFlagEnableLookFavoriting() then nil else v170,
		if not GetFFlagEnableLookFavoriting() then nil else v149,
		if not GetFFlagEnableLookFavoriting() then nil else v168,
		v173,
		v175
	})
	local v182 = React.useCallback(function() -- line: 639
		-- upvalues: v141 (copy), v179 (copy)
		v141(false)
		v179()
	end, { v179 })
	local v183 = React.useCallback(function() -- line: 645
		-- upvalues: v181 (copy), v77 (copy), v157 (copy), v146 (copy), ReportLook (copy), v151 (copy), NavigationUtils (copy), v55 (copy), v173 (copy), v175 (copy), v176 (copy), v150 (copy), AvatarScreen (copy), t3 (copy), v182 (copy), NavigateWithLock (copy)
		v146(NavigateWithLock(function() -- line: 646
			-- upvalues: v181 (copy), v77 (copy), v157 (copy), v146 (copy), ReportLook (copy), v151 (copy), NavigationUtils (copy), v55 (copy), v173 (copy), v175 (copy), v176 (copy), v150 (copy), AvatarScreen (copy), t3 (copy), v182 (copy)
			local v257 = if not v181 then {
				{
					icon = v77,
					text = v157.reportText,
					onActivated = function(p23) -- line: 653
						-- upvalues: v146 (copy), ReportLook (copy), v151 (copy), NavigationUtils (copy)
						v146(ReportLook(v151))
						NavigationUtils.closeOverlay(p23)
					end
				},
				if v55 or (v173 or v175) then nil else v176
			} else v181()

			v150.navigate(AvatarScreen.ContextMenu, {
				centered = t3.centered,
				contextButtons = v257,
				onOverlayClosed = v182
			})
		end))
	end, {
		v150,
		v146,
		v182,
		v157,
		v151,
		v176,
		v181
	})
	local v184 = nil
	local v185 = nil
	local v186 = nil
	local v187, v189, v190, v191, u192

	if FFlagAXMISEnableMultiShopping and t3.alwaysBuyAll then
		local v188

		v187, v184, v185, v188, v189, v190, v191 = LookDetailsBottomBarUtils.getBottomBarInfoMIS(v171, v165, v166, v167, v147, v148, v162)
		u192 = v188
	else
		local v193

		v187, v186, v189, v193, v190, v191 = v92(v162, v165, v166, v167, v147, v148)
		u192 = v193
	end

	local u194 = if not FFlagAXMISEnableMultiShopping or (not v171 or not t3.alwaysBuyAll) then React.useCallback(function() -- line: 822
		-- upvalues: v92 (copy), v162 (copy), v165 (copy), v166 (copy), v167 (copy), v147 (copy), v148 (copy), FFlagAddPerformanceMetricsToUnifiedPurchaseModal (copy), getTTIEventName (copy), ProductPurchaseSurface (copy), TimeToInteractiveTracker (copy), v164 (copy), AvatarScreen (copy), v179 (copy), v153 (copy), Constants2 (copy), Cryo (copy), FFlagAXFixLookLinkToCustomize (copy), Utils (copy), Constants (copy), AvatarEditorSubcategories (copy), AvatarEditorCategories (copy), Constants3 (copy), GetAvatarEditorCategories (copy), LookDetailsBottomBarUtils (copy), v145 (copy), t3 (copy), NavigationUtils (copy), v150 (copy), v146 (copy), NavigateWithLock (copy)
		local v230, _, v232 = v92(v162, v165, v166, v167, v147, v148)
		local InsufficientRobuxPrompt = nil

		if FFlagAddPerformanceMetricsToUnifiedPurchaseModal then
			local v234 = getTTIEventName(ProductPurchaseSurface.Catalog)

			TimeToInteractiveTracker.trackStart(v234)
			TimeToInteractiveTracker.updateMetadata(v234, {
				category = "legacy_purchase_modal",
				page = ProductPurchaseSurface.Catalog
			})
		end

		local t6

		if v230 > v164 then
			InsufficientRobuxPrompt = AvatarScreen.InsufficientRobuxPrompt
			t6 = {
				onOverlayClosed = v179
			}
			v153.sendAXCounter(Constants2.Counter.AvatarWidget.AvatarsWidgetBuyClickedInsufficientRobux)
		elseif Cryo.isEmpty(v232) and v148 ~= nil then
			local v236, v237

			if FFlagAXFixLookLinkToCustomize then
				v236, v237 = Utils.GetAvatarEditorCategoryIdsFromNavKey(if v147[v148].lookType ~= Constants.LookType.Makeup then AvatarEditorCategories.Avatars else AvatarEditorSubcategories.MakeupLooks)
			else
				local CharacterKey = Constants3.CharacterKey

				v236 = nil

				for v239, v240 in (GetAvatarEditorCategories()) do
					if CharacterKey == v240.Name then
						v236 = v239

						break
					end
				end

				v237 = nil
			end

			InsufficientRobuxPrompt = AvatarScreen.LeaveCatalogToAvatarPrompt
			t6 = {
				onOverlayClosed = v179,
				categoryOverride = v236,
				subcategoryOverride = v237
			}
			v153.sendAXCounter(Constants2.Counter.AvatarWidget.AvatarsWidgetBuyClickedNoItemsToPurchase)
		else
			local v241 = LookDetailsBottomBarUtils.getOwnedTryOnItems(v162, v147, v148)

			if v148 ~= nil then
				InsufficientRobuxPrompt = AvatarScreen.PurchaseLookPrompt
				t6 = {
					showSaveAsCharacter = true,
					showWearAfterPurchase = true,
					itemsToPurchase = v232,
					lookId = v148,
					ownedTryOnItems = v241,
					priceInRobux = v230,
					fromAvatarRoute = v145,
					isTryOnFromOutsideAX = t3.isTryOnFromOutsideAX
				}

				if NavigationUtils.isWithinViewContext(v145, AvatarScreen.CatalogSearch) then
					v153.sendAXCounter(Constants2.Counter.AvatarWidget.AvatarsWidgetSearchBuyClicked)
				else
					v153.sendAXCounter(Constants2.Counter.AvatarWidget.AvatarsWidgetHomeBuyClicked)
				end
			else
				v153.sendAXCounter(Constants2.Counter.AvatarWidget.AvatarsWidgetBuyClickedMissingLookId)
				t6 = {
					onOverlayClosed = v179
				}
			end
		end

		v146(NavigateWithLock(function() -- line: 920
			-- upvalues: v150 (copy), InsufficientRobuxPrompt (ref), t6 (ref)
			v150.navigate(InsufficientRobuxPrompt, t6)
		end))
	end, {
		v162,
		v165,
		v166,
		v167,
		v147,
		v148,
		v164,
		v146,
		v150,
		v179,
		v153,
		v145
	}) else React.useCallback(function() -- line: 710
		-- upvalues: LookDetailsBottomBarUtils (copy), v171 (copy), v165 (copy), v166 (copy), v167 (copy), v147 (copy), v148 (copy), v162 (copy), v164 (copy), AvatarScreen (copy), v179 (copy), v153 (copy), Constants2 (copy), FFlagAXFixLookLinkToCustomize (copy), Utils (copy), Constants (copy), AvatarEditorSubcategories (copy), AvatarEditorCategories (copy), Constants3 (copy), GetAvatarEditorCategories (copy), v145 (copy), t3 (copy), NavigationUtils (copy), v150 (copy), v146 (copy), NavigateWithLock (copy)
		local v218, _, v220, _ = LookDetailsBottomBarUtils.getBottomBarInfoMIS(v171, v165, v166, v167, v147, v148, v162)
		local InsufficientRobuxPrompt = nil
		local t7

		if v218 > v164 then
			InsufficientRobuxPrompt = AvatarScreen.InsufficientRobuxPrompt
			t7 = {
				onOverlayClosed = v179
			}
			v153.sendAXCounter(Constants2.Counter.AvatarWidget.AvatarsWidgetBuyClickedInsufficientRobux)
		elseif v220 == 0 and v148 ~= nil then
			local v224, v225

			if FFlagAXFixLookLinkToCustomize then
				v224, v225 = Utils.GetAvatarEditorCategoryIdsFromNavKey(if v147[v148].lookType ~= Constants.LookType.Makeup then AvatarEditorCategories.Avatars else AvatarEditorSubcategories.MakeupLooks)
			else
				local CharacterKey = Constants3.CharacterKey

				v224 = nil

				for v227, v228 in (GetAvatarEditorCategories()) do
					if CharacterKey == v228.Name then
						v224 = v227

						break
					end
				end

				v225 = nil
			end

			InsufficientRobuxPrompt = AvatarScreen.LeaveCatalogToAvatarPrompt
			t7 = {
				onOverlayClosed = v179,
				categoryOverride = v224,
				subcategoryOverride = v225
			}
			v153.sendAXCounter(Constants2.Counter.AvatarWidget.AvatarsWidgetBuyClickedNoItemsToPurchase)
		else
			local v229 = LookDetailsBottomBarUtils.getOwnedItemsInLook(v171, v147, v148)

			if v148 ~= nil then
				InsufficientRobuxPrompt = AvatarScreen.PurchaseLookPrompt
				t7 = {
					showSaveAsCharacter = true,
					showWearAfterPurchase = true,
					lookId = v148,
					priceInRobux = v218,
					fromAvatarRoute = v145,
					allLookItems = v171,
					ownedItemsInLook = v229,
					isTryOnFromOutsideAX = t3.isTryOnFromOutsideAX
				}

				if NavigationUtils.isWithinViewContext(v145, AvatarScreen.CatalogSearch) then
					v153.sendAXCounter(Constants2.Counter.AvatarWidget.AvatarsWidgetSearchBuyClicked)
				else
					v153.sendAXCounter(Constants2.Counter.AvatarWidget.AvatarsWidgetHomeBuyClicked)
				end
			else
				v153.sendAXCounter(Constants2.Counter.AvatarWidget.AvatarsWidgetBuyClickedMissingLookId)
				t7 = {
					onOverlayClosed = v179
				}
			end
		end

		v146(NavigateWithLock(function() -- line: 800
			-- upvalues: v150 (copy), InsufficientRobuxPrompt (ref), t7 (ref)
			v150.navigate(InsufficientRobuxPrompt, t7)
		end))
	end, {
		v165,
		v166,
		v167,
		v147,
		v148,
		v164,
		v146,
		v150,
		v179,
		v153,
		v145,
		v171,
		v162
	})

	if FFlagAXEnableUnifiedPurchaseFlowForLooks then
		local onButtonPressWithUnifiedPurchaseFlow = useLookUnifiedPurchaseFlow({
			lookId = v148,
			totalPrice = v187,
			originalPrice = v190,
			tryOnItems = v162,
			lookDetailsObj = v147,
			lookAnalyticsInfo = if not FFlagAXMISEnableMultiShoppingUnifiedEvents or not v155 then v154 else v156,
			localized = v157,
			isTryOnFromOutsideAX = t3.isTryOnFromOutsideAX,
			itemsToPurchase = v189,
			userRobux = v164,
			onOverlayClosed = v179,
			hasNonDiscountedItems = v191
		}).onButtonPressWithUnifiedPurchaseFlow

		if FFlagAXLaunchUnifiedPurchaseFlowMarketplaceLooks then
			u194 = onButtonPressWithUnifiedPurchaseFlow
		elseif v142 then
			u194 = onButtonPressWithUnifiedPurchaseFlow
		end
	end

	local v196 = if not FFlagAXMISEnableMultiShopping or not t3.alwaysBuyAll then React.useCallback(function() -- line: 970
		-- upvalues: v162 (copy), LookDetailsBottomBarUtils (copy), v147 (copy), v148 (copy)
		local n4 = 0

		for _, v244 in v162 do
			if not v244.selectedInTryOnManager then
				continue
			end

			local v245 = LookDetailsBottomBarUtils.getItemInfo(v244.itemId, v244.itemType, v147, v148)

			if not v245 or not v245.quantityOwned or v245.quantityOwned == 0 then
				return false
			end

			n4 += 1
		end

		return n4 > 0
	end, {
		v162,
		v147,
		v148
	}) else nil
	local v197 = if not FFlagAXMISEnableMultiShopping then nil else React.useCallback(function(p24) -- line: 993
		-- upvalues: v171 (copy), t3 (copy), LookDetailsBottomBarUtils (copy), v147 (copy)
		if v171 == nil or not t3.alwaysBuyAll then
			return false
		end

		local n5 = 0

		for _, v249 in v171 do
			local v250 = if not v249.itemType then nil else LookDetailsBottomBarUtils.getItemInfo(v249.id, v249.itemType, v147, p24)

			if not v250 or not v250.quantityOwned or v250.quantityOwned == 0 then
				return false
			end

			n5 += 1
		end

		return n5 > 0
	end, {
		v147,
		v171,
		t3.alwaysBuyAll
	})
	local u198 = v74
	local u199 = false
	local v200 = v189 and Cryo.isEmpty(v189)

	if FFlagAXMISEnableMultiShopping and t3.alwaysBuyAll then
		v200 = v185 == 0
	end

	local s4

	if v200 then
		s4 = ""

		local v202 = v196 and v196()

		if FFlagAXMISEnableMultiShopping and t3.alwaysBuyAll then
			v202 = v197 and v197(v148) ~= nil
		end

		if v148 ~= nil and v202 then
			u198 = v76
		else
			u198 = v75
			u199 = true
		end
	elseif v187 == 0 then
		u198 = nil
		s4 = v157.freeText
	else
		s4 = NumberLocalization.localize(string.format("%.0f", v187), v152:GetLocale())
	end

	if v164 == nil then
		u199 = true
	end

	local v203 = v152:Format("Feature.Avatar.Label.TryOnManagerDescriptor", {
		numItems = if not FFlagAXMISEnableMultiShopping or not t3.alwaysBuyAll then v186 else v184
	})
	local hideDescriptor = t3.hideDescriptor
	local v205 = Roact.createElement("TextLabel", {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, if not FFlagRenameDeprecatedUIBloxTokens then v161.Global.Size_400 else v161.Size.Size_800),
		Text = v203,
		TextSize = Font.BaseSize * Font.Header2.RelativeSize,
		Font = Font.Header2.Font,
		TextColor3 = Theme.SecondaryContent.Color,
		TextTransparency = Theme.SecondaryContent.Transparency,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top
	})
	local v206 = React.useCallback(function() -- line: 1078
		-- upvalues: v183 (copy), v141 (copy)
		v183()
		v141(true)
	end, {
		v183,
		v141
	})
	local v207 = React.useMemo(function() -- line: 1083
		-- upvalues: s4 (ref), u198 (ref), u192 (ref), u199 (ref), FFlagRenameDeprecatedUIBloxTokens (copy), v161 (copy), FFlagAXMISEnableMultiShopping (copy), v158 (copy), u194 (ref)
		return {
			buttonText = s4,
			buttonIcon = u198,
			buttonIsLoading = u192,
			buttonIsDisabled = u199,
			buttonIconPadding = if not FFlagRenameDeprecatedUIBloxTokens then v161.Global.Space_50 else v161.Size.Size_100,
			buttonIconSize = if not FFlagAXMISEnableMultiShopping then if not FFlagRenameDeprecatedUIBloxTokens then v161.Global.Size_400 else v161.Size.Size_800 else if not FFlagRenameDeprecatedUIBloxTokens then v161.Global.Size_250 else v161.Size.Size_500,
			buttonColor = v158.Theme.ContextualPrimaryDefault.Color,
			buttonTextColor = v158.Theme.ContextualPrimaryContent.Color,
			onActivated = not u199 and u194 or nil
		}
	end, {
		s4,
		u198,
		u192,
		u199,
		v161,
		v158,
		u194
	})
	local v208 = v175 and (not v173 and v176 ~= nil)

	return Roact.createElement(ActionBar, {
		bottomPadding = 0,
		hideGradient = true,
		leftPadding = 0,
		rightPadding = 0,
		showMoreButton = true,
		ZIndex = 1,
		buttonProps = v207,
		isMoreButtonSelected = v140,
		onMoreButtonActivated = v206,
		showMiddleButton = v208,
		onMiddleButtonActivated = if not v208 then nil else v176.onActivated,
		middleButtonIcon = if not v208 then nil else v176.icon,
		topComponent = if not hideDescriptor then v205 else nil,
		topComponentHeight = if not hideDescriptor then if not FFlagRenameDeprecatedUIBloxTokens then v161.Global.Size_400 else v161.Size.Size_800 else 0
	})
end

return LookDetailsBottomBar
