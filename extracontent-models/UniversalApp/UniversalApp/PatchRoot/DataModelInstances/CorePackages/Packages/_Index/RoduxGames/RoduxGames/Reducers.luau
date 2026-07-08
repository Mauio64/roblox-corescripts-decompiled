local Parent = script:FindFirstAncestor("RoduxGames").Parent
local Rodux = require(Parent.Rodux)
local playabilityByGameId = require(script.Games.playabilityByGameId)
local productInfoByGameId = require(script.Games.productInfoByGameId)
local byGameId = require(script.Games.byGameId)
local mediaByGameId = require(script.Games.mediaByGameId)

return function(p1) -- line: 9
	-- upvalues: Rodux (copy), playabilityByGameId (copy), productInfoByGameId (copy), byGameId (copy), mediaByGameId (copy)
	return Rodux.combineReducers({
		playabilityByGameId = playabilityByGameId(p1),
		productInfoByGameId = productInfoByGameId(p1),
		byGameId = byGameId(p1),
		mediaByGameId = mediaByGameId(p1)
	})
end
