local parent = script.Parent.Parent.Parent

require(parent.ES7Types)

return function(list)
	return (table.freeze(list))
end
