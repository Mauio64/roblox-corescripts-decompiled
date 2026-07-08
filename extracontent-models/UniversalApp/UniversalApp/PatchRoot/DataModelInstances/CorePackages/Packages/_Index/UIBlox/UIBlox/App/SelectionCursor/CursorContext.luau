local ParentParent = script.Parent.Parent.Parent.Parent

return (require(ParentParent.React).createContext({
	getCursor = function() -- line: 5
		return nil
	end,
	getCursorByType = function() -- line: 8
		return nil
	end
}))
