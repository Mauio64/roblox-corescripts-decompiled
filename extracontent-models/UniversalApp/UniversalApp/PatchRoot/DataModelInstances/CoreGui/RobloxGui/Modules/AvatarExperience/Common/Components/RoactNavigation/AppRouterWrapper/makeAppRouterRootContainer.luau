local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local AppPage = require(Modules.LuaApp.AppPage)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local AppPageProperties = require(Modules.LuaApp.AppPageProperties)
local AppRouterParamsContext = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AppRouterWrapper.AppRouterParamsContext)
local makeAppRouterRootNavigator = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AppRouterWrapper.makeAppRouterRootNavigator)
local AvatarRouteContext = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.Context.AvatarRouteContext
local makeAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.makeAvatarRoute)
local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagAXGuardNavStateNil = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXGuardNavStateNil
local FFlagSignalsNavP3gAvatarExperience = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3gAvatarExperience
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v20 = if not FFlagSignalsNavP3gAvatarExperience then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore

local function getPageName(p1) -- line: 47
	-- upvalues: AppPage (copy)
	local name = p1.name

	if name == AppPage.AvatarExperienceWrapper or name == AppPage.AvatarExperienceWrapperTransparent then
		name = p1.extraProps.routeName
	end

	return name
end
local function isVisible(p2, p3) -- line: 60
	-- upvalues: NavigationUtils (copy), FFlagAXGuardNavStateNil (copy), AvatarScreenProperties (copy), AppPage (copy), AppPageProperties (copy)
	local v28 = NavigationUtils.getActiveScreenNavigationState(p2.state)

	if FFlagAXGuardNavStateNil and not v28 then
		return false
	end

	local v29 = v28.params and v28.params.detail or nil
	local routeName = v28.routeName
	local v31 = AvatarScreenProperties[routeName]
	local v32 = v31 and v31.isTransparent
	local n1 = 0

	for i = #p3, 1, -1 do
		local v35 = p3[i]
		local name = v35.name

		if name == AppPage.AvatarExperienceWrapper or name == AppPage.AvatarExperienceWrapperTransparent then
			name = v35.extraProps.routeName
		end

		if name == routeName and v29 == v35.detail then
			return true
		end

		if AppPageProperties[name] and not AppPageProperties[name].renderUnderlyingPage then
			return false
		end

		if v32 then
			n1 += 1

			if not (n1 >= 1) then
				continue
			end

			return false
		end
	end

	return false
end
local function makeAppRouterRootContainer(p4) -- line: 92
	-- upvalues: makeAppRouterRootNavigator (copy), Roact (copy), AppRouterParamsContext (copy), AvatarRouteContext (copy), makeAvatarRoute (copy), isVisible (copy), FFlagSignalsNavP3gAvatarExperience (copy), React (copy), v20 (copy), useSignalState (copy), Cryo (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), RoactRodux (copy)
	local v38 = makeAppRouterRootNavigator(p4)
	local v39 = Roact.PureComponent:extend("AppRouterRootContainer")

	function v39.render(p5) -- line: 97
		-- upvalues: Roact (copy), AppRouterParamsContext (copy), AvatarRouteContext (copy), makeAvatarRoute (copy), isVisible (copy), v38 (copy)
		local navigation = p5.props.navigation

		return Roact.createElement(AppRouterParamsContext.Provider, {
			value = p5.props.params
		}, {
			AvatarRouteProvider = Roact.createElement(AvatarRouteContext.Provider, {
				value = makeAvatarRoute(navigation, (isVisible(navigation, p5.props.currentRoute)))
			}, {
				navigation = Roact.createElement(v38, {
					navigation = navigation
				}),
				androidBackButtonNavigationHandler = p5.props.renderAndroidBackButtonNavigationHandler(navigation)
			})
		})
	end

	local v41

	if FFlagSignalsNavP3gAvatarExperience then
		local v40 = v39

		v41 = React.memo(function(p6) -- line: 117
			-- upvalues: v20 (copy), useSignalState (copy), React (copy), v40 (copy), Cryo (copy)
			local v46 = v20(false)
			local v47 = useSignalState(v46.getCurrentLegacyRoute)

			return React.createElement(v40, Cryo.Dictionary.union(p6, {
				currentRoute = v47
			}))
		end)
	else
		local function mapStateToProps(p7, _) -- line: 129
			-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
			return {
				currentRoute = if not FFlagUseNavigationSelectors then p7.Navigation.history[#p7.Navigation.history] else Selectors.selectCurrentLegacyRoute(p7)
			}
		end

		v41 = RoactRodux.connect(mapStateToProps, nil)(v39)
	end

	v41.router = v38.router

	return v41
end

return makeAppRouterRootContainer
