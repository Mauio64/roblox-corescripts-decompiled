local v = { execute_luau = true, verify_luau = true }

local function cleanSummary(value) -- 2 equivalent calls inferred from this helper
	if typeof(value) ~= "string" then
		return nil
	end

	local v2 = string.match(value, "^%s*(.-)%s*$")

	if v2 == "" then
		return nil
	end

	return (string.sub(v2, 1, (utf8.offset(v2, 121) or #v2 + 1) - 1))
end

local function getLeadingComment(code)
	if typeof(code) ~= "string" then
		return nil
	end

	for k in string.gmatch(code, "[^\r\n]+") do
		local v2 = string.match(k, "^%s*(.-)%s*$")

		if v2 ~= "" and string.sub(v2, 1, 3) ~= "--!" then
			if string.sub(v2, 1, 2) ~= "--" or string.match(v2, "^%-%-%[=*%[") ~= nil then
				return nil
			end

			return cleanSummary(string.match(v2, "^%-%-+%s*(.*)$")) -- inferred equivalent call
		end
	end

	return nil
end

return {
	getToolDisplaySummary = function(p: string?, p2)
		if typeof(p2) ~= "table" then
			return nil
		end

		local v2 = cleanSummary(p2._display_summary) -- inferred equivalent call

		if v2 ~= nil then
			return v2
		end

		if p == nil or not v[p] then
			return nil
		end

		return (getLeadingComment(p2.code))
	end
}
