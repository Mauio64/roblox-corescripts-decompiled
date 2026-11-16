local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error

local Fields = {}

require(script.Parent["merge-typedefs_types"])

require(parent.GraphQL)

local utils = require(script.Parent.utils)

local extractType = utils.extractType
local isWrappingTypeNode = utils.isWrappingTypeNode
local isListTypeNode = utils.isListTypeNode
local isNonNullTypeNode = utils.isNonNullTypeNode
local printTypeNode = utils.printTypeNode

local directives = require(script.Parent.directives)
local mergeDirectives = directives.mergeDirectives
local Utils = require(parent.Utils)
local compareNodes = Utils.compareNodes
local arguments = require(script.Parent.arguments)
local mergeArguments = arguments.mergeArguments

local preventConflicts
local safeChangeForFieldType

local function fieldAlreadyExists(joined, item, data)
	local v = Array.find(joined, function(p): boolean
		return p.name.value == item.name.value
	end)

	if v and not (data and Boolean.toJSBoolean(data.ignoreFieldConflicts)) then
		local v2 = extractType(v.type)
		local v3 = extractType(item.type)

		if v2.name.value ~= v3.name.value then
			error(Error.new(("Field \"%s\" already defined with a different type. Declared as \"%s\", but you tried to override with \"%s\""):format(
				tostring(item.name.value),
				tostring(v2.name.value),
				(tostring(v3.name.value))
			)))
		end
	end

	return Boolean.toJSBoolean(v) and true or false
end

function Fields.mergeFields(p, items, p2, data)
	local joined = {}

	if p2 ~= nil then
		joined = Array.concat(joined, p2)
	end

	if items ~= nil then
		for _, item in items do
			if Boolean.toJSBoolean(fieldAlreadyExists(joined, item, data)) then
				local v = Array.find(joined, function(p3): boolean
					return p3.name.value == item.name.value
				end)

				if not (data and Boolean.toJSBoolean(data.ignoreFieldConflicts)) then
					if data and Boolean.toJSBoolean(data.throwOnConflict) then
						preventConflicts(p, v, item, false)
					else
						preventConflicts(p, v, item, true)
					end

					local toJSBoolean = Boolean.toJSBoolean
					local v2 = isNonNullTypeNode(item.type)

					if Boolean.toJSBoolean(v2) then
						v2 = not Boolean.toJSBoolean(isNonNullTypeNode(v.type))
					end

					if toJSBoolean(v2) then
						v.type = item.type
					end
				end

				v.arguments = mergeArguments(
					not Boolean.toJSBoolean(item.arguments) and {} or item.arguments,
					not Boolean.toJSBoolean(v.arguments) and {} or v.arguments,
					data
				)

				v.directives = mergeDirectives(item.directives, v.directives, data)
				local description

				if Boolean.toJSBoolean(item.description) then
					description = item.description
				else
					description = v.description
				end

				v.description = description
			else
				table.insert(joined, item)
			end
		end
	end

	if data and Boolean.toJSBoolean(data.sort) then
		Array.sort(joined, compareNodes)
	end

	if data and data.exclusions then
		local exclusions = data.exclusions
		return Array.filter(joined, function(p3): boolean
			return not Boolean.toJSBoolean(Array.includes(
				exclusions,
				("%s.%s"):format(tostring(p.name.value), (tostring(p3.name.value)))
			))
		end)
	end

	return joined
end

preventConflicts = function(p, p2, item, flag: boolean?)
	if flag == nil then
		flag = false
	end

	local v = printTypeNode(p2.type)
	local v2 = printTypeNode(item.type)

	if v ~= v2 and not Boolean.toJSBoolean(safeChangeForFieldType(p2.type, item.type, flag)) then
		error(Error.new(("Field '%s.%s' changed type from '%s' to '%s'"):format(
			tostring(p.name.value),
			tostring(p2.name.value),
			tostring(v),
			(tostring(v2))
		)))
	end
end

safeChangeForFieldType = function(kind, kind2, flag: boolean?)
	if flag == nil then
		flag = false
	end

	if Boolean.toJSBoolean(isWrappingTypeNode(kind)) or Boolean.toJSBoolean(isWrappingTypeNode(kind2)) then
		if Boolean.toJSBoolean(isNonNullTypeNode(kind2)) then
			if Boolean.toJSBoolean(isNonNullTypeNode(kind)) then
				kind = kind.type
			end

			return safeChangeForFieldType(kind, kind2.type)
		end

		if Boolean.toJSBoolean(isNonNullTypeNode(kind)) then
			return safeChangeForFieldType(kind2, kind, flag)
		end

		if Boolean.toJSBoolean(isListTypeNode(kind)) then
			return isListTypeNode(kind2) and safeChangeForFieldType(kind.type, kind2.type)
				or isNonNullTypeNode(kind2) and safeChangeForFieldType(kind, kind2.type)
		end

		return false
	elseif typeof(kind) == "table" and #kind == 0 and typeof(kind2) == "table" and #kind2 == 0 then
		return true
	else
		return tostring(kind) == tostring(kind2)
	end
end

return Fields
