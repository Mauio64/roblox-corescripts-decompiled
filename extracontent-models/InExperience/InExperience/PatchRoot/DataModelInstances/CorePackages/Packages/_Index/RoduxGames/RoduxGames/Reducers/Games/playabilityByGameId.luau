local RoduxGames = script:FindFirstAncestor("RoduxGames")
local RoduxGamesParent = RoduxGames.Parent
local Rodux = require(RoduxGamesParent.Rodux)
local Dash = require(RoduxGamesParent.Dash)
local PlayabilityStatus = require(RoduxGames.Enums.PlayabilityStatus)
local t1 = {}

return function(p1) -- line: 13
	-- upvalues: Rodux (copy), t1 (copy), Dash (copy), PlayabilityStatus (copy)
	local networkingGames = p1.networkingGames

	return Rodux.createReducer(t1, {
		[networkingGames.GetExperiencesPlayabilityStatus.Succeeded.name] = function(p2, p3) -- line: 17
			-- upvalues: Dash (copy), PlayabilityStatus (copy)
			return Dash.reduce(p3.responseBody, function(p4, p5) -- line: 18
				-- upvalues: Dash (copy), PlayabilityStatus (copy)
				local universeId = p5.universeId
				local playabilityStatus = p5.playabilityStatus

				return Dash.join(p4, {
					[universeId] = PlayabilityStatus.fromRawValue(playabilityStatus)
				})
			end, p2)
		end
	})
end
