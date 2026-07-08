local ParentParent = script.Parent.Parent

require(ParentParent.LuauPolyfill)

local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local GraphQLObjectType = GraphQL.GraphQLObjectType
local GraphQLInterfaceType = GraphQL.GraphQLInterfaceType
local GraphQLInputObjectType = GraphQL.GraphQLInputObjectType
local GraphQLString = GraphQL.GraphQLString
local GraphQLInt = GraphQL.GraphQLInt
local GraphQLFloat = GraphQL.GraphQLFloat
local GraphQLBoolean = GraphQL.GraphQLBoolean
local GraphQLID = GraphQL.GraphQLID
local Kind = GraphQL.Kind
local GraphQLList = GraphQL.GraphQLList
local GraphQLNonNull = GraphQL.GraphQLNonNull

local function createNamedStub(s1: string, p1) -- line: 68
	-- upvalues: GraphQLObjectType (copy), GraphQLInterfaceType (copy), GraphQLInputObjectType (copy), GraphQLString (copy)
	return ((if p1 ~= "object" then (if p1 ~= "interface" then GraphQLInputObjectType else GraphQLInterfaceType) else GraphQLObjectType)).new({
		name = s1,
		fields = {
			_fake = {
				type = GraphQLString
			}
		}
	})
end

t1.createNamedStub = createNamedStub

local function createStub(p2, p3) -- line: 96
	-- upvalues: Kind (copy), GraphQLList (copy), createStub (copy), GraphQLNonNull (copy), createNamedStub (copy)
	local kind = p2.kind

	if kind == Kind.LIST_TYPE then
		return GraphQLList.new(createStub(p2.type, p3))
	end

	if kind == Kind.NON_NULL_TYPE then
		return GraphQLNonNull.new(createStub(p2.type, p3))
	end

	if p3 == "output" then
		return createNamedStub(p2.name.value, "object")
	end

	return createNamedStub(p2.name.value, "input")
end

t1.createStub = createStub

function t1.isNamedStub(p4) -- line: 125
	if p4.getFields ~= nil then
		local v23 = p4:getFields()

		for _, v25 in v23 do
			return v23[tostring((table.unpack(v25)))].name == "_fake"
		end
	end

	return false
end
function t1.getBuiltInForStub(p5) -- line: 149
	-- upvalues: GraphQLInt (copy), GraphQLFloat (copy), GraphQLString (copy), GraphQLBoolean (copy), GraphQLID (copy)
	local name = p5.name

	if name == GraphQLInt.name then
		return GraphQLInt
	end

	if name == GraphQLFloat.name then
		return GraphQLFloat
	end

	if name == GraphQLString.name then
		return GraphQLString
	end

	if name == GraphQLBoolean.name then
		return GraphQLBoolean
	end

	if name == GraphQLID.name then
		return GraphQLID
	end

	return p5
end

return t1
