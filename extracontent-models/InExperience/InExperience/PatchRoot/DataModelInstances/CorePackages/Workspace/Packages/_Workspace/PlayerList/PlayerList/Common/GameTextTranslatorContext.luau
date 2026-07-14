local ParentParent = script.Parent.Parent.Parent

return (require(ParentParent.React).createContext(function(s1: string) -- line: 5
	return s1
end))
