local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local navigateToEventDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/VirtualEvents").navigateToEventDetails
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").AppPage
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local fFlagLuaAppSduiEventDetailsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiEventDetailsEnabled

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = "OpenEventDetails", message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	local eventId = actionParams.eventId

	if eventId == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "OpenEventDetails",
				message = "Missing eventId",
				propName = "eventId"
			},
			p4.appPage
		)
		return
	end

	local universeId = actionParams.universeId or p3 and p3.analyticsData and p3.analyticsData.universeId

	local navigation = p4.dependencies.getNavigation()

	if not fFlagLuaAppSduiEventDetailsEnabled then
		navigation.navigate(appPage.EventDetails, {
			extraProps = {
				currentTime = DateTime.now(),
				virtualEventId = tostring(eventId)
			}
		})

		return
	end

	local v6 = tostring(eventId)
	local v7 = if universeId then tostring(universeId) else nil
	navigateToEventDetails(navigation, v6, v7)
end
