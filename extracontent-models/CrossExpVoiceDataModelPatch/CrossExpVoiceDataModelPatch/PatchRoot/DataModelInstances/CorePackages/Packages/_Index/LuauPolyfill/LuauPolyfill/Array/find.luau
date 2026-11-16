local parent = script.Parent.Parent
require(parent.types)

return function(list, callback)
	for i = 1, #list do
		local item = list[i]

		if callback(item, i, list) then
			return item
		end
	end

	return nil
end
