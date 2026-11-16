local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local FixSchemaAst = {}
local GraphQL = require(parent.GraphQL)

local buildASTSchema = GraphQL.buildASTSchema

require(script.Parent.types)

local printschemawithdirectives = require(script.Parent["print-schema-with-directives"])
local getDocumentNodeFromSchema = printschemawithdirectives.getDocumentNodeFromSchema

local function buildFixedSchema(state, p)
	return buildASTSchema(getDocumentNodeFromSchema(state), Object.assign({}, Boolean.toJSBoolean(p) and p or {}))
end

function FixSchemaAst:fixSchemaAst(p)
	local v

	if not (Boolean.toJSBoolean(self.astNode) and Boolean.toJSBoolean(self.extensionASTNodes)) then
		v = buildFixedSchema(self, p)
	end

	if not Boolean.toJSBoolean(self.astNode) and v and Boolean.toJSBoolean(v.astNode) then
		self.astNode = v.astNode
	end

	if not Boolean.toJSBoolean(self.extensionASTNodes) and v and Boolean.toJSBoolean(v.astNode) then
		self.extensionASTNodes = v.extensionASTNodes
	end

	return self
end
return FixSchemaAst
