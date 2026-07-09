local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local RouteInfo = AvatarExperienceNavigation.AvatarRoute.RouteInfo
local AvatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local AvatarRouteContext = AvatarExperienceNavigation.AvatarRoute.Context.AvatarRouteContext
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local AppPage = require(Modules.LuaApp.AppPage)
local AppPageProperties = require(Modules.LuaApp.AppPageProperties)
local isComponent = require(Modules.AvatarExperience.Common.isComponent)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local withContextValue = require(Modules.AvatarExperience.Common.withContextValue)

require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(CorePackages.Workspace.Packages.NavigationRodux)

local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagSignalsNavP3gAvatarExperience = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3gAvatarExperience
local React = require(CorePackages.Packages.React)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v22 = if not FFlagSignalsNavP3gAvatarExperience then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local SwitchTab = require(CorePackages.Workspace.Packages.RobloxAppEnums).SwitchTab

local function isAvatarRoute(p1) -- line: 59
	-- upvalues: AvatarScreen (copy), SwitchTab (copy)
	return p1 == AvatarScreen.AvatarExperienceRoot or p1 == SwitchTab.AvatarExperienceTab
end

return function(p2) -- line: 63
	-- upvalues: ArgCheck (copy), isComponent (copy), AppPageProperties (copy), AvatarScreen (copy), AppPage (copy), Cryo (copy), RouteInfo (copy), Roact (copy), SwitchTab (copy), AvatarRoute (copy), FFlagSignalsNavP3gAvatarExperience (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), RoactRodux (copy), v22 (copy), useSignalState (copy), React (copy), withContextValue (copy), AvatarRouteContext (copy)
	ArgCheck.assert(isComponent(p2), "withAppRoute must be called with a Roact component")

	local function opaquePageFromRoute(p3) -- line: 67
		-- upvalues: AppPageProperties (copy), AvatarScreen (copy)
		for i = #p3, 1, -1 do
			local v36 = p3[i]
			local v37 = AppPageProperties[v36.name]

			if v37 == nil or not v37.renderUnderlyingPage then
				return v36
			end
		end

		return {
			name = AvatarScreen.None
		}
	end
	local function isAvatarExperienceWrapper(p4) -- line: 86
		-- upvalues: AppPage (copy)
		return p4.name == AppPage.AvatarExperienceWrapper or p4.name == AppPage.AvatarExperienceWrapperTransparent
	end
	local function routeInfoFromPage(p5) -- line: 94
		-- upvalues: AppPage (copy), Cryo (copy), RouteInfo (copy)
		local name = p5.name
		local v41 = name

		if p5.detail then
			v41 ..= ":" .. p5.detail
		end

		local v42 = p5.extraProps or {}

		if p5.name == AppPage.AvatarExperienceWrapper or p5.name == AppPage.AvatarExperienceWrapperTransparent then
			name = v42.routeName
			v42 = v42.params
		end

		local v43 = Cryo.Dictionary.join(v42, {
			detail = p5.detail
		})

		return RouteInfo.new(name, v41, v43)
	end

	local v30 = Roact.PureComponent:extend("AppRouteWrapper")

	function v30.getAvatarRoute(p6) -- line: 114
		-- upvalues: AvatarScreen (copy), SwitchTab (copy), opaquePageFromRoute (copy), AvatarRoute (copy), routeInfoFromPage (copy), AppPage (copy)
		local currentNavigationRoute = p6.props.currentNavigationRoute
		local v46 = currentNavigationRoute[#currentNavigationRoute]
		local name = v46.name

		if name == AvatarScreen.AvatarExperienceRoot or name == SwitchTab.AvatarExperienceTab then
			return p6.props.avatarRoute
		end

		local v48 = opaquePageFromRoute(currentNavigationRoute)
		local name2 = v48.name

		if name2 == AvatarScreen.AvatarExperienceRoot or name2 == SwitchTab.AvatarExperienceTab then
			local avatarRoute = p6.props.avatarRoute

			return AvatarRoute.new({
				isVisible = true,
				current = routeInfoFromPage(v46),
				opaque = avatarRoute.opaque,
				isOverlayVisible = p6.props.centralOverlayShowing
			})
		end

		return AvatarRoute.new({
			current = routeInfoFromPage(v46),
			opaque = routeInfoFromPage(v48),
			isVisible = v46.name == AppPage.AvatarExperienceWrapper or v46.name == AppPage.AvatarExperienceWrapperTransparent or (v48.name == AppPage.AvatarExperienceWrapper or v48.name == AppPage.AvatarExperienceWrapperTransparent),
			isOverlayVisible = p6.props.centralOverlayShowing
		})
	end
	function v30.render(p7) -- line: 149
		-- upvalues: Roact (copy), p2 (copy), Cryo (copy)
		local v52 = p7:getAvatarRoute()

		return Roact.createElement(p2, Cryo.Dictionary.join(p7.props, {
			avatarRoute = v52,
			currentNavigationRoute = Cryo.None,
			centralOverlayShowing = Cryo.None
		}))
	end

	local function mapStateToProps(p8, p9) -- line: 162
		-- upvalues: FFlagSignalsNavP3gAvatarExperience (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
		local v55 = nil

		if not FFlagSignalsNavP3gAvatarExperience then
			v55 = if not FFlagUseNavigationSelectors then p8.Navigation.history[#p8.Navigation.history] else Selectors.selectCurrentLegacyRoute(p8)
		end

		local v56 = p8.CentralOverlay.OverlayType ~= nil
		local v57 = p9.avatarRoute or p8.AvatarExperience.AvatarScene.AvatarRoute

		return {
			currentNavigationRoute = v55,
			avatarRoute = v57,
			centralOverlayShowing = v56
		}
	end

	local v32 = RoactRodux.connect(mapStateToProps, nil)(v30)

	if FFlagSignalsNavP3gAvatarExperience then
		local v33 = v32

		function v32(p10) -- line: 185
			-- upvalues: v22 (copy), useSignalState (copy), React (copy), v33 (copy), Cryo (copy)
			local v59 = v22(false)
			local v60 = useSignalState(v59.getCurrentLegacyRoute)

			return React.createElement(v33, Cryo.Dictionary.union(p10, {
				currentNavigationRoute = v60
			}))
		end
	end

	return (withContextValue(v32, AvatarRouteContext.Consumer, "avatarRoute", {
		required = false
	}))
end
