local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local LuauPolyfill = require(parent3.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error

local devAssert = require(parent2.jsutils.devAssert)
local devAssert2 = devAssert.devAssert
local GraphQLError = require(parent2.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

require(parent2.language.ast)

require(parent2.type.schema)

local visitor = require(parent2.language.visitor)
local visit = visitor.visit
local visitInParallel = visitor.visitInParallel
local validate = require(parent2.type.validate)
local assertValidSchema = validate.assertValidSchema
local TypeInfo = require(parent2.utilities.TypeInfo)
local typeInfo = TypeInfo.TypeInfo

local visitWithTypeInfo = TypeInfo.visitWithTypeInfo
local specifiedRules = require(parent.specifiedRules)
local specifiedRules2 = specifiedRules.specifiedRules
local specifiedSDLRules = specifiedRules.specifiedSDLRules
local ValidationContext = require(parent.ValidationContext)
local SDLValidationContext = ValidationContext.SDLValidationContext
local validationContext = ValidationContext.ValidationContext

local Validate = {}

function Validate.validate(p, p2, p3, p4, p5)
	local v = p4 or { maxErrors = nil }
	local v2 = p5 or typeInfo.new(p)

	devAssert2(p2, "Must provide document.")

	assertValidSchema(p)

	local v3 = {}
	local v4 = {}
	local v5 = validationContext.new(p, p2, v2, function(p6)
		if v.maxErrors ~= nil and #v4 >= v.maxErrors then
			table.insert(v4, graphQLError.new("Too many validation errors, error limit reached. Validation aborted."))

			error(v3)
		end

		table.insert(v4, p6)
	end)

	local v6 = visitInParallel(Array.map(p3 or specifiedRules2, function(callback)
		return callback(v5)
	end))

	local success, result = pcall(function()
		visit(p2, visitWithTypeInfo(v2, v6))
	end)

	if not success and result ~= v3 then
		error(result)
	end

	return v4
end

function Validate.validateSDL(p, p2, p3)
	local v = {}
	local v2 = SDLValidationContext.new(p, p2, function(p4)
		table.insert(v, p4)
	end)
	visit(p, visitInParallel((Array.map(p3 or specifiedSDLRules, function(callback)
		return callback(v2)
	end))))
	return v
end

function Validate.assertValidSDL(p)
	local v = Validate.validateSDL(p)

	if #v ~= 0 then
		error(Error.new(table.concat(Array.map(v, function(p2)
			return p2.message
		end), "\n\n")))
	end
end

function Validate.assertValidSDLExtension(p, p2)
	local v = Validate.validateSDL(p, p2)

	if #v ~= 0 then
		error(Error.new(table.concat(Array.map(v, function(value)
			if typeof(value) == "string" then
				return value
			end

			return value.message
		end), "\n\n")))
	end
end

return Validate
