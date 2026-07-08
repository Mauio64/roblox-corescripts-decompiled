local ParentParent = script.Parent.Parent
local Object = require(ParentParent.Parent.LuauPolyfill).Object
local invariant = require(ParentParent.jsutils.invariant).invariant

require(ParentParent.type.schema)

local parse = require(ParentParent.language.parser).parse
local executeSync = require(ParentParent.execution.execute).executeSync
local getIntrospectionQuery = require(script.Parent.getIntrospectionQuery).getIntrospectionQuery

return {
	introspectionFromSchema = function(p1, p2) -- line: 37
		-- upvalues: Object (copy), parse (copy), getIntrospectionQuery (copy), executeSync (copy), invariant (copy)
		local v9 = Object.assign({
			specifiedByUrl = true,
			directiveIsRepeatable = true,
			schemaDescription = true,
			inputValueDeprecation = true
		}, p2)
		local v10 = parse(getIntrospectionQuery(v9))
		local v11 = executeSync({
			schema = p1,
			document = v10
		})

		invariant(not v11.errors and v11.data)

		return v11.data
	end
}
