local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local language = ParentParent.language
local jsutils = ParentParent.jsutils
local didYouMean = require(jsutils.didYouMean).didYouMean
local suggestionList = require(jsutils.suggestionList).suggestionList
local Kind = require(language.kinds).Kind
local specifiedDirectives = require(ParentParent.type.directives).specifiedDirectives
local t1 = {}

function t1.KnownArgumentNamesRule(p1) -- line: 31
	-- upvalues: Object (copy), t1 (copy), Array (copy), suggestionList (copy), GraphQLError (copy), didYouMean (copy)
	return Object.assign({}, t1.KnownArgumentNamesOnDirectivesRule(p1), {
		Argument = function(_, p3) -- line: 33
			-- upvalues: p1 (copy), Array (copy), suggestionList (copy), GraphQLError (copy), didYouMean (copy)
			local v27 = p1:getArgument()
			local v28 = p1:getFieldDef()
			local v29 = p1:getParentType()

			if not v27 and (v28 and v29) then
				local value = p3.name.value
				local v31 = Array.map(v28.args, function(p4) -- line: 40
					return p4.name
				end)
				local v32 = suggestionList(value, v31)

				p1:reportError(GraphQLError.new(("Unknown argument \"%s\" on field \"%s.%s\"."):format(value, v29.name, v28.name) .. didYouMean(v32), p3))
			end
		end
	})
end
function t1.KnownArgumentNamesOnDirectivesRule(p5) -- line: 62
	-- upvalues: specifiedDirectives (copy), Array (copy), Kind (copy), suggestionList (copy), GraphQLError (copy), didYouMean (copy)
	local t2 = {}
	local v17 = p5:getSchema()
	local v18 = specifiedDirectives

	if v17 then
		v18 = v17:getDirectives()
	end

	for _, v in ipairs(v18) do
		t2[v.name] = Array.map(v.args, function(p6) -- line: 71
			return p6.name
		end)
	end

	local definitions = p5:getDocument().definitions

	for _, v in ipairs(definitions) do
		if v.kind == Kind.DIRECTIVE_DEFINITION then
			local v24 = v.arguments or {}

			t2[v.name.value] = Array.map(v24, function(p7) -- line: 82
				return p7.name.value
			end)
		end
	end

	return {
		Directive = function(_, p9) -- line: 89
			-- upvalues: t2 (copy), Array (copy), suggestionList (copy), p5 (copy), GraphQLError (copy), didYouMean (copy)
			local value = p9.name.value
			local v38 = t2[value]

			if p9.arguments and v38 then
				for _, v in ipairs(p9.arguments) do
					local value2 = v.name.value

					if Array.indexOf(v38, value2) == -1 then
						local v42 = suggestionList(value2, v38)

						p5:reportError(GraphQLError.new(("Unknown argument \"%s\" on directive \"@%s\"."):format(value2, value) .. didYouMean(v42), v))
					end
				end
			end

			return false
		end
	}
end

return t1
