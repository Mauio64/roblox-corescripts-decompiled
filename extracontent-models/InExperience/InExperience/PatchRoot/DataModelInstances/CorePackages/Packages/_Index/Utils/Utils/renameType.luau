local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local GraphQLEnumType = GraphQL.GraphQLEnumType
local GraphQLInputObjectType = GraphQL.GraphQLInputObjectType
local GraphQLInterfaceType = GraphQL.GraphQLInterfaceType
local GraphQLObjectType = GraphQL.GraphQLObjectType
local GraphQLScalarType = GraphQL.GraphQLScalarType
local GraphQLUnionType = GraphQL.GraphQLUnionType
local isEnumType = GraphQL.isEnumType
local isInterfaceType = GraphQL.isInterfaceType
local isInputObjectType = GraphQL.isInputObjectType
local isObjectType = GraphQL.isObjectType
local isScalarType = GraphQL.isScalarType
local isUnionType = GraphQL.isUnionType

function t1.renameType(p1, s1: string) -- line: 52
	-- upvalues: Boolean (copy), isObjectType (copy), GraphQLObjectType (copy), Object (copy), Array (copy), isInterfaceType (copy), GraphQLInterfaceType (copy), isUnionType (copy), GraphQLUnionType (copy), isInputObjectType (copy), GraphQLInputObjectType (copy), isEnumType (copy), GraphQLEnumType (copy), isScalarType (copy), GraphQLScalarType (copy), Error (copy)
	if Boolean.toJSBoolean(isObjectType(p1)) then
		return GraphQLObjectType.new(Object.assign({}, p1:toConfig(), {
			name = s1,
			astNode = if p1.astNode ~= nil then Object.assign({}, p1.astNode, {
				name = Object.assign({}, p1.astNode.name, {
					value = s1
				})
			}) else p1.astNode,
			extensionASTNodes = if p1.extensionASTNodes ~= nil then Array.map(p1.extensionASTNodes, function(p2) -- line: 68
				-- upvalues: Object (copy), s1 (copy)
				return Object.assign({}, p2, {
					name = Object.assign({}, p2.name, {
						value = s1
					})
				})
			end) else p1.extensionASTNodes
		}))
	end

	if Boolean.toJSBoolean(isInterfaceType(p1)) then
		return GraphQLInterfaceType.new(Object.assign({}, p1:toConfig(), {
			name = s1,
			astNode = if p1.astNode ~= nil then Object.assign({}, p1.astNode, {
				name = Object.assign({}, p1.astNode.name, {
					value = s1
				})
			}) else p1.astNode,
			extensionASTNodes = if p1.extensionASTNodes ~= nil then Array.map(p1.extensionASTNodes, function(p3) -- line: 88
				-- upvalues: Object (copy), s1 (copy)
				return Object.assign({}, p3, {
					name = Object.assign({}, p3.name, {
						value = s1
					})
				})
			end) else p1.extensionASTNodes
		}))
	end

	if Boolean.toJSBoolean(isUnionType(p1)) then
		return GraphQLUnionType.new(Object.assign({}, p1:toConfig(), {
			name = s1,
			astNode = if p1.astNode ~= nil then Object.assign({}, p1.astNode, {
				name = Object.assign({}, p1.astNode.name, {
					value = s1
				})
			}) else p1.astNode,
			extensionASTNodes = if p1.extensionASTNodes ~= nil then Array.map(p1.extensionASTNodes, function(p4) -- line: 108
				-- upvalues: Object (copy), s1 (copy)
				return Object.assign({}, p4, {
					name = Object.assign({}, p4.name, {
						value = s1
					})
				})
			end) else p1.extensionASTNodes
		}))
	end

	if Boolean.toJSBoolean(isInputObjectType(p1)) then
		return GraphQLInputObjectType.new(Object.assign({}, p1:toConfig(), {
			name = s1,
			astNode = if p1.astNode ~= nil then Object.assign({}, p1.astNode, {
				name = Object.assign({}, p1.astNode.name, {
					value = s1
				})
			}) else p1.astNode,
			extensionASTNodes = if p1.extensionASTNodes ~= nil then Array.map(p1.extensionASTNodes, function(p5) -- line: 128
				-- upvalues: Object (copy), s1 (copy)
				return Object.assign({}, p5, {
					name = Object.assign({}, p5.name, {
						value = s1
					})
				})
			end) else p1.extensionASTNodes
		}))
	end

	if Boolean.toJSBoolean(isEnumType(p1)) then
		return GraphQLEnumType.new(Object.assign({}, p1:toConfig(), {
			name = s1,
			astNode = if p1.astNode ~= nil then Object.assign({}, p1.astNode, {
				name = Object.assign({}, p1.astNode.name, {
					value = s1
				})
			}) else p1.astNode,
			extensionASTNodes = if p1.extensionASTNodes ~= nil then Array.map(p1.extensionASTNodes, function(p6) -- line: 148
				-- upvalues: Object (copy), s1 (copy)
				return Object.assign({}, p6, {
					name = Object.assign({}, p6.name, {
						value = s1
					})
				})
			end) else p1.extensionASTNodes
		}))
	end

	if Boolean.toJSBoolean(isScalarType(p1)) then
		return GraphQLScalarType.new(Object.assign({}, p1:toConfig(), {
			name = s1,
			astNode = if p1.astNode ~= nil then Object.assign({}, p1.astNode, {
				name = Object.assign({}, p1.astNode.name, {
					value = s1
				})
			}) else p1.astNode,
			extensionASTNodes = if p1.extensionASTNodes ~= nil then Array.map(p1.extensionASTNodes, function(p7) -- line: 168
				-- upvalues: Object (copy), s1 (copy)
				return Object.assign({}, p7, {
					name = Object.assign({}, p7.name, {
						value = s1
					})
				})
			end) else p1.extensionASTNodes
		}))
	end

	error(Error.new(("Unknown type %s."):format((tostring(p1)))))
end

return t1
