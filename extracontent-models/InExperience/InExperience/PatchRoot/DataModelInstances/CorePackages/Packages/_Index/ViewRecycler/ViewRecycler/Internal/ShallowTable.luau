local v = {}

function v.cloneFrozen(p)
	return (table.freeze(table.clone(p)))
end

function v.containsEqual(p, p2, items): boolean
	for _, item in items do
		if p[item] ~= p2[item] then
			return false
		end
	end

	return true
end

function v.optionalContainsEqual(p, p2, p3)
	if p == p2 then
		return true
	elseif p == nil or p2 == nil then
		return false
	else
		return (v.containsEqual(p, p2, p3))
	end
end

function v.equal(items, items2): boolean
	if items == items2 then
		return true
	end

	for k, item in items do
		if items2[k] ~= item then
			return false
		end
	end

	for k, item in items2 do
		if items[k] ~= item then
			return false
		end
	end

	return true
end

return table.freeze(v)
