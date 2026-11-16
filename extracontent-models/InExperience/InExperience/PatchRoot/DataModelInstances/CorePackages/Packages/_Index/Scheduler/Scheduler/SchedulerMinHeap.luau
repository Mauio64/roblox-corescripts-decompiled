local fn
local fn2
local fn3
local SchedulerMinHeap = {
	push = function(self, p)
		local v = #self + 1
		self[v] = p

		fn2(self, p, v)
	end,
	peek = function(list)
		return list[1]
	end,
	pop = function(self)
		local item = self[1]

		if item == nil then
			return nil
		end

		local item2 = self[#self]
		self[#self] = nil

		if item2 ~= item then
			self[1] = item2
			fn3(self, item2, 1)
		end

		return item
	end
}

fn2 = function(list, p, p2: number)
	while true do
		local v = math.floor(p2 / 2)
		local v2 = list[v]

		if v2 == nil or not (fn(v2, p) > 0) then
			break
		end

		list[v] = p
		list[p2] = v2
		p2 = v
	end
end

fn3 = function(list, item, p: number)
	local v = #list

	while p < v do
		local v2 = p * 2
		local item2 = list[v2]
		local v3 = v2 + 1
		local item3 = list[v3]

		if item2 == nil or not (fn(item2, item) < 0) then
			if item3 == nil or not (fn(item3, item) < 0) then
				break
			end

			list[p] = item3
			list[v3] = item
			p = v3
		elseif item3 == nil or not (fn(item3, item2) < 0) then
			list[p] = item2
			list[v2] = item
			p = v2
		else
			list[p] = item3
			list[v3] = item
			p = v3
		end
	end
end

fn = function(p, p2)
	local v = p.sortIndex - p2.sortIndex

	if v == 0 then
		return p.id - p2.id
	end

	return v
end

return SchedulerMinHeap
