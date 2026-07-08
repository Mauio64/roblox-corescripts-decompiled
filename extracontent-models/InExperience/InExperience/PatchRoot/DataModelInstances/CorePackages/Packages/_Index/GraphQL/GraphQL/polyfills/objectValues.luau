local ParentParent = script.Parent.Parent.Parent

return {
	objectValues = require(ParentParent.LuauPolyfill).Object.values
}
