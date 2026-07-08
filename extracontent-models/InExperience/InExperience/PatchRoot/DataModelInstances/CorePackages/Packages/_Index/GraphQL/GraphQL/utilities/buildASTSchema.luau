local Array = require(script.Parent.Parent.Parent.LuauPolyfill).Array
local devAssert = require(script.Parent.Parent.jsutils.devAssert).devAssert

require(script.Parent.Parent.language.source)
require(script.Parent.Parent.language.ast)

local parser = require(script.Parent.Parent.language.parser)
local Kind = require(script.Parent.Parent.language.kinds).Kind
local parse = parser.parse
local assertValidSDL = require(script.Parent.Parent.validation.validate).assertValidSDL
local GraphQLSchema = require(script.Parent.Parent.type.schema).GraphQLSchema
local specifiedDirectives = require(script.Parent.Parent.type.directives).specifiedDirectives
local extendSchemaImpl = require(script.Parent.extendSchema).extendSchemaImpl

local function v10(p1, p2) -- line: 44
	-- upvalues: devAssert (copy), Kind (copy), assertValidSDL (copy), extendSchemaImpl (copy), specifiedDirectives (copy), Array (copy), GraphQLSchema (copy)
	devAssert(p1 ~= nil and p1.kind == Kind.DOCUMENT, "Must provide valid Document AST.")

	if p2 ~= nil and (not p2.assumeValid and not p2.assumeValidSDL) then
		assertValidSDL(p1)
	end

	local t1 = {
		description = nil,
		extensions = nil,
		assumeValid = false,
		types = {},
		directives = {},
		extensionASTNodes = {}
	}
	local v14 = extendSchemaImpl(t1, p1, p2)

	if v14.astNode == nil then
		for _, v in ipairs(v14.types) do
			if v.name == "Query" then
				v14.query = v
			elseif v.name == "Mutation" then
				v14.mutation = v
			elseif v.name == "Subscription" then
				v14.subscription = v
			end
		end
	end

	local directives = v14.directives

	for _, v in ipairs(specifiedDirectives) do
		if Array.every(directives, function(p3) -- line: 86
			-- upvalues: v (copy)
			return p3.name ~= v.name
		end) then
			table.insert(directives, v)
		end
	end

	return GraphQLSchema.new(v14)
end

return {
	buildASTSchema = v10,
	buildSchema = function(p4, p5) -- line: 97
		-- upvalues: parse (copy), v10 (copy)
		local v22 = parse(p4, {
			noLocation = if not p5 then nil else p5.noLocation,
			experimentalFragmentVariables = if not p5 then nil else p5.experimentalFragmentVariables
		})

		return v10(v22, {
			assumeValidSDL = if not p5 then nil else p5.assumeValidSDL,
			assumeValid = if not p5 then nil else p5.assumeValid
		})
	end,
	parse = parse
}
