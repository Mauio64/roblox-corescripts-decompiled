local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.BaseMenu)
require(Foundation.Components.Types)
local function markSelectedItem(items, p)
	if p == nil then
		return items, nil
	end

	local result = {}
	local v = nil

	for _, clone in items do
		if clone.id then
			if clone.id == p then
				clone = table.clone(clone)
				clone.isChecked = true
				v = clone
			end

			table.insert(result, clone)
		elseif clone.items then
			local items2, v2 = markSelectedItem(clone.items, p)
			table.insert(result, { title = clone.title, items = items2 })
			v = v or v2
		end
	end

	return result, v
end

return markSelectedItem
