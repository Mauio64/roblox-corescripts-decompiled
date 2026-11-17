local parent = script.Parent.Parent.Parent
local jsutils = parent.jsutils
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local inspect = require(jsutils.inspect)
local inspect2 = inspect.inspect
local keyMap = require(jsutils.keyMap)
local keyMap2 = keyMap.keyMap
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local language = parent.language
local kinds = require(language.kinds)
local kind = kinds.Kind
local printer = require(language.printer)
local Print = printer.print
local definition = require(parent.type.definition)
local isType = definition.isType
local isRequiredArgument = definition.isRequiredArgument
local directives = require(parent.type.directives)
local specifiedDirectives = directives.specifiedDirectives

local ProvidedRequiredArgumentsRule = {}

function ProvidedRequiredArgumentsRule.ProvidedRequiredArgumentsRule(object)
	return Object.assign({}, ProvidedRequiredArgumentsRule.ProvidedRequiredArgumentsOnDirectivesRule(object), {
		Field = {
			leave = function(_, p)
				local fieldDef = object:getFieldDef()

				if not fieldDef then
					return false
				end

				local arguments = p.arguments or {}
				local v = keyMap2(arguments, function(p2)
					return p2.name.value
				end)

				for _, arg in ipairs(fieldDef.args) do
					if v[arg.name] or not isRequiredArgument(arg) then
						continue
					end

					local v2 = inspect2(arg.type)
					object:reportError(graphQLError.new(
						("Field \"%s\" argument \"%s\" of type \"%s\" is required, but it was not provided."):format(
							fieldDef.name,
							arg.name,
							v2
						),
						p
					))
				end
			end
		}
	})
end

function ProvidedRequiredArgumentsRule.ProvidedRequiredArgumentsOnDirectivesRule(object)
	local v = {}

	local schema = object:getSchema()
	local v2 = specifiedDirectives

	if schema then
		v2 = schema:getDirectives()
	end

	for _, v3 in ipairs(v2) do
		v[v3.name] = keyMap2(Array.filter(v3.args, isRequiredArgument), function(p)
			return p.name
		end)
	end

	local definitions = object:getDocument().definitions

	for _, definition2 in ipairs(definitions) do
		if definition2.kind ~= kind.DIRECTIVE_DEFINITION then
			continue
		end

		local arguments = definition2.arguments or {}

		v[definition2.name.value] = keyMap2(Array.filter(arguments, isRequiredArgumentNode), function(p)
			return p.name.value
		end)
	end

	return {
		Directive = {
			leave = function(_, p)
				local value = p.name.value
				local v3 = v[value]

				if v3 then
					local arguments = p.arguments or {}
					local v4 = keyMap2(arguments, function(p2)
						return p2.name.value
					end)

					for _, v5 in ipairs(Object.keys(v3)) do
						if v4[v5] then
							continue
						end

						local kind2 = v3[v5].type
						local v6 = isType(kind2) and inspect2(kind2) or Print(kind2)

						object:reportError(graphQLError.new(
							("Directive \"@%s\" argument \"%s\" of type \"%s\" is required, but it was not provided."):format(
								value,
								v5,
								v6
							),
							p
						))
					end
				end
			end
		}
	}
end

function isRequiredArgumentNode(p): boolean
	return p.type.kind == kind.NON_NULL_TYPE and p.defaultValue == nil
end

return ProvidedRequiredArgumentsRule
