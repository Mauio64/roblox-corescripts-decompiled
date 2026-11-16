local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local module = require("@luauforge/bundled/dNG")
local module2 = require("@luauforge/bundled/dNH")
local searchUuid = require("@luauforge/bundled/dOk").SearchUuid
local module3 = require("@luauforge/bundled/dRQ")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local api = AvatarExperienceCatalog.Api
local getAXMarketplaceWidgetStore = AvatarExperienceCatalog.Stores.getAXMarketplaceWidgetStore
require("@luauforge/bundled/dMd")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local logWidgetLoaded = AvatarExperienceAnalytics.logWidgetLoaded
local getUnifiedLoggingSurface = AvatarExperienceAnalytics.Utils.getUnifiedLoggingSurface

local fFlagAXPassScreenSizeToWidgetApi = AvatarExperienceFlags.FFlagAXPassScreenSizeToWidgetApi
local fFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly
local fFlagAXUnifiedEventCounters = AvatarExperienceFlags.FFlagAXUnifiedEventCounters
local fFlagAXMarketplaceBreakpointEstimateFix = AvatarExperienceFlags.FFlagAXMarketplaceBreakpointEstimateFix
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

return function(p2, p3, p4)
	if fFlagAXMarketplaceBreakpointEstimateFix then
		getAXMarketplaceWidgetStore(false).refreshEstimate()
	end

	local fetchWidgetInfoFetchKey = module3.getFetchWidgetInfoFetchKey(p3, p4)

	local v5 = searchUuid()
	local v6 = fFlagAXPassScreenSizeToWidgetApi and not fFlagAXMoveAllTabToWidgetOnly

	if fFlagAXPassScreenSizeToWidgetApi and fFlagAXMoveAllTabToWidgetOnly then
		local debouncedScreenSize = getAXMarketplaceWidgetStore(false).getDebouncedScreenSize(false)

		local fetchWidgetInfoFetchKey2 = module3.getFetchWidgetInfoFetchKey(p3, p4, debouncedScreenSize)

		return performFetch.Single(fetchWidgetInfoFetchKey2, function(object)
			object:dispatch(module2(p3, p4))
			local v7

			if p3 then
				local v8
				v7, v8 = api.getWidgetListInfoSearch(p2, v5, p3)
			else
				local v8
				v7, v8 = api.getWidgetListInfo(p2, v5, p4, debouncedScreenSize)
			end

			return v7:andThen(function(p5)
				object:dispatch(module(
					not (p5 and p5.widgets) and {} or p5.widgets,
					v5,
					p3,
					p4,
					not (p5 and p5.configuration) and {} or p5.configuration
				))

				if not (p5 and p5.widgets) then
					return p5
				end

				local widgets = {}

				if fFlagAXUnifiedEventStrictPayloads then
					for k, widget in p5.widgets do
						local v10 = tonumber(k)

						if v10 then
							widgets[v10] = widget
						end
					end
				end

				if not fFlagAXUnifiedEventStrictPayloads then
					widgets = p5.widgets
				end

				logWidgetLoaded(widgets, v5, fFlagAXUnifiedEventCounters and function()
					return getUnifiedLoggingSurface(object:getState().AvatarExperience.AvatarScene.AvatarRoute)
				end or nil)

				return p5
			end):catch(function(p5)
				logging.warn("WebApi failure in FetchWidgetInfo: " .. tostring(p5))
			end)
		end)
	else
		if not v6 then
			return performFetch.Single(fetchWidgetInfoFetchKey, function(object)
				object:dispatch(module2(p3, p4))
				local v7

				if p3 then
					local v8
					v7, v8 = api.getWidgetListInfoSearch(p2, v5, p3)
				else
					local v8
					v7, v8 = api.getWidgetListInfo(p2, v5, p4)
				end

				return v7:andThen(function(p5)
					object:dispatch(module(
						not (p5 and p5.widgets) and {} or p5.widgets,
						v5,
						p3,
						p4,
						not (p5 and p5.configuration) and {} or p5.configuration
					))
				end):catch(function(p5)
					logging.warn("WebApi failure in FetchWidgetInfo: " .. tostring(p5))
				end)
			end)
		end

		local debouncedScreenSize = getAXMarketplaceWidgetStore(false).getDebouncedScreenSize(false)

		local fetchWidgetInfoFetchKey2 = module3.getFetchWidgetInfoFetchKey(p3, p4, nil)

		return performFetch.Single(fetchWidgetInfoFetchKey2, function(object)
			object:dispatch(module2(p3, p4))
			local v7

			if p3 then
				local v8
				v7, v8 = api.getWidgetListInfoSearch(p2, v5, p3)
			else
				local v8
				v7, v8 = api.getWidgetListInfo(p2, v5, p4, nil)
			end

			local v8 = searchUuid()
			local v9

			if p3 then
				local v10
				v9, v10 = api.getWidgetListInfoSearch(p2, v8, p3)
			else
				local v10
				v9, v10 = api.getWidgetListInfo(p2, v8, p4, debouncedScreenSize)
			end

			v9:catch(function(p5)
				logging.warn("WebApi failure in FetchWidgetInfo (shadow traffic): " .. tostring(p5))
			end)

			return v7:andThen(function(p5)
				object:dispatch(module(
					not (p5 and p5.widgets) and {} or p5.widgets,
					v5,
					p3,
					p4,
					not (p5 and p5.configuration) and {} or p5.configuration
				))
				return p5
			end):catch(function(p5)
				logging.warn("WebApi failure in FetchWidgetInfo: " .. tostring(p5))
			end)
		end)
	end
end
