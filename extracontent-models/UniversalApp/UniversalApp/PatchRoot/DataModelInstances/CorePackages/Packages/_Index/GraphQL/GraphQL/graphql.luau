local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Error = require(scriptParentParent.LuauPolyfill).Error
local Promise = require(scriptParentParent.Promise)

require(scriptParent.jsutils.PromiseOrValue)

local isPromise = require(scriptParent.jsutils.isPromise).isPromise

require(scriptParent.language.source)

local parse = require(scriptParent.language.parser).parse

require(scriptParent.type.definition)
require(scriptParent.type.schema)

local validate = require(scriptParent.validation.validate).validate
local validateSchema = require(scriptParent.type.validate).validateSchema
local execute = require(scriptParent.execution.execute).execute
local t1 = {}
local graphqlImpl = nil

function t1.graphql(t2: {[any]: any}) -- line: 93
	-- upvalues: Promise (copy), graphqlImpl (ref)
	return Promise.new(function(resolve) -- line: 95
		-- upvalues: graphqlImpl (ref), t2 (copy)
		return resolve(graphqlImpl(t2))
	end)
end
function t1.graphqlSync(t3: {[any]: any}) -- line: 106
	-- upvalues: graphqlImpl (ref), isPromise (copy), Error (copy)
	local v14 = graphqlImpl(t3)

	if isPromise(v14) then
		error(Error.new("GraphQL execution failed to complete synchronously."))
	end

	return v14
end
function graphqlImpl(t4: {[any]: any}) -- line: 119
	-- upvalues: validateSchema (copy), parse (copy), validate (copy), execute (copy)
	local schema = t4.schema
	local source = t4.source
	local rootValue = t4.rootValue
	local contextValue = t4.contextValue
	local variableValues = t4.variableValues
	local operationName = t4.operationName
	local fieldResolver = t4.fieldResolver
	local typeResolver = t4.typeResolver
	local v24 = validateSchema(schema)

	if #v24 > 0 then
		return {
			errors = v24
		}
	end

	local u25 = nil
	local ok, result = pcall(function() -- line: 138
		-- upvalues: u25 (ref), parse (copy), source (copy)
		u25 = parse(source)
	end)

	if not ok then
		return {
			errors = { result }
		}
	end

	local v28 = validate(schema, u25)

	if #v28 > 0 then
		return {
			errors = v28
		}
	end

	return execute({
		schema = schema,
		document = u25,
		rootValue = rootValue,
		contextValue = contextValue,
		variableValues = variableValues,
		operationName = operationName,
		fieldResolver = fieldResolver,
		typeResolver = typeResolver
	})
end

return t1
