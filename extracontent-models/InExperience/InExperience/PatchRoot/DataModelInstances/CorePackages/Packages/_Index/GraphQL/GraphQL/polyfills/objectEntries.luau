local ParentParent = script.Parent.Parent.Parent

return {
	objectEntries = require(ParentParent.LuauPolyfill).Object.entries
}
