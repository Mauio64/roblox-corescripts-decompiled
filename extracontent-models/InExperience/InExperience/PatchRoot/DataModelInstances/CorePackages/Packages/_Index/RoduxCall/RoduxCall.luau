local Actions = require(script.Actions)
local Enums = require(script.Enums)
local Reducers = require(script.Reducers)
local Models = require(script.Models)
local scriptParent = script.Parent
local Cryo = require(scriptParent.Cryo)
local RoduxNetworking = require(scriptParent.RoduxNetworking)
local NetworkingCall = require(scriptParent.NetworkingCall)

return {
	config = function(p1) -- line: 12
		-- upvalues: Cryo (copy), NetworkingCall (copy), RoduxNetworking (copy), Reducers (copy), Actions (copy), Enums (copy), Models (copy)
		local u10 = Cryo.Dictionary.join(p1, {
			NetworkingCall = NetworkingCall.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function() -- line: 20
				-- upvalues: Reducers (copy), u10 (ref)
				return Reducers(u10)
			end,
			Actions = Actions,
			Enums = Enums,
			Models = Models
		}
	end
}
