local Reducers = require(script.Reducers)
local Actions = require(script.Actions)
local Models = require(script.Models)
local Enums = require(script.Enums)
local scriptParent = script.Parent
local Cryo = require(scriptParent.Cryo)
local RoduxNetworking = require(scriptParent.RoduxNetworking)
local ShareLinksNetworking = require(scriptParent.ShareLinksNetworking)

return {
	config = function(p1) -- line: 13
		-- upvalues: Cryo (copy), ShareLinksNetworking (copy), RoduxNetworking (copy), Reducers (copy), Actions (copy), Models (copy), Enums (copy)
		local u10 = Cryo.Dictionary.join(p1, {
			shareLinksNetworking = ShareLinksNetworking.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function() -- line: 21
				-- upvalues: Reducers (copy), u10 (ref)
				return Reducers(u10)
			end,
			Actions = Actions,
			Models = Models,
			Enums = Enums
		}
	end
}
