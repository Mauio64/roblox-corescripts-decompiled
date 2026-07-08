local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local t1 = {}

require(script.Parent["merge-typedefs_types"])
require(ParentParent.GraphQL)

local utils = require(script.Parent.utils)
local extractType = utils.extractType
local isWrappingTypeNode = utils.isWrappingTypeNode
local isListTypeNode = utils.isListTypeNode
local isNonNullTypeNode = utils.isNonNullTypeNode
local printTypeNode = utils.printTypeNode
local mergeDirectives = require(script.Parent.directives).mergeDirectives
local compareNodes = require(ParentParent.Utils).compareNodes
local mergeArguments = require(script.Parent.arguments).mergeArguments
local preventConflicts = nil
local safeChangeForFieldType = nil

local function fieldAlreadyExists(p1, p2, p3) -- line: 48
	-- upvalues: Array (copy), Boolean (copy), extractType (copy), Error (copy)
	local v22 = Array.find(p1, function(p4) -- line: 51
		-- upvalues: p2 (copy)
		return p4.name.value == p2.name.value
	end)

	if v22 and (not p3 or not Boolean.toJSBoolean(p3.ignoreFieldConflicts)) then
		local v23 = extractType(v22.type)
		local v24 = extractType(p2.type)

		if v23.name.value ~= v24.name.value then
			error(Error.new(("Field \"%s\" already defined with a different type. Declared as \"%s\", but you tried to override with \"%s\""):format(tostring(p2.name.value), tostring(v23.name.value), (tostring(v24.name.value)))))
		end
	end

	return not not Boolean.toJSBoolean(v22)
end

function t1.mergeFields(t2: {[any]: any}, p5, p6, p7) -- line: 83
	-- upvalues: Array (copy), Boolean (copy), fieldAlreadyExists (copy), preventConflicts (ref), isNonNullTypeNode (copy), mergeArguments (copy), mergeDirectives (copy), compareNodes (copy)
	local t3 = {}

	if p6 ~= nil then
		t3 = Array.concat(t3, p6)
	end

	if p5 ~= nil then
		for _, v31 in p5 do
			if Boolean.toJSBoolean((fieldAlreadyExists(t3, v31, p7))) then
				local v32 = Array.find(t3, function(p8) -- line: 115
					-- upvalues: v31 (copy)
					return p8.name.value == v31.name.value
				end)

				if not p7 or not Boolean.toJSBoolean(p7.ignoreFieldConflicts) then
					if p7 and Boolean.toJSBoolean(p7.throwOnConflict) then
						preventConflicts(t2, v32, v31, false)
					else
						preventConflicts(t2, v32, v31, true)
					end

					local toJSBoolean = Boolean.toJSBoolean
					local v34 = isNonNullTypeNode(v31.type)

					if toJSBoolean(if not Boolean.toJSBoolean(v34) then v34 else not Boolean.toJSBoolean(isNonNullTypeNode(v32.type))) then
						v32.type = v31.type
					end
				end

				v32.arguments = mergeArguments(if not Boolean.toJSBoolean(v31.arguments) then {} else v31.arguments, if not Boolean.toJSBoolean(v32.arguments) then {} else v32.arguments, p7)
				v32.directives = mergeDirectives(v31.directives, v32.directives, p7)
				v32.description = if not Boolean.toJSBoolean(v31.description) then v32.description else v31.description
			else
				table.insert(t3, v31)
			end
		end
	end

	if p7 and Boolean.toJSBoolean(p7.sort) then
		Array.sort(t3, compareNodes)
	end

	if p7 and p7.exclusions then
		local exclusions = p7.exclusions

		return Array.filter(t3, function(p9) -- line: 183
			-- upvalues: Boolean (copy), Array (copy), exclusions (copy), t2 (copy)
			return not Boolean.toJSBoolean(Array.includes(exclusions, ("%s.%s"):format(tostring(t2.name.value), (tostring(p9.name.value)))))
		end)
	end

	return t3
end
function preventConflicts(t4: {[any]: any}, p10, p11, b1: boolean?) -- line: 194
	-- upvalues: printTypeNode (copy), Boolean (copy), safeChangeForFieldType (ref), Error (copy)
	local v40 = b1 ~= nil and b1
	local v41 = printTypeNode(p10.type)
	local v42 = printTypeNode(p11.type)

	if v41 ~= v42 and not Boolean.toJSBoolean(safeChangeForFieldType(p10.type, p11.type, v40)) then
		error(Error.new(("Field '%s.%s' changed type from '%s' to '%s'"):format(tostring(t4.name.value), tostring(p10.name.value), tostring(v41), (tostring(v42)))))
	end
end
function safeChangeForFieldType(p12, p13, b2: boolean?) -- line: 223
	-- upvalues: Boolean (copy), isWrappingTypeNode (copy), isNonNullTypeNode (copy), safeChangeForFieldType (ref), isListTypeNode (copy)
	local v46 = b2 ~= nil and b2

	if not Boolean.toJSBoolean(isWrappingTypeNode(p12)) and not Boolean.toJSBoolean(isWrappingTypeNode(p13)) then
		if typeof(p12) == "table" and #p12 == 0 and typeof(p13) == "table" and #p13 == 0 then
			return true
		end

		return tostring(p12) == tostring(p13)
	end

	if Boolean.toJSBoolean(isNonNullTypeNode(p13)) then
		local v47 = if not Boolean.toJSBoolean(isNonNullTypeNode(p12)) then p12 else p12.type

		return safeChangeForFieldType(v47, p13.type)
	end

	if Boolean.toJSBoolean(isNonNullTypeNode(p12)) then
		return safeChangeForFieldType(p13, p12, v46)
	end

	if Boolean.toJSBoolean(isListTypeNode(p12)) then
		return isListTypeNode(p13) and safeChangeForFieldType(p12.type, p13.type) or isNonNullTypeNode(p13) and safeChangeForFieldType(p12, p13.type)
	end

	return false
end

return t1
