local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local t1 = {}
local parse = require(ParentParent.GraphQL).parse
local LuauRegExp = require(ParentParent.LuauRegExp)

function t1.asArray(p1) -- line: 23
	-- upvalues: Boolean (copy), Array (copy)
	if Boolean.toJSBoolean(Array.isArray(p1)) then
		return p1
	end

	if Boolean.toJSBoolean(p1) then
		return { p1 }
	end

	return {}
end

local v10 = LuauRegExp("\\.[a-zA-Z0-9]+$")

function t1.isDocumentString(p2) -- line: 31
	-- upvalues: Boolean (copy), v10 (copy), parse (copy)
	if typeof(p2) ~= "string" then
		return false
	end

	if Boolean.toJSBoolean(v10:test(p2)) then
		return false
	end

	local ok, result = pcall(function() -- line: 53
		-- upvalues: parse (copy), p2 (copy)
		parse(p2)

		return true
	end)

	if not ok then
		return false
	end

	return result
end

local v11 = LuauRegExp("[‘“!%^<=>`]")

function t1.isValidPath(p3) -- line: 68
	-- upvalues: Boolean (copy), v11 (copy)
	return typeof(p3) == "string" and not Boolean.toJSBoolean(v11:test(p3))
end
function t1.compareStrings(p4, p5) -- line: 72
	if tostring(p4) < tostring(p5) then
		return -1
	end

	if tostring(p4) > tostring(p5) then
		return 1
	end

	return 0
end

local function nodeToString(p6) -- line: 96
	-- upvalues: Array (copy), Object (copy)
	local v21 = nil

	if Array.indexOf(Object.keys(p6), "alias") ~= -1 then
		v21 = if typeof(p6.alias) ~= "table" then nil else p6.alias.value
	end

	if v21 == nil and Array.indexOf(Object.keys(p6), "name") ~= -1 then
		v21 = if typeof(p6.name) ~= "table" then nil else p6.name.value
	end

	if v21 == nil then
		v21 = p6.kind
	end

	return v21
end

t1.nodeToString = nodeToString

function t1.compareNodes(p7, p8, p9: ((...any) -> ...any)?) -- line: 122
	-- upvalues: nodeToString (copy)
	local v25 = nodeToString(p7)
	local v26 = nodeToString(p8)

	if typeof(p9) == "function" then
		return p9(v25, v26)
	end

	if tostring(v25) < tostring(v26) then
		return -1
	end

	if tostring(v25) > tostring(v26) then
		return 1
	end

	return 0
end
function t1.isSome(p10) -- line: 131
	-- upvalues: Object (copy)
	return p10 ~= nil and p10 ~= Object.None
end
function t1.assertSome(p11, s1: string?) -- line: 140
	-- upvalues: Error (copy)
	local v30 = s1 == nil and "Value should be something" or s1

	if p11 == nil then
		error(Error.new(v30))
	end

	return true
end

return t1
