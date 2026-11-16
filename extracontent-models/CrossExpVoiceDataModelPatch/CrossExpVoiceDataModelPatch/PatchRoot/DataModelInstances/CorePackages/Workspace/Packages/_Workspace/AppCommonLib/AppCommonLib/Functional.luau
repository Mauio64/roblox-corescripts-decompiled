local Functional = {}

function Functional.Filter(list, callback)
	local result = {}

	for i = 1, #list do
		local item = list[i]

		if callback(item, i) then
			table.insert(result, item)
		end
	end

	return result
end

function Functional.Map(list, callback)
	local result = {}

	for i = 1, #list do
		result[i] = callback(list[i], i)
	end

	return result
end

function Functional.MapReverse(list, callback)
	local result = {}

	for i = #list, 1, -1 do
		result[i] = callback(list[i], i)
	end

	return result
end

function Functional.FilterMap(list, callback)
	local result = {}

	for i = 1, #list do
		local v = callback(list[i], i)

		if v ~= nil then
			table.insert(result, v)
		end
	end

	return result
end

function Functional.Fold(list, p, callback)
	for i = 1, #list do
		p = callback(p, list[i], i)
	end

	return p
end

function Functional.FoldDictionary(items, p, callback)
	for k, item in pairs(items) do
		p = callback(p, k, item)
	end

	return p
end

function Functional.Take(list, p, value)
	value = value or 1

	local v = p + (value - 1)

	local result = {}

	for i = value, #list < v and #list or v do
		local item = list[i]
		result[i - (value - 1)] = item
	end

	return result
end

function Functional.Find(list, p)
	for i, item in ipairs(list) do
		if item == p then
			return i
		end
	end

	return nil
end

return Functional
