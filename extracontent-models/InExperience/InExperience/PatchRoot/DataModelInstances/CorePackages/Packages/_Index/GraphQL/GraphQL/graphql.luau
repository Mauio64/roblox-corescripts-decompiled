local parent = script.Parent

local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Error = LuauPolyfill.Error
local Promise = require(parent2.Promise)

require(parent.jsutils.PromiseOrValue)

local isPromise = require(parent.jsutils.isPromise)
local isPromise2 = isPromise.isPromise

require(parent.language.source)

local parser = require(parent.language.parser)
local parse = parser.parse

require(parent.type.definition)

require(parent.type.schema)

local validate = require(parent.validation.validate)
local validate2 = validate.validate

local validate3 = require(parent.type.validate)
local validateSchema = validate3.validateSchema

local execute = require(parent.execution.execute)
local execute2 = execute.execute

local graphqlImpl
local Graphql = {
	graphql = function(p)
		return Promise.new(function(callback)
			return callback(graphqlImpl(p))
		end)
	end,
	graphqlSync = function(p)
		local v = graphqlImpl(p)

		if isPromise2(v) then
			error(Error.new("GraphQL execution failed to complete synchronously."))
		end

		return v
	end
}

graphqlImpl = function(data)
	local schema = data.schema
	local source = data.source
	local rootValue = data.rootValue
	local contextValue = data.contextValue
	local variableValues = data.variableValues
	local operationName = data.operationName
	local fieldResolver = data.fieldResolver
	local typeResolver = data.typeResolver

	local errors = validateSchema(schema)

	if #errors > 0 then
		return { errors = errors }
	end

	local parsed = nil
	local success, result = pcall(function()
		parsed = parse(source)
	end)

	if not success then
		return {
			errors = { result }
		}
	end

	local errors2 = validate2(schema, parsed)

	if #errors2 > 0 then
		return { errors = errors2 }
	end

	return execute2({
		schema = schema,
		document = parsed,
		rootValue = rootValue,
		contextValue = contextValue,
		variableValues = variableValues,
		operationName = operationName,
		fieldResolver = fieldResolver,
		typeResolver = typeResolver
	})
end

return Graphql
