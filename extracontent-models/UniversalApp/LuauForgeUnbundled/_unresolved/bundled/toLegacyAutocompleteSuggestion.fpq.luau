local discoveryEventErrorLogger = require("@luauforge/bundled/foR").DiscoveryEventErrorLogger

local function toLegacyAutocompleteSuggestion(data)
	if data == nil then
		return nil
	end

	if typeof(data.prefix) ~= "string" or data.suggestions == nil then
		discoveryEventErrorLogger.reportError(
			"SearchAutocomplete",
			"toLegacyAutocompleteSuggestion: ranked data has no prefix or suggestions"
		)

		return nil
	end

	local v5 = {}

	for k, suggestion in data.suggestions do
		local v6 = suggestion.search_query

		if typeof(v6) ~= "string" or v6 == "" then
			discoveryEventErrorLogger.reportError(
				"SearchAutocomplete",
				"toLegacyAutocompleteSuggestion: row has no search_query"
			)
			return nil
		end

		local suggestion_type = suggestion.suggestion_type

		if suggestion_type == "SUGGESTION_TYPE_RICH" then
			local v7 = {
				type = 0,
				searchQuery = v6,
				canonicalTitle = 0,
				universeId = 0,
				position = 0
			}

			if suggestion.canonical_title and suggestion.canonical_title ~= "" then
				v6 = suggestion.canonical_title
			end

			v7.canonicalTitle = v6

			v7.universeId = suggestion.universe_id
			v7.position = suggestion.position
			table.insert(v5, v7)
		elseif
			suggestion_type == "SUGGESTION_TYPE_QUERY"
			or suggestion_type == "SUGGESTION_TYPE_TRENDING_QUERY"
		then
			table.insert(v5, {
				type = 1,
				searchQuery = v6,
				position = suggestion.position
			})
		else
			discoveryEventErrorLogger.reportError(
				"SearchAutocomplete",
				"toLegacyAutocompleteSuggestion: unsupported suggestion_type",
				{ suggestionType = tostring(suggestion_type) }
			)

			return nil
		end
	end

	return {
		prefix = data.prefix,
		algorithmName = data.algorithm_name or "",
		entries = v5
	}
end

return toLegacyAutocompleteSuggestion
