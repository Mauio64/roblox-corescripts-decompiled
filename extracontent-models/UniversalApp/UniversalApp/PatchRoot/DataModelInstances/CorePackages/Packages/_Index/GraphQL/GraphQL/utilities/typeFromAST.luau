local parent = script.Parent.Parent
local inspect = require(parent.jsutils.inspect)
local inspect2 = inspect.inspect
local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local language = parent.language
require(language.ast)

local kinds = require(parent.language.kinds)
local kind = kinds.Kind
local definition = require(parent.type.definition)
local graphQLList = definition.GraphQLList
local graphQLNonNull = definition.GraphQLNonNull

local kind2 = parent.type
require(kind2.schema)
local function typeFromAST(object, kind3)
	if kind3.kind == kind.LIST_TYPE then
		local v = typeFromAST(object, kind3.type)
		return v and graphQLList.new(v)
	end

	if kind3.kind == kind.NON_NULL_TYPE then
		local v = typeFromAST(object, kind3.type)
		return v and graphQLNonNull.new(v)
	end

	if kind3.kind == kind.NAMED_TYPE then
		return object:getType(kind3.name.value)
	end

	invariant2(false, "Unexpected type node: " .. inspect2(kind3))
	return nil
end

return { typeFromAST = typeFromAST }
