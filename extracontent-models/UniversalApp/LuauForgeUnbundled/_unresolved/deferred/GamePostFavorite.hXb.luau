local module = require("@luauforge/bundled/egs")
local module2 = require("@luauforge/deferred/hXc")
local module3 = require("@luauforge/bundled/dCC")
local module4 = require("@luauforge/bundled/egt")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local function GamePostFavorite(p2, value, gameFavorite)
	if type(value) ~= "string" then
		error("GamePostFavorite thunk expects universeId to be a string")
	end

	if type(gameFavorite) ~= "boolean" then
		error("GamePostFavorite thunk expects isFavorited to be a boolean")
	end

	return performFetch.Single("GamePostFavorite" .. value, function(object)
		return module2(p2, value, gameFavorite):andThen(function(p3)
			local gameFavorite2 = object:getState().GameFavorites[value]

			if gameFavorite2 == gameFavorite then
				return module.resolve(p3)
			end

			return GamePostFavorite(p2, value, gameFavorite2)
		end, function(p3)
			object:dispatch(module3(value, not gameFavorite))
			object:dispatch(module4(p3))
			return module.reject(p3)
		end)
	end)
end

return GamePostFavorite
