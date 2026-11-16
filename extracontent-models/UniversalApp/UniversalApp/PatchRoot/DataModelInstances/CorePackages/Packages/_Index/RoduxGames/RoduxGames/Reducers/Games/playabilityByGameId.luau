local RoduxGames = script:FindFirstAncestor("RoduxGames")
local parent = RoduxGames.Parent
local Rodux = require(parent.Rodux)
local Dash = require(parent.Dash)
local PlayabilityStatus = require(RoduxGames.Enums.PlayabilityStatus)

local v = {}

return function(p)
	local networkingGames = p.networkingGames

	return Rodux.createReducer(v, {
		[networkingGames.GetExperiencesPlayabilityStatus.Succeeded.name] = function(p2, p3)
			return Dash.reduce(p3.responseBody, function(p4, p5)
				local universeId = p5.universeId
				local playabilityStatus = p5.playabilityStatus

				return Dash.join(p4, {
					[universeId] = PlayabilityStatus.fromRawValue(playabilityStatus)
				})
			end, p2)
		end
	})
end
