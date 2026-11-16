local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

return {
	SingleFieldSubscriptionsRule = function(object)
		return {
			OperationDefinition = function(_, data)
				if data.operation == "subscription" and #data.selectionSet.selections ~= 1 then
					object:reportError(graphQLError.new(
						data.name and ("Subscription \"%s\" must select only one top level field."):format(data.name.value) or "Anonymous Subscription must select only one top level field.",
						Array.slice(data.selectionSet.selections, 2)
					))
				end
			end
		}
	end
}
