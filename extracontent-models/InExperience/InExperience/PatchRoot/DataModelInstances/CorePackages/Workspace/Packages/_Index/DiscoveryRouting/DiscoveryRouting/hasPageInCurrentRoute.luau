return function(list, p, flag: boolean?): boolean
	if not list then
		return false
	end

	local count = #list

	if flag then
		count -= 1
	end

	for i = 1, count do
		if list[i].name == p then
			return true
		end
	end

	return false
end
