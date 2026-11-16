local v = { ["<"] = "&lt;", [">"] = "&gt;", ["\""] = "&quot;", ["'"] = "&apos;" }

local function escapeRichText(value: string)
	local v2 = string.gsub(value, "&", "&amp;")

	for k, v3 in v do
		v2 = string.gsub(v2, k, v3)
	end

	return v2
end

return escapeRichText
