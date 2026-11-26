local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local routeInfo = AvatarExperienceNavigation.AvatarRoute.RouteInfo
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local avatarRouteContext = AvatarExperienceNavigation.AvatarRoute.Context.AvatarRouteContext
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local module2 = require("@luauforge/bundled/fAg")

local module3 = require("@luauforge/bundled/gTi")
local module4 = require("@luauforge/bundled/dzP")
local module5 = require("@luauforge/bundled/fAf")
require("@luauforge/bundled/dKT")

require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience

local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useSelector = if fFlagSignalsNavP3gAvatarExperience then RoactUtils.Hooks.RoactRodux.useSelector else nil
local getLegacyNavigationStore

if fFlagSignalsNavP3gAvatarExperience then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local module7 = require("@luauforge/bundled/gTj")

local isAvatarRoute = module7.isAvatarRoute
local isAvatarExperienceWrapper = module7.isAvatarExperienceWrapper
local opaquePageFromRoute = module7.opaquePageFromRoute

local function selectCentralOverlayShowing(p2): boolean
	return p2.CentralOverlay.OverlayType ~= nil
end

local function selectStoreAvatarRoute(p2)
	return p2.AvatarExperience.AvatarScene.AvatarRoute
end

local function selectNoAvatarRoute(): nil
	return nil
end

local function routeInfoFromPage(data)
	local v5 = data.name

	local v6 = if data.detail then v5 .. ":" .. data.detail else v5

	local v7 = data.extraProps or {}

	if isAvatarExperienceWrapper(data) then
		v5 = v7.routeName
		v7 = v7.params
	end

	local joined = Cryo.Dictionary.join(v7, { detail = data.detail })

	return routeInfo.new(v5, v6, joined)
end

local function getAvatarRoute(list, p2, p3)
	local item = list[#list]

	if isAvatarRoute(item.name) then
		return p2
	end

	local v5 = opaquePageFromRoute(list)

	if isAvatarRoute(v5.name) then
		return avatarRoute.new({
			current = routeInfoFromPage(item),
			opaque = p2.opaque,
			isVisible = true,
			isOverlayVisible = p3
		})
	end

	return avatarRoute.new({
		current = routeInfoFromPage(item),
		opaque = routeInfoFromPage(v5),
		isVisible = isAvatarExperienceWrapper(item) or isAvatarExperienceWrapper(v5),
		isOverlayVisible = p3
	})
end

local function useAppRouteAvatarRoute(avatarRoute2)
	local legacyNavigationStore = getLegacyNavigationStore(false)
	local v6 = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p2)
			return legacyNavigationStore.getCurrentLegacyRoute(p2)
		end, module3)
	end, { legacyNavigationStore })))
	local v7 = useSelector(selectCentralOverlayShowing)
	local v9 = if avatarRoute2 then selectNoAvatarRoute else selectStoreAvatarRoute
	local v10 = useSelector(v9)

	local v11 = avatarRoute2 or v10
	return React.useMemo(function()
		return getAvatarRoute(v6, v11, v7)
	end, { v6, v11, v7 })
end

return function(p2)
	module4.assert(module2(p2), "withAppRoute must be called with a Roact component")

	local extended = Roact.PureComponent:extend("AppRouteWrapper")

	function extended:getAvatarRoute()
		return getAvatarRoute(
			self.props.currentNavigationRoute,
			self.props.avatarRoute,
			self.props.centralOverlayShowing
		)
	end

	function extended:render()
		local avatarRoute2 = self:getAvatarRoute()

		return Roact.createElement(
			p2,
			Cryo.Dictionary.join(self.props, {
				avatarRoute = avatarRoute2,
				currentNavigationRoute = Cryo.None,
				centralOverlayShowing = Cryo.None
			})
		)
	end

	local function mapStateToProps(data, p3)
		local v5

		if not fFlagSignalsNavP3gAvatarExperience then
			if fFlagUseNavigationSelectors then
				v5 = selectors.selectCurrentLegacyRoute(data)
			else
				v5 = data.Navigation.history[#data.Navigation.history]
			end
		end

		local v6 = data.CentralOverlay.OverlayType ~= nil
		return {
			currentNavigationRoute = v5,
			avatarRoute = p3.avatarRoute or data.AvatarExperience.AvatarScene.AvatarRoute,
			centralOverlayShowing = v6
		}
	end

	local v5

	if fFlagSignalsNavP3gAvatarExperience then
		local function WithAppRouteSignals(p3)
			local v6 = useAppRouteAvatarRoute(p3.avatarRoute)
			return React.createElement(p2, Cryo.Dictionary.union(p3, {
				avatarRoute = v6
			}))
		end

		v5 = React.memo(WithAppRouteSignals)
	else
		v5 = RoactRodux.connect(mapStateToProps, nil)(extended)
	end

	return (module5(v5, avatarRouteContext.Consumer, "avatarRoute", { required = false }))
end
