local ParentParent = script.Parent.Parent

require(ParentParent.types)

return function(p1) -- line: 7
	return (table.freeze(p1))
end
