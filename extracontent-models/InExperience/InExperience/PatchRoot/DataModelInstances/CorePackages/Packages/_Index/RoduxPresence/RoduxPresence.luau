local scriptParent = script.Parent
local Cryo = require(scriptParent.Cryo)
local RoduxNetworking = require(scriptParent.RoduxNetworking)
local NetworkingPresence = require(scriptParent.NetworkingPresence)
local Reducer = require(script.Reducer)
local Actions = require(script.Actions)
local Selectors = require(script.Selectors)
local Models = require(script.Models)
local Enums = require(script.Enums)

return {
	config = function(p1) -- line: 13
		-- upvalues: Cryo (copy), NetworkingPresence (copy), RoduxNetworking (copy), Reducer (copy), Actions (copy), Selectors (copy), Models (copy), Enums (copy)
		local u11 = Cryo.Dictionary.join(p1, {
			presenceNetworking = NetworkingPresence.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function() -- line: 21
				-- upvalues: Reducer (copy), u11 (ref)
				return Reducer(u11)
			end,
			Actions = Actions(u11),
			Selectors = Selectors(u11),
			Models = Models,
			Enums = Enums
		}
	end
}
