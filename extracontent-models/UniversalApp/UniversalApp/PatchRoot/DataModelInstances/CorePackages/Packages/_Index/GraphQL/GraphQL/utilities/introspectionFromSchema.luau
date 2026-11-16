local parent = script.Parent.Parent

local LuauPolyfill = require(parent.Parent.LuauPolyfill)
local Object = LuauPolyfill.Object

local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant

require(parent.type.schema)

local parser = require(parent.language.parser)
local parse = parser.parse

local execute = require(parent.execution.execute)
local executeSync = execute.executeSync

local getIntrospectionQuery = require(script.Parent.getIntrospectionQuery)

local getIntrospectionQuery2 = getIntrospectionQuery.getIntrospectionQuery

return {
	introspectionFromSchema = function(schema, p)
		local v = executeSync({
			schema = schema,
			document = parse(getIntrospectionQuery2((Object.assign(
				{
					specifiedByUrl = true,
					directiveIsRepeatable = true,
					schemaDescription = true,
					inputValueDeprecation = true
				},
				p
			))))
		})
		invariant2(not v.errors and v.data)

		return v.data
	end
}
