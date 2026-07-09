local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType
local OpenDynamicAbuseReport = require(Parent.GenericAbuseReporting.OpenDynamicAbuseReport)
local CloseCentralOverlay = require(Parent.CentralOverlay).Thunks.CloseCentralOverlay
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigationRodux = require(Parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local SduiLoadTimer = require(Parent.SduiSharedUtilities).SduiLoadTimer
local fetchBadgeDetailsPage = require(Parent.Badges).fetchBadgeDetailsPage
local getIsBadgeDetailsSheetOpen = require(Parent.Badges).BadgeDetailsSheetState.getIsBadgeDetailsSheetOpen
local FFlagCloseBadgeSheetOnAbuseReport = require(Parent.SharedFlags).FFlagCloseBadgeSheetOnAbuseReport
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v16 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands

return function(p1, _, p3, _) -- line: 28
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), FFlagCloseBadgeSheetOnAbuseReport (copy), getIsBadgeDetailsSheetOpen (copy), FFlagSignalsNavP3Dispatch (copy), v16 (copy), NavigateBack (copy), OpenDynamicAbuseReport (copy), CloseCentralOverlay (copy), SduiLoadTimer (copy), fetchBadgeDetailsPage (copy), AppPage (copy), NavigateDown (copy)
	local v21 = p1 and p1.actionParams or nil

	if v21 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing action params",
			name = SduiActionType.OpenAbuseReport
		}, p3.appPage)

		return
	end

	assert(v21, "actionParams must exist")

	if v21.targetId == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParam: targetId",
			name = SduiActionType.OpenAbuseReport
		}, p3.appPage)

		return
	end

	if v21.abuseVector == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParam: abuseVector",
			name = SduiActionType.OpenAbuseReport
		}, p3.appPage)

		return
	end

	local targetId = v21.targetId
	local abuseVector = v21.abuseVector
	local assetTypeName = v21.assetTypeName
	local universeId = v21.universeId
	local dispatch = p3.dependencies.dispatch
	local v27 = FFlagCloseBadgeSheetOnAbuseReport and (p3.appPage == "BadgeDetails" and getIsBadgeDetailsSheetOpen())

	if v27 then
		if FFlagSignalsNavP3Dispatch then
			v16.back()
		else
			dispatch(NavigateBack())
		end
	end

	local v28 = if not v27 then nil else targetId

	dispatch(OpenDynamicAbuseReport({
		abuseVector = abuseVector,
		targetId = targetId,
		custom = {
			assetTypeName = assetTypeName,
			universeId = universeId
		},
		onClose = function() -- line: 94
			-- upvalues: dispatch (copy), CloseCentralOverlay (copy), v28 (copy), SduiLoadTimer (copy), fetchBadgeDetailsPage (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v16 (copy), NavigateDown (copy)
			dispatch(CloseCentralOverlay())

			if v28 then
				local v29 = SduiLoadTimer.createLoadTimer("BadgeDetails")

				v29.start("navigate")
				fetchBadgeDetailsPage(v28, v29)

				local t1 = {
					name = AppPage.BadgeDetails,
					extraProps = {
						badgeId = v28,
						pageTimer = v29
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v16.down(v16.fromLegacyPage(t1))

					return
				end

				dispatch(NavigateDown(t1))
			end
		end
	}))
end
