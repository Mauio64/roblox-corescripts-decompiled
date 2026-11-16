local parent = script.Parent.Parent.Parent

local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

local isNillish = require(parent.luaUtils.isNillish)
local isNillish2 = isNillish.isNillish
local isNotNillish = isNillish.isNotNillish

return {
	LoneSchemaDefinitionRule = function(object)
		local schema = object:getSchema()
		local v

		if schema then
			v = schema.astNode

			if isNillish2(v) then
				v = schema:getQueryType()
			end

			if isNillish2(v) then
				v = schema:getMutationType()
			end

			if isNillish2(v) then
				v = schema:getSubscriptionType()
			end
		else
			v = nil
		end

		local count = 0
		return {
			SchemaDefinition = function(_, p)
				if isNotNillish(v) then
					object:reportError(graphQLError.new("Cannot define a new schema within a schema extension.", p))

					return
				end

				if count > 0 then
					object:reportError(graphQLError.new("Must provide only one schema definition.", p))
				end

				count += 1
			end
		}
	end
}
