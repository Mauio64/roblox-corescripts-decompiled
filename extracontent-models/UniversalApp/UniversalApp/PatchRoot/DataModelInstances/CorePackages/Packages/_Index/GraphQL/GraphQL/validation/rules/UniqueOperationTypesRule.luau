local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError

return {
	UniqueOperationTypesRule = function(p1) -- line: 19
		-- upvalues: GraphQLError (copy)
		local v4 = p1:getSchema()
		local t1 = {}
		local v6 = v4 and {
			query = v4:getQueryType(),
			mutation = v4:getMutationType(),
			subscription = v4:getSubscriptionType()
		} or {}

		local function checkOperationTypes(_, p3) -- line: 32
			-- upvalues: t1 (copy), v6 (copy), p1 (copy), GraphQLError (copy)
			local v10 = p3.operationTypes or {}

			for _, v in ipairs(v10) do
				local operation = v.operation
				local v14 = t1[operation]

				if v6[operation] then
					p1:reportError(GraphQLError.new(("Type for %s already defined in the schema. It cannot be redefined."):format(operation), v))
				elseif v14 then
					p1:reportError(GraphQLError.new(("There can be only one %s type in schema."):format(operation), {
						v14,
						v
					}))
				else
					t1[operation] = v
				end
			end

			return false
		end

		return {
			SchemaDefinition = checkOperationTypes,
			SchemaExtension = checkOperationTypes
		}
	end
}
