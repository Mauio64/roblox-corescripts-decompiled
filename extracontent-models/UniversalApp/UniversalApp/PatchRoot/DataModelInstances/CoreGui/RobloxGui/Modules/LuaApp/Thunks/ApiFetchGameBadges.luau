local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Actions = Modules.LuaApp.Actions
local SetGameBadges = require(Actions.SetGameBadges)
local Promise = require(Modules.LuaApp.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local BadgesGetBadges = require(Modules.LuaApp.Http.Requests.BadgesGetBadges)

return function(p1, p2) -- line: 10
	-- upvalues: PerformFetch (copy), BadgesGetBadges (copy), SetGameBadges (copy), Promise (copy)
	return PerformFetch.Single("ApiFetchGameBadges" .. p2, function(p3) -- line: 11
		-- upvalues: BadgesGetBadges (copy), p1 (copy), p2 (copy), SetGameBadges (copy), Promise (copy)
		return BadgesGetBadges(p1, p2):andThen(function(p4) -- line: 12
			-- upvalues: p3 (copy), SetGameBadges (copy), p2 (copy), Promise (copy)
			local data = p4.responseBody.data

			p3:dispatch(SetGameBadges(p2, data))

			return Promise.resolve(p4)
		end)
	end)
end
