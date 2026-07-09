local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(Modules.LuaApp.Promise)
local GameGetIsFavorite = require(Modules.LuaApp.Http.Requests.GamesApi.GameGetIsFavorite)
local SetGameFavorite = require(Modules.LuaApp.Actions.Games.SetGameFavorite)

return function(p1, p2) -- line: 8
	-- upvalues: GameGetIsFavorite (copy), SetGameFavorite (copy), Logging (copy), Promise (copy)
	if type(p2) ~= "string" then
		error("ApiFetchGameIsFavorite thunk expects universeId to be a string")
	end

	return function(p3) -- line: 13
		-- upvalues: GameGetIsFavorite (copy), p1 (copy), p2 (copy), SetGameFavorite (copy), Logging (copy), Promise (copy)
		return GameGetIsFavorite(p1, p2):andThen(function(p4) -- line: 14
			-- upvalues: p3 (copy), SetGameFavorite (copy), p2 (copy), Logging (copy), Promise (copy)
			local responseBody = p4.responseBody

			if responseBody ~= nil and responseBody.isFavorited ~= nil then
				p3:dispatch(SetGameFavorite(p2, responseBody.isFavorited))

				return p4
			end

			Logging.warn("Response from GameGetIsFavorite is malformed!")

			return Promise.reject({
				HttpError = Enum.HttpError.OK
			})
		end)
	end
end
