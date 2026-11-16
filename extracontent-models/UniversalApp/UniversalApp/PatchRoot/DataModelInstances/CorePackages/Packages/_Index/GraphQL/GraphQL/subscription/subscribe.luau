local parent = script.Parent.Parent
local parent2 = parent.Parent
require(parent2.LuauPolyfill)

require(parent.language.ast)

require(parent.execution.execute)

require(parent.type.schema)

require(parent.type.definition)
local Subscribe = {}

function Subscribe.subscribe(_)
	error("graphql-lua does not currently implement subscriptions")
end

function Subscribe.createSourceEventStream(_, _, _, _, _, _: string?, _)
	error("graphql-lua does not currently implement subscriptions")
end

return Subscribe
