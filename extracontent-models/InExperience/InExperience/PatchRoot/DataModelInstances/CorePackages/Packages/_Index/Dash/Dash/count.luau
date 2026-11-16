local function fn(): boolean
	return true
end

local function count(items, callback)
	local v = callback or fn
	local count2 = 0

	for k, item in items do
		if v(item, k) then
			count2 += 1
		end
	end

	return count2
end

return count
