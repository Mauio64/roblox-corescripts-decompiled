local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Actions = Modules.LuaApp.Actions
local SetGamePasses = require(Actions.Games.SetGamePasses)
local Promise = require(Modules.LuaApp.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ApiFetchPassesThumbnails = require(Modules.LuaApp.Thunks.ApiFetchPassesThumbnails)
local GamePassesListByUniverse = require(Modules.LuaApp.Http.Requests.GamePassesHttpService.GamePassesListByUniverse)

return function(p1, p2) -- line: 11
	-- upvalues: PerformFetch (copy), GamePassesListByUniverse (copy), SetGamePasses (copy), ApiFetchPassesThumbnails (copy), Promise (copy)
	return PerformFetch.Single("ApiFetchGamePasses" .. p2, function(p3) -- line: 12
		-- upvalues: GamePassesListByUniverse (copy), p1 (copy), p2 (copy), SetGamePasses (copy), ApiFetchPassesThumbnails (copy), Promise (copy)
		return GamePassesListByUniverse(p1, p2):andThen(function(p4) -- line: 13
			-- upvalues: p3 (copy), SetGamePasses (copy), p2 (copy), ApiFetchPassesThumbnails (copy), p1 (copy), Promise (copy)
			local gamePasses = p4.responseBody.gamePasses

			p3:dispatch(SetGamePasses(p2, gamePasses))

			if #gamePasses > 0 then
				local t1 = {}

				for _, v in ipairs(gamePasses) do
					table.insert(t1, v.id)
				end

				p3:dispatch(ApiFetchPassesThumbnails(p1, t1))
			end

			return Promise.resolve(p4)
		end)
	end)
end
