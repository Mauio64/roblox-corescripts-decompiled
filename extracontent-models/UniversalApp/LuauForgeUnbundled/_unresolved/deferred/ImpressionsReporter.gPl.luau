local CorePackages = game:GetService("CorePackages")

local CollectionService = game:GetService("CollectionService")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/dMx")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local impressionsUtil = AvatarExperienceAnalytics.ImpressionsReporter.ImpressionsUtil
local organicEventImpressionsSchema = AvatarExperienceAnalytics.ImpressionsReporter.OrganicEventImpressionsSchema
local impressionEnums = AvatarExperienceAnalytics.Enums.ImpressionEnums

local avatarExperienceScreenSizeImpressionsDetector = AvatarExperienceAnalytics.AvatarExperienceScreenSizeImpressionsDetector
local analyticsService = AvatarExperienceAnalytics.AnalyticsService

local module3 = require("@luauforge/deferred/gPm")
local module4 = require("@luauforge/bundled/fvF")
require("@luauforge/bundled/dHL")
local defineFastFlag = game:DefineFastFlag("EnableImpressionReporterCounter3", false)
local module5 = require("@luauforge/bundled/dSV")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module6 = require("@luauforge/bundled/eeH")

local module7 = require("@luauforge/deferred/gPn")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module9 = require("@luauforge/bundled/dMB")
local module10 = require("@luauforge/bundled/dSW")
local module11 = require("@luauforge/deferred/gPq")
local fFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly
local ITEM_IMPRESSION = impressionEnums.ActionType.ITEM_IMPRESSION

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

require("@luauforge/bundled/dHK")

local module14 = require("@luauforge/bundled/gOc")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local getShouldPageUseWidgetOnlyFetcher = AvatarExperienceCatalog.Utils.getShouldPageUseWidgetOnlyFetcher

local function ImpressionsReporter(props)
	local eventStream = analyticsService.EventStream
	local v5 = if defineFastFlag then module6(module4) else nil

	local state, setState = React.useState(0)
	local v6 = React.useState({})
	local ref = React.useRef({})
	local v7 = useDispatch()
	local v8 = if module10.isEnabled() then module9.readTestVariable(module10.EnabledForUser) else nil

	local v9 = nil
	local state2, setState2

	if module10.isEnabled() then
		v9 = module11()
		state2, setState2 = React.useState(not v9 and "" or v9.Name)
	else
		if v8 then
			v9 = module11()
		end

		state2, setState2 = React.useState(not (v8 and v9) and "" or v9.Name)
	end

	local v10

	if fFlagAXMoveAllTabToWidgetOnly then
		local v11 = useSelector(function(p2)
			if props.searchUuid then
				return p2.SearchesParameters[props.searchUuid]
			end

			return nil
		end, getUseSelectorDeepEquals())
		v10 = not getShouldPageUseWidgetOnlyFetcher(v9, useSelector(module14), v11 and v11.searchKeyword)
	end

	module7(props.searchUuid, v10)

	React.useEffect(function()
		task.delay(1, function()
			setState(state + module.ImpressionsDetectionInterval)
		end)
	end, { state })

	local function collect(p2)
		return CollectionService:GetTagged(props.impressionsTag)
	end

	local ref2 = React.useRef(false)

	React.useEffect(function()
		if v8 and v9 and v9.Name and v9.Name ~= state2 then
			setState2(v9.Name)
			ref2.current = false
		end
	end, { v9, state2, v8 })

	local function impressionsDetected(items)
		for k, item in items do
			local attribute = item:GetAttribute(props.impressionsTag)

			if v8 then
				ref.current[attribute] = true
			else
				v6[attribute] = true
			end
		end

		local v11 = organicEventImpressionsSchema[props.impressionsSchema]
		local packEvents = impressionsUtil.packEvents(v11, items)

		if v8 and props.searchUuid and not ref2.current and ref.current then
			ref2.current = true

			local v12 = {}

			for k in ref.current do
				table.insert(v12, k)
			end

			if #v12 > 0 then
				v7(module5.SetLoadedThumbnails(props.searchUuid, v12))
			end
		elseif props.searchUuid and v6 then
			for k in pairs(v6) do
				v7(module5.SetLoadedThumbnail(props.searchUuid, k))
			end
		end

		if packEvents then
			for k, packEvent in packEvents do
				local v12

				if props.eventNamePrefix then
					v12 = props.eventNamePrefix .. props.eventName
				else
					v12 = props.eventName
				end

				packEvent.surface = props.surface

				if props.surface and props.analyticsMetadata and v11.surfaceSpecificAnalyticsMetadata then
					local v13 = v11.surfaceSpecificAnalyticsMetadata[props.surface]

					if v13 then
						for k2, v14 in v13 do
							packEvent[v14.out] = props.analyticsMetadata[v14.prop]
						end
					end
				end

				packEvent.requestId = props.requestId
				packEvent.actionType = ITEM_IMPRESSION

				if defineFastFlag then
					v5.sendCounter("AvatarCatalogImpressionReported")
					module3.sendTelemetryEvent("Impression", { id = props.requestId })
				end

				packEvent.event_sender_api = impressionEnums.MarketplaceEventSenderAPI.SEND_ROBLOX_TELEMETRY_EVENT
				eventStream:sendTelemetryEvent(props.eventContext, v12, packEvent)
			end
		end
	end

	local function filterImpression(instance)
		local attribute = instance:GetAttribute(props.impressionsTag)

		if v8 then
			return attribute and not ref.current[attribute]
		end

		return attribute and not v6[attribute]
	end

	return React.createElement(avatarExperienceScreenSizeImpressionsDetector, {
		parentRef = props.parentRef,
		pageFilter = props.pageFilter,
		onRequestImpressionsSignal = props.onRequestImpressionsSignal,
		collectObjectsFunc = collect,
		filterImpressionFunc = filterImpression,
		onImpressionsDetected = impressionsDetected
	})
end

return ImpressionsReporter
