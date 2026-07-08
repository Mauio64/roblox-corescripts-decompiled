local GraphQLError = require(script.Parent.Parent.error.GraphQLError).GraphQLError

require(script.Parent.Parent.language.ast)
require(script.Parent.Parent.type.definition)
require(script.Parent.Parent.type.schema)

return {
	getOperationRootType = function(p1, p2) -- line: 22
		-- upvalues: GraphQLError (copy)
		if p2.operation == "query" then
			local v4 = p1:getQueryType()

			if not v4 then
				error(GraphQLError.new("Schema does not define the required query root type.", p2))
			end

			return v4
		end

		if p2.operation == "mutation" then
			local v5 = p1:getMutationType()

			if not v5 then
				error(GraphQLError.new("Schema is not configured for mutations.", p2))
			end

			return v5
		end

		if p2.operation == "subscription" then
			local v6 = p1:getSubscriptionType()

			if not v6 then
				error(GraphQLError.new("Schema is not configured for subscriptions.", p2))
			end

			return v6
		end

		error(GraphQLError.new("Can only have query, mutation and subscription operations.", p2))
	end
}
