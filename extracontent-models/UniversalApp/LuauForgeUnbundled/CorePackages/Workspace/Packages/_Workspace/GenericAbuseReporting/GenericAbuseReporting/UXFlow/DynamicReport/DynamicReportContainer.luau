local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local layerCollectorProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/UIBlox").Core.Layout.LayerCollector.LayerCollectorProvider

local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportAnalyticsProvider")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiProvider")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportFormDataProvider")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/DynamicReport/DynamicReport")
local DynamicReportV2Container = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/DynamicReportV2/DynamicReportV2Container")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags")
local fFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local fFlagEnableMomentsCommentReporting = SharedFlags.FFlagEnableMomentsCommentReporting
local fFlagEnableNewReportFlowGameTile = SharedFlags.FFlagEnableNewReportFlowGameTile
local fFlagEnableGroupAnnouncementReporting = SharedFlags.FFlagEnableGroupAnnouncementReporting
local fFlagAbuseReportAttributes = SharedFlags.FFlagAbuseReportAttributes

local function DynamicReportV2Adapter(props)
	local targetId = props.targetId
	local v5 = React.useMemo(function()
		if targetId == nil then
			return nil
		end

		assert(type(targetId) == "string", "DynamicReportV2 requires a string targetId")
		return { targetId = targetId }
	end, { targetId })

	local createElement = React.createElement
	local v7 = {
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
		v5 = props.attributes
	end

	v7.attributes = v5
	local v8 = if targetId == nil then props.analyticsTargetId else targetId
	v7.analyticsTargetId = v8
	v7.onClose = props.onClose
	v7.onSubmit = props.onSubmit
	v7.onCustomSubmit = props.onCustomSubmit
	v7.clientActionHandlers = props.clientActionHandlers
	v7.custom = props.custom
	return createElement(DynamicReportV2Container, v7)
end

local function DynamicReportContainer(props)
	if
		fFlagAbuseReportAttributes
		and props.targetId ~= nil
		and (props.attributes ~= nil or props.analyticsTargetId ~= nil)
	then
		error("targetId is mutually exclusive with attributes and analyticsTargetId")
	end

	if
		props.abuseVector == AbuseVector.UserProfile
		or props.abuseVector == AbuseVector.MomentsFeed
		or fFlagEnableMomentsCommentReporting and props.abuseVector == AbuseVector.MomentComment
		or fFlagEnableNewReportFlowGameTile and props.abuseVector == AbuseVector.GameTile
		or fFlagEnableGroupAnnouncementReporting and props.abuseVector == AbuseVector.GroupAnnouncement
	then
		if fFlagAbuseReportAttributes then
			return React.createElement(DynamicReportV2Adapter, props)
		end

		local v5 = {
			abuseVector = props.abuseVector,
			targetId = props.targetId,
			onClose = props.onClose,
			onSubmit = props.onSubmit,
			onCustomSubmit = props.onCustomSubmit,
			clientActionHandlers = props.clientActionHandlers,
			custom = props.custom
		}

		return React.createElement(DynamicReportV2Container, v5)
	else
		if fFlagAbuseReportAttributes then
			assert(props.targetId ~= nil, "attributes are only supported by the Dynamic Report V2 flow")
		end

		local createElement = React.createElement
		local createElement2 = React.createElement
		local v9 = { abuseVector = props.abuseVector }

		local createElement3 = React.createElement
		local v13 = if fFlagAddThumbnailSelectorReport then props.custom else nil
		return createElement(layerCollectorProvider, {}, {
			AbuseReportBeduiProvider = createElement2(module3, v9, {
				AbuseReportFormDataProvider = createElement3(module4, { custom = v13 }, {
					AbuseReportAnalyticsProvider = React.createElement(
						module2,
						{ abuseVector = props.abuseVector },
						{
							DynamicReport = React.createElement(module6, {
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
