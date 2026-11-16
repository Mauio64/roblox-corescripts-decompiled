local RoduxGames = script:FindFirstAncestor("RoduxGames")
local parent = RoduxGames.Parent
local Rodux = require(parent.Rodux)
local Dash = require(parent.Dash)
local GameMediaModel = require(RoduxGames.Models.GameMediaModel)

local v = {}

return function(p)
	local networkingGames = p.networkingGames
	return Rodux.createReducer(v, {
		[networkingGames.GetExperienceMedia.Succeeded.name] = function(p2, p3)
			local v2 = tostring(p3.ids[1])
			return Dash.join(p2, {
				[v2] = Dash.map(p3.responseBody.data, function(p4)
					return GameMediaModel.format(p4)
				end)
			})
		end
	})
end
