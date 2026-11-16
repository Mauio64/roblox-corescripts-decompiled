local Actions = require(script.Actions)
local Enums = require(script.Enums)
local Reducers = require(script.Reducers)
local Models = require(script.Models)

local parent = script.Parent
local Cryo = require(parent.Cryo)
local RoduxNetworking = require(parent.RoduxNetworking)
local NetworkingCall = require(parent.NetworkingCall)

return {
	config = function(p)
		local joined = Cryo.Dictionary.join(p, {
			NetworkingCall = NetworkingCall.config({ roduxNetworking = RoduxNetworking.mock() })
		})

		return {
			installReducer = function()
				return Reducers(joined)
			end,
			Actions = Actions,
			Enums = Enums,
			Models = Models
		}
	end
}
