local function formatTextWithParams(value: string, items)
	if items ~= nil then
		for k, item in pairs(items) do
			local formatted = ("{%s}"):format(k)
			value = string.gsub(value, formatted, function()
				return item
			end)
		end
	end

	return value
end

return formatTextWithParams
