local parent = script.Parent.Parent
require(parent.types)

return function(list)
	return (table.freeze(list))
end
