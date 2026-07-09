local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local GetRobuxBadge = require(Modules.LuaApp.Http.Requests.GetRobuxBadge)
local Promise = require(Modules.LuaApp.Promise)

return function(p1) -- line: 9
	-- upvalues: PerformFetch (copy), GetRobuxBadge (copy), Promise (copy)
	return PerformFetch.Single("FetchRobuxBadge", function(_) -- line: 10
		-- upvalues: GetRobuxBadge (copy), p1 (copy), Promise (copy)
		return GetRobuxBadge(p1):andThen(function(p3) -- line: 11
			-- upvalues: Promise (copy)
			if not p3 then
				return Promise.resolve()
			end

			local v9 = p3[1]

			return Promise.resolve(v9)
		end, function(_) -- line: 17
			-- upvalues: Promise (copy)
			return Promise.resolve()
		end)
	end)
end
