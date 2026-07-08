local ParentParent = script.Parent.Parent.Parent

require(ParentParent.ES7Types)

return function(p1) -- line: 23
	return (table.freeze(p1))
end
