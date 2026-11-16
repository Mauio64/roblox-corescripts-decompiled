local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object

local Directives = {}
local GraphQL = require(parent.GraphQL)

local Print = GraphQL.print

require(script.Parent["merge-typedefs_types"])

local Utils = require(parent.Utils)
local isSome = Utils.isSome

local deduplicateLists

local function directiveAlreadyExists(filtered, p)
	return Boolean.toJSBoolean(Array.find(filtered, function(p2): boolean
		return p2.name.value == p.name.value
	end))
end

local function nameAlreadyExists(p, locations) -- 1 equivalent call inferred from this helper
	return Array.some(locations, function(p2): boolean
		return p2.value == p.value
	end)
end

local function mergeArguments(arguments, arguments2)
	local joined = Array.concat({}, arguments2)

	for _, item in arguments do
		local index = Array.findIndex(joined, function(p): boolean
			return p.name.value == item.name.value
		end)

		if index > -1 then
			local v = joined[index]

			if v.value.kind == "ListValue" then
				local values = v.value.values
				local values2 = item.value.values
				v.value.values = deduplicateLists(values, values2, function(p, p2): boolean
					local value = p.value
					return not (Boolean.toJSBoolean(value) and Array.some(p2, function(p3): boolean
						return p3.value == value
					end))
				end)
			else
				v.value = item.value
			end
		else
			table.insert(joined, item)
		end
	end

	return joined
end

local function deduplicateDirectives(p)
	return (Array.filter(Array.map(p, function(state, p2, p3)
		local index = Array.findIndex(p3, function(p4): boolean
			return p4.name.value == state.name.value
		end)

		if index == p2 then
			return state
		end

		local v = p3[index]

		state.arguments = mergeArguments(state.arguments, v.arguments)
		return nil
	end), isSome))
end

function Directives.mergeDirectives(p, p2, p3)
	local v = p == nil and {} or p
	local v2 = p2 == nil and {} or p2

	local reverseDirectives = p3 and p3.reverseDirectives

	local v3 = if Boolean.toJSBoolean(reverseDirectives) then v else v2

	if Boolean.toJSBoolean(reverseDirectives) then
		v = v2
	end

	local joined = Array.concat({}, v3)
	local filtered = Array.filter(Array.map(joined, function(state, p4, p5)
		local index = Array.findIndex(p5, function(p6): boolean
			return p6.name.value == state.name.value
		end)

		if index == p4 then
			return state
		end

		local v4 = p5[index]

		state.arguments = mergeArguments(state.arguments, v4.arguments)
		return nil
	end), isSome)

	for _, v4 in v do
		if Boolean.toJSBoolean(directiveAlreadyExists(filtered, v4)) then
			local index = Array.findIndex(filtered, function(p4): boolean
				return p4.name.value == v4.name.value
			end)

			local v5 = filtered[index]
			filtered[index].arguments = mergeArguments(
				Boolean.toJSBoolean(v4.arguments) and v4.arguments or {},
				Boolean.toJSBoolean(v5.arguments) and v5.arguments or {}
			)
		else
			table.insert(filtered, v4)
		end
	end

	return filtered
end

local function validateInputs(p, p2)
	local Print2 = Print(Object.assign({}, p, { description = Object.None }))
	local Print3 = Print(Object.assign({}, p2, { description = Object.None }))

	local v = Print2:gsub("directive @w*d*", ""):gsub(" on .*$", "") == Print3:gsub("directive @w*d*", ""):gsub(" on .*$", "")

	if not Boolean.toJSBoolean(v) then
		error(Error.new(("Unable to merge GraphQL directive \"%s\". \nExisting directive:  \n\t%s \nReceived directive: \n\t%s"):format(
			tostring(p.name.value),
			tostring(Print3),
			(tostring(Print2))
		)))
	end
end
function Directives.mergeDirective(p, p2)
	if not p2 then
		return p
	end

	validateInputs(p, p2)
	return Object.assign({}, p, {
		locations = Array.concat({}, p2.locations, Array.filter(p.locations, function(p3): boolean
			return not nameAlreadyExists(p3, p2.locations) -- inferred equivalent call
		end))
	})
end
deduplicateLists = function(values, values2, fn)
	return Array.concat(values, Array.filter(values2, function(p)
		return fn(p, values)
	end))
end

return Directives
