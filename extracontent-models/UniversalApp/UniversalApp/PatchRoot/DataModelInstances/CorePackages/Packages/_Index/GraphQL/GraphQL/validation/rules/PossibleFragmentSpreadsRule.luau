local parent = script.Parent.Parent.Parent
local inspect = require(parent.jsutils.inspect)
local inspect2 = inspect.inspect
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local definition = require(parent.type.definition)
local isCompositeType = definition.isCompositeType
local utilities = parent.utilities
local typeFromAST = require(utilities.typeFromAST)
local typeFromAST2 = typeFromAST.typeFromAST
local typeComparators = require(utilities.typeComparators)
local doTypesOverlap = typeComparators.doTypesOverlap

local getFragmentType
local PossibleFragmentSpreadsRule = {
	PossibleFragmentSpreadsRule = function(object)
		return {
			InlineFragment = function(_, p)
				local kind = object:getType()
				local parentType = object:getParentType()

				if
					isCompositeType(kind)
					and isCompositeType(parentType)
					and not doTypesOverlap(object:getSchema(), kind, parentType)
				then
					local v = inspect2(parentType)
					local v2 = inspect2(kind)

					object:reportError(graphQLError.new(
						("Fragment cannot be spread here as objects of type \"%s\" can never be of type \"%s\"."):format(
							v,
							v2
						),
						p
					))
				end
			end,
			FragmentSpread = function(_, p)
				local value = p.name.value
				local v = getFragmentType(object, value)
				local parentType = object:getParentType()

				if v and parentType and not doTypesOverlap(object:getSchema(), v, parentType) then
					local v2 = inspect2(parentType)
					local v3 = inspect2(v)
					object:reportError(graphQLError.new(
						("Fragment \"%s\" cannot be spread here as objects of type \"%s\" can never be of type \"%s\"."):format(
							value,
							v2,
							v3
						),
						p
					))
				end
			end
		}
	end
}

getFragmentType = function(object, value: string)
	local fragment = object:getFragment(value)

	if fragment then
		local v = typeFromAST2(object:getSchema(), fragment.typeCondition)

		if isCompositeType(v) then
			return v
		end
	end

	return nil
end

return PossibleFragmentSpreadsRule
