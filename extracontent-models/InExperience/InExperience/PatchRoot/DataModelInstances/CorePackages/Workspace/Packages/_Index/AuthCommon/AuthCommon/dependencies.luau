local ParentParent = script.Parent.Parent

return {
	Analytics = require(ParentParent.Analytics),
	SharedFlags = require(ParentParent.SharedFlags)
}
