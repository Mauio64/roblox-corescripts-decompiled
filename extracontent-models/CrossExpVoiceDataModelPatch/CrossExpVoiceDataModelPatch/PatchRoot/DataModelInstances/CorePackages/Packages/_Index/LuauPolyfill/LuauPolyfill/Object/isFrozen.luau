local ParentParent = script.Parent.Parent

require(ParentParent.types)

return function(p1) -- line: 7
	return table.isfrozen(p1)
end
