local function decodeBuildSuggestionsResponse(p2)
	local chips = if typeof(p2) == "table" then p2.chips else nil
	local options = if typeof(chips) == "table" then chips.options else nil

	if typeof(options) ~= "table" then
		error("build suggestions response is missing chips.options")
	end

	local v5 = {}

	for k, option in options do
		if not (typeof(option) == "table" and typeof(option.value) == "string" and option.value ~= "") then
			continue
		end

		table.insert(v5, { value = option.value })
	end

	return {
		prompt = if typeof(p2.prompt) == "string" then p2.prompt else nil,
		chips = v5
	}
end

return decodeBuildSuggestionsResponse
