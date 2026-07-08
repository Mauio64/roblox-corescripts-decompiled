local scriptParent = script.Parent
local RoduxNetworking = require(scriptParent.RoduxNetworking)
local Dash = require(scriptParent.Dash)
local NetworkingGames = require(scriptParent.NetworkingGames)
local Reducers = require(script.Reducers)
local Actions = require(script.Actions)
local Models = require(script.Models)
local Enums = require(script.Enums)

return {
	config = function(p1) -- line: 12
		-- upvalues: Dash (copy), NetworkingGames (copy), RoduxNetworking (copy), Reducers (copy), Actions (copy), Models (copy), Enums (copy)
		local u10 = Dash.join(p1, {
			networkingGames = NetworkingGames.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function() -- line: 20
				-- upvalues: Reducers (copy), u10 (ref)
				return Reducers(u10)
			end,
			Actions = Actions,
			Models = Models,
			Enums = Enums
		}
	end
}
