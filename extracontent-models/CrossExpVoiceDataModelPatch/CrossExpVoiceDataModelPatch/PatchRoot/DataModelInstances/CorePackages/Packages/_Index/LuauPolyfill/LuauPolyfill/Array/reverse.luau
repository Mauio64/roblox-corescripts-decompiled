local parent = script.Parent.Parent
require(parent.types)

return function(list)
	local count = #list
	local v = 1

	while v < count do
		local item = list[count]
		local item2 = list[v]
		list[v] = item
		list[count] = item2
		v += 1
		count -= 1
	end

	return list
end
