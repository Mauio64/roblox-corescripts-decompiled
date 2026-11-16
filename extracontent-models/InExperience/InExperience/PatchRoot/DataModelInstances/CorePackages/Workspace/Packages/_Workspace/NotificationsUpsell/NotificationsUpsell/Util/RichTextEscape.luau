local v = { ["<"] = "&lt;", [">"] = "&gt;", ["\""] = "&quot;", ["'"] = "&apos;" }

return function(value: string)
	local v2 = value:gsub("&", "&amp;")

	for k, v3 in pairs(v) do
		v2 = v2:gsub(k, v3)
	end

	return v2
end
