local Reducers = require(script.Reducers)
local Actions = require(script.Actions)
local Models = require(script.Models)
local Enums = require(script.Enums)

local parent = script.Parent
local Cryo = require(parent.Cryo)
local RoduxNetworking = require(parent.RoduxNetworking)
local ShareLinksNetworking = require(parent.ShareLinksNetworking)

return {
	config = function(p)
		local joined = Cryo.Dictionary.join(p, {
			shareLinksNetworking = ShareLinksNetworking.config({
				roduxNetworking = RoduxNetworking.mock()
			})
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
