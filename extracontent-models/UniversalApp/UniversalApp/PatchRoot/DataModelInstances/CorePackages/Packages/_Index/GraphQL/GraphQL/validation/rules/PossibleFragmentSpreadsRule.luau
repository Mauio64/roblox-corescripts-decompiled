local ParentParent = script.Parent.Parent.Parent
local inspect = require(ParentParent.jsutils.inspect).inspect
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local isCompositeType = require(ParentParent.type.definition).isCompositeType
local utilities = ParentParent.utilities
local typeFromAST = require(utilities.typeFromAST).typeFromAST
local doTypesOverlap = require(utilities.typeComparators).doTypesOverlap
local t1 = {}
local getFragmentType = nil

function t1.PossibleFragmentSpreadsRule(p1) -- line: 31
	-- upvalues: isCompositeType (copy), doTypesOverlap (copy), inspect (copy), GraphQLError (copy), getFragmentType (ref)
	return {
		InlineFragment = function(_, p3) -- line: 33
			-- upvalues: p1 (copy), isCompositeType (copy), doTypesOverlap (copy), inspect (copy), GraphQLError (copy)
			local v17 = p1:getType()
			local v18 = p1:getParentType()

			if isCompositeType(v17) and (isCompositeType(v18) and not doTypesOverlap(p1:getSchema(), v17, v18)) then
				local v19 = inspect(v18)
				local v20 = inspect(v17)

				p1:reportError(GraphQLError.new(("Fragment cannot be spread here as objects of type \"%s\" can never be of type \"%s\"."):format(v19, v20), p3))
			end
		end,
		FragmentSpread = function(_, p5) -- line: 54
			-- upvalues: getFragmentType (ref), p1 (copy), doTypesOverlap (copy), inspect (copy), GraphQLError (copy)
			local value = p5.name.value
			local v24 = getFragmentType(p1, value)
			local v25 = p1:getParentType()

			if v24 and (v25 and not doTypesOverlap(p1:getSchema(), v24, v25)) then
				local v26 = inspect(v25)
				local v27 = inspect(v24)

				p1:reportError(GraphQLError.new(("Fragment \"%s\" cannot be spread here as objects of type \"%s\" can never be of type \"%s\"."):format(value, v26, v27), p5))
			end
		end
	}
end
function getFragmentType(p6, s1: string) -- line: 78
	-- upvalues: typeFromAST (copy), isCompositeType (copy)
	local v13 = p6:getFragment(s1)

	if v13 then
		local v14 = typeFromAST(p6:getSchema(), v13.typeCondition)

		if isCompositeType(v14) then
			return v14
		end
	end

	return nil
end

return t1
