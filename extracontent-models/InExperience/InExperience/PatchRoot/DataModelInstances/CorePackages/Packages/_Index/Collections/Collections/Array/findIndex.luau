local parent = script.Parent.Parent.Parent
require(parent.ES7Types)

return function(list, callback)
	for i = 1, #list do
		if callback(list[i], i, list) then
			return i
		end
	end

	return -1
end
