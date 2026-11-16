local script = script
local parent = script.Parent
local llama = require(parent.llama)
local RoduxNetworking = require(parent.RoduxNetworking)
local AliasNetworking = require(parent.AliasNetworking)

local AliasesReducer = require(script.Reducers.AliasesReducer)
local Actions = require(script.Actions)
local Selectors = require(script.Selectors)

require(script.RoduxAliasesTypes)

return {
	config = function(p)
		local joined = llama.Dictionary.join(p, {
			aliasNetworking = AliasNetworking.config({ roduxNetworking = RoduxNetworking.mock() })
		})

		return {
			installReducer = function()
				return AliasesReducer(joined)
			end,
			Actions = Actions,
			Selectors = Selectors(joined)
		}
	end
}
