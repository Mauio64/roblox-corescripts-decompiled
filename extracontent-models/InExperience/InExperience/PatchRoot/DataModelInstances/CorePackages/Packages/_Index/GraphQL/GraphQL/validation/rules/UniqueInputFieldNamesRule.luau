local parent = script.Parent.Parent.Parent
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
require(parent.language.visitor)

require(script.Parent.Parent.ValidationContext)

local language = parent.language

require(language.ast)

return {
	UniqueInputFieldNamesRule = function(object)
		local v = {}
		local names = {}

		return {
			ObjectValue = {
				enter = function()
					table.insert(v, names)
					names = {}
				end,
				leave = function()
					names = table.remove(v)
				end
			},
			ObjectField = function(_, p)
				local value = p.name.value

				if names[value] then
					object:reportError(graphQLError.new(
						("There can be only one input field named \"%s\"."):format(value),
						{ names[value], p.name }
					))
				else
					names[value] = p.name
				end
			end
		}
	end
}
