local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Promise = require(Modules.LuaApp.Promise)
local GamePostFavorite = require(Modules.LuaApp.Http.Requests.GamesApi.GamePostFavorite)
local SetGameFavorite = require(Modules.LuaApp.Actions.Games.SetGameFavorite)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch

local function GamePostFavorite2(p1, p2, p3) -- line: 9
	-- upvalues: PerformFetch (copy), GamePostFavorite (copy), GamePostFavorite2 (copy), Promise (copy), SetGameFavorite (copy), SetNetworkingErrorToast (copy)
	if type(p2) ~= "string" then
		error("GamePostFavorite thunk expects universeId to be a string")
	end

	if type(p3) ~= "boolean" then
		error("GamePostFavorite thunk expects isFavorited to be a boolean")
	end

	return PerformFetch.Single("GamePostFavorite" .. p2, function(p4) -- line: 18
		-- upvalues: GamePostFavorite (copy), p1 (copy), p2 (copy), p3 (copy), GamePostFavorite2 (copy), Promise (copy), SetGameFavorite (copy), SetNetworkingErrorToast (copy)
		return GamePostFavorite(p1, p2, p3):andThen(function(p5) -- line: 19
			-- upvalues: p4 (copy), p2 (copy), p3 (copy), GamePostFavorite2 (copy), p1 (copy), Promise (copy)
			local v14 = p4:getState().GameFavorites[p2]

			if v14 ~= p3 then
				return GamePostFavorite2(p1, p2, v14)
			end

			return Promise.resolve(p5)
		end, function(p6) -- line: 27
			-- upvalues: p4 (copy), SetGameFavorite (copy), p2 (copy), p3 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			p4:dispatch(SetGameFavorite(p2, not p3))
			p4:dispatch(SetNetworkingErrorToast(p6))

			return Promise.reject(p6)
		end)
	end)
end

return GamePostFavorite2
