local ParentParent = script.Parent.Parent.Parent
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local isNillish = require(ParentParent.luaUtils.isNillish)
local isNillish2 = isNillish.isNillish
local isNotNillish = isNillish.isNotNillish

return {
	LoneSchemaDefinitionRule = function(p1) -- line: 24
		-- upvalues: isNillish2 (copy), isNotNillish (copy), GraphQLError (copy)
		local v7 = p1:getSchema()
		local astNode = nil

		if v7 then
			astNode = v7.astNode

			if isNillish2(astNode) then
				astNode = v7:getQueryType()
			end

			if isNillish2(astNode) then
				astNode = v7:getMutationType()
			end

			if isNillish2(astNode) then
				astNode = v7:getSubscriptionType()
			end
		end

		local n1 = 0

		return {
			SchemaDefinition = function(_, p3) -- line: 42
				-- upvalues: isNotNillish (copy), astNode (ref), p1 (copy), GraphQLError (copy), n1 (ref)
				if isNotNillish(astNode) then
					p1:reportError(GraphQLError.new("Cannot define a new schema within a schema extension.", p3))

					return
				end

				if n1 > 0 then
					p1:reportError(GraphQLError.new("Must provide only one schema definition.", p3))
				end

				n1 += 1
			end
		}
	end
}
