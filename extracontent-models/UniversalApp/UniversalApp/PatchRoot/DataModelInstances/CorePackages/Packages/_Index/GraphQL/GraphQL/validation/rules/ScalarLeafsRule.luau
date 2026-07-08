local ParentParent = script.Parent.Parent.Parent
local jsutils = ParentParent.jsutils
local inspect = require(jsutils.inspect).inspect
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local definition = require(ParentParent.type.definition)
local getNamedType = definition.getNamedType
local isLeafType = definition.isLeafType

return {
	ScalarLeafsRule = function(p1) -- line: 25
		-- upvalues: isLeafType (copy), getNamedType (copy), inspect (copy), GraphQLError (copy)
		return {
			Field = function(_, p3) -- line: 27
				-- upvalues: p1 (copy), isLeafType (copy), getNamedType (copy), inspect (copy), GraphQLError (copy)
				local v11 = p1:getType()
				local selectionSet = p3.selectionSet

				if v11 then
					if isLeafType(getNamedType(v11)) then
						if selectionSet then
							local value = p3.name.value
							local v14 = inspect(v11)

							p1:reportError(GraphQLError.new(("Field \"%s\" must not have a selection since type \"%s\" has no subfields."):format(value, v14), selectionSet))

							return
						end
					elseif not selectionSet then
						local value = p3.name.value
						local v16 = inspect(v11)

						p1:reportError(GraphQLError.new(("Field \"%s\" of type \"%s\" must have a selection of subfields. Did you mean \"%s { ... }\"?"):format(value, v16, value), p3))
					end
				end
			end
		}
	end
}
