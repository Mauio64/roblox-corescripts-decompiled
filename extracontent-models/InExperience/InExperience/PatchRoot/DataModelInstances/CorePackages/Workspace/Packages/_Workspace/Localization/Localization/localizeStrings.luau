local Parent = script:FindFirstAncestor("Localization").Parent
local ArgCheck = require(Parent.ArgCheck)

local function localizeStrings(p1, p2) -- line: 6
	-- upvalues: ArgCheck (copy)
	local t1 = {}

	for k, v in pairs(p2) do
		if typeof(v) == "table" then
			if typeof(v[1]) == "string" then
				local ok, result = pcall(function() -- line: 12
					-- upvalues: p1 (copy), v (copy)
					return p1:Format(v[1], v)
				end)

				ArgCheck.isEqual(ok, true, string.format("LocalizationConsumer finding value for translation key[%s]: %s", k, v[1]))
				t1[k] = ok and result or ""
			else
				error(string.format("%s[1] in stringsToBeLocalized must be a string, got %s instead", k, (typeof(v[1]))))
			end
		elseif typeof(v) == "string" then
			local ok, result = pcall(function() -- line: 37
				-- upvalues: p1 (copy), v (copy)
				return p1:Format(v)
			end)

			ArgCheck.isEqual(ok, true, string.format("LocalizationConsumer finding value for translation key[%s]: %s", k, v))
			t1[k] = ok and result or ""
		else
			error(string.format("%s in stringsToBeLocalized must be a string or table, got %s instead", k, (typeof(v))))
		end
	end

	return t1
end

return localizeStrings
