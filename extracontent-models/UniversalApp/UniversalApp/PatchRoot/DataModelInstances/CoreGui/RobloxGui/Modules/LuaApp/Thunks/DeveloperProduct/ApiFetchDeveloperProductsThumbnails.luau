local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local ApiFetchThumbnails = require(CorePackages.Workspace.Packages.Http).Utils.ApiFetchThumbnails
local DeveloperProductsGetThumbnails = require(Modules.LuaApp.Http.Requests.DeveloperProductApi.DeveloperProductsGetThumbnails)
local SetDeveloperProductsThumbnails = require(Modules.LuaApp.Actions.DeveloperProduct.SetDeveloperProductsThumbnails)

return function(p1, p2) -- line: 12
	-- upvalues: Promise (copy), ApiFetchThumbnails (copy), DeveloperProductsGetThumbnails (copy), SetDeveloperProductsThumbnails (copy)
	return function(p3) -- line: 13
		-- upvalues: p2 (copy), Promise (copy), ApiFetchThumbnails (copy), p1 (copy), DeveloperProductsGetThumbnails (copy), SetDeveloperProductsThumbnails (copy)
		local DeveloperProductsThumbnails = p3:getState().DeveloperProductsThumbnails
		local t1 = {}

		if DeveloperProductsThumbnails then
			for _, v13 in p2 do
				if DeveloperProductsThumbnails[tostring(v13)] == nil then
					table.insert(t1, v13)
				end
			end
		else
			t1 = p2
		end

		if #t1 == 0 then
			return Promise.resolve()
		end

		return ApiFetchThumbnails.Fetch(p1, t1, "150x150", "DeveloperProducts", DeveloperProductsGetThumbnails, SetDeveloperProductsThumbnails, p3)
	end
end
