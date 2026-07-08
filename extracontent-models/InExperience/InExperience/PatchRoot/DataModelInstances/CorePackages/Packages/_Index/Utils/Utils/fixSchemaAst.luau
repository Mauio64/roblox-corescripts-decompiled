local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}
local buildASTSchema = require(ParentParent.GraphQL).buildASTSchema

require(script.Parent.types)

local getDocumentNodeFromSchema = require(script.Parent["print-schema-with-directives"]).getDocumentNodeFromSchema

local function buildFixedSchema(p1, p2) -- line: 24
	-- upvalues: getDocumentNodeFromSchema (copy), buildASTSchema (copy), Object (copy), Boolean (copy)
	local v11 = getDocumentNodeFromSchema(p1)

	return buildASTSchema(v11, Object.assign({}, Boolean.toJSBoolean(p2) and p2 or {}))
end

function t1.fixSchemaAst(p3, p4) -- line: 28
	-- upvalues: Boolean (copy), buildFixedSchema (copy)
	local v14 = nil

	if not Boolean.toJSBoolean(p3.astNode) or not Boolean.toJSBoolean(p3.extensionASTNodes) then
		v14 = buildFixedSchema(p3, p4)
	end

	if not Boolean.toJSBoolean(p3.astNode) and v14 and Boolean.toJSBoolean(v14.astNode) then
		p3.astNode = v14.astNode
	end

	if not Boolean.toJSBoolean(p3.extensionASTNodes) and v14 and Boolean.toJSBoolean(v14.astNode) then
		p3.extensionASTNodes = v14.extensionASTNodes
	end

	return p3
end

return t1
