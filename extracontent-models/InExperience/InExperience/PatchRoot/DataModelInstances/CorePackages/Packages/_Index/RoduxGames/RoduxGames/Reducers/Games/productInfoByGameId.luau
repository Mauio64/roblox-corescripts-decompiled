local RoduxGames = script:FindFirstAncestor("RoduxGames")
local parent = RoduxGames.Parent
local Rodux = require(parent.Rodux)
local Dash = require(parent.Dash)
local ProductModel = require(RoduxGames.Models.ProductModel)

local v = {}

return function(p)
	local networkingGames = p.networkingGames

	return Rodux.createReducer(v, {
		[networkingGames.GetExperiencesProductInfo.Succeeded.name] = function(p2, p3)
			return Dash.reduce(p3.responseBody.data, function(p4, p5)
				local universeId = tostring(p5.universeId)

				return Dash.join(p4, { [universeId] = ProductModel.format(p5) })
			end, p2)
		end
	})
end
