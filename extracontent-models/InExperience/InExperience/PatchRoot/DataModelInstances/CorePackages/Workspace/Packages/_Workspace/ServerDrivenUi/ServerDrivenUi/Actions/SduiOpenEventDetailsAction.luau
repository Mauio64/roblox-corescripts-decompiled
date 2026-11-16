local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local VirtualEvents = require(parent.VirtualEvents)
local navigateToEventDetails = VirtualEvents.navigateToEventDetails
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiEventDetailsEnabled = SharedFlags.FFlagLuaAppSduiEventDetailsEnabled

return function(p, p2, p3, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = "OpenEventDetails", message = "Missing actionParams" },
			p3.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	local eventId = actionParams.eventId

	if eventId == nil then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = "OpenEventDetails", message = "Missing eventId", propName = "eventId" },
			p3.appPage
		)
		return
	end

	local universeId = actionParams.universeId or p2 and p2.analyticsData and p2.analyticsData.universeId

	local navigation = p3.dependencies.getNavigation()

	if not FFlagLuaAppSduiEventDetailsEnabled then
		navigation.navigate(AppPage.EventDetails, {
			extraProps = { currentTime = DateTime.now(), virtualEventId = tostring(eventId) }
		})

		return
	end

	local v = tostring(eventId)
	local v2

	if universeId then
		v2 = tostring(universeId)
	end

	navigateToEventDetails(navigation, v, v2)
end
