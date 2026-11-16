return {
	Filter = function(list, callback)
		local result = {}

		for i = 1, #list do
			local item = list[i]

			if callback(item, i) then
				table.insert(result, item)
			end
		end

		return result
	end,
	Map = function(list, callback)
		local result = {}

		for i = 1, #list do
			result[i] = callback(list[i], i)
		end

		return result
	end,
	MapReverse = function(list, callback)
		local result = {}

		for i = #list, 1, -1 do
			result[i] = callback(list[i], i)
		end

		return result
	end,
	FilterMap = function(list, callback)
		local result = {}

		for i = 1, #list do
			local v5 = callback(list[i], i)

			if v5 ~= nil then
				table.insert(result, v5)
			end
		end

		return result
	end,
	Fold = function(list, p2, callback)
		for i = 1, #list do
			p2 = callback(p2, list[i], i)
		end

		return p2
	end,
	FoldDictionary = function(items, p2, callback)
		for k, item in pairs(items) do
			p2 = callback(p2, k, item)
		end

		return p2
	end,
	Take = function(list, p2, value)
		local v5 = value or 1

		local v6 = p2 + (v5 - 1)

		local result = {}

		for i = v5, #list < v6 and #list or v6 do
			local item = list[i]
			result[i - (v5 - 1)] = item
		end

		return result
	end,
	Find = function(list, p2)
		for i, item in ipairs(list) do
			if item == p2 then
				return i
			end
		end

		return nil
	end
}
