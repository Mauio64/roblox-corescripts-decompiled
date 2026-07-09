local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local LocalizationService = game:GetService("LocalizationService")
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(Modules.LuaApp.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.Types)

local Utils = require(Modules.AvatarExperience.Common.Utils)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local mutedError = require(Modules.LuaApp.mutedError)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local ModelsUtils = require(Modules.AvatarExperience.Common.Models.ModelsUtils)
local AvatarWidgetBlockyUtils = require(Modules.AvatarExperience.Common.Util.AvatarWidgetBlockyUtils)
local AddLookDetails = require(Modules.AvatarExperience.Common.Actions.AddLookDetails)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local SetTryOnManagerPeekViewState = AvatarExperienceRodux.Actions.SetTryOnManagerPeekViewState
local SetLookDetailsPeekViewSelectedTab = AvatarExperienceRodux.Actions.SetLookDetailsPeekViewSelectedTab
local TryOnLooksOutfit = AvatarExperienceRodux.Actions.TryOnLooksOutfit
local Utils2 = require(Modules.AvatarExperience.AvatarEditor.Utils)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local Localization = require(CorePackages.Workspace.Packages.RobloxAppLocales).Localization
local ClearTryOns = AvatarExperienceRodux.Actions.ClearTryOns
local SetFullView = require(Modules.AvatarExperience.Common.Actions.SetFullView)
local FullView = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView
local FetchAssetOrBundleInfoBatched = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfoBatched)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local GetFFlagEnableLookFavoriting = require(Modules.AvatarExperience.Flags.GetFFlagEnableLookFavoriting)
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagEnableLookDetailsDeepLink = require(Modules.LuaApp.Flags.FFlagEnableLookDetailsDeepLink)
local GetFFlagAXFixDeepLinkRelatedIssues = require(Modules.AvatarExperience.Flags.GetFFlagAXFixDeepLinkRelatedIssues)
local v39 = game:DefineFastFlag("RemoveTryOnLookV2MutedError", false)
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagParseHeadShapeFromAPIResponse = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagParseHeadShapeFromAPIResponse
local FFlagAXCatalogMakeupSupport = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCatalogMakeupSupport

local function keyMapper(s1: string) -- line: 61
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.FetchLookDetailInfoKey .. s1
end
local function translateString(s2: string, t1: {[any]: any}?) -- line: 65
	-- upvalues: LocalizationService (copy), Localization (copy)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local v54 = Localization.new(RobloxLocaleId)

	v54:SetLocale(RobloxLocaleId)

	return v54:Format(s2, t1)
end
local function handleErrorCases(p1, p2, s3: string, s4: string) -- line: 73
	-- upvalues: v39 (copy), mutedError (copy), ClearTryOns (copy), NavigateWithLock (copy), NavigationUtils (copy), SetCurrentToastMessage (copy), ToastType (copy)
	if not v39 then
		mutedError(tostring(s4) .. tostring(s3))
	end

	p1:dispatch(ClearTryOns())

	if p2 ~= nil then
		p1:dispatch(NavigateWithLock(function() -- line: 80
			-- upvalues: NavigationUtils (copy), p2 (copy)
			NavigationUtils.closeTryOnManager(p2)
		end))
	end

	p1:dispatch(SetCurrentToastMessage({
		isLocalized = false,
		toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
		toastType = ToastType.NetworkingError
	}))
end
local function processAssetItem(p3) -- line: 91
	-- upvalues: WidgetConstants (copy), Utils (copy)
	assert(p3.id ~= nil and p3.assetType ~= nil, "Asset is missing required fields")

	return {
		itemId = p3.id,
		itemType = WidgetConstants.ContentType.Asset,
		itemSubType = tostring(p3.assetType),
		tryOnItemOrder = p3.tryOnItemOrder,
		isNotSelectable = not Utils.isItemSelectable(p3),
		order = if not p3.meta then nil else p3.meta.order
	}
end
local function processAssetItemInBundle(p4) -- line: 106
	-- upvalues: WidgetConstants (copy), FFlagParseHeadShapeFromAPIResponse (copy)
	assert(p4.id ~= nil and p4.assetType ~= nil, "Asset is missing required fields")

	return {
		itemId = tostring(p4.id),
		itemType = WidgetConstants.ContentType.Asset,
		itemSubType = tostring(p4.assetType),
		tryOnItemOrder = p4.tryOnItemOrder,
		headShape = if not FFlagParseHeadShapeFromAPIResponse or not p4.meta then nil else p4.meta.headShape
	}
end
local function processBundleItem(p5) -- line: 120
	-- upvalues: processAssetItemInBundle (copy), WidgetConstants (copy), Utils (copy)
	assert(p5.id ~= nil and p5.bundleType ~= nil, "Bundle is missing required fields")

	local n1 = 0
	local t2 = {}

	for v64, v65 in p5.assetsInBundle do
		if v65.isIncluded then
			v65.tryOnItemOrder = v64
			n1 += 1
			table.insert(t2, (processAssetItemInBundle(v65)))
		end
	end

	return {
		itemId = p5.id,
		itemType = WidgetConstants.ContentType.Bundle,
		itemSubType = tostring(p5.bundleType),
		items = t2,
		numberOfAssetsIncluded = if not (n1 > 0) then nil else n1,
		tryOnItemOrder = p5.tryOnItemOrder,
		isNotSelectable = not Utils.isItemSelectable(p5)
	}
end

local u49 = if not GetFFlagEnableLookFavoriting() then WebApi.GetLookDetailsV2 else function(p6, p7) -- line: 148
	-- upvalues: WebApi (copy), Promise (copy)
	local t3 = {
		WebApi.GetLookDetailsV2(p6, p7),
		(WebApi.HasFavoritedLook(p6, p7))
	}

	return Promise.allSettled(t3):andThen(function(p8) -- line: 155
		-- upvalues: Promise (copy), t3 (copy), p7 (copy)
		if p8[1] ~= Promise.Status.Resolved then
			return Promise.reject("Failed to fetch look details")
		end

		local v77 = t3[1]:expect()
		local v78 = false

		if p8[2] == Promise.Status.Resolved then
			v78 = t3[2]:expect().responseBody.isFavorited
		else
			warn("HasFavoritedLook API call failed for lookId:", p7)
		end

		if v77.responseBody.look then
			v77.responseBody.look.isFavorited = v78
		end

		return v77
	end)
end

return function(p9, p10, p11, s5: string, p12, n2: number?, b1: boolean?) -- line: 183
	-- upvalues: GetFFlagAXFixDeepLinkRelatedIssues (copy), SetFullView (copy), AvatarScreen (copy), FullView (copy), SetLookDetailsPeekViewSelectedTab (copy), PerformFetch (copy), CatalogConstants (copy), u49 (ref), FFlagAXCatalogMakeupSupport (copy), Constants (copy), ModelsUtils (copy), WidgetConstants (copy), AvatarWidgetBlockyUtils (copy), translateString (copy), FFlagAXMISEnableMultiShopping (copy), FetchAssetOrBundleInfoBatched (copy), AddLookDetails (copy), GetFFlagEnableLookFavoriting (copy), Promise (copy), processAssetItem (copy), processBundleItem (copy), FFlagEnableLookDetailsDeepLink (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), Utils (copy), Utils2 (copy), TryOnLooksOutfit (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), NavigationUtils (copy), NavigateWithLock (copy), Logging (copy), handleErrorCases (copy), SetCurrentToastMessage (copy), ToastType (copy)
	return function(p13) -- line: 192
		-- upvalues: GetFFlagAXFixDeepLinkRelatedIssues (copy), SetFullView (copy), AvatarScreen (copy), FullView (copy), n2 (copy), SetLookDetailsPeekViewSelectedTab (copy), PerformFetch (copy), s5 (copy), CatalogConstants (copy), u49 (ref), p9 (copy), FFlagAXCatalogMakeupSupport (copy), Constants (copy), ModelsUtils (copy), WidgetConstants (copy), AvatarWidgetBlockyUtils (copy), translateString (copy), FFlagAXMISEnableMultiShopping (copy), FetchAssetOrBundleInfoBatched (copy), p11 (copy), AddLookDetails (copy), GetFFlagEnableLookFavoriting (copy), b1 (copy), Promise (copy), processAssetItem (copy), processBundleItem (copy), FFlagEnableLookDetailsDeepLink (copy), p12 (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), Utils (copy), Utils2 (copy), TryOnLooksOutfit (copy), p10 (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), NavigationUtils (copy), NavigateWithLock (copy), Logging (copy), handleErrorCases (copy), SetCurrentToastMessage (copy), ToastType (copy)
		if GetFFlagAXFixDeepLinkRelatedIssues() then
			p13:dispatch(SetFullView(AvatarScreen.Catalog, FullView.None))
		end

		if n2 then
			p13:dispatch(SetLookDetailsPeekViewSelectedTab(n2))
		end

		local Single = PerformFetch.Single
		local v81 = s5

		return Single(CatalogConstants.FetchLookDetailInfoKey .. v81, function(p14) -- line: 200
			-- upvalues: u49 (ref), p9 (copy), s5 (copy), FFlagAXCatalogMakeupSupport (copy), Constants (copy), ModelsUtils (copy), WidgetConstants (copy), AvatarWidgetBlockyUtils (copy), translateString (copy), FFlagAXMISEnableMultiShopping (copy), FetchAssetOrBundleInfoBatched (copy), p11 (copy), AddLookDetails (copy), GetFFlagEnableLookFavoriting (copy), b1 (copy), Promise (copy), processAssetItem (copy), processBundleItem (copy), FFlagEnableLookDetailsDeepLink (copy), p12 (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), Utils (copy), Utils2 (copy), TryOnLooksOutfit (copy), p10 (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AvatarScreen (copy), NavigationUtils (copy), NavigateWithLock (copy), Logging (copy), GetFFlagAXFixDeepLinkRelatedIssues (copy), handleErrorCases (copy), SetCurrentToastMessage (copy), ToastType (copy)
			return u49(p9, s5):andThen(function(p15) -- line: 201
				-- upvalues: FFlagAXCatalogMakeupSupport (copy), Constants (copy), ModelsUtils (copy), WidgetConstants (copy), AvatarWidgetBlockyUtils (copy), translateString (copy), FFlagAXMISEnableMultiShopping (copy), p14 (copy), FetchAssetOrBundleInfoBatched (copy), p9 (copy), p11 (copy), AddLookDetails (copy), s5 (copy), GetFFlagEnableLookFavoriting (copy), b1 (copy), Promise (copy), processAssetItem (copy), processBundleItem (copy), FFlagEnableLookDetailsDeepLink (copy), p12 (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), Utils (copy), Utils2 (copy), TryOnLooksOutfit (copy), p10 (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AvatarScreen (copy), NavigationUtils (copy), NavigateWithLock (copy), Logging (copy), GetFFlagAXFixDeepLinkRelatedIssues (copy), handleErrorCases (copy), SetCurrentToastMessage (copy), ToastType (copy)
				local look = p15.responseBody.look
				local discounts = nil

				if look then
					local v86 = if not FFlagAXCatalogMakeupSupport then nil else look.lookType == Constants.LookType.Makeup
					local t4 = {}
					local t5 = {}

					for v89, v90 in look.items do
						v90.id = tostring(v90.id)

						local _, v92 = ModelsUtils.CreateRestrictionInfo(v90.itemRestrictions)

						v90.itemRestrictionsMap = v92
						v90.tryOnItemOrder = v89

						if v90.itemType == WidgetConstants.ContentType.Asset then
							if v90.timedOptions then
								table.insert(v90.timedOptions, {
									days = 0,
									selected = true,
									price = v90.priceInRobux
								})
							end

							table.insert(t4, v90)
						elseif v90.itemType == WidgetConstants.ContentType.Bundle then
							table.insert(t5, v90)
						else
							warn("TryOnLookV2 - Unknown item type: " .. v90.itemType)
						end

						if v90.discountInformation and discounts == nil then
							discounts = v90.discountInformation.discounts
						end
					end

					local v93 = if not FFlagAXCatalogMakeupSupport or not v86 then AvatarWidgetBlockyUtils.buildBlockyLookDetailItem(t5, translateString) else nil

					if v93 then
						table.insert(t5, v93)
						AvatarWidgetBlockyUtils.adjustTryOnItemOrderForBlockyBundle(t4, t5, look.items)
					end

					if FFlagAXMISEnableMultiShopping then
						local v94 = table.clone(look.items)

						if v93 then
							table.insert(v94, v93)
						end

						p14:dispatch(FetchAssetOrBundleInfoBatched(p9, p11, v94))
					end

					p14:dispatch(AddLookDetails(s5, look.totalPrice, nil, t4, t5, look.lookType, look.totalValue, look.curator, look.description, look.moderationStatus, look.name, look.displayProperties, if not GetFFlagEnableLookFavoriting() then nil else look.favoriteCount, if not GetFFlagEnableLookFavoriting() then nil else look.isFavorited, discounts))

					if b1 then
						return Promise.resolve()
					end

					local t6 = {}

					for _, v97 in t4 do
						table.insert(t6, (processAssetItem(v97)))
					end

					local t7 = {}

					for _, v100 in t5 do
						table.insert(t7, (processBundleItem(v100)))
					end

					if FFlagEnableLookDetailsDeepLink then
						if FFlagAXMISEnableMultiShopping then
							if p12 then
								p14:dispatch(SetTryOnManagerPeekViewState(p12))
							end
						else
							p14:dispatch(SetTryOnManagerPeekViewState(if not p12 then PeekViewState.SuperBrief else p12))
						end
					else
						p14:dispatch(SetTryOnManagerPeekViewState(PeekViewState.SuperBrief))
					end

					local v101 = if FFlagAXCatalogMakeupSupport and v86 or not look.avatarProperties then nil else Utils.convertBodyColor3HexesToColor3s(look.avatarProperties.bodyColor3s)
					local t8 = nil

					if v101 then
						t8 = {}

						local DefaultBodyColorRanges = p14:getState().AvatarExperience.AvatarEditor.DefaultBodyColorRanges

						for v104, v105 in v101 do
							local v106, _ = Utils2.findRangeAndSliderValueForColor3(v105, DefaultBodyColorRanges)

							t8[v104] = v106
						end
					end

					local scale = nil

					if (not FFlagAXCatalogMakeupSupport or not v86) and look.avatarProperties then
						scale = look.avatarProperties.scale
					end

					p14:dispatch(TryOnLooksOutfit({
						assetItemIdTypeAndSubtype = t6,
						bundleItemIdTypeAndSubtype = t7,
						lookId = s5,
						analyticsInfo = p11,
						lookType = look.lookType,
						bodyColor3s = v101,
						bodyPartColorRangeIds = t8,
						scale = scale
					}))

					if p10 ~= nil then
						if FFlagAXMISEnableMultiShopping then
							local v109 = p14:getState()
							local v110 = if not FFlagUseNavigationSelectors then v109.Navigation.currentRoute.routeName else Selectors.selectCurrentRoactNavigationRoute(v109).routeName

							if v110 == AvatarScreen.Checkout then
								NavigationUtils.closeFocusedScreen(p10)
							elseif v110 == AvatarScreen.MySharedAvatars or p12 == PeekViewState.Full then
								p14:dispatch(NavigateWithLock(function() -- line: 366
									-- upvalues: NavigationUtils (copy), p10 (copy), AvatarScreen (copy)
									NavigationUtils.closeFiltersAndItemDetails(p10)
									NavigationUtils.closeTryOnManager(p10, { AvatarScreen.TryOnManager })
									p10.navigate(AvatarScreen.LookDetails)
								end))
							end
						else
							p14:dispatch(NavigateWithLock(function() -- line: 373
								-- upvalues: NavigationUtils (copy), p10 (copy), AvatarScreen (copy)
								NavigationUtils.closeFiltersAndItemDetails(p10)
								NavigationUtils.closeTryOnManager(p10, { AvatarScreen.TryOnManager })
								p10.navigate(AvatarScreen.LookDetails)
							end))
						end
					end

					return Promise.resolve()
				end

				Logging.warn("Unexpectedly received an empty response from Look Details V2")

				if GetFFlagAXFixDeepLinkRelatedIssues() then
					handleErrorCases(p14, p10, s5, "Unexpectedly received an empty response from Look Details V2")

					return
				end

				p14:dispatch(SetCurrentToastMessage({
					isLocalized = false,
					toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
					toastType = ToastType.NetworkingError
				}))
			end):catch(function(p16) -- line: 399
				-- upvalues: Logging (copy), GetFFlagAXFixDeepLinkRelatedIssues (copy), handleErrorCases (copy), p14 (copy), p10 (copy), s5 (copy), SetCurrentToastMessage (copy), ToastType (copy), Promise (copy)
				Logging.warn("Failed to fetch Look Details V2")

				if GetFFlagAXFixDeepLinkRelatedIssues() then
					handleErrorCases(p14, p10, s5, "Failed to fetch Look Details V2 with lookId: ")
				else
					p14:dispatch(SetCurrentToastMessage({
						isLocalized = false,
						toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
						toastType = ToastType.NetworkingError
					}))
				end

				return Promise.reject(p16)
			end)
		end)(p13)
	end
end
