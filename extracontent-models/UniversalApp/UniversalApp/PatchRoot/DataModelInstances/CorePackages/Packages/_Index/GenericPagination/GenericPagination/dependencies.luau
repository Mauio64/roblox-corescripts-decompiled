local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent

return {
	t = require(scriptParentParent.t),
	LinkedList = require(scriptParent.LinkedList),
	Promise = require(scriptParentParent.Promise)
}
