local LuauPolyfill = require(script.Parent.Parent.Parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local devAssert = require(script.Parent.Parent.jsutils.devAssert)
local devAssert2 = devAssert.devAssert
require(script.Parent.Parent.language.source)

require(script.Parent.Parent.language.ast)

local parser = require(script.Parent.Parent.language.parser)

local kinds = require(script.Parent.Parent.language.kinds)
local kind = kinds.Kind
local parse = parser.parse

local validate = require(script.Parent.Parent.validation.validate)
local assertValidSDL = validate.assertValidSDL

local schema = require(script.Parent.Parent.type.schema)

local graphQLSchema = schema.GraphQLSchema
local directives = require(script.Parent.Parent.type.directives)
local specifiedDirectives = directives.specifiedDirectives

local extendSchema = require(script.Parent.extendSchema)
local extendSchemaImpl = extendSchema.extendSchemaImpl

local function fn(parsed, p)
	devAssert2(parsed ~= nil and parsed.kind == kind.DOCUMENT, "Must provide valid Document AST.")

	if p ~= nil and not (p.assumeValid or p.assumeValidSDL) then
		assertValidSDL(parsed)
	end

	local v = extendSchemaImpl({
		description = nil,
		types = {},
		directives = {},
		extensions = nil,
		extensionASTNodes = {},
		assumeValid = false
	}, parsed, p)

	if v.astNode == nil then
		for _, kind2 in ipairs(v.types) do
			if kind2.name == "Query" then
				v.query = kind2
			elseif kind2.name == "Mutation" then
				v.mutation = kind2
			elseif kind2.name == "Subscription" then
				v.subscription = kind2
			end
		end
	end

	local directives2 = v.directives

	for _, specifiedDirective in ipairs(specifiedDirectives) do
		if not Array.every(directives2, function(p2): boolean
			return p2.name ~= specifiedDirective.name
		end) then
			continue
		end

		table.insert(directives2, specifiedDirective)
	end

	return graphQLSchema.new(v)
end

return {
	buildASTSchema = fn,
	buildSchema = function(p, data)
		local noLocation

		if data then
			noLocation = data.noLocation
		end

		local experimentalFragmentVariables

		if data then
			experimentalFragmentVariables = data.experimentalFragmentVariables
		end

		local parsed = parse(p, {
			noLocation = noLocation,
			experimentalFragmentVariables = experimentalFragmentVariables
		})
		local assumeValidSDL

		if data then
			assumeValidSDL = data.assumeValidSDL
		end

		local assumeValid

		if data then
			assumeValid = data.assumeValid
		end

		return fn(parsed, { assumeValidSDL = assumeValidSDL, assumeValid = assumeValid })
	end,
	parse = parse
}
