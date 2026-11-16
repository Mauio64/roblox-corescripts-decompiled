local parent = script.Parent
local Cryo = require(parent.Cryo)
local RoduxNetworking = require(parent.RoduxNetworking)
local NetworkingPresence = require(parent.NetworkingPresence)

local Reducer = require(script.Reducer)
local Actions = require(script.Actions)
local Selectors = require(script.Selectors)
local Models = require(script.Models)
local Enums = require(script.Enums)

return {
	config = function(p)
		local joined = Cryo.Dictionary.join(p, {
			presenceNetworking = NetworkingPresence.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function()
				return Reducer(joined)
			end,
			Actions = Actions(joined),
			Selectors = Selectors(joined),
			Models = Models,
			Enums = Enums
		}
	end
}
