local PinSeparation = {}

function PinSeparation.resolve(p, data)
	local clone = table.clone(p)
	table.sort(clone, function(a, b): boolean
		if a.priority == b.priority then
			return a.id < b.id
		end

		return a.priority > b.priority
	end)

	local previouslyHidden = data.previouslyHidden or {}
	local hysteresis = data.hysteresis or 0
	local v = {}
	local idSet = {}

	for _, v2 in clone do
		local v3 = data.minDistance + (not previouslyHidden[v2.id] and 0 or hysteresis)
		local flag = false

		for _, v4 in v do
			if (v2.position - v4.position).Magnitude < v3 then
				flag = true
				break
			end
		end

		if flag then
			idSet[v2.id] = true
		else
			table.insert(v, v2)
		end
	end

	return idSet
end

function PinSeparation.pinStatesEqual(items, items2): boolean
	for k, item in items do
		local item2 = items2[k]

		if
			not item2
			or item2.position ~= item.position
			or item2.opacity ~= item.opacity
			or item2.isFocused ~= item.isFocused
		then
			return false
		end
	end

	for k in items2 do
		if not items[k] then
			return false
		end
	end

	return true
end

return PinSeparation
