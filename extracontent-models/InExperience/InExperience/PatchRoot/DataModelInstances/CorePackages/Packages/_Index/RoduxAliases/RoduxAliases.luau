local _script = script
local _scriptParent = _script.Parent
local llama = require(_scriptParent.llama)
local RoduxNetworking = require(_scriptParent.RoduxNetworking)
local AliasNetworking = require(_scriptParent.AliasNetworking)
local AliasesReducer = require(_script.Reducers.AliasesReducer)
local Actions = require(_script.Actions)
local Selectors = require(_script.Selectors)

require(_script.RoduxAliasesTypes)

return {
	config = function(p1) -- line: 16
		-- upvalues: llama (copy), AliasNetworking (copy), RoduxNetworking (copy), AliasesReducer (copy), Actions (copy), Selectors (copy)
		local u10 = llama.Dictionary.join(p1, {
			aliasNetworking = AliasNetworking.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function() -- line: 24
				-- upvalues: AliasesReducer (copy), u10 (ref)
				return AliasesReducer(u10)
			end,
			Actions = Actions,
			Selectors = Selectors(u10)
		}
	end
}
