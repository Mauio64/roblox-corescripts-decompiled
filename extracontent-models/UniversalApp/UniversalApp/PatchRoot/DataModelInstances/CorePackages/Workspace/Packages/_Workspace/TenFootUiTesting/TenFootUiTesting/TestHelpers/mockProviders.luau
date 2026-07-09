local Parent = script:FindFirstAncestor("TenFootUiTesting").Parent
local Dash = require(Parent.Dash)
local React = require(Parent.React)
local RoactNavigation = require(Parent.RoactNavigation)
local RoactRodux = require(Parent.RoactRodux)
local Rodux = require(Parent.Rodux)
local UIBlox = require(Parent.UIBlox)
local RoactAppPolicy = require(Parent.UniversalAppPolicy).RoactAppPolicy
local AppFeaturePolicies = require(Parent.UniversalAppPolicy).AppFeaturePolicies
local t = require(Parent.t)
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Constants = UIBlox.App.Style.Constants
local Foundation = require(Parent.Foundation)
local MockContentProvider = UIBlox.UnitTestHelpers.MockContentProvider
local v15 = t.strictInterface({
	includeStoreProvider = t.optional(t.boolean),
	store = t.optional(t.table),
	topLevelReducer = t.optional(t.callback),
	initialStoreState = t.optional(t.table),
	includeStyleProvider = t.optional(t.boolean),
	includeFoundationProvider = t.optional(t.boolean),
	includeLocalizationProvider = t.optional(t.boolean),
	includeNavigationProvider = t.optional(t.boolean),
	includeAppPolicyProvider = t.optional(t.boolean),
	includeFocusControllerProvider = t.optional(t.boolean),
	middlewareList = t.optional(t.table),
	appStyle = t.optional(t.table),
	appPolicy = t.optional(t.table),
	policyFactory = t.optional(t.union(t.callback, t.table)),
	focusController = t.optional(t.table),
	captureFocusOnMount = t.optional(t.boolean),
	includeContentProvider = t.optional(t.boolean),
	localization = t.optional(t.table),
	navigation = t.optional(t.table)
})

local function getDefaultArgs() -- line: 42
	-- upvalues: Constants (copy)
	return {
		includeStoreProvider = false,
		store = nil,
		topLevelReducer = nil,
		initialStoreState = nil,
		includeStyleProvider = true,
		includeFoundationProvider = false,
		includeLocalizationProvider = true,
		includeNavigationProvider = false,
		includeAppPolicyProvider = true,
		includeFocusControllerProvider = false,
		focusController = nil,
		captureFocusOnMount = false,
		includeContentProvider = false,
		middlewareList = nil,
		policyFactory = nil,
		appPolicy = nil,
		appStyle = {
			themeName = Constants.ThemeName.Dark,
			fontName = Constants.FontName.Gotham
		},
		localization = {},
		navigation = {
			isFocused = function() -- line: 66
				return false
			end,
			addListener = function() -- line: 69
				return {
					remove = function() -- line: 71
					end
				}
			end,
			getParam = function() -- line: 74
				return nil
			end,
			navigate = function() -- line: 77
			end,
			state = {
				routeName = "DummyRoute"
			}
		}
	}
end

assert(v15((getDefaultArgs())))

local function staticReducer(p1) -- line: 88
	return p1
end
local function mockProviders(p2, p3) -- line: 99
	-- upvalues: getDefaultArgs (copy), v15 (copy), Dash (copy), Rodux (copy), staticReducer (copy), React (copy), RoactRodux (copy), RoactAppPolicy (copy), AppFeaturePolicies (copy), AppStyleProvider (copy), Foundation (copy), Constants (copy), RoactNavigation (copy), UIBlox (copy), MockContentProvider (copy)
	assert(p2, "Expected a map of components, received none")

	local v22 = getDefaultArgs()

	if p3 then
		assert(v15(p3))
		v22 = Dash.join(v22, p3)
	end

	if v22.includeStoreProvider then
		local t1 = { Rodux.thunkMiddleware }

		if v22.middlewareList then
			Dash.append(t1, v22.middlewareList)
		end

		local v24 = v22.topLevelReducer or staticReducer
		local v25 = if not v22.store then if not v22.initialStoreState then Rodux.Store.new(v24, nil, t1) else Rodux.Store.new(v24, v22.initialStoreState, t1) else v22.store

		p2 = {
			StoreProvider = React.createElement(RoactRodux.StoreProvider, {
				store = v25
			}, p2)
		}
	end

	if v22.includeAppPolicyProvider then
		p2 = {
			PolicyProvider = React.createElement(RoactAppPolicy.Provider, {
				policy = {
					AppFeaturePolicies,
					v22.policyFactory or function() -- line: 137
						return {}
					end
				},
				policyData = v22.appPolicy
			}, p2)
		}
	end

	if v22.includeStyleProvider then
		p2 = {
			StyleProvider = React.createElement(AppStyleProvider, {
				style = v22.appStyle
			}, p2)
		}
	end

	if v22.includeFoundationProvider or v22.includeStyleProvider then
		p2 = {
			FoundationProvider = React.createElement(Foundation.FoundationProvider, {
				theme = if v22.appStyle.themeName ~= Constants.ThemeName.Dark then Foundation.Enums.Theme.Light else Foundation.Enums.Theme.Dark,
				device = Foundation.Enums.Device.Desktop
			}, p2)
		}
	end

	if v22.includeNavigationProvider then
		p2 = {
			NavigationProvider = React.createElement(RoactNavigation.Provider, {
				value = v22.navigation
			}, p2)
		}
	end

	local v26 = React.createElement("Folder", {}, p2)

	if v22.includeContentProvider then
		v26 = React.createElement(UIBlox.App.Context.ContentProvider.Provider, {
			value = MockContentProvider.new()
		}, v26)
	end

	return v26
end

return mockProviders
