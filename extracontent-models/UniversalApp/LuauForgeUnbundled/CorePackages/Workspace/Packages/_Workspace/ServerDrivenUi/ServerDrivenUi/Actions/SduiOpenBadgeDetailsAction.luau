local IXPService = game:GetService("IXPService")

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").AppPage
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UrlBuilder").UrlBuilder
local fFlagLuaAppBadgeDetailsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppBadgeDetailsEnabled
local fetchBadgeDetailsPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Badges").fetchBadgeDetailsPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppNavigation").NavigationCommands else nil

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiLoadTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities").SduiLoadTimer

local fFlagLuaAppBadgeDetailsLogExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppBadgeDetailsLogExposure
local fStringLuaAppBadgeDetailsIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FStringLuaAppBadgeDetailsIxpLayer

local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType

local v5 = urlBuilder.fromString("www:badges")()

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.OpenBadgeDetails, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	if actionParams.badgeId == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenBadgeDetails,
				message = "Missing actionParam: badgeId"
			},
			p4.appPage
		)
		return
	end

	if fFlagLuaAppBadgeDetailsLogExposure then
		IXPService:LogFlagLinkedUserLayerExposure(fStringLuaAppBadgeDetailsIxpLayer)
	end

	if fFlagLuaAppBadgeDetailsEnabled then
		local loadTimer = sduiLoadTimer.createLoadTimer("BadgeDetails")
		loadTimer.start("navigate")

		fetchBadgeDetailsPage(actionParams.badgeId, loadTimer)

		local v6 = {
			name = appPage.BadgeDetails,
			extraProps = { badgeId = actionParams.badgeId, pageTimer = loadTimer }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v6))
		else
			p4.dependencies.dispatch(navigateDown(v6))
		end
	else
		local formatted = `{v5}/{actionParams.badgeId}`
		local v6 = {
			name = appPage.GenericWebPage,
			detail = formatted,
			extraProps = {
				title = actionParams.titleText,
				transitionAnimation = "SlideInFromRight"
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v6))
		else
			p4.dependencies.dispatch(navigateDown(v6))
		end
	end
end
