local function dumpInstanceTree(child, value: string?)
	value = value or ""
	assert(value ~= nil, "indent must be a string")

	if child == nil then
		print(value .. "[nil Instance]")
		return
	end

	assert(child ~= nil, "instance must be non-nil")
	print(value .. child.Name)
	local v = value .. "  "

	for _, child2 in ipairs(child:GetChildren()) do
		dumpInstanceTree(child2, v)
	end
end

return dumpInstanceTree
