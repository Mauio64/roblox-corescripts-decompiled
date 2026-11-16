local parent = script.Parent
local GraphQLError = require(parent.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

return {
	syntaxError = function(p, p2: number, p3: string)
		return graphQLError.new("Syntax Error: " .. p3, nil, p, { p2 })
	end
}
