local parent = script.Parent.Parent.Parent
local jsutils = parent.jsutils
local inspect = require(jsutils.inspect)
local inspect2 = inspect.inspect
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local definition = require(parent.type.definition)
local getNamedType = definition.getNamedType
local isLeafType = definition.isLeafType

return {
	ScalarLeafsRule = function(object)
		return {
			Field = function(_, p)
				local kind = object:getType()
				local selectionSet = p.selectionSet

				if kind then
					if isLeafType(getNamedType(kind)) then
						if selectionSet then
							local value = p.name.value
							local v = inspect2(kind)
							object:reportError(graphQLError.new(
								("Field \"%s\" must not have a selection since type \"%s\" has no subfields."):format(
									value,
									v
								),
								selectionSet
							))
						end
					elseif not selectionSet then
						local value = p.name.value
						local v = inspect2(kind)
						object:reportError(graphQLError.new(
							("Field \"%s\" of type \"%s\" must have a selection of subfields. Did you mean \"%s { ... }\"?"):format(
								value,
								v,
								value
							),
							p
						))
					end
				end
			end
		}
	end
}
