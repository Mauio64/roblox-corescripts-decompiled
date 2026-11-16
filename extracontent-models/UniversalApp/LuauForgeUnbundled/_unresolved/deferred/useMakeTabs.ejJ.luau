local useLocalization = require("@luauforge/deferred/ejK").Hooks.useLocalization

local function useMakeTabs(items)
	local textKeysById = {}

	for k, item in items do
		textKeysById[item.id] = item.textKey
	end

	local v5 = useLocalization(textKeysById)

	local result = {}

	for k, item in items do
		table.insert(result, { id = item.id, text = v5[item.id] })
	end

	return result
end

return useMakeTabs
