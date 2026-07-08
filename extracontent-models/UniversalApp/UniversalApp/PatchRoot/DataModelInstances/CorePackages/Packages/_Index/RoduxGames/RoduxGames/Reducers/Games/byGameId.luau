local RoduxGames = script:FindFirstAncestor("RoduxGames")
local RoduxGamesParent = RoduxGames.Parent
local Rodux = require(RoduxGamesParent.Rodux)
local Dash = require(RoduxGamesParent.Dash)
local GameModel = require(RoduxGames.Models.GameModel)
local t1 = {}

return function(p1) -- line: 13
	-- upvalues: Rodux (copy), t1 (copy), Dash (copy), GameModel (copy)
	local networkingGames = p1.networkingGames

	return Rodux.createReducer(t1, {
		[networkingGames.GetExperiencesDetails.Succeeded.name] = function(p2, p3) -- line: 17
			-- upvalues: Dash (copy), GameModel (copy)
			return Dash.reduce(p3.responseBody.data, function(p4, p5) -- line: 18
				-- upvalues: Dash (copy), GameModel (copy)
				local str = tostring(p5.id)

				return Dash.join(p4, {
					[str] = GameModel.format(p5)
				})
			end, p2)
		end
	})
end
