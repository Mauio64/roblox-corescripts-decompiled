local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local IXPService = game:GetService("IXPService")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local AppPage = require(ServerDrivenUiParent.RobloxAppEnums).AppPage
local UrlBuilder = require(ServerDrivenUiParent.UrlBuilder).UrlBuilder
local FFlagLuaAppBadgeDetailsEnabled = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppBadgeDetailsEnabled
local fetchBadgeDetailsPage = require(ServerDrivenUiParent.Badges).fetchBadgeDetailsPage
local NavigateDown = require(ServerDrivenUiParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ServerDrivenUiParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v10 = if not FFlagSignalsNavP3Dispatch then nil else require(ServerDrivenUiParent.RobloxAppNavigation).NavigationCommands
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiLoadTimer = require(ServerDrivenUiParent.SduiSharedUtilities).SduiLoadTimer
local FFlagLuaAppBadgeDetailsLogExposure = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppBadgeDetailsLogExposure
local FStringLuaAppBadgeDetailsIxpLayer = require(ServerDrivenUiParent.SharedFlags).FStringLuaAppBadgeDetailsIxpLayer
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType
local v17 = UrlBuilder.fromString("www:badges")()

return function(p1, _, p3, _) -- line: 32
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), FFlagLuaAppBadgeDetailsLogExposure (copy), IXPService (copy), FStringLuaAppBadgeDetailsIxpLayer (copy), FFlagLuaAppBadgeDetailsEnabled (copy), SduiLoadTimer (copy), fetchBadgeDetailsPage (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy), v17 (copy)
	local v22 = p1 and p1.actionParams or nil

	if v22 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenBadgeDetails
		}, p3.appPage)

		return
	end

	assert(v22, "actionParams must exist")

	if v22.badgeId == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParam: badgeId",
			name = SduiActionType.OpenBadgeDetails
		}, p3.appPage)

		return
	end

	if FFlagLuaAppBadgeDetailsLogExposure then
		IXPService:LogFlagLinkedUserLayerExposure(FStringLuaAppBadgeDetailsIxpLayer)
	end

	if FFlagLuaAppBadgeDetailsEnabled then
		local v23 = SduiLoadTimer.createLoadTimer("BadgeDetails")

		v23.start("navigate")
		fetchBadgeDetailsPage(v22.badgeId, v23)

		local t1 = {
			name = AppPage.BadgeDetails,
			extraProps = {
				badgeId = v22.badgeId,
				pageTimer = v23
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v10.down(v10.fromLegacyPage(t1))

			return
		end

		p3.dependencies.dispatch(NavigateDown(t1))

		return
	end

	local v25 = `{ v17 }/{ v22.badgeId }`
	local t2 = {
		name = AppPage.GenericWebPage,
		detail = v25,
		extraProps = {
			transitionAnimation = "SlideInFromRight",
			title = v22.titleText
		}
	}

	if FFlagSignalsNavP3Dispatch then
		v10.down(v10.fromLegacyPage(t2))

		return
	end

	p3.dependencies.dispatch(NavigateDown(t2))
end
