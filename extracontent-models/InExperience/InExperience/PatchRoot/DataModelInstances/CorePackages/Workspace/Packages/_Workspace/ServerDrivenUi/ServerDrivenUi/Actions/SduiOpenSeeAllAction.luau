local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p, _, p2)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenSeeAll, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local collectionId = tostring(actionParams.collectionId)

	if collectionId == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenSeeAll,
				message = `Missing collectionId: {nil}`,
				propName = "collectionId"
			},
			p2.appPage
		)
		return
	end

	local collectionPosition = actionParams.collectionPosition
	local isOmni = p2.appPage == "Home"

	p2.dependencies.gameAnalytics.reportSeeAllWithId(collectionId, actionParams.gameSetTargetId, collectionPosition)

	local v = { name = AppPage.GamesList, detail = collectionId, extraProps = 0 }

	local extraProps = {
		sortPageId = tostring(collectionId),
		sortName = collectionId,
		pageContext = p2.appPage,
		isOmni = isOmni,
		sortIndex = 0
	}
	local sortIndex

	if isOmni then
		sortIndex = tonumber(collectionPosition)
	end

	extraProps.sortIndex = sortIndex
	v.extraProps = extraProps

	if FFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(v))
	else
		p2.dependencies.dispatch(NavigateDown(v))
	end
end
