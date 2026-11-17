local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType
local OpenDynamicAbuseReport = require(parent.GenericAbuseReporting.OpenDynamicAbuseReport)
local AbuseVector = require(parent.GenericAbuseReporting.AbuseVector)
local CentralOverlay = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local Badges = require(parent.Badges)
local fetchBadgeDetailsPage = Badges.fetchBadgeDetailsPage
local Badges2 = require(parent.Badges)
local getIsBadgeDetailsSheetOpen = Badges2.BadgeDetailsSheetState.getIsBadgeDetailsSheetOpen
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableGroupAnnouncementReporting = SharedFlags.FFlagEnableGroupAnnouncementReporting
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags2.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenAbuseReport, message = "Missing action params" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	if actionParams.targetId == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenAbuseReport, message = "Missing actionParam: targetId" },
			p2.appPage
		)
		return
	end

	if actionParams.abuseVector == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenAbuseReport, message = "Missing actionParam: abuseVector" },
			p2.appPage
		)
		return
	end

	local targetId = actionParams.targetId
	local abuseVector = actionParams.abuseVector

	local assetTypeName = actionParams.assetTypeName
	local universeId = actionParams.universeId
	local groupId

	if FFlagEnableGroupAnnouncementReporting and abuseVector == AbuseVector.GroupAnnouncement then
		if type(targetId) ~= "string" or targetId == "" then
			p2.dependencies.logger.reportError(
				SduiErrorType.InvalidActionParams,
				{
					name = SduiActionType.OpenAbuseReport,
					message = "Group announcement reports require a nonempty targetId"
				},
				p2.appPage
			)
			return
		end

		groupId = actionParams.groupId

		if type(groupId) ~= "string" or groupId == "" then
			p2.dependencies.logger.reportError(
				SduiErrorType.InvalidActionParams,
				{
					name = SduiActionType.OpenAbuseReport,
					message = "Group announcement reports require a nonempty groupId"
				},
				p2.appPage
			)
			return
		end
	end

	local dispatch = p2.dependencies.dispatch
	local v

	if p2.appPage == "BadgeDetails" then
		v = getIsBadgeDetailsSheetOpen()
	else
		v = false
	end

	if v then
		if FFlagSignalsNavP3Dispatch then
			navigationCommands.back()
		else
			dispatch(NavigateBack())
		end
	end

	local badgeId

	if v then
		badgeId = targetId
	else
		badgeId = nil
	end

	local v2 = {
		abuseVector = abuseVector,
		targetId = targetId,
		custom = { assetTypeName = assetTypeName, universeId = universeId },
		onClose = function()
			dispatch(CloseCentralOverlay())

			if badgeId then
				local loadTimer = SduiLoadTimer.createLoadTimer("BadgeDetails")
				loadTimer.start("navigate")
				fetchBadgeDetailsPage(badgeId, loadTimer)

				local v2 = {
					name = AppPage.BadgeDetails,
					extraProps = { badgeId = badgeId, pageTimer = loadTimer }
				}

				if FFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v2))
				else
					dispatch(NavigateDown(v2))
				end
			end
		end
	}

	if groupId then
		v2.attributes = { targetId = targetId, groupId = groupId }
		v2.analyticsTargetId = targetId
		v2.targetId = nil
	end

	dispatch(OpenDynamicAbuseReport(v2))
end
