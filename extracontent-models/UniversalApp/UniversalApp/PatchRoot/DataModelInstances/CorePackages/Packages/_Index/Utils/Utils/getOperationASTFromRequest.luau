local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local t1 = {}
local getOperationAST = require(ParentParent.GraphQL).getOperationAST

require(script.Parent.Interfaces)

local memoize1 = require(script.Parent.memoize).memoize1

local function getOperationASTFromDocument(p1, s1: string?) -- line: 26
	-- upvalues: getOperationAST (copy), Boolean (copy), Error (copy)
	local v11 = getOperationAST(p1, s1)

	if not Boolean.toJSBoolean(v11) then
		error(Error.new(("Cannot infer operation %s"):format((tostring(Boolean.toJSBoolean(s1) and s1 or "")))))
	end

	return v11
end

t1.getOperationASTFromDocument = getOperationASTFromDocument
t1.getOperationASTFromRequest = memoize1(function(p2) -- line: 43
	-- upvalues: getOperationASTFromDocument (copy)
	return (getOperationASTFromDocument(p2.document, p2.operationName))
end)

return t1
