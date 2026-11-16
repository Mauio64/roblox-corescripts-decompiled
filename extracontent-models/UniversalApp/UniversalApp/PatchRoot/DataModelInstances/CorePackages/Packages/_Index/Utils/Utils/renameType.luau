local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object

local GraphQL = require(parent.GraphQL)
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
return {
	renameType = function(object, name: string)
		if Boolean.toJSBoolean(isObjectType(object)) then
			local new = GraphQLObjectType.new
			local assign = Object.assign
			local config = object:toConfig()
			local v = { name = name, astNode = 0, extensionASTNodes = 0 }
			local astNode

			if object.astNode == nil then
				astNode = object.astNode
			else
				astNode = Object.assign({}, object.astNode, {
					name = Object.assign({}, object.astNode.name, { value = name })
				})
			end

			v.astNode = astNode
			local extensionASTNodes

			if object.extensionASTNodes == nil then
				extensionASTNodes = object.extensionASTNodes
			else
				extensionASTNodes = Array.map(object.extensionASTNodes, function(p)
					return Object.assign({}, p, {
						name = Object.assign({}, p.name, { value = name })
					})
				end)
			end

			v.extensionASTNodes = extensionASTNodes
			return new(assign({}, config, v))
		elseif Boolean.toJSBoolean(isInterfaceType(object)) then
			local new = GraphQLInterfaceType.new
			local assign = Object.assign
			local config = object:toConfig()
			local v = { name = name, astNode = 0, extensionASTNodes = 0 }
			local astNode

			if object.astNode == nil then
				astNode = object.astNode
			else
				astNode = Object.assign({}, object.astNode, {
					name = Object.assign({}, object.astNode.name, { value = name })
				})
			end

			v.astNode = astNode
			local extensionASTNodes

			if object.extensionASTNodes == nil then
				extensionASTNodes = object.extensionASTNodes
			else
				extensionASTNodes = Array.map(object.extensionASTNodes, function(p)
					return Object.assign({}, p, {
						name = Object.assign({}, p.name, { value = name })
					})
				end)
			end

			v.extensionASTNodes = extensionASTNodes
			return new(assign({}, config, v))
		elseif Boolean.toJSBoolean(isUnionType(object)) then
			local new = GraphQLUnionType.new
			local assign = Object.assign
			local config = object:toConfig()
			local v = { name = name, astNode = 0, extensionASTNodes = 0 }
			local astNode

			if object.astNode == nil then
				astNode = object.astNode
			else
				astNode = Object.assign({}, object.astNode, {
					name = Object.assign({}, object.astNode.name, { value = name })
				})
			end

			v.astNode = astNode
			local extensionASTNodes

			if object.extensionASTNodes == nil then
				extensionASTNodes = object.extensionASTNodes
			else
				extensionASTNodes = Array.map(object.extensionASTNodes, function(p)
					return Object.assign({}, p, {
						name = Object.assign({}, p.name, { value = name })
					})
				end)
			end

			v.extensionASTNodes = extensionASTNodes
			return new(assign({}, config, v))
		elseif Boolean.toJSBoolean(isInputObjectType(object)) then
			local new = GraphQLInputObjectType.new
			local assign = Object.assign
			local config = object:toConfig()
			local v = { name = name, astNode = 0, extensionASTNodes = 0 }
			local astNode

			if object.astNode == nil then
				astNode = object.astNode
			else
				astNode = Object.assign({}, object.astNode, {
					name = Object.assign({}, object.astNode.name, { value = name })
				})
			end

			v.astNode = astNode
			local extensionASTNodes

			if object.extensionASTNodes == nil then
				extensionASTNodes = object.extensionASTNodes
			else
				extensionASTNodes = Array.map(object.extensionASTNodes, function(p)
					return Object.assign({}, p, {
						name = Object.assign({}, p.name, { value = name })
					})
				end)
			end

			v.extensionASTNodes = extensionASTNodes
			return new(assign({}, config, v))
		elseif Boolean.toJSBoolean(isEnumType(object)) then
			local new = GraphQLEnumType.new
			local assign = Object.assign
			local config = object:toConfig()
			local v = { name = name, astNode = 0, extensionASTNodes = 0 }
			local astNode

			if object.astNode == nil then
				astNode = object.astNode
			else
				astNode = Object.assign({}, object.astNode, {
					name = Object.assign({}, object.astNode.name, { value = name })
				})
			end

			v.astNode = astNode
			local extensionASTNodes

			if object.extensionASTNodes == nil then
				extensionASTNodes = object.extensionASTNodes
			else
				extensionASTNodes = Array.map(object.extensionASTNodes, function(p)
					return Object.assign({}, p, {
						name = Object.assign({}, p.name, { value = name })
					})
				end)
			end

			v.extensionASTNodes = extensionASTNodes
			return new(assign({}, config, v))
		else
			if not Boolean.toJSBoolean(isScalarType(object)) then
				error(Error.new(("Unknown type %s."):format((tostring(object)))))
				return
			end

			local new = GraphQLScalarType.new
			local assign = Object.assign
			local config = object:toConfig()
			local v = { name = name, astNode = 0, extensionASTNodes = 0 }
			local astNode

			if object.astNode == nil then
				astNode = object.astNode
			else
				astNode = Object.assign({}, object.astNode, {
					name = Object.assign({}, object.astNode.name, { value = name })
				})
			end

			v.astNode = astNode
			local extensionASTNodes

			if object.extensionASTNodes == nil then
				extensionASTNodes = object.extensionASTNodes
			else
				extensionASTNodes = Array.map(object.extensionASTNodes, function(p)
					return Object.assign({}, p, {
						name = Object.assign({}, p.name, { value = name })
					})
				end)
			end

			v.extensionASTNodes = extensionASTNodes
			return new(assign({}, config, v))
		end
	end
}
