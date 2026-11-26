local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType
local OpenDynamicAbuseReport = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GenericAbuseReporting/OpenDynamicAbuseReport")
local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GenericAbuseReporting/AbuseVector")
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay").Thunks.CloseCentralOverlay
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").AppPage
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/NavigationRodux")
local navigateDown = NavigationRodux.Thunks.NavigateDown
local navigateBack = NavigationRodux.Thunks.NavigateBack
local sduiLoadTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities").SduiLoadTimer
local fetchBadgeDetailsPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Badges").fetchBadgeDetailsPage
local getIsBadgeDetailsSheetOpen = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Badges").BadgeDetailsSheetState.getIsBadgeDetailsSheetOpen
local fFlagEnableGroupAnnouncementReporting = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagEnableGroupAnnouncementReporting
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppNavigation").NavigationCommands else nil

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.OpenAbuseReport, message = "Missing action params" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	if actionParams.targetId == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenAbuseReport,
				message = "Missing actionParam: targetId"
			},
			p4.appPage
		)
		return
	end

	if actionParams.abuseVector == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenAbuseReport,
				message = "Missing actionParam: abuseVector"
			},
			p4.appPage
		)
		return
	end

	local targetId = actionParams.targetId
	local abuseVector = actionParams.abuseVector

	local assetTypeName = actionParams.assetTypeName
	local universeId = actionParams.universeId
	local groupId

	if fFlagEnableGroupAnnouncementReporting and abuseVector == AbuseVector.GroupAnnouncement then
		if type(targetId) ~= "string" or targetId == "" then
			p4.dependencies.logger.reportError(
				sduiErrorType.InvalidActionParams,
				{
					name = sduiActionType.OpenAbuseReport,
					message = "Group announcement reports require a nonempty targetId"
				},
				p4.appPage
			)
			return
		end

		groupId = actionParams.groupId

		if type(groupId) ~= "string" or groupId == "" then
			p4.dependencies.logger.reportError(
				sduiErrorType.InvalidActionParams,
				{
					name = sduiActionType.OpenAbuseReport,
					message = "Group announcement reports require a nonempty groupId"
				},
				p4.appPage
			)
			return
		end
	end

	local dispatch = p4.dependencies.dispatch

	local v5 = p4.appPage == "BadgeDetails" and getIsBadgeDetailsSheetOpen()

	if v5 then
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.back()
		else
			dispatch(navigateBack())
		end
	end

	local v6 = if v5 then targetId else nil
	local v7 = {
		abuseVector = abuseVector,
		targetId = targetId,
		custom = { assetTypeName = assetTypeName, universeId = universeId },
		onClose = function()
			dispatch(closeCentralOverlay())

			if v6 then
				local loadTimer = sduiLoadTimer.createLoadTimer("BadgeDetails")
				loadTimer.start("navigate")
				fetchBadgeDetailsPage(v6, loadTimer)

				local v8 = {
					name = appPage.BadgeDetails,
					extraProps = { badgeId = v6, pageTimer = loadTimer }
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v8))
				else
					dispatch(navigateDown(v8))
				end
			end
		end
	}

	if groupId then
		v7.attributes = { targetId = targetId, groupId = groupId }
		v7.analyticsTargetId = targetId
		v7.targetId = nil
	end

	dispatch(OpenDynamicAbuseReport(v7))
end
