local Parent = script:FindFirstAncestor("TenFootUiTesting").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local Style = require(Parent.Style)
local UIBlox = require(Parent.UIBlox)
local AppNotificationService = require(Parent.RoactServiceTags).AppNotificationService
local AppLogging = require(Parent.RoactServiceTags).AppLogging
local AppCommonLib = require(Parent.AppCommonLib)
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local RoactServices = require(Parent.RoactServices)
local JestGlobals = require(Parent.Dev.JestGlobals)
local mockProviders = require(script.Parent.mockProviders)
local TenFootUiContext = require(Parent.TenFootUiCommon).TenFootUiContext

require(Parent.TenFootUiCommon)

local LoginStatus = require(Parent.RobloxAppEnums).LoginStatus
local AppPage = require(Parent.RobloxAppEnums).AppPage
local SwitchTab = require(Parent.RobloxAppEnums).SwitchTab
local Constants = UIBlox.App.Style.Constants
local Images = UIBlox.App.ImageSet.Images
local RoactNavigation = require(Parent.RoactNavigation)
local NavigationRodux = require(Parent.NavigationRodux)
local createMockNavigationObject = require(Parent.Navigation).TestUtils.createMockNavigationObject
local jest = JestGlobals.jest
local Signal = AppCommonLib.Signal
local DesignTokenProvider = Style.DesignTokenProvider
local t1 = {
	AuthenticationStatus = {
		status = LoginStatus.LOGGED_IN
	},
	Startup = {
		Preloading = false
	},
	CrossPlaySettings = {
		LuaError = nil,
		HttpError = nil,
		SystemError = nil,
		Status = {
			isEnabled = true,
			isSystemPrivilegeEnabled = true
		},
		SystemPrivileges = {},
		NetworkStatus = {}
	}
}
local t2 = {
	tabs = {
		{
			titleLocalizationKey = "CommonUI.Features.Label.Home",
			actionType = nil,
			page = SwitchTab.HomeTab,
			iconImage = Images["icons/menu/home_on"]
		},
		{
			titleLocalizationKey = "CommonUI.Features.Label.Discover",
			page = SwitchTab.GamesTab,
			iconImage = Images["icons/menu/games_on"],
			actionType = Enum.AppShellActionType.TapGamePageTab
		},
		{
			titleLocalizationKey = "CommonUI.Features.Label.Avatar",
			page = SwitchTab.AvatarExperienceTab,
			iconComponent = function() -- line: 75
				-- upvalues: React (copy)
				return React.createElement("Frame")
			end,
			actionType = Enum.AppShellActionType.TapAvatarTab
		}
	},
	options = {
		{
			titleLocalizationKey = "Feature.Catalog.Label.Search",
			icon = "icons/common/search",
			actionType = nil,
			page = AppPage.SearchPage
		},
		{
			titleLocalizationKey = "Feature.Home.Robux",
			icon = "icons/common/goldrobux",
			actionType = nil,
			page = AppPage.PurchaseRobux
		}
	}
}

local function createDummyStackNavigator(p1) -- line: 97
	-- upvalues: RoactNavigation (copy)
	return RoactNavigation.createNavigator(RoactNavigation.RobloxSwitchView, RoactNavigation.StackRouter(p1), {})
end
local function makeTenFootUiContextMocks(p2, t3: {[any]: any}) -- line: 105
	-- upvalues: Signal (copy), jest (copy), AppNotificationService (copy), RoactNavigation (copy)
	local t4 = {
		ReloadPage = Signal.new(),
		ReportMutedError = Signal.new()
	}

	t4.ReloadPage.fire = jest.fn()
	t4.ReportMutedError.fire = jest.fn()

	local v37 = newproxy(true)
	local t5 = {
		EventStream = {}
	}
	local t6 = {
		[AppNotificationService] = t3,
		[v37] = t5
	}
	local v40 = jest.fn().mockImplementation(function(p3) -- line: 121
		-- upvalues: t6 (copy)
		return t6[p3]
	end)
	local t7 = {
		LuaAppEvents = t4,
		RoactAnalytics = v37,
		buttonClick = jest.fn(),
		globalNavConfig = p2,
		useRoactService = v40
	}
	local t8 = {{
		Foo = function() -- line: 132
			return nil
		end
	}}

	t7.RootNavigator = RoactNavigation.createNavigator(RoactNavigation.RobloxSwitchView, RoactNavigation.StackRouter(t8), {})

	return t7
end
local function makeMockNotificationService() -- line: 140
	-- upvalues: jest (copy)
	return {
		ActionTaken = jest.fn()
	}
end
local function makeMockLoggingService() -- line: 144
	-- upvalues: jest (copy)
	return {
		logEventWithTimestamp = jest.fn(),
		logEvent = jest.fn(),
		logEventOnce = jest.fn(),
		getTimestamp = jest.fn(),
		logRobloxTelemetryEvent = jest.fn(),
		logRobloxTelemetryCounter = jest.fn(),
		logEphemeralCounterEvent = jest.fn(),
		logEphemeralStatEvent = jest.fn()
	}
end
local function makeMockNavigation(t9: {[any]: any}?) -- line: 168
	-- upvalues: AppPage (copy), SwitchTab (copy), Cryo (copy), NavigationRodux (copy), jest (copy)
	local v45 = t9 or {}
	local t10 = {
		{
			key = "Landing",
			routeName = AppPage.Landing
		},
		{
			key = "Startup",
			routeName = AppPage.Startup
		},
		{
			key = "Home",
			routeName = SwitchTab.HomeTab
		},
		{
			key = "Games",
			routeName = SwitchTab.GamesTab
		},
		{
			key = "AvatarExperienceRoot",
			routeName = SwitchTab.AvatarExperienceTab
		},
		{
			key = "SearchPage",
			routeName = AppPage.SearchPage
		},
		{
			key = "PurchaseRobux",
			routeName = AppPage.PurchaseRobux
		}
	}
	local t11 = {
		state = Cryo.Dictionary.join({
			index = 1,
			routes = t10,
			routeName = NavigationRodux.Constants.TempRnSwitchNavigatorName
		}, v45),
		isFocused = jest.fn().mockReturnValue(false),
		addListener = jest.fn().mockImplementation(function() -- line: 188
			-- upvalues: jest (copy)
			return {
				remove = jest.fn()
			}
		end),
		dispatch = jest.fn(),
		getParam = jest.fn()
	}

	t11.navigate = jest.fn().mockImplementation(function(s1: string) -- line: 195
		-- upvalues: Cryo (copy), t11 (copy)
		local v72 = Cryo.List.findWhere(t11.state.routes, function(p4) -- line: 196
			-- upvalues: s1 (copy)
			return p4.routeName == s1
		end)

		if v72 ~= nil then
			t11.state = Cryo.Dictionary.join(t11.state, {
				index = v72
			})

			return
		end

		error("No navigated route [" .. s1 .. "] has been mocked")
	end)
	t11.getChildNavigation = jest.fn()
	t11.router = {
		getScreenOptions = jest.fn()
	}

	return t11
end

local t12 = {}

t12.__index = t12

function t12.new(s2: string) -- line: 230
	-- upvalues: Signal (copy), t12 (copy)
	local t13 = {
		locale = s2,
		changed = Signal.new()
	}

	setmetatable(t13, t12)

	return t13
end
function t12.SetLocale(t14: {[any]: any}, s3: string) -- line: 239
	if s3 ~= t14.locale then
		t14.locale = s3
		t14.changed:fire()
	end
end
function t12.GetLocale(p5) -- line: 246
	return p5.locale
end
function t12.Format(_: {[any]: any}, s4: string, _: {[any]: any}?) -- line: 250
	return "Localized:" .. s4
end
function makeMockLocalization() -- line: 254
	-- upvalues: t12 (copy)
	return t12.new("en-us")
end

return {
	makeMockGlobalNavConfig = function(p6) -- line: 157
		-- upvalues: t2 (copy)
		return p6 or t2
	end,
	makeMockProviders = function(t17: {[any]: any}?) -- line: 270
		-- upvalues: t2 (copy), jest (copy), makeMockLoggingService (copy), makeMockNavigation (copy), makeTenFootUiContextMocks (copy), mockProviders (copy), Constants (copy), React (copy), DesignTokenProvider (copy), LocalizationProvider (copy), TenFootUiContext (copy), RoactServices (copy), AppLogging (copy)
		local u57 = t17 or {}

		assert(u57, "Config must not be nil")

		local v58 = makeMockLocalization()
		local v59 = u57.globalNavConfig or t2
		local t18 = {
			ActionTaken = jest.fn()
		}
		local v61 = makeMockLoggingService()
		local v62 = makeMockNavigation(u57.navigationState)
		local v63 = makeTenFootUiContextMocks(v59, t18)

		return {
			function(p7) -- line: 282
				-- upvalues: mockProviders (copy), u57 (ref), v62 (copy), Constants (copy)
				return mockProviders(p7.children, {
					includeStoreProvider = true,
					includeStyleProvider = true,
					includeNavigationProvider = true,
					includeAppPolicyProvider = true,
					store = u57.store,
					initialStoreState = u57.initialStoreState or {},
					navigation = v62,
					appStyle = {
						deviceType = "Console",
						themeName = Constants.ThemeName.Dark,
						fontName = Constants.FontName.Gotham
					},
					policyFactory = u57.policyFactory,
					appPolicy = u57.appPolicy
				})
			end,
			function(p8) -- line: 300
				-- upvalues: React (copy), DesignTokenProvider (copy), u57 (ref)
				return React.createElement(DesignTokenProvider, {
					tokenMappers = u57.tokenMappers or {},
					uiModeInfo = {
						deviceType = "Console",
						uiMode = "TenFoot"
					}
				}, p8.children)
			end,
			function(p9) -- line: 309
				-- upvalues: React (copy), LocalizationProvider (copy), v58 (copy)
				return React.createElement(LocalizationProvider, {
					localization = v58
				}, p9.children)
			end,
			function(p10) -- line: 314
				-- upvalues: React (copy), TenFootUiContext (copy), u57 (ref), v63 (copy)
				return React.createElement(TenFootUiContext.Provider, {
					value = u57.tenFootUiContext or v63
				}, p10.children)
			end,
			function(p11) -- line: 323
				-- upvalues: React (copy), RoactServices (copy), AppLogging (copy), v61 (copy)
				return React.createElement(RoactServices.RoactServices.ServiceProvider, {
					services = {
						[AppLogging] = v61
					}
				}, p11.children)
			end
		}, {
			globalNavConfig = v59,
			mockNavigation = v62,
			mockTenFootUiContext = v63,
			mockNotificationService = t18,
			mockLogging = v61
		}
	end,
	makeMockDescriptor = function(s5: string, p12, p13) -- line: 343
		-- upvalues: React (copy), createMockNavigationObject (copy)
		local navigation = nil
		local screenProps = nil
		local v69 = React.Component:extend("TestComponent")

		function v69.render(p14) -- line: 346
			-- upvalues: navigation (ref), screenProps (ref)
			navigation = p14.props.navigation
			screenProps = p14.props.screenProps

			return nil
		end

		return {
			getComponent = function() -- line: 352
				-- upvalues: v69 (copy)
				return v69
			end,
			key = s5,
			options = {
				screenKind = p13
			},
			navigation = createMockNavigationObject(p12),
			state = p12
		}, navigation, screenProps
	end,
	makeMockLocalization = makeMockLocalization,
	makeTenFootUiContextMocks = makeTenFootUiContextMocks,
	mockCrossPlayState = t1
}
