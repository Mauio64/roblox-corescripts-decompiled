local function deepEqual(item, item2, p): boolean
	if item == item2 then
		return true
	end

	local typeName = type(item)

	if not (typeName == type(item2) and typeName == "table") then
		return false
	end

	if not p then
		local metatable = getmetatable(item)

		if metatable and metatable.__eq then
			return item == item2
		end
	end

	local set = {}

	for k, item3 in pairs(item) do
		local item4 = item2[k]

		if item4 == nil or not deepEqual(item3, item4, p) then
			return false
		end

		set[k] = true
	end

	for k, _ in pairs(item2) do
		if not set[k] then
			return false
		end
	end

	return true
end

return deepEqual
