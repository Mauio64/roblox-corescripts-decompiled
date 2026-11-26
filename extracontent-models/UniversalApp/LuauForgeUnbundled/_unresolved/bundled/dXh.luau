local CorePackages = game:GetService("CorePackages")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local actions = RoactNavigation.Actions
local Cryo = require(CorePackages.Packages.Cryo)
require(CorePackages.Packages.Dash)
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.rn.navutils")
local avatarExperienceActions = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Actions.AvatarExperienceActions
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
require("@luauforge/bundled/dXi")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout
local fFlagAXGuardNavStateNil = AvatarExperienceFlags.FFlagAXGuardNavStateNil
local fFlagAXGuardNavStateTraversal = AvatarExperienceFlags.FFlagAXGuardNavStateTraversal
local module2 = require("@luauforge/bundled/dXj")

local v5 = {}

function v5.instantTransitionConfig()
	return {
		transitionSpec = { frequency = 100000, dampingRatio = 1 }
	}
end

function v5.navigateToSearch(p2, p3, p4)
	v5.closeFiltersAndItemDetails(p2)
	v5.closeTryOnManager(p2)

	local v6 = { avatarScreen.CatalogSearch, avatarScreen.CatalogSearchLanding }
	p2.dispatch(avatarExperienceActions.clearScreens(v6))

	p2.dispatch(actions.navigate({
		routeName = avatarScreen.CatalogSearch,
		params = { detail = p3, searchParams = p4 },
		key = tostring(p3)
	}))
end

if module2 then
	function v5.navigateToSearchLandingFromSearch(p2)
		v5.closeFiltersAndItemDetails(p2)
		v5.closeTryOnManager(p2)

		local v6 = { avatarScreen.CatalogSearch, avatarScreen.CatalogSearchLanding }
		p2.dispatch(avatarExperienceActions.clearScreens(v6))

		p2.navigate(avatarScreen.CatalogSearchLanding)
	end
end

function v5.isWithinViewContext(p2, list): boolean
	if p2 and p2.previousPages and #list > 0 then
		local previousPages = p2.previousPages
		return #Cryo.List.filter(previousPages, function(p3): boolean
			return p3.name == list
		end) > 0
	end

	logging.warn("NavigationUtils.isWithinViewContext() failed because you forget to provide a valid avatarRoute")
	return false
end

function v5.isFirstItemDetailsPage(p2)
	return p2 and p2.getParam("isFirstItemDetails")
end

function v5.getEntryOrigin(p2)
	local param = p2.getParam("entryOrigin")

	if param then
		return param
	end

	local param2 = p2.getParam("prevNavPage")

	if param2 then
		return { screenName = param2 }
	end

	return nil
end

function v5.getEntryOriginParams(p2)
	local entryOrigin = v5.getEntryOrigin(p2)

	if entryOrigin then
		return { entryOrigin = entryOrigin }
	end

	return {}
end

function v5.restoreEntryOrigin(p2, p3)
	local entryOrigin = v5.getEntryOrigin(p2)

	if not entryOrigin then
		p2.navigate(p3)
		return
	end

	p2.navigate(avatarScreen.Catalog)

	if entryOrigin.coveredScreenName then
		p2.navigate(entryOrigin.coveredScreenName, entryOrigin.coveredScreenParams)
	end

	p2.navigate(entryOrigin.screenName, entryOrigin.screenParams)

	if entryOrigin.reopenAction then
		p2.dispatch(entryOrigin.reopenAction)
	end
end

function v5.closeFocusedScreen(p2)
	p2.dispatch(actions.back(nil))
end

function v5.closeFiltersAndItemDetails(p2)
	local expiredUserLookActionBars = {
		avatarScreen.ItemDetails,
		avatarScreen.SortAndFilters,
		avatarScreen.OutfitDetails,
		avatarScreen.LookDetails
	}

	if fFlagAXEnableExpiredUserLookCheckout then
		table.insert(expiredUserLookActionBars, avatarScreen.ExpiredUserLookActionBar)
	end

	p2.dispatch(avatarExperienceActions.clearScreens(expiredUserLookActionBars))
end

function v5.closeExpiredUserLookActionBar(p2)
	p2.dispatch(avatarExperienceActions.clearScreens({ avatarScreen.ExpiredUserLookActionBar }))
end

function v5.closeMySharedAvatars(p2)
	local v6 = { avatarScreen.MySharedAvatars, avatarScreen.LookDetails }

	p2.dispatch(avatarExperienceActions.clearScreens(v6))
end

function v5.closeLookComposer(p2)
	local v6 = { avatarScreen.LookComposerPage, avatarScreen.LookDetails }

	p2.dispatch(avatarExperienceActions.clearScreens(v6))
end

function v5.closeSearchLandingPageFocusedWidget(p2)
	local v6 = { avatarScreen.SearchLandingFocusedWidgetPage }

	p2.dispatch(avatarExperienceActions.clearScreens(v6))
end

function v5.closeSearchLandingPage(p2)
	local v6 = { avatarScreen.CatalogSearchLanding }

	p2.dispatch(avatarExperienceActions.clearScreens(v6))
end

function v5.closeTryOnManager(p2, p3)
	local v6 = { avatarScreen.TryOnManager, avatarScreen.LookDetails }

	p2.dispatch(avatarExperienceActions.clearScreens(p3 or v6))
end

function v5.getRootNavigation(p2)
	local v6 = p2

	while v6 do
		local v7 = if v6._dangerouslyGetParent then v6._dangerouslyGetParent() or nil else nil
		p2 = v6
		v6 = v7
	end

	return p2
end

function v5.closeAllDialogs(p2)
	p2.navigate(avatarScreen.AvatarExperienceMainStackNavigator)
end

local function onOverlayClosed() end

local function getRouteName(p2)
	return p2 and p2.state and p2.state.routeName or "<UnknownRoute>"
end

local function callbackToString(p2): string
	if p2 == onOverlayClosed then
		return "no-op"
	end

	if p2 == nil then
		return "nil"
	end

	return "callback"
end

function v5.removeOnOverlayClosed(p2)
	local onOverlayClosed2 = (p2.state.params or {}).onOverlayClosed

	if onOverlayClosed2 then
		p2.setParams({ onOverlayClosed = onOverlayClosed })
	end

	if logger.active[logger.Levels.Debug] then
		logger:debug(
			"removeOnOverlayClosed, routeName={}",
			p2 and p2.state and p2.state.routeName or "<UnknownRoute>"
		)
	end

	return onOverlayClosed2
end

function v5.invokeOnOverlayClosed(p2)
	local param = p2.getParam("onOverlayClosed")

	if logger.active[logger.Levels.Debug] then
		logger:debug(
			"invokeOnOverlayClosed, routeName={}, onOverlayClosed={}",
			p2 and p2.state and p2.state.routeName or "<UnknownRoute>",
			param == onOverlayClosed and "no-op" or param == nil and "nil" or "callback"
		)
	end

	if param then
		param()
	end
end

function v5.closeOverlay(p2)
	v5.invokeOnOverlayClosed(p2)
	p2.goBack()
end

function v5.navigateFromOverlay(p2, ...)
	v5.invokeOnOverlayClosed(p2)
	p2.navigate(...)
end

function v5.navigateToNextOverlay(p2, p3, options, ...)
	local v6 = v5.removeOnOverlayClosed(p2)

	if logger.active[logger.Levels.Debug] then
		logger:debug(
			"navigateToNextOverlay {} -> {}, onOverlayClosed={}",
			p2 and p2.state and p2.state.routeName or "<UnknownRoute>",
			p3,
			v6 == onOverlayClosed and "no-op" or v6 == nil and "nil" or "callback"
		)
	end

	local joined = Cryo.Dictionary.join(options or {}, { onOverlayClosed = v6 })

	p2.replace(p3, joined, ...)
end

function v5.getActiveScreenNavigationState(p2)
	if fFlagAXGuardNavStateTraversal then
		while p2 and p2.routes do
			p2 = p2.routes[p2.index]
		end
	else
		if fFlagAXGuardNavStateNil and not p2 then
			return nil
		end

		while p2.routes do
			p2 = p2.routes[p2.index]
		end
	end

	return p2
end

return v5
