local module = require("@luauforge/deferred/gQK")

local function maxPromptLength()
	return module.FIntAXBackgroundGenerationMaxPromptLength
end

local function trim(value)
	return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

return {
	clampPrompt = function(value)
		local fIntAXBackgroundGenerationMaxPromptLength = module.FIntAXBackgroundGenerationMaxPromptLength

		local v5 = utf8.len(value)

		if v5 == nil then
			return value:sub(1, fIntAXBackgroundGenerationMaxPromptLength)
		end

		if v5 <= fIntAXBackgroundGenerationMaxPromptLength then
			return value
		end

		local v6 = utf8.offset(value, fIntAXBackgroundGenerationMaxPromptLength + 1)

		if v6 == nil then
			return value:sub(1, fIntAXBackgroundGenerationMaxPromptLength)
		end

		return value:sub(1, v6 - 1)
	end,
	isPromptSubmittable = function(value): boolean
		if value:gsub("^%s+", ""):gsub("%s+$", "") == "" then
			return false
		end

		return (utf8.len(value) or #value) <= module.FIntAXBackgroundGenerationMaxPromptLength
	end
}
