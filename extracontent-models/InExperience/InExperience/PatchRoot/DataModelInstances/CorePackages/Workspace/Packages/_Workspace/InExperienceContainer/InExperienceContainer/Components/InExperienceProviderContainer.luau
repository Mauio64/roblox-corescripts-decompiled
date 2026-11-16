local HttpService = game:GetService("HttpService")
local InExperienceContainer = script:FindFirstAncestor("InExperienceContainer")
local LocalizationService = game:GetService("LocalizationService")
local IXPService = game:GetService("IXPService")
local parent = InExperienceContainer.Parent
local React = require(parent.React)
local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local openWebview = require(InExperienceContainer.Http.openWebview)
local RoactRodux = require(parent.RoactRodux)
local Http = require(parent.Http)
local FetchingStatus = Http.Reducers.FetchingStatus
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local RoactServiceTags2 = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags2.RoactNetworking
local RoactServiceTags3 = require(parent.RoactServiceTags)
local AppLinking = RoactServiceTags3.AppLinking
local LinkingProtocol = require(parent.LinkingProtocol)
local linkingProtocol = LinkingProtocol.LinkingProtocol
local Analytics = require(parent.Analytics)
local analytics = Analytics.Analytics
local Http2 = require(parent.Http)
local requestInternalWrapper = Http2.NetworkLayers.requestInternalWrapper
local RoactServices = require(parent.RoactServices)
local roactServices = RoactServices.RoactServices
local RoactUtils = require(parent.RoactUtils)
local ProviderContainer = RoactUtils.Components.ProviderContainer
local RoactUtils2 = require(parent.RoactUtils)
local useSelectedTheme = RoactUtils2.Hooks.useSelectedTheme
local RoactAppExperiment = require(parent.RoactAppExperiment)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy
local UniversalAppPolicy2 = require(parent.UniversalAppPolicy)
local AppFeaturePolicies = UniversalAppPolicy2.AppFeaturePolicies
local RobloxAppLocales = require(parent.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local UIBlox = require(parent.UIBlox)
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local CursorProvider = UIBlox.App.SelectionCursor.CursorProvider
local Rodux = require(parent.Rodux)
local AuthCommon = require(parent.AuthCommon)
local CountryCodeList = AuthCommon.Reducers.CountryCodeList
local Cryo = require(parent.Cryo)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagInExperienceContainerScreenSizeReducer = SharedFlags.GetFFlagInExperienceContainerScreenSizeReducer
local SetScreenSize

if GetFFlagInExperienceContainerScreenSizeReducer() then
	SetScreenSize = require(InExperienceContainer.Actions.SetScreenSize)
else
	SetScreenSize = nil
end

local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagInExperienceContainerAppLinking = SharedFlags2.GetFFlagInExperienceContainerAppLinking

local SharedFlags3 = require(parent.SharedFlags)
local GetFFlagInExperienceContainerRespectUserTheme = SharedFlags3.GetFFlagInExperienceContainerRespectUserTheme
local SharedFlags4 = require(parent.SharedFlags)
local FFlagUseSignalsForCountryCodeList = SharedFlags4.FFlagUseSignalsForCountryCodeList

local v = { reducer = {} }

local function InExperienceProviderContainer(p)
	local v2 = useSelectedTheme()
	local union = Cryo.Dictionary.union(v, p)
	local only = React.Children.only(union.children)

	local v3 = { Rodux.thunkMiddleware }

	local new = Rodux.Store.new
	local combineReducers = Rodux.combineReducers
	local join = Cryo.Dictionary.join
	local countryCodeList

	if not FFlagUseSignalsForCountryCodeList then
		countryCodeList = CountryCodeList
	end

	local v4 = {
		CountryCodeList = countryCodeList,
		FetchingStatus = FetchingStatus,
		ScreenSize = 0
	}
	local screenSize

	if GetFFlagInExperienceContainerScreenSizeReducer() then
		screenSize = Rodux.createReducer(Vector2.new(400, 400), {
			[SetScreenSize.name] = function(_, p2)
				return p2.screenSize
			end
		})
	else
		screenSize = function(_, _)
			return Vector2.new(400, 400)
		end
	end

	v4.ScreenSize = screenSize
	local store = new(combineReducers(join(v4, union.reducer)), nil, v3)

	local providers = {}

	table.insert(providers, {
		class = StyleProviderWithDefaultTheme,
		props = {
			withDarkTheme = not GetFFlagInExperienceContainerRespectUserTheme() or v2 ~= "light"
		}
	})

	table.insert(providers, {
		class = RoactRodux.StoreProvider,
		props = { store = store }
	})

	table.insert(providers, {
		class = LocalizationProvider,
		props = {
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		}
	})

	table.insert(providers, {
		class = RoactAppExperiment.Provider,
		props = { value = IXPService }
	})

	table.insert(providers, {
		class = RoactAppPolicy.Provider,
		props = {
			policy = { AppFeaturePolicies }
		}
	})

	local v5 = { class = roactServices.ServiceProvider, props = 0 }

	local services = {
		[RoactAnalytics] = analytics.new(),
		[RoactNetworking] = requestInternalWrapper(HttpService)
	}
	local v6

	if GetFFlagInExperienceContainerAppLinking() then
		v6 = linkingProtocol.default
	end

	services[AppLinking] = v6
	v5.props = { services = services }
	table.insert(providers, v5)

	table.insert(providers, { class = SelectionCursorProvider })

	table.insert(providers, { class = CursorProvider })

	return React.createElement(ProviderContainer, { providers = providers }, {
		Child = React.cloneElement(only, { showWebpage = openWebview })
	})
end

return InExperienceProviderContainer
