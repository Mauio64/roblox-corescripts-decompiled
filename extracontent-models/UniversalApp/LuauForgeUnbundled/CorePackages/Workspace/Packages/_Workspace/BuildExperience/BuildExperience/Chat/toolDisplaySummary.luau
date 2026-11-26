local v5 = { execute_luau = true, verify_luau = true }

local function cleanSummary(value)
	if typeof(value) ~= "string" then
		return nil
	end

	local v6 = string.match(value, "^%s*(.-)%s*$")

	if v6 == "" then
		return nil
	end

	return (string.sub(v6, 1, (utf8.offset(v6, 121) or #v6 + 1) - 1))
end

local function getLeadingComment(code)
	if typeof(code) ~= "string" then
		return nil
	end

	for k in string.gmatch(code, "[^\r\n]+") do
		local v6 = string.match(k, "^%s*(.-)%s*$")

		if v6 ~= "" and string.sub(v6, 1, 3) ~= "--!" then
			if string.sub(v6, 1, 2) ~= "--" or string.match(v6, "^%-%-%[=*%[") ~= nil then
				return nil
			end

			local v7 = string.match(v6, "^%-%-+%s*(.*)$")

			if typeof(v7) ~= "string" then
				return nil
			end

			local v8 = string.match(v7, "^%s*(.-)%s*$")

			if v8 == "" then
				return nil
			end

			return (string.sub(v8, 1, (utf8.offset(v8, 121) or #v8 + 1) - 1))
		end
	end

	return nil
end

return {
	getToolDisplaySummary = function(p2, p3)
		if typeof(p3) ~= "table" then
			return nil
		end

		local display_summary = p3._display_summary
		local v6

		if typeof(display_summary) == "string" then
			local v7 = string.match(display_summary, "^%s*(.-)%s*$")

			if v7 ~= "" then
				v6 = string.sub(v7, 1, (utf8.offset(v7, 121) or #v7 + 1) - 1)
			end
		end

		if v6 ~= nil then
			return v6
		end

		if p2 == nil or not v5[p2] then
			return nil
		end

		return getLeadingComment(p3.code)
	end
}
