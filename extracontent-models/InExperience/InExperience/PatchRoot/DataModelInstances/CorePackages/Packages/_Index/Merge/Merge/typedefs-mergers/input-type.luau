local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local t1 = {}

require(script.Parent["merge-typedefs_types"])

local Kind = require(ParentParent.GraphQL).Kind
local mergeFields = require(script.Parent.fields).mergeFields
local mergeDirectives = require(script.Parent.directives).mergeDirectives

function t1.mergeInputType(p1, p2, p3) -- line: 29
	-- upvalues: Boolean (copy), mergeFields (copy), mergeDirectives (copy), Error (copy), Object (copy), Kind (copy)
	if Boolean.toJSBoolean(p2) then
		local ok, result = pcall(function() -- line: 37
			-- upvalues: p1 (copy), Boolean (copy), p2 (copy), p3 (copy), mergeFields (copy), mergeDirectives (copy)
			return {
				name = p1.name,
				description = if not Boolean.toJSBoolean(p1.description) then p2.description else p1.description,
				kind = not Boolean.toJSBoolean(p3 and p3.convertExtensions) and (p1.kind ~= "InputObjectTypeDefinition" and p2.kind ~= "InputObjectTypeDefinition") and "InputObjectTypeExtension" or "InputObjectTypeDefinition",
				loc = p1.loc,
				fields = mergeFields(p1, p1.fields, p2.fields, p3),
				directives = mergeDirectives(p1.directives, p2.directives, p3)
			}
		end)

		if not ok then
			error(Error.new(("Unable to merge GraphQL input type \"%s\": %s"):format(tostring(p1.name.value), (tostring(result.message)))))
		end

		return result
	end

	if p3 and Boolean.toJSBoolean(p3.convertExtensions) then
		return (Object.assign({}, p1, {
			kind = Kind.INPUT_OBJECT_TYPE_DEFINITION
		}))
	end

	return p1
end

return t1
