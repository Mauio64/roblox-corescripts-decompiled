local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local createComputed = Signals.createComputed
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local module = require("@luauforge/deferred/fvI")
local module2 = require("@luauforge/deferred/fvO")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local t = require(CorePackages.Packages.t)

local module3 = require("@luauforge/bundled/dzM")
local module4 = require("@luauforge/bundled/dFu")
local module5 = require("@luauforge/bundled/fzG")
local module6 = require("@luauforge/bundled/gJr")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module7 = require("@luauforge/bundled/gJs")

local module8 = require("@luauforge/deferred/gJu")
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3gAvatarExperience then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local extended = Roact.Component:extend("AvatarExperienceWrapper")

extended.validateProps = t.strictInterface({
	routeName = t.string,
	params = t.interface({ detail = t.string }),
	currentAppPageName = t.optional(t.string),
	currentAppPageDetail = t.optional(t.string),
	unlockNavigation = t.callback
})

function extended:init()
	local v5 = module8(self.props.routeName)
	self.navigationAppContainer = RoactNavigation.createAppContainer(v5, nil)

	self.isAndroidBackButtonHandlerDisabled = memoize(function(p3, p4, p5): boolean
		return p3 ~= module4.AvatarExperienceWrapper and p3 ~= module4.AvatarExperienceWrapperTransparent
			or p4 ~= p5
	end)

	self.renderAndroidBackButtonNavigationHandler = memoize(function(p3)
		return function(p4)
			return Roact.createElement(module, {
				canGoBackInRN = not module2(p4.state),
				navigateBackInRN = p4.pop,
				disabled = p3
			})
		end
	end)

	local v6 = module7("AvatarExperienceWrapper:" .. self.props.routeName)

	function self.onNavigationStateChange(p3, p4, p5)
		v6(p3, p4, p5)

		if not p4.isTransitioning then
			self.props.unlockNavigation()
		end
	end
end

function extended.render(props)
	local isAndroidBackButtonHandlerDisabled = props.isAndroidBackButtonHandlerDisabled
	local currentAppPageName = props.props.currentAppPageName
	local currentAppPageDetail = props.props.currentAppPageDetail
	local v5 = if props.props.params then props.props.params.detail or nil else nil
	local androidBackButtonHandlerDisabled = isAndroidBackButtonHandlerDisabled(
		currentAppPageName,
		currentAppPageDetail,
		v5
	)

	return Roact.createElement(module5.Provider, {
		value = avatarScreen.AvatarExperienceRoot
	}, {
		SwitchNavigatorVisibleProvider = Roact.createElement(module6.Provider, {
			value = not androidBackButtonHandlerDisabled
		}, {
			NavigationAppContainer = Roact.createElement(props.navigationAppContainer, {
				onNavigationStateChange = props.onNavigationStateChange,
				renderAndroidBackButtonNavigationHandler = props.renderAndroidBackButtonNavigationHandler(androidBackButtonHandlerDisabled),
				params = props.props.params
			})
		})
	})
end

local function mapStateToProps(p2, p3)
	local v5

	if fFlagUseNavigationSelectors then
		v5 = selectors.selectCurrentLegacyPage(p2)
	else
		local v6 = p2.Navigation.history[#p2.Navigation.history]
		v5 = v6[#v6]
	end

	return {
		currentAppPageName = if v5 then v5.name or nil else nil,
		currentAppPageDetail = v5 and v5.detail or nil
	}
end

local function mapDispatchToProps(callback)
	return {
		unlockNavigation = function()
			if not fFlagSignalsNavP3gAvatarExperience then
				callback(module3(false))
			end
		end
	}
end

local connect = RoactRodux.connect

if fFlagSignalsNavP3gAvatarExperience then
	mapStateToProps = nil
end

local v5 = connect(mapStateToProps, mapDispatchToProps)(extended)
local v6

if fFlagSignalsNavP3gAvatarExperience then
	local function AvatarExperienceWrapperWithSignals(p2)
		local legacyNavigationStore = getLegacyNavigationStore(false)
		local v7 = useSignalState(legacyNavigationStore.getCurrentPageName)

		local v9 = useSignalState((React.useMemo(function()
			return createComputed(function(p3)
				local currentPage = legacyNavigationStore.getCurrentPage(p3)
				return currentPage and currentPage.detail or nil
			end)
		end, { legacyNavigationStore })))
		return React.createElement(
			v5,
			Cryo.Dictionary.union(p2, {
				currentAppPageName = v7,
				currentAppPageDetail = v9
			})
		)
	end

	v6 = React.memo(AvatarExperienceWrapperWithSignals)
else
	v6 = v5
end

return v6
