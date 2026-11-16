local ItemKeyRegistry = require(script.Parent.ItemKeyRegistry)

local function validateUnique(items, p: string)
	local formatted = `{p}: keys must be strings`
	local result = {}

	for _, item in items do
		assert(type(item) == "string", formatted)

		if result[item] ~= nil then
			assert(false, `{p}: duplicate key "{item}"`)
		end

		result[item] = true
	end

	return result
end

return {
	validateUnique = validateUnique,
	keysFor = function(list, callback)
		local result = table.create(#list)

		for k, item in list do
			local v

			if callback == nil then
				v = ItemKeyRegistry.generatedKey()
			else
				v = callback(item, k)
			end

			result[k] = v
		end

		return result, validateUnique(result, "DataSource")
	end
}
