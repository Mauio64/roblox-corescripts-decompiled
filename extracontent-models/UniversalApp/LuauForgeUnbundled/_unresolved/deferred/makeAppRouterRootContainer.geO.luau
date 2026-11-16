local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local module = require("@luauforge/bundled/dCp")
local module2 = require("@luauforge/bundled/dTM")
local module3 = require("@luauforge/bundled/dDE")

local module4 = require("@luauforge/deferred/geP")

local module5 = require("@luauforge/deferred/geQ")

local avatarRouteContext = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Context.AvatarRouteContext
local module6 = require("@luauforge/deferred/gqS")

local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties
require("@luauforge/bundled/dHK")

local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors
local fFlagAXGuardNavStateNil = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXGuardNavStateNil

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3gAvatarExperience then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local function getPageName(p2)
	local pageName = p2.name

	if
		pageName == module.AvatarExperienceWrapper
		or pageName == module.AvatarExperienceWrapperTransparent
	then
		pageName = p2.extraProps.routeName
	end

	return pageName
end

local function isVisible(navigation, currentRoute): boolean
	local activeScreenNavigationState = module2.getActiveScreenNavigationState(navigation.state)

	if fFlagAXGuardNavStateNil and not activeScreenNavigationState then
		return false
	end

	local detail

	if activeScreenNavigationState.params then
		detail = activeScreenNavigationState.params.detail or nil
	end

	local routeName = activeScreenNavigationState.routeName
	local avatarScreenProperty = avatarScreenProperties[routeName]
	local isTransparent = avatarScreenProperty and avatarScreenProperty.isTransparent
	local count = 0

	for i = #currentRoute, 1, -1 do
		local item = currentRoute[i]
		local v5 = item.name

		if v5 == module.AvatarExperienceWrapper or v5 == module.AvatarExperienceWrapperTransparent then
			v5 = item.extraProps.routeName
		end

		if v5 == routeName and item.detail == detail then
			return true
		end

		if module3[v5] and not module3[v5].renderUnderlyingPage then
			return false
		end

		if not isTransparent then
			continue
		end

		count += 1

		if count >= 1 then
			return false
		end
	end

	return false
end

local function makeAppRouterRootContainer(p2)
	local v5 = module5(p2)

	local extended = Roact.PureComponent:extend("AppRouterRootContainer")

	function extended.render(p3)
		local navigation = p3.props.navigation

		return Roact.createElement(module4.Provider, { value = p3.props.params }, {
			AvatarRouteProvider = Roact.createElement(
				avatarRouteContext.Provider,
				{
					value = module6(navigation, isVisible(navigation, p3.props.currentRoute))
				},
				{
					navigation = Roact.createElement(v5, { navigation = navigation }),
					androidBackButtonNavigationHandler = p3.props.renderAndroidBackButtonNavigationHandler(navigation)
				}
			)
		})
	end

	local appRouterRootContainer

	if fFlagSignalsNavP3gAvatarExperience then
		appRouterRootContainer = React.memo(function(p3)
			local v6 = useSignalState(getLegacyNavigationStore(false).getCurrentLegacyRoute)
			return React.createElement(extended, Cryo.Dictionary.union(p3, {
				currentRoute = v6
			}))
		end)
	else
		local function mapStateToProps(p3, p4)
			return {
				currentRoute = if fFlagUseNavigationSelectors then selectors.selectCurrentLegacyRoute(p3) else p3.Navigation.history[#p3.Navigation.history]
			}
		end

		appRouterRootContainer = RoactRodux.connect(mapStateToProps, nil)(extended)
	end

	appRouterRootContainer.router = v5.router

	return appRouterRootContainer
end

return makeAppRouterRootContainer
