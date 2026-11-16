local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local IXPService = game:GetService("IXPService")
local parent = ServerDrivenUi.Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppBadgeDetailsEnabled = SharedFlags.FFlagLuaAppBadgeDetailsEnabled
local Badges = require(parent.Badges)
local fetchBadgeDetailsPage = Badges.fetchBadgeDetailsPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags2.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppBadgeDetailsLogExposure = SharedFlags3.FFlagLuaAppBadgeDetailsLogExposure
local SharedFlags4 = require(parent.SharedFlags)
local FStringLuaAppBadgeDetailsIxpLayer = SharedFlags4.FStringLuaAppBadgeDetailsIxpLayer

local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

local v = urlBuilder.fromString("www:badges")()

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenBadgeDetails, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	if actionParams.badgeId == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenBadgeDetails, message = "Missing actionParam: badgeId" },
			p2.appPage
		)
		return
	end

	if FFlagLuaAppBadgeDetailsLogExposure then
		IXPService:LogFlagLinkedUserLayerExposure(FStringLuaAppBadgeDetailsIxpLayer)
	end

	if FFlagLuaAppBadgeDetailsEnabled then
		local loadTimer = SduiLoadTimer.createLoadTimer("BadgeDetails")
		loadTimer.start("navigate")

		fetchBadgeDetailsPage(actionParams.badgeId, loadTimer)

		local v2 = {
			name = AppPage.BadgeDetails,
			extraProps = { badgeId = actionParams.badgeId, pageTimer = loadTimer }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v2))
		else
			p2.dependencies.dispatch(NavigateDown(v2))
		end
	else
		local formatted = `{v}/{actionParams.badgeId}`
		local v2 = {
			name = AppPage.GenericWebPage,
			detail = formatted,
			extraProps = {
				title = actionParams.titleText,
				transitionAnimation = "SlideInFromRight"
			}
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v2))
		else
			p2.dependencies.dispatch(NavigateDown(v2))
		end
	end
end
