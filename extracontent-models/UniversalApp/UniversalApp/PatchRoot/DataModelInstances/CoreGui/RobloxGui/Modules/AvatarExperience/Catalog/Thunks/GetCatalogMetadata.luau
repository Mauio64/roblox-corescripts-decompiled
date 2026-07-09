local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local SetCatalogMetadata = require(Modules.AvatarExperience.Catalog.Actions.SetCatalogMetadata)

return function(p1) -- line: 16
	-- upvalues: ArgCheck (copy), PerformFetch (copy), WebApi (copy), SetCatalogMetadata (copy), Logging (copy), Promise (copy)
	ArgCheck.isType(p1, "function", "GetCatalogMetadata thunk expects networkImpl to be a function")

	return PerformFetch.Single("catalog.getcatalogmetadata", function(p2) -- line: 19
		-- upvalues: WebApi (copy), p1 (copy), SetCatalogMetadata (copy), Logging (copy), Promise (copy)
		return WebApi.GetCatalogMetadata(p1):andThen(function(p3) -- line: 20
			-- upvalues: p2 (copy), SetCatalogMetadata (copy)
			local responseBody = p3.responseBody

			if responseBody then
				p2:dispatch(SetCatalogMetadata(responseBody))
			end

			return responseBody
		end, function(p4) -- line: 27
			-- upvalues: Logging (copy), p2 (copy), SetCatalogMetadata (copy), Promise (copy)
			Logging.warn("WebApi failure in GetCatalogMetadata")
			p2:dispatch(SetCatalogMetadata({}))
			Promise.reject(p4)
		end)
	end)
end
