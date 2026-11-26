local HttpService = game:GetService("HttpService")

local LocalizationService = game:GetService("LocalizationService")
local IXPService = game:GetService("IXPService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/React")
local styleProviderWithDefaultTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/Style").StyleProviderWithDefaultTheme
local openWebview = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/InExperienceContainer/Http/openWebview")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/RoactRodux")
local fetchingStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/Http").Reducers.FetchingStatus
local roactAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/RoactServiceTags").RoactAnalytics
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/RoactServiceTags").RoactNetworking
local appLinking = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/RoactServiceTags").AppLinking
local linkingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/LinkingProtocol").LinkingProtocol
local analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/Analytics").Analytics
local requestInternalWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/Http").NetworkLayers.requestInternalWrapper
local roactServices = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/RoactServices").RoactServices
local providerContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/RoactUtils").Components.ProviderContainer
local useSelectedTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/RoactUtils").Hooks.useSelectedTheme
local RoactAppExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/RoactAppExperiment")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/UniversalAppPolicy").RoactAppPolicy
local appFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/UniversalAppPolicy").AppFeaturePolicies
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/RobloxAppLocales").Localization
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/Localization").LocalizationProvider
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/UIBlox")
local selectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local cursorProvider = UIBlox.App.SelectionCursor.CursorProvider
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/Rodux")
local countryCodeList = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/AuthCommon").Reducers.CountryCodeList
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/Cryo")

local getFFlagInExperienceContainerScreenSizeReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/SharedFlags").GetFFlagInExperienceContainerScreenSizeReducer
local v5 = if getFFlagInExperienceContainerScreenSizeReducer() then require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/InExperienceContainer/Actions/SetScreenSize") else nil

local getFFlagInExperienceContainerAppLinking = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/SharedFlags").GetFFlagInExperienceContainerAppLinking

local getFFlagInExperienceContainerRespectUserTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/SharedFlags").GetFFlagInExperienceContainerRespectUserTheme
local fFlagUseSignalsForCountryCodeList = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceContainer/SharedFlags").FFlagUseSignalsForCountryCodeList

local v6 = { reducer = {} }

local function InExperienceProviderContainer(p2)
	local v7 = useSelectedTheme()
	local union = Cryo.Dictionary.union(v6, p2)
	local only = React.Children.only(union.children)

	local v8 = { Rodux.thunkMiddleware }

	local new = Rodux.Store.new
	local combineReducers = Rodux.combineReducers
	local join = Cryo.Dictionary.join
	local v9 = {
		CountryCodeList = if not fFlagUseSignalsForCountryCodeList then countryCodeList else nil,
		FetchingStatus = fetchingStatus,
		ScreenSize = 0
	}
	local v11

	if getFFlagInExperienceContainerScreenSizeReducer() then
		v11 = Rodux.createReducer(Vector2.new(400, 400), {
			[v5.name] = function(p3, p4)
				return p4.screenSize
			end
		})
	else
		v11 = function(p3, p4)
			return Vector2.new(400, 400)
		end
	end

	v9.ScreenSize = v11
	local v12 = new(combineReducers(join(v9, union.reducer)), nil, v8)

	local v13 = {}

	table.insert(v13, {
		class = styleProviderWithDefaultTheme,
		props = {
			withDarkTheme = not getFFlagInExperienceContainerRespectUserTheme() or v7 ~= "light"
		}
	})

	table.insert(v13, {
		class = RoactRodux.StoreProvider,
		props = { store = v12 }
	})

	table.insert(v13, {
		class = localizationProvider,
		props = {
			localization = localization.new(LocalizationService.RobloxLocaleId)
		}
	})

	table.insert(v13, {
		class = RoactAppExperiment.Provider,
		props = { value = IXPService }
	})

	table.insert(v13, {
		class = roactAppPolicy.Provider,
		props = {
			policy = { appFeaturePolicies }
		}
	})

	local v14 = { class = roactServices.ServiceProvider, props = 0 }

	local v16 = {
		[roactAnalytics] = analytics.new(),
		[roactNetworking] = requestInternalWrapper(HttpService)
	}
	local v18 = if getFFlagInExperienceContainerAppLinking() then linkingProtocol.default else nil
	v16[appLinking] = v18
	v14.props = { services = v16 }
	table.insert(v13, v14)

	table.insert(v13, { class = selectionCursorProvider })

	table.insert(v13, { class = cursorProvider })

	return React.createElement(providerContainer, { providers = v13 }, {
		Child = React.cloneElement(only, { showWebpage = openWebview })
	})
end

return InExperienceProviderContainer
