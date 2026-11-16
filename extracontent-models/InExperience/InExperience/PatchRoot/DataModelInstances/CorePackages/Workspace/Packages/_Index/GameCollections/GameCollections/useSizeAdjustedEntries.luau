local parent = script:FindFirstAncestor("GameCollections").Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)

return function(items, value: number?, value2: number?)
	return React.useMemo(function()
		local result = {}
		local flag = false

		for _, item in items do
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

		return if flag then result else items
	end, { items, value, value2 })
end
