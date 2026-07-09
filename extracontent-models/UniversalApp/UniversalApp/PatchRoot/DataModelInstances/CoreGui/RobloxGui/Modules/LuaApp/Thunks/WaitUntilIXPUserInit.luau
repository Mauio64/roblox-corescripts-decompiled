local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local FetchIXPUserInit = require(Modules.LuaApp.Thunks.FetchIXPUserInit)
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local Promise = require(Modules.LuaApp.Promise)

return function(p1, p2, p3) -- line: 7
	-- upvalues: FetchIXPUserInit (copy), RetrievalStatus (copy), Promise (copy)
	return function(p4) -- line: 8
		-- upvalues: FetchIXPUserInit (copy), p2 (copy), p1 (copy), RetrievalStatus (copy), Promise (copy), p3 (copy)
		local v10 = FetchIXPUserInit.GetFetchingStatus(p4:getState(), p2, p1)

		if v10 == RetrievalStatus.Done or v10 == RetrievalStatus.Failed then
			return Promise.resolve()
		end

		return Promise.new(function(resolve, _) -- line: 14
			-- upvalues: p4 (copy), FetchIXPUserInit (copy), p1 (copy), p2 (copy), p3 (copy)
			p4:dispatch(FetchIXPUserInit.Fetch(p1, p2, p3)):andThen(function() -- line: 15
				-- upvalues: resolve (copy)
				resolve()
			end, function() -- line: 17
				-- upvalues: resolve (copy)
				resolve()
			end)
		end)
	end
end
