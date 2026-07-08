local ParentParent = script.Parent.Parent
local inspect = require(ParentParent.jsutils.inspect).inspect
local invariant = require(ParentParent.jsutils.invariant).invariant
local language = ParentParent.language

require(language.ast)

local Kind = require(ParentParent.language.kinds).Kind
local definition = require(ParentParent.type.definition)
local GraphQLList = definition.GraphQLList
local GraphQLNonNull = definition.GraphQLNonNull
local type = ParentParent.type

require(type.schema)

local function typeFromAST(p1, p2) -- line: 33
	-- upvalues: Kind (copy), typeFromAST (copy), GraphQLList (copy), GraphQLNonNull (copy), invariant (copy), inspect (copy)
	if p2.kind == Kind.LIST_TYPE then
		local v13 = typeFromAST(p1, p2.type)

		return v13 and GraphQLList.new(v13)
	end

	if p2.kind == Kind.NON_NULL_TYPE then
		local v14 = typeFromAST(p1, p2.type)

		return v14 and GraphQLNonNull.new(v14)
	end

	if p2.kind == Kind.NAMED_TYPE then
		return p1:getType(p2.name.value)
	end

	invariant(false, "Unexpected type node: " .. inspect(p2))

	return nil
end

return {
	typeFromAST = typeFromAST
}
