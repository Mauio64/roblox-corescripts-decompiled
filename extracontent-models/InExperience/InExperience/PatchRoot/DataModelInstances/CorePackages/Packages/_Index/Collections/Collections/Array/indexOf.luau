local parent = script.Parent.Parent.Parent
require(parent.ES7Types)

return function(list, p, value: number?)
	local v = value or 1
	local count = #list

	if v < 1 then
		v = math.max(count - math.abs(v), 1)
	end

	for i = v, count do
		if list[i] == p then
			return i
		end
	end

	return -1
end
