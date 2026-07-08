local ParentParent = script.Parent.Parent.Parent
local inspect = require(ParentParent.jsutils.inspect).inspect
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local Kind = require(ParentParent.language.kinds).Kind
local isNonNullType = require(ParentParent.type.definition).isNonNullType
local utilities = ParentParent.utilities
local typeFromAST = require(utilities.typeFromAST).typeFromAST
local isTypeSubTypeOf = require(utilities.typeComparators).isTypeSubTypeOf
local t1 = {}
local allowedVariableUsage = nil

function t1.VariablesInAllowedPositionRule(p1) -- line: 27
	-- upvalues: typeFromAST (copy), allowedVariableUsage (ref), inspect (copy), GraphQLError (copy)
	local t2 = {}

	return {
		OperationDefinition = {
			enter = function() -- line: 32
				-- upvalues: t2 (ref)
				t2 = {}
			end,
			leave = function(_, p3) -- line: 35
				-- upvalues: p1 (copy), t2 (ref), typeFromAST (copy), allowedVariableUsage (ref), inspect (copy), GraphQLError (copy)
				local v23 = p1:getRecursiveVariableUsages(p3)

				for _, v in ipairs(v23) do
					local node = v.node
					local type = v.type
					local defaultValue = v.defaultValue
					local value = node.name.value
					local v30 = t2[value]

					if v30 and type then
						local v31 = p1:getSchema()
						local v32 = typeFromAST(v31, v30.type)

						if v32 and not allowedVariableUsage(v31, v32, v30.defaultValue, type, defaultValue) then
							local v33 = inspect(v32)
							local v34 = inspect(type)

							p1:reportError(GraphQLError.new(("Variable \"$%s\" of type \"%s\" used in position expecting type \"%s\"."):format(value, v33, v34), {
								v30,
								node
							}))
						end
					end
				end
			end
		},
		VariableDefinition = function(_, p5) -- line: 79
			-- upvalues: t2 (ref)
			t2[p5.variable.name.value] = p5
		end
	}
end
function allowedVariableUsage(p6, p7, p8, p9, p10) -- line: 90
	-- upvalues: isNonNullType (copy), Kind (copy), isTypeSubTypeOf (copy)
	if isNonNullType(p9) and not isNonNullType(p7) then
		local v18 = p8 ~= nil and p8.kind ~= Kind.NULL
		local v19 = p10 ~= nil

		if not v18 and not v19 then
			return false
		end

		local ofType = p9.ofType

		return isTypeSubTypeOf(p6, p7, ofType)
	end

	return isTypeSubTypeOf(p6, p7, p9)
end

return t1
