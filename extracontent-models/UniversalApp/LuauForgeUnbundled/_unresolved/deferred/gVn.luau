local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local navigationParams = require("@luauforge/bundled/fCn").Enums.NavigationParams

local module = require("@luauforge/bundled/dPC")
local module2 = require("@luauforge/bundled/fCe")
local module3 = require("@luauforge/bundled/fIl")
require("@luauforge/bundled/dKT")

local peekViewState = require("@luauforge/bundled/dCI").PeekViewState
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local module4 = require("@luauforge/bundled/dPD")

local module5 = require("@luauforge/deferred/gVo")
local module6 = require("@luauforge/deferred/fDP")
local module7 = require("@luauforge/deferred/gTn")
local module8 = require("@luauforge/bundled/fDf")
local module9 = require("@luauforge/bundled/egx")
local module10 = require("@luauforge/bundled/gJS")

local module11 = require("@luauforge/bundled/fIH")
local module12 = require("@luauforge/bundled/fJq")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXAvatarMomentsCreation = AvatarExperienceFlags.FFlagAXAvatarMomentsCreation
local fFlagAXBackgroundGenerationDeepLink = AvatarExperienceFlags.FFlagAXBackgroundGenerationDeepLink
local fFlagAXCustomizeTabDeepLink = AvatarExperienceFlags.FFlagAXCustomizeTabDeepLink
local fFlagAXFixPrefetchMarketplaceStartupCrash = AvatarExperienceFlags.FFlagAXFixPrefetchMarketplaceStartupCrash
local fFlagAXPhotoboothMomentsPage = AvatarExperienceFlags.FFlagAXPhotoboothMomentsPage
local fFlagAXSduiProcessCatalogDeepLink = AvatarExperienceFlags.FFlagAXSduiProcessCatalogDeepLink

local fFlagEditProfileImageV2Enabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEditProfileImageV2Enabled

local fFlagEnableSplitPaneAvatarOverlay = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPaneAvatarOverlay

local extended = Roact.PureComponent:extend("ExternalNavigationHandler")

local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.rn.externalnav")

function extended.render(p2): nil
	return nil
end

function extended:didMount()
	self:processNavigationRequest()
end

function extended:didUpdate(p2)
	self:processNavigationRequest()
end

local function editorCatalogSwitchAction(p2, p3)
	return RoactNavigation.Actions.navigate({
		routeName = avatarScreen.LandingPageSwitchNavigator,
		action = RoactNavigation.Actions.navigate({ routeName = p2, params = p3 })
	})
end

local function itemDetailsAction(p2)
	local v5

	if fFlagAXCustomizeTabDeepLink then
		v5 = Cryo.Dictionary.join(p2, {
			category = Cryo.None,
			subcategory = Cryo.None,
			opaquePage = Cryo.None,
			[navigationParams.customizeTab] = Cryo.None
		})
	else
		v5 = Cryo.Dictionary.join(p2, {
			category = Cryo.None,
			subcategory = Cryo.None,
			opaquePage = Cryo.None
		})
	end

	return RoactNavigation.Actions.navigate({
		routeName = avatarScreen.ItemDetails,
		params = Cryo.Dictionary.join(v5, { isFirstItemDetails = true })
	})
end

local function outfitDetailsAction(p2, isPortrait)
	return RoactNavigation.Actions.navigate({
		routeName = avatarScreen.OutfitDetails,
		params = {
			outfitId = p2.itemId,
			ZIndex = 2,
			showFullWithNoPeekView = not isPortrait,
			renderBottomBar = false
		}
	})
end

function extended:processNavigationRequest()
	local completeExternalNavigation = self.props.completeExternalNavigation
	local externalNavigationRequest = self.props.externalNavigationRequest

	if externalNavigationRequest.completedRequestId ~= externalNavigationRequest.requestId then
		completeExternalNavigation(externalNavigationRequest.requestId)
		self:navigateToScreen(externalNavigationRequest.screen, externalNavigationRequest.params)
	end
end

function extended.navigateToScreen(p2, p3, options)
	local v5 = fFlagAXCustomizeTabDeepLink and (options or {}) or options

	logger:info("navigateToScreen: {}, params: {}", p3, v5)
	local navigation = p2.props.navigation
	local isPortrait = p2.props.isPortrait

	local function fn(p4)
		navigation.navigate(
			avatarScreen.AvatarExperienceMainStackNavigator,
			{},
			RoactNavigation.StackActions.reset({ actions = p4, index = 2 })
		)
	end

	if p3 == avatarScreen.ItemDetails then
		local v6 = avatarScreen.Catalog

		if v5.opaquePage then
			v6 = v5.opaquePage
		end

		fn({
			editorCatalogSwitchAction(
				v6,
				fFlagAXCustomizeTabDeepLink and v6 == avatarScreen.AvatarEditor and v5[navigationParams.customizeTab] ~= nil and {
					category = v5.category,
					subcategory = v5.subcategory,
					customizeTab = v5[navigationParams.customizeTab]
				} or {}
			),
			itemDetailsAction(v5)
		})
	elseif p3 == avatarScreen.OutfitDetails then
		fn({ editorCatalogSwitchAction(avatarScreen.AvatarEditor, {}), outfitDetailsAction(v5, isPortrait) })
	elseif module11 and p3 == avatarScreen.LookDetails then
		p2.props.dispatchTryOnLookV2(
			p2.props.networking,
			p2.props.navigation,
			p2.props.catalogAnalytics,
			v5.itemId,
			peekViewState.Full
		)

		fn({
			editorCatalogSwitchAction(avatarScreen.Catalog, {}),
			RoactNavigation.Actions.navigate({ routeName = avatarScreen.LookDetails })
		})
	elseif p3 == avatarScreen.LayeredClothingSort then
		fn({
			editorCatalogSwitchAction(avatarScreen.Catalog, {}),
			RoactNavigation.Actions.navigate({ routeName = p3 })
		})
	elseif fFlagAXBackgroundGenerationDeepLink and p3 == avatarScreen.BackgroundGeneration then
		fn({
			editorCatalogSwitchAction(avatarScreen.AvatarEditor, {}),
			RoactNavigation.Actions.navigate({ routeName = p3 })
		})
	elseif
		fFlagEnableSplitPaneAvatarOverlay
		and (p3 == avatarScreen.AvatarEditor or p3 == avatarScreen.Profile)
	then
		navigation.navigate(p3, v5)
	elseif
		p3 == avatarScreen.AvatarExperienceLandingPage
		or p3 == avatarScreen.AvatarEditor
		or module12 and p3 == avatarScreen.ProfilePictureEditorEmotes
	then
		if
			fFlagAXCustomizeTabDeepLink
			and p3 == avatarScreen.AvatarEditor
			and v5[navigationParams.customizeTab] ~= nil
		then
			navigation.navigate(p3, v5)
		else
			navigation.navigate(p3)
		end
	else
		if fFlagEditProfileImageV2Enabled and p3 == avatarScreen.EditProfileImage then
			navigation.navigate(p3, v5)
			return
		end

		if
			fFlagAXAvatarMomentsCreation
			and fFlagAXPhotoboothMomentsPage
			and p3 == avatarScreen.PhotoboothMomentsPage
		then
			navigation.navigate(p3)
			return
		end

		if module2.isAvatarBackground(p3) or p3 == avatarScreen.Catalog then
			navigation.navigate(p3, v5)
			return
		end

		if p3 ~= avatarScreen.CatalogSearch then
			warn("[ExternalNavigationHandler] Invalid screen:", p3)

			return
		end

		local catalogFilterFromDeepLinkParams = module3.buildCatalogFilterFromDeepLinkParams(v5)
		local v6 = { searchKeyword = v5.keyword }

		p2.props.applyDeepLinkCatalogFilters(catalogFilterFromDeepLinkParams)

		p2.props.navigateToSearch(p2.props.navigation, v6)
	end
end

local function mapStateToProps(p2, p3)
	return {
		externalNavigationRequest = p2.AvatarExperience.ExternalNavigationRequest,
		isPortrait = module10(p2)
	}
end

local function mapDispatchToProps(callback)
	return {
		completeExternalNavigation = function(p2)
			callback(module(p2))
		end,
		dispatchTryOnLookV2 = module11 and function(p2, p3, p4, p5, p6)
			callback(module7(p2, p3, p4, p5, p6, 1))
		end or nil,
		applyDeepLinkCatalogFilters = function(p2)
			if not fFlagAXFixPrefetchMarketplaceStartupCrash then
				callback(module4(p2))
			elseif fFlagAXSduiProcessCatalogDeepLink then
				callback(module5(p2, false))
			else
				callback(module5(p2))
			end
		end,
		navigateToSearch = function(p2, p3)
			return callback(module6(p2, p3))
		end
	}
end

if module11 then
	extended = roactServices.connect({
		catalogAnalytics = module8,
		networking = module9
	})(extended)
end

return (RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended))
