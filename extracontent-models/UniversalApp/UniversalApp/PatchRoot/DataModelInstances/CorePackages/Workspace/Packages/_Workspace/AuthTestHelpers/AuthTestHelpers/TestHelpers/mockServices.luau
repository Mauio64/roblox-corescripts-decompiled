local Parent = script:FindFirstAncestor("AuthTestHelpers").Parent
local t = require(Parent.t)
local React = require(Parent.React)
local RoactServices = require(Parent.RoactServices).RoactServices
local RoactRodux = require(Parent.RoactRodux)
local Rodux = require(Parent.Rodux)
local UIBlox = require(Parent.UIBlox)
local DesignTokenProvider = require(Parent.Style).DesignTokenProvider
local AppStyleProvider = require(Parent.Style).AppStyleProvider
local Provider = require(Parent.RoactAppExperiment).Provider
local FocusControllerProvider = require(Parent.UnitTestHelpers).FocusControllerProvider
local Localization = require(Parent.RobloxAppLocales).Localization
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local MockIXPService = require(Parent.RoactAppExperiment).MockIXPService
local Constants = require(Parent.Style).Constants
local Cryo = require(Parent.Cryo)
local FetchingStatus = require(Parent.Http).Reducers.FetchingStatus
local mockHttpResponse = require(Parent.UnitTestHelpers).mockHttpResponse
local StatusCodes = require(Parent.Http).StatusCodes
local Promise = require(Parent.Promise)
local Foundation = require(Parent.Foundation)
local RoactNetworking = require(Parent.RoactServiceTags).RoactNetworking
local RoactAnalytics = require(Parent.RoactServiceTags).RoactAnalytics
local RoactAppPolicy = require(Parent.UniversalAppPolicy).RoactAppPolicy
local AppFeaturePolicies = require(Parent.UniversalAppPolicy).AppFeaturePolicies
local Analytics = require(Parent.Analytics).Analytics
local v27 = t.strictInterface({
	includeTopBarSearchSignalProvider = t.optional(t.boolean),
	includeIXPServiceProvider = t.optional(t.boolean),
	includeABTestServiceProvider = t.optional(t.boolean),
	browserTrackerABTests = t.optional(t.table),
	userABTests = t.optional(t.table),
	browserTrackerLayers = t.optional(t.table),
	userLayers = t.optional(t.table),
	includeStoreProvider = t.optional(t.boolean),
	store = t.optional(t.table),
	initialStoreState = t.optional(t.table),
	includeAppGridProvider = t.optional(t.boolean),
	includeStyleProvider = t.optional(t.boolean),
	includeDesignTokenProvider = t.optional(t.boolean),
	tokenMappers = t.optional(t.table),
	includeThemeProvider = t.optional(t.boolean),
	includeAppPolicyProvider = t.optional(t.boolean),
	includeLocalizationProvider = t.optional(t.boolean),
	includeNavigationProvider = t.optional(t.boolean),
	includeFocusControllerProvider = t.optional(t.boolean),
	includeApolloProvider = t.optional(t.boolean),
	includeCursorProvider = t.optional(t.boolean),
	includeRootRNAppContainer = t.optional(t.boolean),
	middlewareList = t.optional(t.table),
	focusController = t.optional(t.table),
	captureFocusOnMount = t.optional(t.boolean),
	includeContentProvider = t.optional(t.boolean),
	includeFoundationProvider = t.optional(t.boolean),
	foundationOverlayGui = t.optional(t.any),
	theme = t.optional(t.table),
	appPolicy = t.optional(t.table),
	themeName = t.optional(t.string),
	appStyle = t.optional(t.table),
	appGridConfig = t.optional(t.table),
	localization = t.optional(t.table),
	navigation = t.optional(t.table),
	extraServices = t.optional(t.map(t.table, t.any)),
	apolloClient = t.optional(t.table)
})

local function v28() -- line: 76
	-- upvalues: Constants (copy), Localization (copy)
	return {
		includeTopBarSearchSignalProvider = false,
		includeABTestServiceProvider = false,
		includeIXPServiceProvider = true,
		browserTrackerABTests = {},
		userABTests = {},
		browserTrackerLayers = {},
		userLayers = {},
		includeStoreProvider = false,
		store = {},
		initialStoreState = nil,
		includeStyleProvider = true,
		includeAppGridProvider = false,
		includeDesignTokenProvider = false,
		tokenMappers = {},
		includeThemeProvider = true,
		includeAppPolicyProvider = false,
		includeLocalizationProvider = true,
		includeNavigationProvider = true,
		includeFocusControllerProvider = false,
		includeApolloProvider = false,
		includeCursorProvider = false,
		includeRootRNAppContainer = false,
		apolloClient = nil,
		focusController = nil,
		captureFocusOnMount = false,
		includeContentProvider = true,
		includeFoundationProvider = false,
		foundationOverlayGui = nil,
		middlewareList = nil,
		appPolicy = {},
		appStyle = {
			deviceType = "Desktop",
			themeName = Constants.ThemeName.Dark,
			fontName = Constants.FontName.Gotham
		},
		appGridConfig = nil,
		localization = Localization.new("en-us"),
		navigation = {
			isFocused = function() -- line: 116
				return false
			end,
			addListener = function() -- line: 119
				return {
					remove = function() -- line: 121
					end
				}
			end,
			getParam = function(_, p2) -- line: 124
				return p2
			end,
			navigate = function() -- line: 127
			end,
			state = {
				routeName = "DummyRoute"
			}
		},
		extraServices = nil
	}
end
local function simpleSuccessRequest(p3) -- line: 136
	-- upvalues: Promise (copy), mockHttpResponse (copy), StatusCodes (copy)
	assert(p3 ~= nil, "Expected responseBody not to be nil")

	return function(p4, _) -- line: 140
		-- upvalues: Promise (copy), mockHttpResponse (copy), p3 (copy), StatusCodes (copy)
		return Promise.resolve(mockHttpResponse.new(p4, p3, 0, StatusCodes.OK))
	end
end

return function(p6, p7) -- line: 146
	-- upvalues: v28 (copy), v27 (copy), Cryo (copy), RoactNetworking (copy), Promise (copy), mockHttpResponse (copy), StatusCodes (copy), RoactAnalytics (copy), Analytics (copy), React (copy), DesignTokenProvider (copy), Rodux (copy), FetchingStatus (copy), RoactRodux (copy), AppStyleProvider (copy), UIBlox (copy), Provider (copy), MockIXPService (copy), FocusControllerProvider (copy), LocalizationProvider (copy), RoactAppPolicy (copy), AppFeaturePolicies (copy), Foundation (copy), RoactServices (copy)
	local v33 = v28()

	if p7 then
		assert(v27(p7))
		v33 = Cryo.Dictionary.join(v33, p7)
	end

	local store = v33.store
	local t1 = {}
	local t2 = {}
	local v37 = RoactNetworking
	local t3 = {}

	assert(t3 ~= nil, "Expected responseBody not to be nil")
	t2[v37] = function(p8, _) -- line: 140
		-- upvalues: Promise (copy), mockHttpResponse (copy), t3 (copy), StatusCodes (copy)
		return Promise.resolve(mockHttpResponse.new(p8, t3, 0, StatusCodes.OK))
	end
	t2[RoactAnalytics] = Analytics.mock()
	t1.services = t2

	if v33.extraServices ~= nil then
		for k, v in pairs(v33.extraServices) do
			assert(type(k) == "table", "Expected key to be a table")
			t1.services[k] = v
		end
	end

	local t4 = {
		DesignTokenProvider = React.createElement(DesignTokenProvider, {
			tokenMappers = v33.tokenMappers
		}, p6)
	}
	local t5 = { Rodux.thunkMiddleware }
	local v43 = Rodux.combineReducers({
		FetchingStatus = FetchingStatus,
		ScreenSize = function(p10, p11) -- line: 180
			local v53 = p10 or Vector2.new(0, 0)

			assert(v53, "")

			if p11.type == "SetScreenSize" then
				return p11.screenSize
			end

			return v53
		end,
		CountryCodeList = function(p12, p13) -- line: 190
			local v56 = p12 or {}

			if p13.type == "SetCountryCodeList" then
				return p13.countryCodeList
			end

			return v56
		end
	})

	local function v44(p14, p15) -- line: 199
		-- upvalues: v43 (copy)
		return v43(p14, p15)
	end

	if v33.initialStoreState then
		store = Rodux.Store.new(v44, v33.initialStoreState, t5)
	elseif store then
		if getmetatable(store) == nil then
			store = Rodux.Store.new(v44, store, t5)
		end
	else
		store = Rodux.Store.new(v44, nil, t5)
	end

	if v33.includeStoreProvider then
		t4 = {
			StoreProvider = React.createElement(RoactRodux.StoreProvider, {
				store = store
			}, t4)
		}
	end

	if v33.includeStyleProvider then
		t4 = {
			StyleProvider = React.createElement(AppStyleProvider, {
				style = v33.appStyle
			}, t4)
		}
	end

	if v33.includeCursorProvider then
		assert(v33.includeStyleProvider, "includeStyleProvider must be set to `true` in order to include CursorProvider")
		t4 = {
			CursorProvider = React.createElement(UIBlox.App.SelectionCursor.CursorProvider, {}, t4)
		}
	end

	if v33.includeIXPServiceProvider then
		t4 = {
			IXPServiceProvider = React.createElement(Provider, {
				value = MockIXPService.new(v33.browserTrackerLayers, v33.userLayers, true)
			}, t4)
		}
	end

	if v33.includeFocusControllerProvider then
		t4 = {
			FocusControllerProvider = React.createElement(FocusControllerProvider, {
				captureFocusOnMount = v33.captureFocusOnMount,
				focusController = v33.focusController
			}, t4)
		}
	end

	if v33.includeThemeProvider then
		t4 = {
			ThemeProvider = React.createElement(UIBlox.Style.Provider, {}, t4)
		}
	end

	if v33.includeLocalizationProvider then
		t4 = {
			LocalizationProvider = React.createElement(LocalizationProvider, {
				localization = v33.localization
			}, t4)
		}
	end

	if v33.includeAppPolicyProvider then
		t4 = {
			AppPolicyProvider = React.createElement(RoactAppPolicy.Provider, {
				policy = { AppFeaturePolicies },
				policyData = v33.appPolicy
			}, t4)
		}
	end

	if v33.includeFoundationProvider or v33.includeStyleProvider then
		t4 = {
			FoundationProvider = React.createElement(Foundation.FoundationProvider, {
				device = "Phone",
				theme = "Dark",
				overlayGui = v33.foundationOverlayGui
			}, t4)
		}
	end

	return (React.createElement(RoactServices.ServiceProvider, t1, t4))
end
