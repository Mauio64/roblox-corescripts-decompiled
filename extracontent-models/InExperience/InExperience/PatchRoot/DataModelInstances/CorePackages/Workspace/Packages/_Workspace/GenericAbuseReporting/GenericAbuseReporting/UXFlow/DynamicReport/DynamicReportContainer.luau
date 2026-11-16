local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local LayerCollectorProvider = UIBlox.Core.Layout.LayerCollector.LayerCollectorProvider

local AbuseReportAnalyticsProvider = require(GenericAbuseReporting.Bedui.Provider.AbuseReportAnalyticsProvider)
local AbuseReportBeduiProvider = require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiProvider)
local AbuseReportFormDataProvider = require(GenericAbuseReporting.Bedui.Provider.AbuseReportFormDataProvider)
require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local DynamicReport = require(GenericAbuseReporting.UXFlow.DynamicReport.DynamicReport)
local DynamicReportV2Container = require(GenericAbuseReporting.UXFlow.DynamicReportV2.DynamicReportV2Container)

local SharedFlags = require(parent.SharedFlags)
local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local FFlagEnableMomentsCommentReporting = SharedFlags.FFlagEnableMomentsCommentReporting
local FFlagEnableNewReportFlowGameTile = SharedFlags.FFlagEnableNewReportFlowGameTile
local FFlagEnableGroupAnnouncementReporting = SharedFlags.FFlagEnableGroupAnnouncementReporting
local FFlagAbuseReportAttributes = SharedFlags.FFlagAbuseReportAttributes

local function DynamicReportV2Adapter(props)
	local targetId = props.targetId
	local attributes = React.useMemo(function()
		if targetId == nil then
			return nil
		end

		assert(type(targetId) == "string", "DynamicReportV2 requires a string targetId")
		return { targetId = targetId }
	end, { targetId })

	local createElement = React.createElement
	local v = {
		abuseVector = props.abuseVector,
		attributes = 0,
		analyticsTargetId = 0,
		onClose = 0,
		onSubmit = 0,
		onCustomSubmit = 0,
		clientActionHandlers = 0,
		custom = 0
	}

	if targetId == nil then
		attributes = props.attributes
	end

	v.attributes = attributes
	local analyticsTargetId

	if targetId == nil then
		analyticsTargetId = props.analyticsTargetId
	else
		analyticsTargetId = targetId
	end

	v.analyticsTargetId = analyticsTargetId
	v.onClose = props.onClose
	v.onSubmit = props.onSubmit
	v.onCustomSubmit = props.onCustomSubmit
	v.clientActionHandlers = props.clientActionHandlers
	v.custom = props.custom
	return createElement(DynamicReportV2Container, v)
end

local function DynamicReportContainer(props)
	if
		FFlagAbuseReportAttributes
		and props.targetId ~= nil
		and (props.attributes ~= nil or props.analyticsTargetId ~= nil)
	then
		error("targetId is mutually exclusive with attributes and analyticsTargetId")
	end

	if
		props.abuseVector == AbuseVector.UserProfile
		or props.abuseVector == AbuseVector.MomentsFeed
		or FFlagEnableMomentsCommentReporting and props.abuseVector == AbuseVector.MomentComment
		or FFlagEnableNewReportFlowGameTile and props.abuseVector == AbuseVector.GameTile
		or FFlagEnableGroupAnnouncementReporting and props.abuseVector == AbuseVector.GroupAnnouncement
	then
		if FFlagAbuseReportAttributes then
			return React.createElement(DynamicReportV2Adapter, props)
		end

		local v = {
			abuseVector = props.abuseVector,
			targetId = props.targetId,
			onClose = props.onClose,
			onSubmit = props.onSubmit,
			onCustomSubmit = props.onCustomSubmit,
			clientActionHandlers = props.clientActionHandlers,
			custom = props.custom
		}

		return React.createElement(DynamicReportV2Container, v)
	else
		if FFlagAbuseReportAttributes then
			assert(props.targetId ~= nil, "attributes are only supported by the Dynamic Report V2 flow")
		end

		local createElement = React.createElement
		local createElement2 = React.createElement
		local v = { abuseVector = props.abuseVector }

		local createElement3 = React.createElement
		local custom

		if FFlagAddThumbnailSelectorReport then
			custom = props.custom
		end

		return createElement(LayerCollectorProvider, {}, {
			AbuseReportBeduiProvider = createElement2(AbuseReportBeduiProvider, v, {
				AbuseReportFormDataProvider = createElement3(AbuseReportFormDataProvider, {
					custom = custom
				}, {
					AbuseReportAnalyticsProvider = React.createElement(
						AbuseReportAnalyticsProvider,
						{ abuseVector = props.abuseVector },
						{
							DynamicReport = React.createElement(DynamicReport, {
								abuseVector = props.abuseVector,
								targetId = props.targetId,
								onClose = props.onClose,
								onSubmit = props.onSubmit,
								custom = props.custom
							})
						}
					)
				})
			})
		})
	end
end

return React.memo(DynamicReportContainer)
