local parent = script.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

return {
	UniqueOperationTypesRule = function(object)
		local schema = object:getSchema()
		local operationTypesByOperation = {}

		local v = schema
			and {
				query = schema:getQueryType(),
				mutation = schema:getMutationType(),
				subscription = schema:getSubscriptionType()
			}
			or {}

		local function checkOperationTypes(_, p): boolean
			local operationTypes = p.operationTypes or {}

			for _, operationType in ipairs(operationTypes) do
				local operation = operationType.operation
				local v2 = operationTypesByOperation[operation]

				if v[operation] then
					object:reportError(graphQLError.new(
						("Type for %s already defined in the schema. It cannot be redefined."):format(operation),
						operationType
					))
				elseif v2 then
					object:reportError(graphQLError.new(
						("There can be only one %s type in schema."):format(operation),
						{ v2, operationType }
					))
				else
					operationTypesByOperation[operation] = operationType
				end
			end

			return false
		end

		return { SchemaDefinition = checkOperationTypes, SchemaExtension = checkOperationTypes }
	end
}
