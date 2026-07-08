local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.LuauPolyfill)
require(ParentParent.language.ast)
require(ParentParent.execution.execute)
require(ParentParent.type.schema)
require(ParentParent.type.definition)

return {
	subscribe = function(_: {[any]: any}) -- line: 35
		error("graphql-lua does not currently implement subscriptions")
	end,
	createSourceEventStream = function(_, _, _, _, _: {[any]: any}?, _: string?, _) -- line: 39
		error("graphql-lua does not currently implement subscriptions")
	end
}
