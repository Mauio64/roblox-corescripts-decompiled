local HttpService = game:GetService("HttpService")
local InExperienceContainer = script:FindFirstAncestor("InExperienceContainer")
local LocalizationService = game:GetService("LocalizationService")
local IXPService = game:GetService("IXPService")
local InExperienceContainerParent = InExperienceContainer.Parent
local React = require(InExperienceContainerParent.React)
local StyleProviderWithDefaultTheme = require(InExperienceContainerParent.Style).StyleProviderWithDefaultTheme
local openWebview = require(InExperienceContainer.Http.openWebview)
local RoactRodux = require(InExperienceContainerParent.RoactRodux)
local FetchingStatus = require(InExperienceContainerParent.Http).Reducers.FetchingStatus
local RoactAnalytics = require(InExperienceContainerParent.RoactServiceTags).RoactAnalytics
local RoactNetworking = require(InExperienceContainerParent.RoactServiceTags).RoactNetworking
local AppLinking = require(InExperienceContainerParent.RoactServiceTags).AppLinking
local LinkingProtocol = require(InExperienceContainerParent.LinkingProtocol).LinkingProtocol
local Analytics = require(InExperienceContainerParent.Analytics).Analytics
local requestInternalWrapper = require(InExperienceContainerParent.Http).NetworkLayers.requestInternalWrapper
local RoactServices = require(InExperienceContainerParent.RoactServices).RoactServices
local ProviderContainer = require(InExperienceContainerParent.RoactUtils).Components.ProviderContainer
local useSelectedTheme = require(InExperienceContainerParent.RoactUtils).Hooks.useSelectedTheme
local RoactAppExperiment = require(InExperienceContainerParent.RoactAppExperiment)
local RoactAppPolicy = require(InExperienceContainerParent.UniversalAppPolicy).RoactAppPolicy
local AppFeaturePolicies = require(InExperienceContainerParent.UniversalAppPolicy).AppFeaturePolicies
local Localization = require(InExperienceContainerParent.RobloxAppLocales).Localization
local LocalizationProvider = require(InExperienceContainerParent.Localization).LocalizationProvider
local UIBlox = require(InExperienceContainerParent.UIBlox)
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local CursorProvider = UIBlox.App.SelectionCursor.CursorProvider
local Rodux = require(InExperienceContainerParent.Rodux)
local CountryCodeList = require(InExperienceContainerParent.AuthCommon).Reducers.CountryCodeList
local Cryo = require(InExperienceContainerParent.Cryo)
local GetFFlagInExperienceContainerScreenSizeReducer = require(InExperienceContainerParent.SharedFlags).GetFFlagInExperienceContainerScreenSizeReducer
local v32 = if not GetFFlagInExperienceContainerScreenSizeReducer() then nil else require(InExperienceContainer.Actions.SetScreenSize)
local GetFFlagInExperienceContainerAppLinking = require(InExperienceContainerParent.SharedFlags).GetFFlagInExperienceContainerAppLinking
local GetFFlagInExperienceContainerRespectUserTheme = require(InExperienceContainerParent.SharedFlags).GetFFlagInExperienceContainerRespectUserTheme
local t1 = {
	reducer = {}
}

local function InExperienceProviderContainer(t2: {[any]: any}) -- line: 53
	-- upvalues: useSelectedTheme (copy), Cryo (copy), t1 (copy), React (copy), Rodux (copy), CountryCodeList (copy), FetchingStatus (copy), GetFFlagInExperienceContainerScreenSizeReducer (copy), v32 (copy), StyleProviderWithDefaultTheme (copy), GetFFlagInExperienceContainerRespectUserTheme (copy), RoactRodux (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), RoactAppExperiment (copy), IXPService (copy), RoactAppPolicy (copy), AppFeaturePolicies (copy), RoactServices (copy), RoactAnalytics (copy), Analytics (copy), RoactNetworking (copy), requestInternalWrapper (copy), HttpService (copy), AppLinking (copy), GetFFlagInExperienceContainerAppLinking (copy), LinkingProtocol (copy), SelectionCursorProvider (copy), CursorProvider (copy), ProviderContainer (copy), openWebview (copy)
	local v38 = useSelectedTheme()
	local v39 = Cryo.Dictionary.union(t1, t2)
	local v40 = React.Children.only(v39.children)
	local t3 = { Rodux.thunkMiddleware }
	local v42 = Rodux.Store.new(Rodux.combineReducers(Cryo.Dictionary.join({
		CountryCodeList = CountryCodeList,
		FetchingStatus = FetchingStatus,
		ScreenSize = not GetFFlagInExperienceContainerScreenSizeReducer() and function(_, _) -- line: 72
			return Vector2.new(400, 400)
		end or Rodux.createReducer(Vector2.new(400, 400), {
			[v32.name] = function(_, p4) -- line: 68
				return p4.screenSize
			end
		})
	}, v39.reducer)), nil, t3)
	local t4 = {}

	table.insert(t4, {
		class = StyleProviderWithDefaultTheme,
		props = {
			withDarkTheme = not GetFFlagInExperienceContainerRespectUserTheme() or v38 ~= "light"
		}
	})
	table.insert(t4, {
		class = RoactRodux.StoreProvider,
		props = {
			store = v42
		}
	})
	table.insert(t4, {
		class = LocalizationProvider,
		props = {
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		}
	})
	table.insert(t4, {
		class = RoactAppExperiment.Provider,
		props = {
			value = IXPService
		}
	})
	table.insert(t4, {
		class = RoactAppPolicy.Provider,
		props = {
			policy = { AppFeaturePolicies }
		}
	})
	table.insert(t4, {
		class = RoactServices.ServiceProvider,
		props = {
			services = {
				[RoactAnalytics] = Analytics.new(),
				[RoactNetworking] = requestInternalWrapper(HttpService),
				[AppLinking] = if not GetFFlagInExperienceContainerAppLinking() then nil else LinkingProtocol.default
			}
		}
	})
	table.insert(t4, {
		class = SelectionCursorProvider
	})
	table.insert(t4, {
		class = CursorProvider
	})

	return React.createElement(ProviderContainer, {
		providers = t4
	}, {
		Child = React.cloneElement(v40, {
			showWebpage = openWebview
		})
	})
end

return InExperienceProviderContainer
