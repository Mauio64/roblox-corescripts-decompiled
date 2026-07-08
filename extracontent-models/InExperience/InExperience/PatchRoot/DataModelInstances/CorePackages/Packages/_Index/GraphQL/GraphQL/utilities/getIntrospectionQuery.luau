local ParentParent = script.Parent.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object

require(script.Parent.Parent.language.directiveLocation)

function getIntrospectionQuery(t1: {[any]: any}?) -- line: 39
	-- upvalues: Object (copy)
	local v4 = Object.assign({
		descriptions = true,
		specifiedByUrl = false,
		directiveIsRepeatable = false,
		schemaDescription = false,
		inputValueDeprecation = false
	}, t1)
	local v5 = not v4.descriptions and "" or "description"
	local v6 = not v4.specifiedByUrl and "" or "specifiedByUrl"
	local v7 = not v4.directiveIsRepeatable and "" or "isRepeatable"

	local function inputDeprecation(p1) -- line: 55
		-- upvalues: v4 (copy)
		if v4.inputValueDeprecation then
			return p1
		end

		return ""
	end

	return ("\n    query IntrospectionQuery {\n      __schema {\n        %s\n        queryType { name }\n        mutationType { name }\n        subscriptionType { name }\n        types {\n          ...FullType\n        }\n        directives {\n          name\n          %s\n          %s\n          locations\n          args%s {\n            ...InputValue\n          }\n        }\n      }\n    }\n\n    fragment FullType on __Type {\n      kind\n      name\n      %s\n      %s\n      fields(includeDeprecated: true) {\n        name\n        %s\n        args%s {\n          ...InputValue\n        }\n        type {\n          ...TypeRef\n        }\n        isDeprecated\n        deprecationReason\n      }\n      inputFields%s {\n        ...InputValue\n      }\n      interfaces {\n        ...TypeRef\n      }\n      enumValues(includeDeprecated: true) {\n        name\n        %s\n        isDeprecated\n        deprecationReason\n      }\n      possibleTypes {\n        ...TypeRef\n      }\n    }\n\n    fragment InputValue on __InputValue {\n      name\n      %s\n      type { ...TypeRef }\n      defaultValue\n      %s\n      %s\n    }\n\n    fragment TypeRef on __Type {\n      kind\n      name\n      ofType {\n        kind\n        name\n        ofType {\n          kind\n          name\n          ofType {\n            kind\n            name\n            ofType {\n              kind\n              name\n              ofType {\n                kind\n                name\n                ofType {\n                  kind\n                  name\n                  ofType {\n                    kind\n                    name\n                  }\n                }\n              }\n            }\n          }\n        }\n      }\n    }\n  "):format(not v4.schemaDescription and "" or v5, v5, v7, not v4.inputValueDeprecation and "" or "(includeDeprecated: true)", v5, v6, v5, not v4.inputValueDeprecation and "" or "(includeDeprecated: true)", not v4.inputValueDeprecation and "" or "(includeDeprecated: true)", v5, v5, not v4.inputValueDeprecation and "" or "isDeprecated", not v4.inputValueDeprecation and "" or "deprecationReason")
end

return {
	getIntrospectionQuery = getIntrospectionQuery
}
