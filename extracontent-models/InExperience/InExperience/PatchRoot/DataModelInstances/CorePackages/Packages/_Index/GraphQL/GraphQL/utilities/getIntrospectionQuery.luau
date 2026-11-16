local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

require(script.Parent.Parent.language.directiveLocation)

function getIntrospectionQuery(p)
	local v = Object.assign({
		descriptions = true,
		specifiedByUrl = false,
		directiveIsRepeatable = false,
		schemaDescription = false,
		inputValueDeprecation = false
	}, p)

	local v2 = v.descriptions and "description" or ""
	local v3 = v.specifiedByUrl and "specifiedByUrl" or ""
	local v4 = v.directiveIsRepeatable and "isRepeatable" or ""

	local function inputDeprecation(p2)
		return if v.inputValueDeprecation then p2 else ""
	end

	return ("\n    query IntrospectionQuery {\n      __schema {\n        %s\n        queryType { name }\n        mutationType { name }\n        subscriptionType { name }\n        types {\n          ...FullType\n        }\n        directives {\n          name\n          %s\n          %s\n          locations\n          args%s {\n            ...InputValue\n          }\n        }\n      }\n    }\n\n    fragment FullType on __Type {\n      kind\n      name\n      %s\n      %s\n      fields(includeDeprecated: true) {\n        name\n        %s\n        args%s {\n          ...InputValue\n        }\n        type {\n          ...TypeRef\n        }\n        isDeprecated\n        deprecationReason\n      }\n      inputFields%s {\n        ...InputValue\n      }\n      interfaces {\n        ...TypeRef\n      }\n      enumValues(includeDeprecated: true) {\n        name\n        %s\n        isDeprecated\n        deprecationReason\n      }\n      possibleTypes {\n        ...TypeRef\n      }\n    }\n\n    fragment InputValue on __InputValue {\n      name\n      %s\n      type { ...TypeRef }\n      defaultValue\n      %s\n      %s\n    }\n\n    fragment TypeRef on __Type {\n      kind\n      name\n      ofType {\n        kind\n        name\n        ofType {\n          kind\n          name\n          ofType {\n            kind\n            name\n            ofType {\n              kind\n              name\n              ofType {\n                kind\n                name\n                ofType {\n                  kind\n                  name\n                  ofType {\n                    kind\n                    name\n                  }\n                }\n              }\n            }\n          }\n        }\n      }\n    }\n  "):format(
		not v.schemaDescription and "" or v2,
		v2,
		v4,
		v.inputValueDeprecation and "(includeDeprecated: true)" or "",
		v2,
		v3,
		v2,
		v.inputValueDeprecation and "(includeDeprecated: true)" or "",
		v.inputValueDeprecation and "(includeDeprecated: true)" or "",
		v2,
		v2,
		v.inputValueDeprecation and "isDeprecated" or "",
		v.inputValueDeprecation and "deprecationReason" or ""
	)
end

return { getIntrospectionQuery = getIntrospectionQuery }
