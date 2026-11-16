local module = require("@luauforge/bundled/fsl")

local function filterOutPasskeyUpsell(list)
	if typeof(list) ~= "table" or #list == 0 then
		return list
	end

	local result = {}

	for i = 1, #list do
		local item = list[i]

		if item and module.fromRawValue(item.promptType) ~= module.PasskeyUpsell then
			table.insert(result, item)
		end
	end

	return result
end

return filterOutPasskeyUpsell
