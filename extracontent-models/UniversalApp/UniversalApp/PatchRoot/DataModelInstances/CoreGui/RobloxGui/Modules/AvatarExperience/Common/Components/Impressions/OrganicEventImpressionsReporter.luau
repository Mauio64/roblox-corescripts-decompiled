local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CollectionService = game:GetService("CollectionService")
local React = require(CorePackages.Packages.React)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local ImpressionsUtil = AvatarExperienceAnalytics.ImpressionsReporter.ImpressionsUtil
local OrganicEventImpressionsSchema = AvatarExperienceAnalytics.ImpressionsReporter.OrganicEventImpressionsSchema
local ImpressionEnums = AvatarExperienceAnalytics.Enums.ImpressionEnums
local AvatarExperienceScreenSizeImpressionsDetector = AvatarExperienceAnalytics.AvatarExperienceScreenSizeImpressionsDetector
local AnalyticsService = AvatarExperienceAnalytics.AnalyticsService
local AvatarExperiencePointsTelemetry = require(Modules.AvatarExperience.Common.Components.Impressions.AvatarExperiencePointsTelemetry)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local v14 = game:DefineFastFlag("EnableImpressionReporterCounter3", false)
local CatalogTilesLatencyTracker = require(Modules.AvatarExperience.Catalog.Actions.CatalogTilesLatencyTracker)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useTileThumbnailLatencyTracker = require(Modules.AvatarExperience.Common.Hooks.TileLatency.useTileThumbnailLatencyTracker)
local GetFFlagEnableCatalogTileLoadingLatency = require(Modules.AvatarExperience.Flags.GetFFlagEnableCatalogTileLoadingLatency)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AXCatalogPerfReduxReductionIXP = require(Modules.AvatarExperience.Experiments.AXCatalogPerfReduxReductionIXP)
local v23 = game:DefineFastFlag("AXImpressionReporterConditionalHookBacktraceError", false)
local v24 = game:DefineFastFlag("AXConditionalHookForOrganicImpressionReporter", false)
local useCategoryInfo = require(Modules.AvatarExperience.Common.Hooks.useCategoryInfo)
local FFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly
local ITEM_IMPRESSION = ImpressionEnums.ActionType.ITEM_IMPRESSION
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local selectFilterCount = require(Modules.AvatarExperience.Catalog.Selectors.selectFilterCount)
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local getShouldPageUseWidgetOnlyFetcher = AvatarExperienceCatalog.Utils.getShouldPageUseWidgetOnlyFetcher

local function ImpressionsReporter(t1: {[any]: any}) -- line: 78
	-- upvalues: AnalyticsService (copy), v14 (copy), useRoactService (copy), Analytics (copy), React (copy), useDispatch (copy), AXCatalogPerfReduxReductionIXP (copy), IxpUtils (copy), v23 (copy), useCategoryInfo (copy), FFlagAXMoveAllTabToWidgetOnly (copy), useSelector (copy), getUseSelectorDeepEquals (copy), selectFilterCount (copy), getShouldPageUseWidgetOnlyFetcher (copy), v24 (copy), GetFFlagEnableCatalogTileLoadingLatency (copy), useTileThumbnailLatencyTracker (copy), Constants (copy), CollectionService (copy), OrganicEventImpressionsSchema (copy), ImpressionsUtil (copy), CatalogTilesLatencyTracker (copy), ITEM_IMPRESSION (copy), AvatarExperiencePointsTelemetry (copy), ImpressionEnums (copy), AvatarExperienceScreenSizeImpressionsDetector (copy)
	local EventStream = AnalyticsService.EventStream
	local v37 = if not v14 then nil else useRoactService(Analytics)
	local v38, v39 = React.useState(0)
	local v40 = React.useState({})
	local v41 = React.useRef({})
	local v42 = useDispatch()
	local v43 = if not AXCatalogPerfReduxReductionIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXCatalogPerfReduxReductionIXP.EnabledForUser)
	local u44 = nil
	local u47, u48

	if v23 and AXCatalogPerfReduxReductionIXP.isEnabled() then
		u44 = useCategoryInfo()

		local v45, v46 = React.useState(not u44 and "" or u44.Name)

		u47 = v45
		u48 = v46
	else
		if v43 then
			u44 = useCategoryInfo()
		end

		local v49, v50 = React.useState((not v43 or not u44) and "" or u44.Name)

		u47 = v49
		u48 = v50
	end

	local v51 = nil

	if FFlagAXMoveAllTabToWidgetOnly then
		local v52 = useSelector(function(p1) -- line: 106
			-- upvalues: t1 (copy)
			if t1.searchUuid then
				return p1.SearchesParameters[t1.searchUuid]
			end

			return nil
		end, getUseSelectorDeepEquals())
		local v53 = useSelector(selectFilterCount)

		v51 = not getShouldPageUseWidgetOnlyFetcher(u44, v53, v52 and v52.searchKeyword)
	end

	if v24 and GetFFlagEnableCatalogTileLoadingLatency() then
		useTileThumbnailLatencyTracker(t1.searchUuid, v51)
	elseif GetFFlagEnableCatalogTileLoadingLatency() and t1.searchUuid then
		useTileThumbnailLatencyTracker(t1.searchUuid)
	end

	React.useEffect(function() -- line: 128
		-- upvalues: v39 (copy), v38 (copy), Constants (copy)
		task.delay(1, function() -- line: 129
			-- upvalues: v39 (copy), v38 (copy), Constants (copy)
			v39(v38 + Constants.ImpressionsDetectionInterval)
		end)
	end, { v38 })

	local function collect(_) -- line: 134
		-- upvalues: CollectionService (copy), t1 (copy)
		return CollectionService:GetTagged(t1.impressionsTag)
	end

	local v55 = React.useRef(false)

	React.useEffect(function() -- line: 141
		-- upvalues: v43 (copy), u44 (ref), u47 (ref), u48 (ref), v55 (copy)
		if v43 and (u44 and u44.Name and u44.Name ~= u47) then
			u48(u44.Name)
			v55.current = false
		end
	end, {
		u44,
		u47,
		v43
	})

	local function impressionsDetected(p3) -- line: 153
		-- upvalues: t1 (copy), v43 (copy), v41 (copy), v40 (copy), OrganicEventImpressionsSchema (copy), ImpressionsUtil (copy), v55 (copy), v42 (copy), CatalogTilesLatencyTracker (copy), GetFFlagEnableCatalogTileLoadingLatency (copy), ITEM_IMPRESSION (copy), v14 (copy), v37 (copy), AvatarExperiencePointsTelemetry (copy), ImpressionEnums (copy), EventStream (copy)
		for _, v62 in p3 do
			local t1impressionsTag = v62:GetAttribute(t1.impressionsTag)

			if v43 then
				v41.current[t1impressionsTag] = true
			else
				v40[t1impressionsTag] = true
			end
		end

		local v64 = OrganicEventImpressionsSchema[t1.impressionsSchema]
		local v65 = ImpressionsUtil.packEvents(v64, p3)

		if v43 and t1.searchUuid and not v55.current and v41.current then
			v55.current = true

			local t2 = {}

			for v67 in v41.current do
				table.insert(t2, v67)
			end

			if #t2 > 0 then
				v42(CatalogTilesLatencyTracker.SetLoadedThumbnails(t1.searchUuid, t2))
			end
		elseif GetFFlagEnableCatalogTileLoadingLatency() and t1.searchUuid and v40 then
			for k in pairs(v40) do
				v42(CatalogTilesLatencyTracker.SetLoadedThumbnail(t1.searchUuid, k))
			end
		end

		if v65 then
			for _, v70 in v65 do
				local v71 = if not t1.eventNamePrefix then t1.eventName else t1.eventNamePrefix .. t1.eventName

				v70.surface = t1.surface

				if t1.surface and t1.analyticsMetadata and v64.surfaceSpecificAnalyticsMetadata then
					local v72 = v64.surfaceSpecificAnalyticsMetadata[t1.surface]

					if v72 then
						for _, v74 in v72 do
							v70[v74.out] = t1.analyticsMetadata[v74.prop]
						end
					end
				end

				v70.requestId = t1.requestId
				v70.actionType = ITEM_IMPRESSION

				if v14 then
					v37.sendCounter("AvatarCatalogImpressionReported")
					AvatarExperiencePointsTelemetry.sendTelemetryEvent("Impression", {
						id = t1.requestId
					})
				end

				v70.event_sender_api = ImpressionEnums.MarketplaceEventSenderAPI.SEND_ROBLOX_TELEMETRY_EVENT
				EventStream:sendTelemetryEvent(t1.eventContext, v71, v70)
			end
		end
	end
	local function filterImpression(p4) -- line: 227
		-- upvalues: t1 (copy), v43 (copy), v41 (copy), v40 (copy)
		local t1impressionsTag = p4:GetAttribute(t1.impressionsTag)

		if v43 then
			return t1impressionsTag and not v41.current[t1impressionsTag]
		end

		return t1impressionsTag and not v40[t1impressionsTag]
	end

	return React.createElement(AvatarExperienceScreenSizeImpressionsDetector, {
		parentRef = t1.parentRef,
		pageFilter = t1.pageFilter,
		onRequestImpressionsSignal = t1.onRequestImpressionsSignal,
		collectObjectsFunc = collect,
		filterImpressionFunc = filterImpression,
		onImpressionsDetected = impressionsDetected
	})
end

return ImpressionsReporter
