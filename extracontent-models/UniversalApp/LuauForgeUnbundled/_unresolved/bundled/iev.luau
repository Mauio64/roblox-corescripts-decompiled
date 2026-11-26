local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc

local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/RoactServiceTags")
local appEventIngestService = RoactServiceTags.AppEventIngestService
local appSessionService = RoactServiceTags.AppSessionService

local searchSourceEvent = require("@luauforge/bundled/cBc").SearchSourceEvent

local openSearchResultsWithQueryBridge = require("@luauforge/bundled/dDZ").OpenSearchResultsWithQueryBridge

local module4 = require("@luauforge/bundled/fvZ")
local v5 = if not fFlagSignalsNavP3hMisc then require("@luauforge/bundled/fyF") else nil

local getLegacyNavigationStore = if fFlagSignalsNavP3hMisc then require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore else nil

local fFlagLuaAppSduiSearchAutocomplete = SharedFlags.FFlagLuaAppSduiSearchAutocomplete

local sessionType = if fFlagLuaAppSduiSearchAutocomplete then require("@luauforge/bundled/fwa").SessionType else nil

local function SduiOpenSearchResultsWithQueryReceiver(): nil
	local v6 = useDispatch()
	local v7 = useRoactService(appEventIngestService)
	local v8 = useRoactService(appSessionService)
	local v9 = if not fFlagSignalsNavP3hMisc then useSelector(v5) else nil

	React.useEffect(function()
		local v10 = openSearchResultsWithQueryBridge.connect(function(p2, searchType, p3)
			local v11

			if fFlagSignalsNavP3hMisc then
				v11 = getLegacyNavigationStore(false).getCurrentPage(false).name
			else
				v11 = v9
			end

			local v13 = if fFlagLuaAppSduiSearchAutocomplete then p3 == true else false
			local v12 = {
				isAutocompleteSuggestion = v13,
				allAutocompleteSuggestions = {},
				searchType = searchType,
				isAvatarAutocompleteEnabled = false,
				pageOwner = v11,
				sessionService = v8,
				eventIngest = v7,
				sourceEvent = 0
			}

			local v14 = if fFlagLuaAppSduiSearchAutocomplete and p3 then searchSourceEvent.ConfirmSearch else searchSourceEvent.SearchDeepLink
			v12.sourceEvent = v14

			v6(module4(p2, v12))

			if
				fFlagLuaAppSduiSearchAutocomplete
				and p3
				and v8:SessionExists(sessionType.StructuralIdentifier.SearchLandingPage)
			then
				v8:RemoveSession(sessionType.StructuralIdentifier.SearchLandingPage)
			end
		end)

		return function()
			v10:disconnect()
		end
	end, { v6, v7, v8, v9 })

	return nil
end

return React.memo(SduiOpenSearchResultsWithQueryReceiver)
