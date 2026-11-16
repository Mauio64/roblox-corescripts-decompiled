local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local language = parent.language
local kinds = require(language.kinds)
local kind = kinds.Kind

return {
	LoneAnonymousOperationRule = function(object)
		local v = 0
		return {
			Document = function(_, p)
				v = #Array.filter(p.definitions, function(p2): boolean
					return p2.kind == kind.OPERATION_DEFINITION
				end)
			end,
			OperationDefinition = function(_, p)
				if not p.name and v > 1 then
					object:reportError(graphQLError.new(
						"This anonymous operation must be the only defined operation.",
						p
					))
				end
			end
		}
	end
}
