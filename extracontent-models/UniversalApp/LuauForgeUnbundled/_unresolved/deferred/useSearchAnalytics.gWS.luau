local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/fpM")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module3 = require("@luauforge/bundled/frh")
local module4 = require("@luauforge/bundled/fri")
local module5 = require("@luauforge/bundled/frj")
local module6 = require("@luauforge/bundled/frk")

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module7 = require("@luauforge/bundled/eeH")

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local getLegacyNavigationStore

if fFlagSignalsNavP3gAvatarExperience then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local module8 = require("@luauforge/bundled/frl")
local normalizeKeyword = module.Utils.normalizeKeyword

local fFlagAXUnifiedAutocompleteEndpoint = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUnifiedAutocompleteEndpoint
local getAutocompleteQueryKey = module.Utils.getAutocompleteQueryKey
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals

local module9 = require("@luauforge/bundled/dYU")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")

local function getDefaultAnalyticsQueryState()
	return { query = nil, time = tick() }
end

local function useSearchAnalytics()
	local ref = React.useRef({ query = nil, time = tick() })
	local ref2 = React.useRef("")

	local v5 = module7(module9)

	local v6 = if not fFlagSignalsNavP3gAvatarExperience then useSelector(module8) else nil

	local v7 = useSelector(function(p2)
		return p2.AvatarExperience.AvatarAutocompleteSuggestions or {}
	end, getUseSelectorDeepEquals())

	local v8 = React.useCallback(function(current, p2, p3)
		if not (ref.current and ref2.current) then
			return
		end

		local current2 = ref.current or {}

		if not current or current ~= current2.query or not p2 then
			return
		end

		local now = tick()

		local v9 = if fFlagSignalsNavP3gAvatarExperience then getLegacyNavigationStore(false).getCurrentPageName(false) else v6

		module3(
			v5,
			"AvatarShopSearch",
			current,
			ref2.current,
			p2,
			v9,
			now - current2.time,
			p3,
			RobloxAppEnums.SearchTypes.Catalog
		)

		ref2.current = current
		ref.current = { query = nil, time = tick() }
	end, {})

	local function fn(p2)
		module5(v5, "AvatarShopSearch", p2, RobloxAppEnums.SearchTypes.Catalog)
	end

	local function fn2(p2, value)
		local v10 = if fFlagAXUnifiedAutocompleteEndpoint then getAutocompleteQueryKey(p2) or "" else normalizeKeyword(p2)
		local v11 = v7[v10]

		if not (v11 and v11.entries and value) then
			return
		end

		local entries = v11.entries
		local v12 = nil
		local v13 = nil

		for k, entry in entries do
			if string.lower(entry.searchQuery) == string.lower(value) then
				v13 = k
				v12 = entry
				break
			end
		end

		if v12 and v13 then
			module6(v5, "AvatarShopSearch", p2, RobloxAppEnums.SearchTypes.Catalog, entries, v13, v12)
		end
	end

	local function fn3(value)
		local query = ref.current and ref.current.query
		ref.current = { query = value, time = tick() }

		if value and query and string.len(value) < string.len(query) then
			module4(v5, "AvatarShopSearch", query, value, RobloxAppEnums.SearchTypes.Catalog)
		end

		local v9 = if fFlagAXUnifiedAutocompleteEndpoint then getAutocompleteQueryKey(value) or "" else normalizeKeyword(value)
		local v10 = v7[v9]

		if v10 then
			v8(value, v10, true)
		end
	end

	React.useEffect(function()
		local query = ref.current and ref.current.query

		if query then
			local v9 = if fFlagAXUnifiedAutocompleteEndpoint then getAutocompleteQueryKey(query) or "" else normalizeKeyword(query)
			local v10 = v7[v9]

			if v10 then
				v8(query, v10, false)
			end
		end
	end, { v7, v8 })

	return {
		updateQuery = fn3,
		sendClearEvent = fn,
		sendAutocompleteTermClickedEvent = fn2
	}
end

return useSearchAnalytics
