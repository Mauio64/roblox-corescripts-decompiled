local IXPService = game:GetService("IXPService")

local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local sessionType = require("@luauforge/bundled/fwa").SessionType
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local navigateSideways = NavigationRodux.Thunks.NavigateSideways
local selectors = NavigationRodux.Selectors
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies
local searchSourceEvent = require("@luauforge/bundled/cBc").SearchSourceEvent
local module2 = require("@luauforge/bundled/egz")
local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SearchTypes
local navigateToSearchResults = require("@luauforge/bundled/fwb").navigateToSearchResults

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSduiSearchResultsPageEnabled = SharedFlags.FFlagSduiSearchResultsPageEnabled
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local getLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore

local omniSearchSessionUtil = require("@luauforge/bundled/dtb").Modules.LuaApp.Analytics.Sessions.OmniSearchSessionUtil

local searchUuid = require("@luauforge/bundled/dRA").SearchUuid
local module4 = require("@luauforge/bundled/fvU")
local module5 = require("@luauforge/bundled/fwM")
local module6 = require("@luauforge/bundled/fwR")
local module7 = require("@luauforge/bundled/fwS")
local module8 = require("@luauforge/bundled/dXh")

local function navigateToSearch(object, p2, p3)
	IXPService:LogUserLayerExposure(appUserLayers.OmniSearchResultsPageUXExposureLayer)

	local v5 = {
		name = appPage.SearchPage,
		key = tostring(p2),
		detail = p2,
		extraProps = { omniSearchInfo = p3 }
	}

	if fFlagSignalsNavP3Dispatch then
		navigationCommands.sideways(navigationCommands.fromLegacyPage(v5), false)
	else
		object:dispatch(navigateSideways(v5, false))
	end
end

return function(value, data)
	return function(object)
		local v5 = data.searchType

		if data.isAutocompleteSuggestion and v5 == searchTypes.Auto then
			v5 = searchTypes.Games
		end

		if value and #value > 1950 then
			value = string.sub(value, 1, 1950)
		end

		local v6 = searchUuid()

		local state = object:getState()
		local v7

		if fFlagSignalsNavP3hMisc then
			v7 = getLegacyNavigationStore(false).getCurrentLegacyRoute(false)
		elseif fFlagUseNavigationSelectors then
			v7 = selectors.selectCurrentLegacyRoute(state)
		else
			v7 = state.Navigation.history[#state.Navigation.history]
		end

		object:dispatch(module6(v6, v5))
		object:dispatch(module7(v6, {
			searchKeyword = value,
			isKeywordSuggestionEnabled = true
		}))

		if module2.isSearchTypeInOmniSearch(v5) then
			local uuid = omniSearchSessionUtil.generateUuid()
			omniSearchSessionUtil.create(
				data.sessionService,
				uuid,
				value,
				v5,
				v6,
				data.sourceEvent or searchSourceEvent.ConfirmSearch
			)

			if v5 ~= searchTypes.Auto then
				local name = v7[#v7].name
				module4(data.eventIngest, v5, "search", value, false, name)
			end

			data.sessionService:RemoveSession(sessionType.StructuralIdentifier.GameSearchAutocomplete)

			local v8 = { omniSearchUuid = uuid, searchKeyword = value }

			if not getAppFeaturePolicies().getSearchWithoutNavigatingEnabled() then
				if fFlagSduiSearchResultsPageEnabled then
					navigateToSearchResults(value, v6, uuid, function()
						navigateToSearch(object, v6, v8)
					end)
				else
					navigateToSearch(object, v6, v8)
				end
			end
		elseif v5 == searchTypes.Catalog then
			if data.topBarAnalytics then
				data.topBarAnalytics.reportSearched("catalog", value)
			end

			if data.isAvatarAutocompleteEnabled then
				module5(
					data.eventIngest,
					"catalog",
					value,
					data.isAutocompleteSuggestion,
					data.pageOwner,
					data.allAutocompleteSuggestions
				)
			end

			local v8 = { searchKeyword = value }

			module8.navigateToSearch(data.navigation, v6, v8)
		end
	end
end
