local parent = script.Parent.Parent
require(parent.types)

return function(list, p: number, p2: number?, ...)
	if #list < p then
		for i = 1, select("#", ...) do
			table.insert(list, (select(i, ...)))
		end

		return {}
	else
		local count = #list

		if p < 1 then
			p = math.max(count - math.abs(p), 1)
		end

		local result = {}

		local v = p2 or count

		if v > 0 then
			for _ = p, math.min(count, p + math.max(0, v - 1)) do
				table.insert(result, (table.remove(list, p)))
			end
		end

		for i = select("#", ...), 1, -1 do
			table.insert(list, p, (select(i, ...)))
		end

		return result
	end
end
