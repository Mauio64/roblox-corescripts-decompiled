local GraphQLError = require(script.Parent.Parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

require(script.Parent.Parent.language.ast)

require(script.Parent.Parent.type.definition)

require(script.Parent.Parent.type.schema)

return {
	getOperationRootType = function(object, p)
		if p.operation == "query" then
			local queryType = object:getQueryType()

			if not queryType then
				error(graphQLError.new("Schema does not define the required query root type.", p))
			end

			return queryType
		elseif p.operation == "mutation" then
			local mutationType = object:getMutationType()

			if not mutationType then
				error(graphQLError.new("Schema is not configured for mutations.", p))
			end

			return mutationType
		else
			if p.operation ~= "subscription" then
				error(graphQLError.new("Can only have query, mutation and subscription operations.", p))
				return
			end

			local subscriptionType = object:getSubscriptionType()

			if not subscriptionType then
				error(graphQLError.new("Schema is not configured for subscriptions.", p))
			end

			return subscriptionType
		end
	end
}
