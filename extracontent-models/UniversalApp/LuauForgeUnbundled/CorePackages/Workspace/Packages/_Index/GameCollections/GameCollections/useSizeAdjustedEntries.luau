local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")

return function(items, value, value2)
	return React.useMemo(function()
		local result = {}
		local flag = false

		for k, item in items do
			local spanOverride = item.spanOverride

			if spanOverride then
				local colSpan = spanOverride.colSpan or 1
				local rowSpan = spanOverride.rowSpan or 1
				table.insert(result, Cryo.Dictionary.join(item, {
					sizeOverride = UDim2.new(
						colSpan,
						(value or 0) * (colSpan - 1),
						rowSpan,
						(value2 or 0) * (rowSpan - 1)
					)
				}))
				flag = true
			else
				table.insert(result, item)
			end
		end

		if flag then
			return result
		end

		return items
	end, { items, value, value2 })
end
