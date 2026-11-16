local parent = script.Parent
local RoduxNetworking = require(parent.RoduxNetworking)
local Dash = require(parent.Dash)
local NetworkingGames = require(parent.NetworkingGames)

local Reducers = require(script.Reducers)
local Actions = require(script.Actions)
local Models = require(script.Models)
local Enums = require(script.Enums)

return {
	config = function(p)
		local joined = Dash.join(p, {
			networkingGames = NetworkingGames.config({ roduxNetworking = RoduxNetworking.mock() })
		})

		return {
			installReducer = function()
				return Reducers(joined)
			end,
			Actions = Actions,
			Models = Models,
			Enums = Enums
		}
	end
}
