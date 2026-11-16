local function decodeBuildSuggestionsResponse(p)
	local chips

	if typeof(p) == "table" then
		chips = p.chips
	end

	local options

	if typeof(chips) == "table" then
		options = chips.options
	end

	if typeof(options) ~= "table" then
		error("build suggestions response is missing chips.options")
	end

	local chips2 = {}

	for _, option in options do
		if not (typeof(option) == "table" and typeof(option.value) == "string" and option.value ~= "") then
			continue
		end

		table.insert(chips2, { value = option.value })
	end

	local prompt

	if typeof(p.prompt) == "string" then
		prompt = p.prompt
	end

	return { prompt = prompt, chips = chips2 }
end

return decodeBuildSuggestionsResponse
