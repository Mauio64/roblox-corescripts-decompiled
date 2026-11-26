return function(p2, list)
	local item = list[#list]

	if not item then
		return
	end

	for i = #item, 1, -1 do
		if item[i].name == p2 then
			return i
		end
	end
end
