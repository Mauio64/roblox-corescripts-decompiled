local parent = script.Parent.Parent
local SelectionSets = {}
local GraphQL = require(parent.GraphQL)

local parse = GraphQL.parse

require(script.Parent.Interfaces)

function SelectionSets.parseSelectionSet(p: string, p2)
	return parse(p, p2).definitions[1].selectionSet
end
return SelectionSets
