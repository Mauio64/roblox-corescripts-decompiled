local ParentParent = script.Parent.Parent
local t1 = {}
local parse = require(ParentParent.GraphQL).parse

require(script.Parent.Interfaces)

function t1.parseSelectionSet(s1: string, p1) -- line: 17
	-- upvalues: parse (copy)
	return parse(s1, p1).definitions[1].selectionSet
end

return t1
