local RoduxGames = script:FindFirstAncestor("RoduxGames")
local RoduxGamesParent = RoduxGames.Parent
local Rodux = require(RoduxGamesParent.Rodux)
local Dash = require(RoduxGamesParent.Dash)
local GameMediaModel = require(RoduxGames.Models.GameMediaModel)
local t1 = {}

return function(p1) -- line: 13
	-- upvalues: Rodux (copy), t1 (copy), Dash (copy), GameMediaModel (copy)
	local networkingGames = p1.networkingGames

	return Rodux.createReducer(t1, {
		[networkingGames.GetExperienceMedia.Succeeded.name] = function(p2, p3) -- line: 16
			-- upvalues: Dash (copy), GameMediaModel (copy)
			local str = tostring(p3.ids[1])

			return Dash.join(p2, {
				[str] = Dash.map(p3.responseBody.data, function(p4) -- line: 19
					-- upvalues: GameMediaModel (copy)
					return GameMediaModel.format(p4)
				end)
			})
		end
	})
end
