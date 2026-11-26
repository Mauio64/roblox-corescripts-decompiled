return function(list, p2, p3): boolean
	if not list then
		return false
	end

	local count = #list

	if p3 then
		count -= 1
	end

	for i = 1, count do
		if list[i].name == p2 then
			return true
		end
	end

	return false
end
