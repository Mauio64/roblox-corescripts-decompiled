local parent = script.Parent.Parent.Parent
local inspect = require(parent.jsutils.inspect)
local inspect2 = inspect.inspect
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local kinds = require(parent.language.kinds)
local kind = kinds.Kind
local definition = require(parent.type.definition)
local isNonNullType = definition.isNonNullType
local utilities = parent.utilities
local typeFromAST = require(utilities.typeFromAST)
local typeFromAST2 = typeFromAST.typeFromAST
local typeComparators = require(utilities.typeComparators)
local isTypeSubTypeOf = typeComparators.isTypeSubTypeOf

local allowedVariableUsage
local VariablesInAllowedPositionRule = {
	VariablesInAllowedPositionRule = function(object)
		local v = {}

		return {
			OperationDefinition = {
				enter = function()
					v = {}
				end,
				leave = function(_, p)
					local recursiveVariableUsages = object:getRecursiveVariableUsages(p)

					for _, recursiveVariableUsage in ipairs(recursiveVariableUsages) do
						local node = recursiveVariableUsage.node
						local kind2 = recursiveVariableUsage.type
						local defaultValue = recursiveVariableUsage.defaultValue
						local value = node.name.value
						local v2 = v[value]

						if not (v2 and kind2) then
							continue
						end

						local schema = object:getSchema()
						local v3 = typeFromAST2(schema, v2.type)

						if not v3 or allowedVariableUsage(schema, v3, v2.defaultValue, kind2, defaultValue) then
							continue
						end

						local v4 = inspect2(v3)
						local v5 = inspect2(kind2)

						object:reportError(graphQLError.new(
							("Variable \"$%s\" of type \"%s\" used in position expecting type \"%s\"."):format(
								value,
								v4,
								v5
							),
							{ v2, node }
						))
					end
				end
			},
			VariableDefinition = function(_, p)
				v[p.variable.name.value] = p
			end
		}
	end
}

allowedVariableUsage = function(schema, p, defaultValue, kind2, defaultValue2)
	if not isNonNullType(kind2) or isNonNullType(p) then
		return isTypeSubTypeOf(schema, p, kind2)
	end

	local v

	if defaultValue == nil then
		v = false
	else
		v = defaultValue.kind ~= kind.NULL
	end

	local v2 = defaultValue2 ~= nil

	if v or v2 then
		return isTypeSubTypeOf(schema, p, kind2.ofType)
	end

	return false
end

return VariablesInAllowedPositionRule
