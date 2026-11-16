local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local language = parent.language
local jsutils = parent.jsutils
local didYouMean = require(jsutils.didYouMean)
local didYouMean2 = didYouMean.didYouMean
local suggestionList = require(jsutils.suggestionList)
local suggestionList2 = suggestionList.suggestionList
local kinds = require(language.kinds)
local kind = kinds.Kind
local directives = require(parent.type.directives)
local specifiedDirectives = directives.specifiedDirectives

local KnownArgumentNamesRule = {}

function KnownArgumentNamesRule.KnownArgumentNamesRule(object)
	return Object.assign({}, KnownArgumentNamesRule.KnownArgumentNamesOnDirectivesRule(object), {
		Argument = function(_, p)
			local argument = object:getArgument()
			local fieldDef = object:getFieldDef()
			local parentType = object:getParentType()

			if not argument and fieldDef and parentType then
				local value = p.name.value
				local v = suggestionList2(value, (Array.map(fieldDef.args, function(p2)
					return p2.name
				end)))
				object:reportError(graphQLError.new(
					("Unknown argument \"%s\" on field \"%s.%s\"."):format(value, parentType.name, fieldDef.name) .. didYouMean2(v),
					p
				))
			end
		end
	})
end

function KnownArgumentNamesRule.KnownArgumentNamesOnDirectivesRule(object)
	local values = {}

	local schema = object:getSchema()
	local v = specifiedDirectives

	if schema then
		v = schema:getDirectives()
	end

	for _, v2 in ipairs(v) do
		values[v2.name] = Array.map(v2.args, function(p)
			return p.name
		end)
	end

	local definitions = object:getDocument().definitions

	for _, definition in ipairs(definitions) do
		if definition.kind ~= kind.DIRECTIVE_DEFINITION then
			continue
		end

		local arguments = definition.arguments or {}

		values[definition.name.value] = Array.map(arguments, function(p)
			return p.name.value
		end)
	end

	return {
		Directive = function(_, p): boolean
			local value = p.name.value
			local v2 = values[value]

			if p.arguments and v2 then
				for _, argument in ipairs(p.arguments) do
					local value2 = argument.name.value

					if Array.indexOf(v2, value2) ~= -1 then
						continue
					end

					local v3 = suggestionList2(value2, v2)
					object:reportError(graphQLError.new(
						("Unknown argument \"%s\" on directive \"@%s\"."):format(value2, value) .. didYouMean2(v3),
						argument
					))
				end
			end

			return false
		end
	}
end

return KnownArgumentNamesRule
