local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppNavigation").NavigationCommands else nil

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.OpenSeeAll, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local collectionId = tostring(actionParams.collectionId)

	if collectionId == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenSeeAll,
				message = `Missing collectionId: {nil}`,
				propName = "collectionId"
			},
			p4.appPage
		)
		return
	end

	local collectionPosition = actionParams.collectionPosition
	local v5 = p4.appPage == "Home"

	p4.dependencies.gameAnalytics.reportSeeAllWithId(
		collectionId,
		actionParams.gameSetTargetId,
		collectionPosition
	)

	local v6 = { name = appPage.GamesList, detail = collectionId, extraProps = 0 }

	local v7 = {
		sortPageId = tostring(collectionId),
		sortName = collectionId,
		pageContext = p4.appPage,
		isOmni = v5,
		sortIndex = 0
	}

	local v8 = if v5 then tonumber(collectionPosition) else nil
	v7.sortIndex = v8
	v6.extraProps = v7

	if fFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(v6))
	else
		p4.dependencies.dispatch(navigateDown(v6))
	end
end
