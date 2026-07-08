local __DEV__ = _G.__DEV__
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.ES7Types)

return function(p1) -- line: 24
	-- upvalues: __DEV__ (copy)
	if __DEV__ then
		print("Luau now has a direct table.isfrozen call that can save the overhead of this library function call")
	end

	return table.isfrozen(p1)
end
