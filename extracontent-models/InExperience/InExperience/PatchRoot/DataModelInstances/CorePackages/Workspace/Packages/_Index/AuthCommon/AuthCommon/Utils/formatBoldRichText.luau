local v = { ["<"] = "&lt;", [">"] = "&gt;", ["\""] = "&quot;", ["'"] = "&apos;" }

local function formatBoldRichText(value: string)
	local v2 = string.gsub(value, "&", "&amp;")

	for k, v3 in v do
		v2 = string.gsub(v2, k, v3)
	end

	return `<b>{v2}</b>`
end

return formatBoldRichText
