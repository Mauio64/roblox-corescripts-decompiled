local parent = script.Parent
local parent2 = parent.Parent

return {
	t = require(parent2.t),
	LinkedList = require(parent.LinkedList),
	Promise = require(parent2.Promise)
}
