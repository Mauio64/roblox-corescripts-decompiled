local set = {}

local function isPascalCase(value: string) -- 1 equivalent call inferred from this helper
	if set[value] then
		return true
	end

	if typeof(value) ~= "string" then
		return false
	end

	local v = value:sub(1, 1)
	local selected = v == v:upper()

	if selected then
		set[value] = true
	end

	return selected
end

local function mapServerBindingProps(items, p)
	local result = nil
	local result2 = nil

	for k, item in items do
		local v = p[k]

		if v == nil then
			if isPascalCase(k) then -- inferred equivalent call
				result = result or {}
				table.insert(result, k)
			end
		else
			result2 = result2 or {}
			result2[v] = item
		end
	end

	return result2, result
end

return mapServerBindingProps
