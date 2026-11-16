local HttpService = game:GetService("HttpService")

local function replaceLeadingQuote(value) -- 1 equivalent call inferred from this helper
	local v = string.gsub(value, "\n\"", "\n`")

	if v.sub(v, 1, 1) == "\"" then
		return "`" .. string.sub(v, 2)
	end

	return v
end

local function replaceTrailingQuote(value) -- 1 equivalent call inferred from this helper
	local v = string.gsub(value, "\"\n", "`\n")

	if v.sub(v, -1) == "\"" then
		return string.sub(v, 1, -2) .. "`"
	end

	return v
end

return {
	inspectStr = function(p: string)
		if p == nil then
			return "nil"
		end

		local v = string.gsub(replaceTrailingQuote(replaceLeadingQuote(HttpService:JSONEncode(p))), "\\\"", "\"") -- inferred equivalent call
		return (string.gsub(v, "\\\\", "\\"))
	end
}
