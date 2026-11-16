local Immutable = {}

function Immutable.JoinDictionaries(...)
	local result = {}

	for i = 1, select("#", ...) do
		local v = select(i, ...)

		for k, v2 in pairs(v) do
			result[k] = v2
		end
	end

	return result
end

function Immutable.JoinLists(...)
	local result = {}

	for i = 1, select("#", ...) do
		local v = select(i, ...)
		local v2 = #result

		for j = 1, #v do
			result[v2 + j] = v[j]
		end
	end

	return result
end

function Immutable.Set(p, p2, p3)
	local clone = table.clone(p)
	clone[p2] = p3
	return clone
end

function Immutable.Append(list, ...)
	local count = #list
	local result = {}

	for i = 1, count do
		result[i] = list[i]
	end

	for i = 1, select("#", ...) do
		result[count + i] = select(i, ...)
	end

	return result
end

function Immutable.RemoveFromDictionary(items, ...)
	local result = {}

	for k, item in pairs(items) do
		local v = false

		for i = 1, select("#", ...) do
			if k == select(i, ...) then
				v = true
				break
			end
		end

		if not v then
			result[k] = item
		end
	end

	return result
end

function Immutable.RemoveFromList(list, p)
	local result = {}

	for i = 1, #list do
		if i ~= p then
			table.insert(result, list[i])
		end
	end

	return result
end

function Immutable.RemoveRangeFromList(list, p, p2)
	local result = {}

	for i = 1, #list do
		if i < p or p + p2 <= i then
			table.insert(result, list[i])
		end
	end

	return result
end

function Immutable.RemoveValueFromList(list, p)
	local result = {}

	for i = 1, #list do
		if list[i] ~= p then
			table.insert(result, list[i])
		end
	end

	return result
end

return Immutable
