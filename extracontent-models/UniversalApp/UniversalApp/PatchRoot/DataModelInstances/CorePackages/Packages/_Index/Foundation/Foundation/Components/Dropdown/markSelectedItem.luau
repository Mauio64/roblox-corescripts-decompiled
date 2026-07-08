local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.BaseMenu)
require(Foundation.Components.Types)

local function markSelectedItem(p1, p2) -- line: 10
	-- upvalues: markSelectedItem (copy)
	if p2 == nil then
		return p1, nil
	end

	local t1 = {}
	local v6 = nil

	for _, v8 in p1 do
		if v8.id then
			local v9 = v8

			if p2 == v8.id then
				v9 = table.clone(v8)
				v9.isChecked = true
				v6 = v9
			end

			table.insert(t1, v9)
		elseif v8.items then
			local v10, v11 = markSelectedItem(v8.items, p2)

			table.insert(t1, {
				title = v8.title,
				items = v10
			})
			v6 = v6 or v11
		end
	end

	return t1, v6
end

return markSelectedItem
