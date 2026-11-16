local set = {}

local function isPascalCase(value)
	if set[value] then
		return true
	end

	if typeof(value) ~= "string" then
		return false
	end

	local v5 = value:sub(1, 1)
	local v6 = v5 == v5:upper()

	if v6 then
		set[value] = true
	end

	return v6
end

local function mapServerBindingProps(items, p2)
	local result = nil
	local result2 = nil

	for k, item in items do
		local v5 = p2[k]

		if v5 == nil then
			local v6

			if set[k] then
				v6 = true
			elseif typeof(k) == "string" then
				local v7 = k:sub(1, 1)
				v6 = v7 == v7:upper()

				if v6 then
					set[k] = true
				end
			else
				v6 = false
			end

			if v6 then
				result = result or {}
				table.insert(result, k)
			end
		else
			result2 = result2 or {}
			result2[v5] = item
		end
	end

	return result2, result
end

return mapServerBindingProps
