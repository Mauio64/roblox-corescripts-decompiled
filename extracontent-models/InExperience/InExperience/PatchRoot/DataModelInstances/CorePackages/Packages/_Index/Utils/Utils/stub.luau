local parent = script.Parent.Parent
require(parent.LuauPolyfill)

local GraphQL = require(parent.GraphQL)
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

local function createNamedStub(name: string, p)
	local v

	if p == "object" then
		v = GraphQLObjectType
	elseif p == "interface" then
		v = GraphQLInterfaceType
	else
		v = GraphQLInputObjectType
	end

	return v.new({
		name = name,
		fields = {
			_fake = { type = GraphQLString }
		}
	})
end

local Stub = {}
Stub.createNamedStub = createNamedStub
local function createStub(kind, p)
	local kind2 = kind.kind

	if kind2 == Kind.LIST_TYPE then
		return GraphQLList.new(createStub(kind.type, p))
	end

	if kind2 == Kind.NON_NULL_TYPE then
		return GraphQLNonNull.new(createStub(kind.type, p))
	end

	if p == "output" then
		return createNamedStub(kind.name.value, "object")
	end

	return createNamedStub(kind.name.value, "input")
end

Stub.createStub = createStub

function Stub.isNamedStub(object): boolean
	if object.getFields ~= nil then
		local fields = object:getFields()

		for _, list in fields do
			return fields[tostring((table.unpack(list)))].name == "_fake"
		end
	end

	return false
end

function Stub.getBuiltInForStub(p)
	local name = p.name

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

	return if name == GraphQLID.name then GraphQLID else p
end
return Stub
