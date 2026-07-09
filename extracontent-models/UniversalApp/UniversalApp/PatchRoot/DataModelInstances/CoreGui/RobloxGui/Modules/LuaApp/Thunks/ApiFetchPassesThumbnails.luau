local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local ApiFetchThumbnails = require(CorePackages.Workspace.Packages.Http).Utils.ApiFetchThumbnails
local PassesGetThumbnails = require(Modules.LuaApp.Http.Requests.PassesGetThumbnails)
local SetPassesThumbnails = require(Modules.LuaApp.Actions.SetPassesThumbnails)

return function(p1, p2) -- line: 11
	-- upvalues: Promise (copy), ApiFetchThumbnails (copy), PassesGetThumbnails (copy), SetPassesThumbnails (copy)
	return function(p3) -- line: 12
		-- upvalues: p2 (copy), Promise (copy), ApiFetchThumbnails (copy), p1 (copy), PassesGetThumbnails (copy), SetPassesThumbnails (copy)
		local PassesThumbnails = p3:getState().PassesThumbnails
		local t1 = {}

		if PassesThumbnails then
			for _, v in ipairs(p2) do
				if PassesThumbnails[tostring(v)] == nil then
					table.insert(t1, v)
				end
			end
		else
			t1 = p2
		end

		if #t1 == 0 then
			return Promise.resolve()
		end

		return ApiFetchThumbnails.Fetch(p1, t1, "150x150", "Pass", PassesGetThumbnails, SetPassesThumbnails, p3)
	end
end
