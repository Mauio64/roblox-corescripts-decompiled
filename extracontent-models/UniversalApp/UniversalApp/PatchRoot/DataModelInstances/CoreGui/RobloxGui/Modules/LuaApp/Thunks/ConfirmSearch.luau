local IXPService = game:GetService("IXPService")
local CorePackages = game:GetService("CorePackages")
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType
local NavigationRodux = require(CorePackages.Workspace.Packages.NavigationRodux)
local NavigateSideways = NavigationRodux.Thunks.NavigateSideways
local Selectors = NavigationRodux.Selectors
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local SearchSourceEvent = require(CorePackages.Workspace.Packages.DiscoveryTypes).SearchSourceEvent
local DiscoveryUtils = require(CorePackages.Workspace.Packages.DiscoveryUtils)
local SearchTypes = require(CorePackages.Workspace.Packages.RobloxAppEnums).SearchTypes
local navigateToSearchResults = require(CorePackages.Workspace.Packages.SearchResults).navigateToSearchResults
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagSduiSearchResultsPageEnabled = SharedFlags.FFlagSduiSearchResultsPageEnabled
local FFlagLuaAppSduiOpenSearchResultsWithQueryAction = SharedFlags.FFlagLuaAppSduiOpenSearchResultsWithQueryAction
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v19 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local OmniSearchSessionUtil = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Analytics.Sessions.OmniSearchSessionUtil
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SearchUuid = require(Modules.LuaApp.SearchUuid)
local search = require(Modules.LuaApp.Analytics.Events.search)
local catalogSearchEvent = require(Modules.LuaApp.Analytics.Events.catalogSearchEvent)
local SetSearchType = require(Modules.LuaApp.Actions.SetSearchType)
local SetSearchParameters = require(Modules.LuaApp.Actions.SetSearchParameters)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)

local function navigateToSearch(p1, p2, p3) -- line: 73
	-- upvalues: IXPService (copy), AppUserLayers (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v19 (copy), NavigateSideways (copy)
	IXPService:LogUserLayerExposure(AppUserLayers.OmniSearchResultsPageUXExposureLayer)

	local t1 = {
		name = AppPage.SearchPage,
		key = tostring(p2),
		detail = p2,
		extraProps = {
			omniSearchInfo = p3
		}
	}

	if FFlagSignalsNavP3Dispatch then
		v19.sideways(v19.fromLegacyPage(t1), false)

		return
	end

	p1:dispatch(NavigateSideways(t1, false))
end

return function(s1: string, t2: {[any]: any}) -- line: 91
	-- upvalues: SearchTypes (copy), SearchUuid (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), SetSearchType (copy), SetSearchParameters (copy), DiscoveryUtils (copy), OmniSearchSessionUtil (copy), FFlagLuaAppSduiOpenSearchResultsWithQueryAction (copy), SearchSourceEvent (copy), search (copy), SessionType (copy), getAppFeaturePolicies (copy), FFlagSduiSearchResultsPageEnabled (copy), navigateToSearchResults (copy), navigateToSearch (copy), catalogSearchEvent (copy), NavigationUtils (copy)
	return function(p4) -- line: 92
		-- upvalues: t2 (copy), SearchTypes (copy), s1 (ref), SearchUuid (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), SetSearchType (copy), SetSearchParameters (copy), DiscoveryUtils (copy), OmniSearchSessionUtil (copy), FFlagLuaAppSduiOpenSearchResultsWithQueryAction (copy), SearchSourceEvent (copy), search (copy), SessionType (copy), getAppFeaturePolicies (copy), FFlagSduiSearchResultsPageEnabled (copy), navigateToSearchResults (copy), navigateToSearch (copy), catalogSearchEvent (copy), NavigationUtils (copy)
		local searchType = t2.searchType

		if t2.isAutocompleteSuggestion and searchType == SearchTypes.Auto then
			searchType = SearchTypes.Games
		end

		if s1 and #s1 > 1950 then
			s1 = string.sub(s1, 1, 1950)
		end

		local v38 = SearchUuid()
		local v39 = p4:getState()
		local v40 = if not FFlagUseNavigationSelectors then v39.Navigation.history[#v39.Navigation.history] else Selectors.selectCurrentLegacyRoute(v39)

		p4:dispatch(SetSearchType(v38, searchType))
		p4:dispatch(SetSearchParameters(v38, {
			isKeywordSuggestionEnabled = true,
			searchKeyword = s1
		}))

		if DiscoveryUtils.isSearchTypeInOmniSearch(searchType) then
			local v41 = OmniSearchSessionUtil.generateUuid()

			OmniSearchSessionUtil.create(t2.sessionService, v41, s1, searchType, v38, if not FFlagLuaAppSduiOpenSearchResultsWithQueryAction then SearchSourceEvent.ConfirmSearch else t2.sourceEvent or SearchSourceEvent.ConfirmSearch)

			if searchType ~= SearchTypes.Auto then
				local name = v40[#v40].name

				search(t2.eventIngest, searchType, "search", s1, false, name)
			end

			t2.sessionService:RemoveSession(SessionType.StructuralIdentifier.GameSearchAutocomplete)

			local t3 = {
				omniSearchUuid = v41,
				searchKeyword = s1
			}

			if not getAppFeaturePolicies().getSearchWithoutNavigatingEnabled() then
				if FFlagSduiSearchResultsPageEnabled then
					navigateToSearchResults(s1, v38, v41, function() -- line: 150
						-- upvalues: navigateToSearch (copy), p4 (copy), v38 (copy), t3 (copy)
						navigateToSearch(p4, v38, t3)
					end)

					return
				end

				navigateToSearch(p4, v38, t3)

				return
			end
		elseif searchType == SearchTypes.Catalog then
			if FFlagLuaAppSduiOpenSearchResultsWithQueryAction then
				if t2.topBarAnalytics then
					t2.topBarAnalytics.reportSearched("catalog", s1)
				end
			else
				t2.topBarAnalytics.reportSearched("catalog", s1)
			end

			if t2.isAvatarAutocompleteEnabled then
				catalogSearchEvent(t2.eventIngest, "catalog", s1, t2.isAutocompleteSuggestion, t2.pageOwner, t2.allAutocompleteSuggestions)
			end

			local t4 = {
				searchKeyword = s1
			}

			NavigationUtils.navigateToSearch(t2.navigation, v38, t4)
		end
	end
end
