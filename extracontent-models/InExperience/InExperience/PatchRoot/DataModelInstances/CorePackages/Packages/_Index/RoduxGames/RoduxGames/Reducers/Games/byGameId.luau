local RoduxGames = script:FindFirstAncestor("RoduxGames")
local parent = RoduxGames.Parent
local Rodux = require(parent.Rodux)
local Dash = require(parent.Dash)
local GameModel = require(RoduxGames.Models.GameModel)

local v = {}

return function(p)
	local networkingGames = p.networkingGames

	return Rodux.createReducer(v, {
		[networkingGames.GetExperiencesDetails.Succeeded.name] = function(p2, p3)
			return Dash.reduce(p3.responseBody.data, function(p4, p5)
				local id = tostring(p5.id)

				return Dash.join(p4, { [id] = GameModel.format(p5) })
			end, p2)
		end
	})
end
