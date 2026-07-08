local ParentParent = script.Parent.Parent.Parent
local jsutils = ParentParent.jsutils
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local inspect = require(jsutils.inspect).inspect
local keyMap = require(jsutils.keyMap).keyMap
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local language = ParentParent.language
local Kind = require(language.kinds).Kind
local print = require(language.printer).print
local definition = require(ParentParent.type.definition)
local isType = definition.isType
local isRequiredArgument = definition.isRequiredArgument
local specifiedDirectives = require(ParentParent.type.directives).specifiedDirectives
local t1 = {}

function t1.ProvidedRequiredArgumentsRule(p1) -- line: 36
	-- upvalues: Object (copy), t1 (copy), keyMap (copy), isRequiredArgument (copy), inspect (copy), GraphQLError (copy)
	return Object.assign({}, t1.ProvidedRequiredArgumentsOnDirectivesRule(p1), {
		Field = {
			leave = function(_, p3) -- line: 40
				-- upvalues: p1 (copy), keyMap (copy), isRequiredArgument (copy), inspect (copy), GraphQLError (copy)
				local v32 = p1:getFieldDef()

				if not v32 then
					return false
				end

				local v33 = p3.arguments or {}
				local v34 = keyMap(v33, function(p4) -- line: 48
					return p4.name.value
				end)

				for _, v in ipairs(v32.args) do
					if not v34[v.name] and isRequiredArgument(v) then
						local v37 = inspect(v.type)

						p1:reportError(GraphQLError.new(("Field \"%s\" argument \"%s\" of type \"%s\" is required, but it was not provided."):format(v32.name, v.name, v37), p3))
					end
				end
			end
		}
	})
end
function t1.ProvidedRequiredArgumentsOnDirectivesRule(p5) -- line: 74
	-- upvalues: specifiedDirectives (copy), keyMap (copy), Array (copy), isRequiredArgument (copy), Kind (copy), Object (copy), isType (copy), inspect (copy), print (copy), GraphQLError (copy)
	local t2 = {}
	local v21 = p5:getSchema()
	local v22 = specifiedDirectives

	if v21 then
		v22 = v21:getDirectives()
	end

	for _, v in ipairs(v22) do
		t2[v.name] = keyMap(Array.filter(v.args, isRequiredArgument), function(p6) -- line: 85
			return p6.name
		end)
	end

	local definitions = p5:getDocument().definitions

	for _, v in ipairs(definitions) do
		if v.kind == Kind.DIRECTIVE_DEFINITION then
			local v28 = v.arguments or {}

			t2[v.name.value] = keyMap(Array.filter(v28, isRequiredArgumentNode), function(p7) -- line: 99
				return p7.name.value
			end)
		end
	end

	return {
		Directive = {
			leave = function(_, p9) -- line: 109
				-- upvalues: t2 (copy), keyMap (copy), Object (copy), isType (copy), inspect (copy), print (copy), p5 (copy), GraphQLError (copy)
				local value = p9.name.value
				local v43 = t2[value]

				if v43 then
					local v44 = p9.arguments or {}
					local v45 = keyMap(v44, function(p10) -- line: 116
						return p10.name.value
					end)

					for _, v in ipairs(Object.keys(v43)) do
						if not v45[v] then
							local type = v43[v].type
							local v49 = isType(type) and inspect(type) or print(type)

							p5:reportError(GraphQLError.new(("Directive \"@%s\" argument \"%s\" of type \"%s\" is required, but it was not provided."):format(value, v, v49), p9))
						end
					end
				end
			end
		}
	}
end
function isRequiredArgumentNode(p11) -- line: 141
	-- upvalues: Kind (copy)
	return p11.type.kind == Kind.NON_NULL_TYPE and p11.defaultValue == nil
end

return t1
