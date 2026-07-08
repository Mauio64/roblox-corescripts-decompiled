local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Boolean = require(ParentParentParent.LuauPolyfill).Boolean
local t1 = {}
local InvariantError = require(ParentParent.jsutils.invariant).InvariantError

function t1.checkFetcher(p1: ((...any) -> ...any)?) -- line: 22
	-- upvalues: Boolean (copy), InvariantError (copy)
	if not Boolean.toJSBoolean(p1) and typeof(_G.fetch) == "nil" then
		error(InvariantError.new("\n\"fetch\" has not been found globally and no fetcher has been configured. To fix this, install a fetch package (like https://www.npmjs.com/package/cross-fetch), instantiate the fetcher, and pass it into your HttpLink constructor. For example:\n\nimport fetch from 'cross-fetch';\nimport { ApolloClient, HttpLink } from '@apollo/client';\nconst client = new ApolloClient({\n  link: new HttpLink({ uri: '/graphql', fetch })\n});\n    "))
	end
end

return t1
