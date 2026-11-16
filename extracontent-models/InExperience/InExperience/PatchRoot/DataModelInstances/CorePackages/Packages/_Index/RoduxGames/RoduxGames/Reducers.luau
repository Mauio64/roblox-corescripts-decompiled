local parent = script:FindFirstAncestor("RoduxGames").Parent
local Rodux = require(parent.Rodux)

local playabilityByGameId = require(script.Games.playabilityByGameId)
local productInfoByGameId = require(script.Games.productInfoByGameId)
local byGameId = require(script.Games.byGameId)
local mediaByGameId = require(script.Games.mediaByGameId)

return function(p)
	return Rodux.combineReducers({
		playabilityByGameId = playabilityByGameId(p),
		productInfoByGameId = productInfoByGameId(p),
		byGameId = byGameId(p),
		mediaByGameId = mediaByGameId(p)
	})
end
