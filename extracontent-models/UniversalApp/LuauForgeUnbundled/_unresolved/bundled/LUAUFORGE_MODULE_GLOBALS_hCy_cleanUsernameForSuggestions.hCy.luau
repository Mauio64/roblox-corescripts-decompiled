function LUAUFORGE_MODULE_GLOBALS_hCy_cleanUsernameForSuggestions(value)
	local v5 = value:gsub("[^%w_]", "")

	if string.sub(v5, 1, 1) == "_" then
		v5 = v5:sub(2)
	end

	if string.sub(v5, -1) == "_" then
		v5 = v5:sub(1, -2)
	end

	local v6 = string.find(v5, "_")

	if v6 and v6 < #v5 then
		v5 = v5:sub(1, v6) .. string.gsub(v5:sub(v6 + 1), "_", "")
	end

	if #v5 >= 20 then
		v5 = v5:sub(1, 18)
	end

	return v5
end

return LUAUFORGE_MODULE_GLOBALS_hCy_cleanUsernameForSuggestions
