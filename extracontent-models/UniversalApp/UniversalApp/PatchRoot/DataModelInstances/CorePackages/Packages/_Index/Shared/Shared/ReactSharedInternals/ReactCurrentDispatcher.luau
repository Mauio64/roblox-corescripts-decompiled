local ParentParent = script.Parent.Parent.Parent

require(ParentParent.LuauPolyfill)
require(script.Parent.Parent.ReactElementType)
require(script.Parent.Parent.ReactTypes)

return {
	current = nil
}
