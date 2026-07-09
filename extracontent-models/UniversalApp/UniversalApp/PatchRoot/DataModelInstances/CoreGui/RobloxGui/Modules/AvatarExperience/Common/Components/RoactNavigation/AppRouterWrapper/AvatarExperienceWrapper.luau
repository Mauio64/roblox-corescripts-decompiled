local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local Container = require(Modules.LuaApp.Navigation.AndroidBackButtonNavigationHandler.Container)
local isRootRouteInRN = require(Modules.LuaApp.Navigation.isRootRouteInRN)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local t = require(CorePackages.Packages.t)
local ApplySetNavigationLocked = require(Modules.LuaApp.Actions.ApplySetNavigationLocked)
local AppPage = require(Modules.LuaApp.AppPage)
local CurrentTabContext = require(Modules.LuaApp.Navigation.CurrentTabContext)
local SwitchNavigatorVisibleContext = require(Modules.LuaApp.Navigation.SwitchNavigatorVisibleContext)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local makeNavigationStateLogger = require(Modules.AvatarExperience.Common.Components.RoactNavigation.Debug.makeNavigationStateLogger)
local makeAppRouterRootContainer = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AppRouterWrapper.makeAppRouterRootContainer)
local FFlagAXFixTryOnItemVR = AvatarExperienceFlags.FFlagAXFixTryOnItemVR
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagSignalsNavP3gAvatarExperience = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3gAvatarExperience
local Cryo = require(CorePackages.Packages.Cryo)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v25 = if not FFlagSignalsNavP3gAvatarExperience then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local v26 = Roact.Component:extend("AvatarExperienceWrapper")

v26.validateProps = t.strictInterface({
	routeName = t.string,
	params = t.interface({
		detail = t.string
	}),
	currentAppPageName = t.optional(t.string),
	currentAppPageDetail = t.optional(t.string),
	unlockNavigation = t.callback
})

function v26.init(p1) -- line: 68
	-- upvalues: makeAppRouterRootContainer (copy), RoactNavigation (copy), memoize (copy), AppPage (copy), Roact (copy), Container (copy), isRootRouteInRN (copy), makeNavigationStateLogger (copy)
	local routeName = p1.props.routeName
	local v33 = makeAppRouterRootContainer(routeName)

	p1.navigationAppContainer = RoactNavigation.createAppContainer(v33, nil)
	p1.isAndroidBackButtonHandlerDisabled = memoize(function(s1: string?, s2: string?, s3: string) -- line: 74
		-- upvalues: AppPage (copy)
		return not ((s1 == AppPage.AvatarExperienceWrapper or s1 == AppPage.AvatarExperienceWrapperTransparent) and s2 == s3)
	end)
	p1.renderAndroidBackButtonNavigationHandler = memoize(function(b1: boolean) -- line: 87
		-- upvalues: Roact (copy), Container (copy), isRootRouteInRN (copy)
		return function(p2) -- line: 88
			-- upvalues: Roact (copy), Container (copy), isRootRouteInRN (copy), b1 (copy)
			return Roact.createElement(Container, {
				canGoBackInRN = not isRootRouteInRN(p2.state),
				navigateBackInRN = p2.pop,
				disabled = b1
			})
		end
	end)

	local v34 = makeNavigationStateLogger("AvatarExperienceWrapper:" .. p1.props.routeName)

	function p1.onNavigationStateChange(p3, p4, p5) -- line: 100
		-- upvalues: v34 (copy), p1 (copy)
		v34(p3, p4, p5)

		if not p4.isTransitioning then
			p1.props.unlockNavigation()
		end
	end
end
function v26.render(p6) -- line: 111
	-- upvalues: FFlagAXFixTryOnItemVR (copy), Roact (copy), CurrentTabContext (copy), AvatarScreen (copy), SwitchNavigatorVisibleContext (copy)
	local v36 = p6.isAndroidBackButtonHandlerDisabled(p6.props.currentAppPageName, p6.props.currentAppPageDetail, p6.props.params and p6.props.params.detail or nil)

	if FFlagAXFixTryOnItemVR then
		return Roact.createElement(CurrentTabContext.Provider, {
			value = AvatarScreen.AvatarExperienceRoot
		}, {
			SwitchNavigatorVisibleProvider = Roact.createElement(SwitchNavigatorVisibleContext.Provider, {
				value = not v36
			}, {
				NavigationAppContainer = Roact.createElement(p6.navigationAppContainer, {
					onNavigationStateChange = p6.onNavigationStateChange,
					renderAndroidBackButtonNavigationHandler = p6.renderAndroidBackButtonNavigationHandler(v36),
					params = p6.props.params
				})
			})
		})
	end

	return Roact.createElement(p6.navigationAppContainer, {
		onNavigationStateChange = p6.onNavigationStateChange,
		renderAndroidBackButtonNavigationHandler = p6.renderAndroidBackButtonNavigationHandler(v36),
		params = p6.props.params
	})
end

local function mapStateToProps(p7, _) -- line: 145
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
	local v39

	if FFlagUseNavigationSelectors then
		v39 = Selectors.selectCurrentLegacyPage(p7)
	else
		local v40 = p7.Navigation.history[#p7.Navigation.history]

		v39 = v40[#v40]
	end

	local v41 = v39 and v39.name or nil
	local v42 = v39 and v39.detail or nil

	return {
		currentAppPageName = v41,
		currentAppPageDetail = v42
	}
end
local function mapDispatchToProps(p9) -- line: 162
	-- upvalues: ApplySetNavigationLocked (copy)
	return {
		unlockNavigation = function() -- line: 164
			-- upvalues: p9 (copy), ApplySetNavigationLocked (copy)
			p9(ApplySetNavigationLocked(false))
		end
	}
end

local v29 = RoactRodux.connect((if not FFlagSignalsNavP3gAvatarExperience then mapStateToProps else nil), mapDispatchToProps)(v26)

if FFlagSignalsNavP3gAvatarExperience then
	local v30 = v29

	function v29(p10) -- line: 177
		-- upvalues: v25 (copy), useSignalState (copy), React (copy), v30 (copy), Cryo (copy)
		local v45 = v25(false)
		local v46 = useSignalState(v45.getCurrentPage)
		local v47 = v46 and v46.name or nil
		local v48 = v46 and v46.detail or nil

		return React.createElement(v30, Cryo.Dictionary.union(p10, {
			currentAppPageName = v47,
			currentAppPageDetail = v48
		}))
	end
end

return v29
