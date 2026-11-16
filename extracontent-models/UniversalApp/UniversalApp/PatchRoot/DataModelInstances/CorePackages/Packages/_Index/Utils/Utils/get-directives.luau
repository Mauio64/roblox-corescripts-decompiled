local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

require(parent.GraphQL)

local getArgumentValues = require(script.Parent.getArgumentValues)
local getArgumentValues2 = getArgumentValues.getArgumentValues

local function getDirectivesInExtensions(p, p2)
	local v = p2 == nil and { "directives" } or p2
	local reduce = Array.reduce

	local function fn(p3, p4)
		if p3 == Object.None or p3 == nil then
			return nil
		end

		return p3[p4]
	end

	local v2

	if typeof(p) == "table" and p.extensions then
		v2 = p.extensions
	else
		v2 = Object.None
	end

	return (reduce(v, fn, v2))
end

local GetDirectives = {}
GetDirectives.getDirectivesInExtensions = getDirectivesInExtensions

local function _getDirectiveInExtensions(p, p2: string)
	local filtered = Array.filter(p, function(p3): boolean
		return p3.name == p2
	end)

	if #filtered == 0 then
		return nil
	end

	return (Array.map(filtered, function(p3)
		if p3.args == nil then
			return {}
		end

		return p3.args
	end))
end

local function getDirectiveInExtensions(p, p2: string, p3)
	local v = p3 == nil and { "directives" } or p3
	local reduce = Array.reduce

	local function fn(p4, p5)
		if p4 == Object.None or p4 == nil then
			return nil
		end

		return p4[p5]
	end

	local v2

	if typeof(p) == "table" and p.extensions then
		v2 = p.extensions
	else
		v2 = Object.None
	end

	local reduced = reduce(v, fn, v2)

	if reduced == nil then
		return nil
	end

	if Boolean.toJSBoolean(Array.isArray(reduced)) then
		return _getDirectiveInExtensions(reduced, p2)
	end

	local v3 = {}

	for _, list in Object.entries(reduced) do
		local name, args = table.unpack(list, 1, 2)

		if Boolean.toJSBoolean(Array.isArray(args)) then
			for _, args2 in args do
				table.insert(v3, { name = name, args = args2 })
			end
		else
			table.insert(v3, { name = name, args = args })
		end
	end

	return _getDirectiveInExtensions(v3, p2)
end

GetDirectives.getDirectiveInExtensions = getDirectiveInExtensions
function GetDirectives:getDirectives(p, p2)
	local directivesInExtensions = getDirectivesInExtensions(p, p2 == nil and { "directives" } or p2)

	if directivesInExtensions ~= nil and #directivesInExtensions > 0 then
		return directivesInExtensions
	end

	local toJSBoolean = Boolean.toJSBoolean
	local v

	if Boolean.toJSBoolean(self) then
		v = self.getDirectives
	else
		v = self
	end

	local v2 = not toJSBoolean(v) and {} or self:getDirectives()
	local reduced = Array.reduce(v2, function(p3, p4)
		p3[tostring(p4.name)] = p4
		return p3
	end, {})
	local joined = {}

	if Boolean.toJSBoolean(p.astNode) then
		table.insert(joined, p.astNode)
	end

	if Array.indexOf(Object.keys(p), "extensionASTNodes") ~= -1 and Boolean.toJSBoolean(p.extensionASTNodes) then
		joined = Array.concat({}, joined, p.extensionASTNodes)
	end

	local result = {}

	for _, v3 in joined do
		if not Boolean.toJSBoolean(v3.directives) then
			continue
		end

		for _, directive in v3.directives do
			local v4 = reduced[tostring(directive.name.value)]

			if Boolean.toJSBoolean(v4) then
				table.insert(result, {
					name = directive.name.value,
					args = getArgumentValues2(v4, directive)
				})
			end
		end
	end

	return result
end
function GetDirectives:getDirective(p, p2: string, p3)
	local directiveInExtensions = getDirectiveInExtensions(p, p2, p3 == nil and { "directives" } or p3)

	if directiveInExtensions ~= nil then
		return directiveInExtensions
	end

	local toJSBoolean = Boolean.toJSBoolean
	local v

	if Boolean.toJSBoolean(self) then
		v = self.getDirective
	else
		v = self
	end

	local v2

	if toJSBoolean(v) then
		v2 = self:getDirective(p2)
	end

	if v2 == nil then
		return nil
	end

	local joined = {}

	if Boolean.toJSBoolean(p.astNode) then
		table.insert(joined, p.astNode)
	end

	if Array.indexOf(Object.keys(p), "extensionASTNodes") ~= -1 and Boolean.toJSBoolean(p.extensionASTNodes) then
		joined = Array.concat({}, joined, p.extensionASTNodes)
	end

	local result = {}

	for _, v3 in joined do
		if not Boolean.toJSBoolean(v3.directives) then
			continue
		end

		for _, directive in v3.directives do
			if directive.name.value == p2 then
				table.insert(result, getArgumentValues2(v2, directive))
			end
		end
	end

	return if Boolean.toJSBoolean(#result) then result else nil
end
return GetDirectives
