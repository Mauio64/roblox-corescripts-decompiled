local v5 = { ["<"] = "&lt;", [">"] = "&gt;", ["\""] = "&quot;", ["'"] = "&apos;" }

return function(value)
	local v6 = value:gsub("&", "&amp;")

	for k, v7 in pairs(v5) do
		v6 = v6:gsub(k, v7)
	end

	return v6
end
