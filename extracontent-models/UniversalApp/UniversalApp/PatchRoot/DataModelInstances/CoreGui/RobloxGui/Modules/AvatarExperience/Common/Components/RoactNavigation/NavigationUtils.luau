local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Actions = require(CorePackages.Packages.RoactNavigation).Actions
local Cryo = require(CorePackages.Packages.Cryo)

require(CorePackages.Packages.Dash)

local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Modules = CoreGui.RobloxGui.Modules
local v7 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.rn.navutils")
local AvatarExperienceActions = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AvatarExperienceActions)

require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)

local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen

require(Modules.AvatarExperience.Catalog.SearchTypes)

local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout
local FFlagAXGuardNavStateNil = AvatarExperienceFlags.FFlagAXGuardNavStateNil
local FFlagAXGuardNavStateTraversal = AvatarExperienceFlags.FFlagAXGuardNavStateTraversal
local t1 = {
	instantTransitionConfig = function() -- line: 31
		return {
			transitionSpec = {
				frequency = 100000,
				dampingRatio = 1
			}
		}
	end
}

function t1.navigateToSearch(p1, s1: string, p2) -- line: 40
	-- upvalues: t1 (copy), AvatarScreen (copy), AvatarExperienceActions (copy), Actions (copy)
	t1.closeFiltersAndItemDetails(p1)
	t1.closeTryOnManager(p1)

	local t2 = {
		AvatarScreen.CatalogSearch,
		AvatarScreen.CatalogSearchLanding
	}

	p1.dispatch(AvatarExperienceActions.clearScreens(t2))
	p1.dispatch(Actions.navigate({
		routeName = AvatarScreen.CatalogSearch,
		params = {
			detail = s1,
			searchParams = p2
		},
		key = tostring(s1)
	}))
end
function t1.isWithinViewContext(p3, s2: string) -- line: 67
	-- upvalues: Cryo (copy), Logging (copy)
	if p3 and (p3.previousPages and #s2 > 0) then
		local previousPages = p3.previousPages

		return #Cryo.List.filter(previousPages, function(p4) -- line: 70
			-- upvalues: s2 (copy)
			return p4.name == s2
		end) > 0
	end

	Logging.warn("NavigationUtils.isWithinViewContext() failed because you forget to provide a valid avatarRoute")

	return false
end
function t1.isFirstItemDetailsPage(p5) -- line: 86
	return p5 and p5.getParam("isFirstItemDetails")
end
function t1.closeFocusedScreen(p6) -- line: 98
	-- upvalues: Actions (copy)
	p6.dispatch(Actions.back(nil))
end
function t1.closeFiltersAndItemDetails(p7) -- line: 110
	-- upvalues: AvatarScreen (copy), FFlagAXEnableExpiredUserLookCheckout (copy), AvatarExperienceActions (copy)
	local t3 = {
		AvatarScreen.ItemDetails,
		AvatarScreen.SortAndFilters,
		AvatarScreen.OutfitDetails,
		AvatarScreen.LookDetails
	}

	if FFlagAXEnableExpiredUserLookCheckout then
		table.insert(t3, AvatarScreen.ExpiredUserLookActionBar)
	end

	p7.dispatch(AvatarExperienceActions.clearScreens(t3))
end
function t1.closeExpiredUserLookActionBar(p8) -- line: 131
	-- upvalues: AvatarExperienceActions (copy), AvatarScreen (copy)
	p8.dispatch(AvatarExperienceActions.clearScreens({ AvatarScreen.ExpiredUserLookActionBar }))
end
function t1.closeMySharedAvatars(p9) -- line: 137
	-- upvalues: AvatarScreen (copy), AvatarExperienceActions (copy)
	local t4 = {
		AvatarScreen.MySharedAvatars,
		AvatarScreen.LookDetails
	}

	p9.dispatch(AvatarExperienceActions.clearScreens(t4))
end
function t1.closeLookComposer(p10) -- line: 146
	-- upvalues: AvatarScreen (copy), AvatarExperienceActions (copy)
	local t5 = {
		AvatarScreen.LookComposerPage,
		AvatarScreen.LookDetails
	}

	p10.dispatch(AvatarExperienceActions.clearScreens(t5))
end
function t1.closeSearchLandingPageFocusedWidget(p11) -- line: 155
	-- upvalues: AvatarScreen (copy), AvatarExperienceActions (copy)
	local t6 = { AvatarScreen.SearchLandingFocusedWidgetPage }

	p11.dispatch(AvatarExperienceActions.clearScreens(t6))
end
function t1.closeSearchLandingPage(p12) -- line: 162
	-- upvalues: AvatarScreen (copy), AvatarExperienceActions (copy)
	local t7 = { AvatarScreen.CatalogSearchLanding }

	p12.dispatch(AvatarExperienceActions.clearScreens(t7))
end
function t1.closeTryOnManager(p13, t8: {[any]: any}?) -- line: 173
	-- upvalues: AvatarScreen (copy), AvatarExperienceActions (copy)
	local t9 = {
		AvatarScreen.TryOnManager,
		AvatarScreen.LookDetails
	}

	if t8 then
		t9 = t8
	end

	p13.dispatch(AvatarExperienceActions.clearScreens(t9))
end
function t1.getRootNavigation(p14) -- line: 189
	local v42 = p14

	while v42 do
		p14 = v42
		v42 = p14._dangerouslyGetParent and p14._dangerouslyGetParent() or nil
	end

	return p14
end
function t1.closeAllDialogs(p15) -- line: 198
	-- upvalues: AvatarScreen (copy)
	p15.navigate(AvatarScreen.AvatarExperienceMainStackNavigator)
end

local function v15() -- line: 202
end
local function getRouteName(p16) -- line: 204
	return p16 and (not not p16.state and p16.state.routeName) or "<UnknownRoute>"
end
local function callbackToString(p17) -- line: 208
	-- upvalues: v15 (copy)
	if p17 == v15 then
		return "no-op"
	end

	if p17 == nil then
		return "nil"
	end

	return "callback"
end

function t1.removeOnOverlayClosed(p18) -- line: 221
	-- upvalues: v15 (copy), v7 (copy)
	local onOverlayClosed = (p18.state.params or {}).onOverlayClosed

	if onOverlayClosed then
		p18.setParams({
			onOverlayClosed = v15
		})
	end

	if v7.active[v7.Levels.Debug] then
		v7:debug("removeOnOverlayClosed, routeName={}", p18 and (not not p18.state and p18.state.routeName) or "<UnknownRoute>")
	end

	return onOverlayClosed
end
function t1.invokeOnOverlayClosed(p19) -- line: 235
	-- upvalues: v7 (copy), v15 (copy)
	local v49 = p19.getParam("onOverlayClosed")

	if v7.active[v7.Levels.Debug] then
		v7:debug("invokeOnOverlayClosed, routeName={}, onOverlayClosed={}", p19 and (not not p19.state and p19.state.routeName) or "<UnknownRoute>", if v49 ~= v15 then v49 ~= nil and "callback" or "nil" else "no-op")
	end

	if v49 then
		v49()
	end
end
function t1.closeOverlay(p20) -- line: 260
	-- upvalues: t1 (copy)
	t1.invokeOnOverlayClosed(p20)
	p20.goBack()
end
function t1.navigateFromOverlay(p21, ...) -- line: 275
	-- upvalues: t1 (copy)
	t1.invokeOnOverlayClosed(p21)
	p21.navigate(...)
end
function t1.navigateToNextOverlay(p22, s3: string, p23, ...) -- line: 288
	-- upvalues: t1 (copy), v7 (copy), v15 (copy), Cryo (copy)
	local v55 = t1.removeOnOverlayClosed(p22)

	if v7.active[v7.Levels.Debug] then
		v7:debug("navigateToNextOverlay {} -> {}, onOverlayClosed={}", p22 and (not not p22.state and p22.state.routeName) or "<UnknownRoute>", s3, if v55 ~= v15 then v55 ~= nil and "callback" or "nil" else "no-op")
	end

	local v56 = Cryo.Dictionary.join(p23 or {}, {
		onOverlayClosed = v55
	})

	p22.replace(s3, v56, ...)
end
function t1.getActiveScreenNavigationState(p24) -- line: 308
	-- upvalues: FFlagAXGuardNavStateTraversal (copy), FFlagAXGuardNavStateNil (copy)
	if FFlagAXGuardNavStateTraversal then
		while p24 and p24.routes do
			p24 = p24.routes[p24.index]
		end
	else
		if FFlagAXGuardNavStateNil and not p24 then
			return nil
		end

		while p24.routes do
			p24 = p24.routes[p24.index]
		end
	end

	return p24
end

return t1
