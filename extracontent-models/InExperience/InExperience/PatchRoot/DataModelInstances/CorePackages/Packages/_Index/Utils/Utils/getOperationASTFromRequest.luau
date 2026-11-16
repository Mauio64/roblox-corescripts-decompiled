local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error

local GraphQL = require(parent.GraphQL)

local getOperationAST = GraphQL.getOperationAST

require(script.Parent.Interfaces)

local memoize = require(script.Parent.memoize)

local function getOperationASTFromDocument(document, operationName: string?)
	local operationAST = getOperationAST(document, operationName)

	if not Boolean.toJSBoolean(operationAST) then
		error(Error.new(("Cannot infer operation %s"):format((tostring(Boolean.toJSBoolean(operationName) and operationName or "")))))
	end

	return operationAST
end

return {
	["getOperationASTFromDocument"] = getOperationASTFromDocument,
	getOperationASTFromRequest = memoize.memoize1(function(p)
		return getOperationASTFromDocument(p.document, p.operationName)
	end)
}
