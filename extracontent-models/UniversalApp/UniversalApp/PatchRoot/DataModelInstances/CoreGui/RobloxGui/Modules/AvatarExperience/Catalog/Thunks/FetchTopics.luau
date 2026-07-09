local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local Dash = require(CorePackages.Packages.Dash)
local Modules = CoreGui.RobloxGui.Modules
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging

require(CorePackages.Workspace.Packages.Http)

local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local SetTopics = require(Modules.AvatarExperience.Catalog.Actions.SetTopics)

local function keyMapper(t1: {[any]: any}, t2: {[any]: any}?, s1: string?) -- line: 32
	-- upvalues: CatalogConstants (copy), CatalogUtils (copy)
	return CatalogConstants.GetTopicsKey .. CatalogUtils.getTopicRequestKey(t1, t2, s1)
end

return function(p1, t3: {[any]: any}, t4: {[any]: any}?, s2: string?) -- line: 36
	-- upvalues: PerformFetch (copy), CatalogConstants (copy), CatalogUtils (copy), WebApi (copy), Dash (copy), SetTopics (copy), Promise (copy), Logging (copy)
	return PerformFetch.Single(CatalogConstants.GetTopicsKey .. CatalogUtils.getTopicRequestKey(t3, t4, s2), function(p2) -- line: 42
		-- upvalues: t3 (copy), s2 (copy), WebApi (copy), p1 (copy), t4 (copy), Dash (copy), SetTopics (copy), Promise (copy), Logging (copy)
		return ((if #t3 ~= 0 or s2 then WebApi.GetTopics(p1, t3, s2) else WebApi.GetInitialTopics(p1, t4 or {}))):andThen(function(p3) -- line: 47
			-- upvalues: Dash (copy), p2 (copy), SetTopics (copy), t3 (copy), t4 (copy), s2 (copy), Promise (copy)
			local v22 = p3.responseBody or {}
			local v23 = Dash.map(v22.topics or {}, function(p4) -- line: 49
				return string.lower(p4.displayName)
			end)

			p2:dispatch(SetTopics(t3, t4, s2, v23))

			return Promise.resolve(v23)
		end, function(p5) -- line: 54
			-- upvalues: Logging (copy)
			Logging.warn("FetchTopics failure: " .. tostring(p5))
		end)
	end)
end
