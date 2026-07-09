local t1 = {
	["<"] = "&lt;",
	[">"] = "&gt;",
	["\""] = "&quot;",
	["'"] = "&apos;"
}

return function(s1: string) -- line: 11
	-- upvalues: t1 (copy)
	local v3 = s1:gsub("&", "&amp;")

	for k, v in pairs(t1) do
		v3 = v3:gsub(k, v)
	end

	return v3
end
