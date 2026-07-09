local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v5 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p1, _, p3) -- line: 21
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v5 (copy), NavigateDown (copy)
	local v12 = p1 and p1.actionParams or nil

	if v12 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenSeeAll
		}, p3.appPage)

		return
	end

	assert(v12, "actionParams must exist")

	local str = tostring(v12.collectionId)

	if str == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "collectionId",
			name = SduiActionType.OpenSeeAll,
			message = `Missing collectionId: { str }`
		}, p3.appPage)

		return
	end

	local collectionPosition = v12.collectionPosition
	local v15 = p3.appPage == "Home"

	p3.dependencies.gameAnalytics.reportSeeAllWithId(str, v12.gameSetTargetId, collectionPosition)

	local t1 = {
		name = AppPage.GamesList,
		detail = str,
		extraProps = {
			sortPageId = tostring(str),
			sortName = str,
			pageContext = p3.appPage,
			isOmni = v15,
			sortIndex = if not v15 then nil else tonumber(collectionPosition)
		}
	}

	if FFlagSignalsNavP3Dispatch then
		v5.down(v5.fromLegacyPage(t1))

		return
	end

	p3.dependencies.dispatch(NavigateDown(t1))
end
