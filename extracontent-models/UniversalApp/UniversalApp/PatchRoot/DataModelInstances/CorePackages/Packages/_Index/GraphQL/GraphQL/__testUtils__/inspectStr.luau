local HttpService = game:GetService("HttpService")

local function replaceLeadingQuote(p1) -- line: 11
	local v5 = string.gsub(p1, "\n\"", "\n`")

	if v5:sub(1, 1) == "\"" then
		return "`" .. string.sub(v5, 2)
	end

	return v5
end
local function replaceTrailingQuote(p2) -- line: 19
	local v7 = string.gsub(p2, "\"\n", "`\n")

	if v7:sub(-1) == "\"" then
		return string.sub(v7, 1, -2) .. "`"
	end

	return v7
end

return {
	inspectStr = function(s1: string) -- line: 30
		-- upvalues: HttpService (copy)
		if s1 == nil then
			return "nil"
		end

		local json = HttpService:JSONEncode(s1)
		local v10 = string.gsub(json, "\n\"", "\n`")
		local v11 = if v10:sub(1, 1) ~= "\"" then v10 else "`" .. string.sub(v10, 2)
		local v12 = string.gsub(v11, "\"\n", "`\n")
		local v13 = if v12:sub(-1) ~= "\"" then v12 else string.sub(v12, 1, -2) .. "`"
		local v14 = string.gsub(v13, "\\\"", "\"")

		return (string.gsub(v14, "\\\\", "\\"))
	end
}
