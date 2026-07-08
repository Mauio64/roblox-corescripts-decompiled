local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Array = require(ParentParentParent.LuauPolyfill).Array
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError

return {
	SingleFieldSubscriptionsRule = function(p1) -- line: 23
		-- upvalues: GraphQLError (copy), Array (copy)
		return {
			OperationDefinition = function(_, p3) -- line: 25
				-- upvalues: p1 (copy), GraphQLError (copy), Array (copy)
				if p3.operation == "subscription" and #p3.selectionSet.selections ~= 1 then
					p1:reportError(GraphQLError.new(p3.name and ("Subscription \"%s\" must select only one top level field."):format(p3.name.value) or "Anonymous Subscription must select only one top level field.", Array.slice(p3.selectionSet.selections, 2)))
				end
			end
		}
	end
}
