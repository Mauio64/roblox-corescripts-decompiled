local v5 = { ["<"] = "&lt;", [">"] = "&gt;", ["\""] = "&quot;", ["'"] = "&apos;" }

local function escapeRichText(value)
	local v6 = string.gsub(value, "&", "&amp;")

	for k, v7 in v5 do
		v6 = string.gsub(v6, k, v7)
	end

	return v6
end

return escapeRichText
