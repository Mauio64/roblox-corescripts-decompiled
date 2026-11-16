local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)

local function moveItemToPositionInShop(p, p2: number, p3: string, p4, value: number)
	local v = p[p2]

	if v == nil then
		return p
	end

	local v2 = nil

	for k, item in v.items do
		if item.itemType == p4 and item.id == p3 then
			v2 = k
			break
		end
	end

	if v2 == nil then
		return p
	end

	local v3 = math.clamp(value, 1, #v.items)

	if v2 == v3 then
		return p
	end

	local item = v.items[v2]
	local clone = table.clone(v.items)
	table.remove(clone, v2)
	table.insert(clone, v3, item)

	local clone2 = table.clone(v)
	clone2.items = clone
	local clone3 = table.clone(p)
	clone3[p2] = clone2
	return clone3
end

return moveItemToPositionInShop
