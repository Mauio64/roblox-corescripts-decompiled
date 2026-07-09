local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local AvatarExperienceSearch = require(CorePackages.Workspace.Packages.AvatarExperienceSearch)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local searchAutocompleteEventNew = require(Modules.LuaApp.Analytics.Events.searchAutocompleteEventNew)
local searchTextTrim = require(Modules.LuaApp.Analytics.Events.searchTextTrim)
local searchClear = require(Modules.LuaApp.Analytics.Events.searchClear)
local searchSuggestionClicked = require(Modules.LuaApp.Analytics.Events.searchSuggestionClicked)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local FFlagSignalsNavP3gAvatarExperience = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3gAvatarExperience
local v14 = if not FFlagSignalsNavP3gAvatarExperience then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local getCurrentPage = require(Modules.LuaApp.getCurrentPage)
local normalizeKeyword = AvatarExperienceSearch.Utils.normalizeKeyword
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)

local function getDefaultAnalyticsQueryState() -- line: 37
	return {
		query = nil,
		time = tick()
	}
end
local function useSearchAnalytics() -- line: 44
	-- upvalues: React (copy), useRoactService (copy), AppEventIngestService (copy), FFlagSignalsNavP3gAvatarExperience (copy), v14 (copy), useSignalState (copy), useSelector (copy), getCurrentPage (copy), getUseSelectorDeepEquals (copy), searchAutocompleteEventNew (copy), RobloxAppEnums (copy), searchClear (copy), normalizeKeyword (copy), searchSuggestionClicked (copy), searchTextTrim (copy)
	local v22 = React.useRef({
		query = nil,
		time = tick()
	})
	local v23 = React.useRef("")
	local v24 = useRoactService(AppEventIngestService)
	local name

	if FFlagSignalsNavP3gAvatarExperience then
		local v25 = v14(false)

		name = useSignalState(v25.getCurrentPage).name
	else
		name = useSelector(getCurrentPage)
	end

	local v27 = useSelector(function(p1) -- line: 60
		return p1.AvatarExperience.AvatarAutocompleteSuggestions or {}
	end, getUseSelectorDeepEquals())
	local v28 = React.useCallback(function(s1: string, p2, b1: boolean) -- line: 69
		-- upvalues: v22 (copy), v23 (copy), searchAutocompleteEventNew (copy), v24 (copy), name (ref), RobloxAppEnums (copy)
		if not v22.current or not v23.current then
			return
		end

		local v33 = v22.current or {}

		if not s1 or s1 ~= v33.query or not p2 then
			return
		end

		local timestamp = tick()

		searchAutocompleteEventNew(v24, "AvatarShopSearch", s1, v23.current, p2, name, timestamp - v33.time, b1, RobloxAppEnums.SearchTypes.Catalog)
		v23.current = s1
		v22.current = {
			query = nil,
			time = tick()
		}
	end, {})

	React.useEffect(function() -- line: 156
		-- upvalues: v22 (copy), normalizeKeyword (copy), v27 (copy), v28 (copy)
		local v47 = v22.current and v22.current.query

		if v47 then
			local v48 = v27[normalizeKeyword(v47)]

			if v48 then
				v28(v47, v48, false)
			end
		end
	end, {
		v27,
		v28
	})

	return {
		updateQuery = function(s2: string) -- line: 128
			-- upvalues: v22 (copy), searchTextTrim (copy), v24 (copy), RobloxAppEnums (copy), normalizeKeyword (copy), v27 (copy), v28 (copy)
			local v45 = v22.current and v22.current.query

			v22.current = {
				query = s2,
				time = tick()
			}

			if s2 and (v45 and string.len(s2) < string.len(v45)) then
				searchTextTrim(v24, "AvatarShopSearch", v45, s2, RobloxAppEnums.SearchTypes.Catalog)
			end

			local v46 = v27[normalizeKeyword(s2)]

			if v46 then
				v28(s2, v46, true)
			end
		end,
		sendClearEvent = function(s3: string) -- line: 96
			-- upvalues: searchClear (copy), v24 (copy), RobloxAppEnums (copy)
			searchClear(v24, "AvatarShopSearch", s3, RobloxAppEnums.SearchTypes.Catalog)
		end,
		sendAutocompleteTermClickedEvent = function(s4: string, s5: string) -- line: 100
			-- upvalues: v27 (copy), normalizeKeyword (copy), searchSuggestionClicked (copy), v24 (copy), RobloxAppEnums (copy)
			local v38 = v27[normalizeKeyword(s4)]

			if not v38 or (not v38.entries or not s5) then
				return
			end

			local entries = v38.entries
			local v40 = nil
			local v41 = nil

			for v42, v43 in entries do
				if string.lower(v43.searchQuery) == string.lower(s5) then
					v40 = v42
					v41 = v43

					break
				end
			end

			if v41 and v40 then
				searchSuggestionClicked(v24, "AvatarShopSearch", s4, RobloxAppEnums.SearchTypes.Catalog, entries, v40, v41)
			end
		end
	}
end

return useSearchAnalytics
