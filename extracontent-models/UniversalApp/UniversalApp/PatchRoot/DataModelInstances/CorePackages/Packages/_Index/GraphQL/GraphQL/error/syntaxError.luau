local scriptParent = script.Parent
local GraphQLError = require(scriptParent.GraphQLError).GraphQLError

return {
	syntaxError = function(p1, n1: number, s1: string) -- line: 16
		-- upvalues: GraphQLError (copy)
		return GraphQLError.new("Syntax Error: " .. s1, nil, p1, { n1 })
	end
}
