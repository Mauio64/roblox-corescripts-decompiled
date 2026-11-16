local function createShallowEqualAndTables(items)
	local set = {}

	for _, item in items do
		set[item] = true
	end

	return function(items2, items3): boolean
		for k, item in items2 do
			local item2 = items3[k]

			if set[k] then
				if typeof(item) ~= "table" or typeof(item2) ~= "table" then
					return false
				end

				for k2, v in item do
					if v ~= item2[k2] then
						return false
					end
				end

				for k2, _ in item2 do
					if item[k2] == nil then
						return false
					end
				end
			elseif item ~= item2 then
				return false
			end
		end

		for k, _ in items3 do
			if items2[k] == nil then
				return false
			end
		end

		return true
	end
end

return createShallowEqualAndTables
