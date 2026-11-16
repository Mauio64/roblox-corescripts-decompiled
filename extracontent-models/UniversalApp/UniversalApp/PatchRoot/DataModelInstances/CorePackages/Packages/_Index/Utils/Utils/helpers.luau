local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object

local GraphQL = require(parent.GraphQL)
local parse = GraphQL.parse

local LuauRegExp = require(parent.LuauRegExp)
local Helpers = {}

function Helpers.asArray(p)
	if Boolean.toJSBoolean(Array.isArray(p)) then
		return p
	end

	if Boolean.toJSBoolean(p) then
		return { p }
	end

	return {}
end

local luauRegExp = LuauRegExp("\\.[a-zA-Z0-9]+$")

function Helpers.isDocumentString(value)
	if typeof(value) ~= "string" or Boolean.toJSBoolean(luauRegExp:test(value)) then
		return false
	end

	local success, result = pcall(function(): boolean
		parse(value)
		return true
	end)
	return if success then result else false
end

local luauRegExp2 = LuauRegExp("[‘“!%^<=>`]")

function Helpers.isValidPath(value): boolean
	return typeof(value) == "string" and not Boolean.toJSBoolean(luauRegExp2:test(value))
end
local function compareStrings(p, p2): number -- 1 equivalent call inferred from this helper
	if tostring(p) < tostring(p2) then
		return -1
	end

	return if tostring(p) > tostring(p2) then 1 else 0
end

Helpers.compareStrings = compareStrings

local function nodeToString(data)
	local v

	if not (Array.indexOf(Object.keys(data), "alias") == -1 or typeof(data.alias) ~= "table") then
		v = data.alias.value
	end

	if v == nil and Array.indexOf(Object.keys(data), "name") ~= -1 then
		if typeof(data.name) == "table" then
			v = data.name.value
		else
			v = nil
		end
	end

	return if v == nil then data.kind else v
end

Helpers.nodeToString = nodeToString
function Helpers.compareNodes(p, p2, callback)
	local v = nodeToString(p)
	local v2 = nodeToString(p2)

	if typeof(callback) == "function" then
		return callback(v, v2)
	end

	return compareStrings(v, v2) -- inferred equivalent call
end
function Helpers.isSome(p): boolean
	return p ~= nil and p ~= Object.None
end
function Helpers.assertSome(p, p2: string?): boolean
	local v = p2 == nil and "Value should be something" or p2

	if p == nil then
		error(Error.new(v))
	end

	return true
end
return Helpers
