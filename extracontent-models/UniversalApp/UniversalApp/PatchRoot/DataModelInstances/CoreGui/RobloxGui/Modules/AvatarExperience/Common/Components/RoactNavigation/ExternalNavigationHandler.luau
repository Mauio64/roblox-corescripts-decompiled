local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local CompleteExternalNavigation = require(Modules.AvatarExperience.Common.Actions.CompleteExternalNavigation)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local DeepLinkUtils = require(Modules.AvatarExperience.Common.DeepLinkUtils)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local NavigatedToDeepLinkCatalogFilter = require(Modules.AvatarExperience.Catalog.Actions.NavigatedToDeepLinkCatalogFilter)
local NavigateToDeepLinkCatalogFilterThunk = require(Modules.AvatarExperience.Catalog.Thunks.NavigateToDeepLinkCatalogFilterThunk)
local NavigateToSearch = require(Modules.AvatarExperience.Catalog.Thunks.NavigateToSearch)
local TryOnLookV2 = require(Modules.AvatarExperience.Common.Thunks.TryOnLookV2)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local FFlagEnableLookDetailsDeepLink = require(Modules.LuaApp.Flags.FFlagEnableLookDetailsDeepLink)
local FFlagEnableProfilePictureEditorDeepLink = require(Modules.LuaApp.Flags.FFlagEnableProfilePictureEditorDeepLink)
local FFlagAXFixPrefetchMarketplaceStartupCrash = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixPrefetchMarketplaceStartupCrash
local v24 = Roact.PureComponent:extend("ExternalNavigationHandler")
local v25 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.rn.externalnav")

function v24.render(_) -- line: 39
	return nil
end
function v24.didMount(p2) -- line: 43
	p2:processNavigationRequest()
end
function v24.didUpdate(p3, _) -- line: 47
	p3:processNavigationRequest()
end

local function editorCatalogSwitchAction(p5, p6) -- line: 52
	-- upvalues: RoactNavigation (copy), AvatarScreen (copy)
	return RoactNavigation.Actions.navigate({
		routeName = AvatarScreen.LandingPageSwitchNavigator,
		action = RoactNavigation.Actions.navigate({
			routeName = p5,
			params = p6
		})
	})
end
local function itemDetailsAction(p7) -- line: 62
	-- upvalues: Cryo (copy), RoactNavigation (copy), AvatarScreen (copy)
	local v38 = Cryo.Dictionary.join(p7, {
		category = Cryo.None,
		subcategory = Cryo.None,
		opaquePage = Cryo.None
	})

	return RoactNavigation.Actions.navigate({
		routeName = AvatarScreen.ItemDetails,
		params = Cryo.Dictionary.join(v38, {
			isFirstItemDetails = true
		})
	})
end
local function outfitDetailsAction(p8, p9) -- line: 78
	-- upvalues: RoactNavigation (copy), AvatarScreen (copy)
	return RoactNavigation.Actions.navigate({
		routeName = AvatarScreen.OutfitDetails,
		params = {
			ZIndex = 2,
			renderBottomBar = false,
			outfitId = p8.itemId,
			showFullWithNoPeekView = not p9
		}
	})
end

function v24.processNavigationRequest(p10) -- line: 90
	local completeExternalNavigation = p10.props.completeExternalNavigation
	local externalNavigationRequest = p10.props.externalNavigationRequest

	if externalNavigationRequest.completedRequestId ~= externalNavigationRequest.requestId then
		completeExternalNavigation(externalNavigationRequest.requestId)
		p10:navigateToScreen(externalNavigationRequest.screen, externalNavigationRequest.params)
	end
end
function v24.navigateToScreen(p11, p12, p13) -- line: 100
	-- upvalues: v25 (copy), AvatarScreen (copy), RoactNavigation (copy), editorCatalogSwitchAction (copy), itemDetailsAction (copy), outfitDetailsAction (copy), FFlagEnableLookDetailsDeepLink (copy), PeekViewState (copy), FFlagEnableProfilePictureEditorDeepLink (copy), Utils (copy), DeepLinkUtils (copy)
	v25:info("navigateToScreen: {}, params: {}", p12, p13)

	local navigation = p11.props.navigation
	local isPortrait = p11.props.isPortrait

	local function v49(p14) -- line: 105
		-- upvalues: navigation (copy), AvatarScreen (copy), RoactNavigation (copy)
		navigation.navigate(AvatarScreen.AvatarExperienceMainStackNavigator, {}, RoactNavigation.StackActions.reset({
			index = 2,
			actions = p14
		}))
	end

	if p12 == AvatarScreen.ItemDetails then
		local Catalog = AvatarScreen.Catalog

		if p13.opaquePage then
			Catalog = p13.opaquePage
		end

		v49({
			editorCatalogSwitchAction(Catalog, {}),
			itemDetailsAction(p13)
		})

		return
	end

	if p12 == AvatarScreen.OutfitDetails then
		v49({
			editorCatalogSwitchAction(AvatarScreen.AvatarEditor, {}),
			outfitDetailsAction(p13, isPortrait)
		})

		return
	end

	if FFlagEnableLookDetailsDeepLink and p12 == AvatarScreen.LookDetails then
		p11.props.dispatchTryOnLookV2(p11.props.networking, p11.props.navigation, p11.props.catalogAnalytics, p13.itemId, PeekViewState.Full)
		v49({
			editorCatalogSwitchAction(AvatarScreen.Catalog, {}),
			RoactNavigation.Actions.navigate({
				routeName = AvatarScreen.LookDetails
			})
		})

		return
	end

	if p12 == AvatarScreen.LayeredClothingSort then
		v49({
			editorCatalogSwitchAction(AvatarScreen.Catalog, {}),
			RoactNavigation.Actions.navigate({
				routeName = p12
			})
		})

		return
	end

	if p12 == AvatarScreen.AvatarExperienceLandingPage or p12 == AvatarScreen.AvatarEditor or FFlagEnableProfilePictureEditorDeepLink and p12 == AvatarScreen.ProfilePictureEditorEmotes then
		navigation.navigate(p12)

		return
	end

	if Utils.isAvatarBackground(p12) or p12 == AvatarScreen.Catalog then
		navigation.navigate(p12, p13)

		return
	end

	if p12 == AvatarScreen.CatalogSearch then
		local v51 = DeepLinkUtils.buildCatalogFilterFromDeepLinkParams(p13)
		local t1 = {
			searchKeyword = p13.keyword
		}

		p11.props.applyDeepLinkCatalogFilters(v51)
		p11.props.navigateToSearch(p11.props.navigation, t1)

		return
	end

	warn("[ExternalNavigationHandler] Invalid screen:", p12)
end

local function mapStateToProps(p15, _) -- line: 187
	-- upvalues: selectIsPortrait (copy)
	return {
		externalNavigationRequest = p15.AvatarExperience.ExternalNavigationRequest,
		isPortrait = selectIsPortrait(p15)
	}
end
local function mapDispatchToProps(p17) -- line: 194
	-- upvalues: CompleteExternalNavigation (copy), FFlagEnableLookDetailsDeepLink (copy), TryOnLookV2 (copy), FFlagAXFixPrefetchMarketplaceStartupCrash (copy), NavigateToDeepLinkCatalogFilterThunk (copy), NavigatedToDeepLinkCatalogFilter (copy), NavigateToSearch (copy)
	return {
		completeExternalNavigation = function(p18) -- line: 196
			-- upvalues: p17 (copy), CompleteExternalNavigation (copy)
			p17(CompleteExternalNavigation(p18))
		end,
		dispatchTryOnLookV2 = if not FFlagEnableLookDetailsDeepLink then nil else function(p19, p20, p21, p22, p23) -- line: 201
			-- upvalues: p17 (copy), TryOnLookV2 (copy)
			p17(TryOnLookV2(p19, p20, p21, p22, p23, 1))
		end,
		applyDeepLinkCatalogFilters = function(p24) -- line: 205
			-- upvalues: FFlagAXFixPrefetchMarketplaceStartupCrash (copy), p17 (copy), NavigateToDeepLinkCatalogFilterThunk (copy), NavigatedToDeepLinkCatalogFilter (copy)
			if FFlagAXFixPrefetchMarketplaceStartupCrash then
				p17(NavigateToDeepLinkCatalogFilterThunk(p24))

				return
			end

			p17(NavigatedToDeepLinkCatalogFilter(p24))
		end,
		navigateToSearch = function(p25, p26) -- line: 212
			-- upvalues: p17 (copy), NavigateToSearch (copy)
			return p17(NavigateToSearch(p25, p26))
		end
	}
end

if FFlagEnableLookDetailsDeepLink then
	v24 = RoactServices.connect({
		catalogAnalytics = Analytics,
		networking = RoactNetworking
	})(v24)
end

return (RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v24))
