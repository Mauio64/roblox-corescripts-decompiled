local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local SetWidgetInfo = require(Modules.AvatarExperience.Catalog.Actions.SetWidgetInfo)
local ClearWidgetInfo = require(Modules.AvatarExperience.Catalog.Actions.ClearWidgetInfo)
local SearchUuid = require(Modules.LuaApp.SearchUuid)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local Api = AvatarExperienceCatalog.Api
local getAXMarketplaceWidgetStore = AvatarExperienceCatalog.Stores.getAXMarketplaceWidgetStore
local logWidgetLoaded = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).logWidgetLoaded
local FFlagAXPassScreenSizeToWidgetApi = AvatarExperienceFlags.FFlagAXPassScreenSizeToWidgetApi
local FFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly

return function(p1, s1: string?, s2: string?) -- line: 29
	-- upvalues: CatalogUtils (copy), SearchUuid (copy), FFlagAXPassScreenSizeToWidgetApi (copy), FFlagAXMoveAllTabToWidgetOnly (copy), getAXMarketplaceWidgetStore (copy), PerformFetch (copy), ClearWidgetInfo (copy), Api (copy), SetWidgetInfo (copy), logWidgetLoaded (copy), Logging (copy)
	local v19 = CatalogUtils.getFetchWidgetInfoFetchKey(s1, s2)
	local v20 = SearchUuid()
	local v21 = FFlagAXPassScreenSizeToWidgetApi and FFlagAXMoveAllTabToWidgetOnly
	local v22 = FFlagAXPassScreenSizeToWidgetApi and not FFlagAXMoveAllTabToWidgetOnly

	if v21 then
		local v23 = getAXMarketplaceWidgetStore(false).getDebouncedScreenSize(false)
		local v24 = CatalogUtils.getFetchWidgetInfoFetchKey(s1, s2, v23)

		return PerformFetch.Single(v24, function(p2) -- line: 45
			-- upvalues: ClearWidgetInfo (copy), s1 (copy), s2 (copy), Api (copy), p1 (copy), v20 (copy), v23 (copy), SetWidgetInfo (copy), logWidgetLoaded (copy), Logging (copy)
			p2:dispatch(ClearWidgetInfo(s1, s2))

			local v28

			if s1 then
				local v29

				v28, v29 = Api.getWidgetListInfoSearch(p1, v20, s1)
			else
				local v30

				v28, v30 = Api.getWidgetListInfo(p1, v20, s2, v23)
			end

			return v28:andThen(function(p3) -- line: 57
				-- upvalues: p2 (copy), SetWidgetInfo (copy), v20 (copy), s1 (copy), s2 (copy), logWidgetLoaded (copy)
				local v44 = if not p3 or not p3.widgets then {} else p3.widgets
				local v45 = if not p3 or not p3.configuration then {} else p3.configuration

				p2:dispatch(SetWidgetInfo(v44, v20, s1, s2, v45))

				if p3 and p3.widgets then
					logWidgetLoaded(p3.widgets, v20)
				end

				return p3
			end):catch(function(p4) -- line: 70
				-- upvalues: Logging (copy)
				Logging.warn("WebApi failure in FetchWidgetInfo: " .. tostring(p4))
			end)
		end)
	end

	if v22 then
		local v25 = getAXMarketplaceWidgetStore(false).getDebouncedScreenSize(false)
		local v26 = CatalogUtils.getFetchWidgetInfoFetchKey(s1, s2, nil)

		return PerformFetch.Single(v26, function(p5) -- line: 83
			-- upvalues: ClearWidgetInfo (copy), s1 (copy), s2 (copy), Api (copy), p1 (copy), v20 (copy), SearchUuid (copy), v25 (copy), Logging (copy), SetWidgetInfo (copy)
			p5:dispatch(ClearWidgetInfo(s1, s2))

			local v32

			if s1 then
				local v33

				v32, v33 = Api.getWidgetListInfoSearch(p1, v20, s1)
			else
				local v34

				v32, v34 = Api.getWidgetListInfo(p1, v20, s2, nil)
			end

			local v35 = SearchUuid()
			local v36

			if s1 then
				local v37

				v36, v37 = Api.getWidgetListInfoSearch(p1, v35, s1)
			else
				local v38

				v36, v38 = Api.getWidgetListInfo(p1, v35, s2, v25)
			end

			v36:catch(function(p6) -- line: 108
				-- upvalues: Logging (copy)
				Logging.warn("WebApi failure in FetchWidgetInfo (shadow traffic): " .. tostring(p6))
			end)

			return v32:andThen(function(p7) -- line: 114
				-- upvalues: p5 (copy), SetWidgetInfo (copy), v20 (copy), s1 (copy), s2 (copy)
				local v49 = if not p7 or not p7.widgets then {} else p7.widgets
				local v50 = if not p7 or not p7.configuration then {} else p7.configuration

				p5:dispatch(SetWidgetInfo(v49, v20, s1, s2, v50))

				return p7
			end):catch(function(p8) -- line: 123
				-- upvalues: Logging (copy)
				Logging.warn("WebApi failure in FetchWidgetInfo: " .. tostring(p8))
			end)
		end)
	end

	return PerformFetch.Single(v19, function(p9) -- line: 129
		-- upvalues: ClearWidgetInfo (copy), s1 (copy), s2 (copy), Api (copy), p1 (copy), v20 (copy), SetWidgetInfo (copy), Logging (copy)
		p9:dispatch(ClearWidgetInfo(s1, s2))

		local v40

		if s1 then
			local v41

			v40, v41 = Api.getWidgetListInfoSearch(p1, v20, s1)
		else
			local v42

			v40, v42 = Api.getWidgetListInfo(p1, v20, s2)
		end

		return v40:andThen(function(p10) -- line: 143
			-- upvalues: p9 (copy), SetWidgetInfo (copy), v20 (copy), s1 (copy), s2 (copy)
			local v53 = if not p10 or not p10.widgets then {} else p10.widgets
			local v54 = if not p10 or not p10.configuration then {} else p10.configuration

			p9:dispatch(SetWidgetInfo(v53, v20, s1, s2, v54))
		end):catch(function(p11) -- line: 150
			-- upvalues: Logging (copy)
			Logging.warn("WebApi failure in FetchWidgetInfo: " .. tostring(p11))
		end)
	end)
end
