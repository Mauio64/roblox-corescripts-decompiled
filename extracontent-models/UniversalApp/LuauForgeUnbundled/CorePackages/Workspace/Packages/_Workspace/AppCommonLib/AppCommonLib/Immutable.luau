local defineFastFlag = game:DefineFastFlag("ImmutableJoinDictionariesUseTableClone", false)

return {
	JoinDictionaries = function(...)
		local v5 = select("#", ...)

		if defineFastFlag and v5 > 0 then
			local clone = table.clone((select)(1, ...))

			for i = 2, v5 do
				local v6 = select(i, ...)

				for k, v7 in v6 do
					clone[k] = v7
				end
			end

			return clone
		else
			local result = {}

			for i = 1, v5 do
				local v6 = select(i, ...)

				for k, v7 in pairs(v6) do
					result[k] = v7
				end
			end

			return result
		end
	end,
	JoinLists = function(...)
		local result = {}

		for i = 1, select("#", ...) do
			local v5 = select(i, ...)
			local v6 = #result

			for j = 1, #v5 do
				result[v6 + j] = v5[j]
			end
		end

		return result
	end,
	Set = function(p2, p3, p4)
		local clone = table.clone(p2)
		clone[p3] = p4
		return clone
	end,
	Append = function(list, ...)
		local count = #list
		local result = {}

		for i = 1, count do
			result[i] = list[i]
		end

		for i = 1, select("#", ...) do
			result[count + i] = select(i, ...)
		end

		return result
	end,
	RemoveFromDictionary = function(items, ...)
		local result = {}

		for k, item in pairs(items) do
			local v5 = false

			for i = 1, select("#", ...) do
				if k == select(i, ...) then
					v5 = true
					break
				end
			end

			if not v5 then
				result[k] = item
			end
		end

		return result
	end,
	RemoveFromList = function(list, p2)
		local result = {}

		for i = 1, #list do
			if i ~= p2 then
				table.insert(result, list[i])
			end
		end

		return result
	end,
	RemoveRangeFromList = function(list, p2, p3)
		local result = {}

		for i = 1, #list do
			if i < p2 or p2 + p3 <= i then
				table.insert(result, list[i])
			end
		end

		return result
	end,
	RemoveValueFromList = function(list, p2)
		local result = {}

		for i = 1, #list do
			if list[i] ~= p2 then
				table.insert(result, list[i])
			end
		end

		return result
	end
}
