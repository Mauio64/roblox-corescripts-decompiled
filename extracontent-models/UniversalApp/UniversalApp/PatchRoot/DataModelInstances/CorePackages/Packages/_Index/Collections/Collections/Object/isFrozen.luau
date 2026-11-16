local __DEV__ = _G.__DEV__
local parent = script.Parent.Parent.Parent

require(parent.ES7Types)

return function(list)
	if __DEV__ then
		print("Luau now has a direct table.isfrozen call that can save the overhead of this library function call")
	end

	return table.isfrozen(list)
end
