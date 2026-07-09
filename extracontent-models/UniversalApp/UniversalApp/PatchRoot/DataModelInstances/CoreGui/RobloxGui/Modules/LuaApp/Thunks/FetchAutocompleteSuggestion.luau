local CorePackages = game:GetService("CorePackages")
local SearchTypes = require(CorePackages.Workspace.Packages.RobloxAppEnums).SearchTypes
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ApiFetchAutocompleteGameSuggestion = require(Modules.LuaApp.Thunks.ApiFetchAutocompleteGameSuggestion)
local ApiFetchAutocompleteAvatarSuggestion = require(Modules.LuaApp.Thunks.ApiFetchAutocompleteAvatarSuggestion)

return {
	Fetch = function(p1, s1: string, t1: {[any]: any}?, s2: string) -- line: 10
		-- upvalues: SearchTypes (copy), ApiFetchAutocompleteAvatarSuggestion (copy), ApiFetchAutocompleteGameSuggestion (copy)
		if s2 == SearchTypes.Catalog then
			return ApiFetchAutocompleteAvatarSuggestion.Fetch(p1, s1)
		end

		if s2 == SearchTypes.Games or s2 == SearchTypes.Auto or s2 == SearchTypes.TopResults then
			return ApiFetchAutocompleteGameSuggestion.Fetch(p1, s1, t1)
		end

		if s2 == SearchTypes.Players then
			return ApiFetchAutocompleteGameSuggestion.Fetch(p1, s1, t1)
		end

		error(`Unrecognized search type for fetching autocomplete suggestions: { s2 }`)
	end,
	GetFetchingStatus = function(p2, p3, p4) -- line: 29
		-- upvalues: SearchTypes (copy), ApiFetchAutocompleteAvatarSuggestion (copy), ApiFetchAutocompleteGameSuggestion (copy)
		if p4 == SearchTypes.Catalog then
			return ApiFetchAutocompleteAvatarSuggestion.GetFetchingStatus(p2, p3)
		end

		if p4 == SearchTypes.Games or p4 == SearchTypes.Auto or p4 == SearchTypes.TopResults then
			return ApiFetchAutocompleteGameSuggestion.GetFetchingStatus(p2, p3)
		end

		if p4 == SearchTypes.Players then
			return ApiFetchAutocompleteGameSuggestion.GetFetchingStatus(p2, p3)
		end

		error(`Unrecognized search type for fetching status for autocomplete suggestions: { p4 }`)
	end
}
