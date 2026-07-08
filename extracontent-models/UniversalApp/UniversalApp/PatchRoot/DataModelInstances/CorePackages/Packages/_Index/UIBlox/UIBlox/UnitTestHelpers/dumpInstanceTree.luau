local function dumpInstanceTree(p1, s1: string?) -- line: 1
	-- upvalues: dumpInstanceTree (copy)
	local v4 = s1 or ""

	assert(v4 ~= nil, "indent must be a string")

	if p1 == nil then
		print(v4 .. "[nil Instance]")

		return
	end

	assert(p1 ~= nil, "instance must be non-nil")
	print(v4 .. p1.Name)

	local v5 = v4 .. "  "

	for _, child in ipairs(p1:GetChildren()) do
		dumpInstanceTree(child, v5)
	end
end

return dumpInstanceTree
