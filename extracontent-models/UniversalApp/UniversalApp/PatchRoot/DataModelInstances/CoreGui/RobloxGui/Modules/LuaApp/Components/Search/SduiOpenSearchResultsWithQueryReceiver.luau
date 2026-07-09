local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local AppSessionService = RoactServiceTags.AppSessionService
local SearchSourceEvent = require(CorePackages.Workspace.Packages.DiscoveryTypes).SearchSourceEvent
local OpenSearchResultsWithQueryBridge = require(CorePackages.Workspace.Packages.ServerDrivenUi).OpenSearchResultsWithQueryBridge
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ConfirmSearch = require(Modules.LuaApp.Thunks.ConfirmSearch)
local getCurrentPage = require(Modules.LuaApp.getCurrentPage)

local function SduiOpenSearchResultsWithQueryReceiver() -- line: 35
	-- upvalues: useDispatch (copy), useRoactService (copy), AppEventIngestService (copy), AppSessionService (copy), useSelector (copy), getCurrentPage (copy), React (copy), OpenSearchResultsWithQueryBridge (copy), SearchSourceEvent (copy), ConfirmSearch (copy)
	local v16 = useDispatch()
	local v17 = useRoactService(AppEventIngestService)
	local v18 = useRoactService(AppSessionService)
	local v19 = useSelector(getCurrentPage)

	React.useEffect(function() -- line: 41
		-- upvalues: OpenSearchResultsWithQueryBridge (copy), v19 (copy), v18 (copy), v17 (copy), SearchSourceEvent (copy), v16 (copy), ConfirmSearch (copy)
		local v20 = OpenSearchResultsWithQueryBridge.connect(function(s1: string, s2: string) -- line: 42
			-- upvalues: v19 (copy), v18 (copy), v17 (copy), SearchSourceEvent (copy), v16 (copy), ConfirmSearch (copy)
			local t1 = {
				isAutocompleteSuggestion = false,
				isAvatarAutocompleteEnabled = false,
				allAutocompleteSuggestions = {},
				searchType = s2,
				pageOwner = v19,
				sessionService = v18,
				eventIngest = v17,
				sourceEvent = SearchSourceEvent.SearchDeepLink
			}

			v16(ConfirmSearch(s1, t1))
		end)

		return function() -- line: 56
			-- upvalues: v20 (copy)
			v20:disconnect()
		end
	end, {
		v16,
		v17,
		v18,
		v19
	})

	return nil
end

return React.memo(SduiOpenSearchResultsWithQueryReceiver)
