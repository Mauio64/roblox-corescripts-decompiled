local parent = script.Parent.Parent.Parent
require(parent.ES7Types)

return function(list, callback)
	for i = 1, #list do
		local item = list[i]

		if callback(item, i, list) then
			return item
		end
	end

	return nil
end
