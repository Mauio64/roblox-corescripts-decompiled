local parent = script:FindFirstAncestor("Localization").Parent
local ArgCheck = require(parent.ArgCheck)

local function localizeStrings(object, items)
	local result = {}

	for k, item in pairs(items) do
		if typeof(item) == "table" then
			if typeof(item[1]) == "string" then
				local success, result2 = pcall(function()
					return object:Format(item[1], item)
				end)

				ArgCheck.isEqual(
					success,
					true,
					string.format("LocalizationConsumer finding value for translation key[%s]: %s", k, item[1])
				)

				result[k] = success and result2 or ""
			else
				error(string.format(
					"%s[1] in stringsToBeLocalized must be a string, got %s instead",
					k,
					(typeof(item[1]))
				))
			end
		elseif typeof(item) == "string" then
			local success, result2 = pcall(function()
				return object:Format(item)
			end)

			ArgCheck.isEqual(
				success,
				true,
				string.format("LocalizationConsumer finding value for translation key[%s]: %s", k, item)
			)

			result[k] = success and result2 or ""
		else
			error(string.format(
				"%s in stringsToBeLocalized must be a string or table, got %s instead",
				k,
				(typeof(item))
			))
		end
	end

	return result
end

return localizeStrings
