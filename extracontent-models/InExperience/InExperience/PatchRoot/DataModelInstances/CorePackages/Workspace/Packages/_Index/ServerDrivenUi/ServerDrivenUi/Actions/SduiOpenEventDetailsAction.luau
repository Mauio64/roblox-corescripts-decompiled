local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local navigateToEventDetails = require(Parent.VirtualEvents).navigateToEventDetails
local AppPage = require(Parent.RobloxAppEnums).AppPage
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local FFlagLuaAppSduiEventDetailsEnabled = require(Parent.SharedFlags).FFlagLuaAppSduiEventDetailsEnabled

return function(p1, p2, p3, _) -- line: 16
	-- upvalues: SduiErrorType (copy), FFlagLuaAppSduiEventDetailsEnabled (copy), navigateToEventDetails (copy), AppPage (copy)
	local v11 = p1 and p1.actionParams or nil

	if v11 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "OpenEventDetails",
			message = "Missing actionParams"
		}, p3.appPage)

		return
	end

	assert(v11, "actionParams must exist")

	local eventId = v11.eventId

	if eventId == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "OpenEventDetails",
			message = "Missing eventId",
			propName = "eventId"
		}, p3.appPage)

		return
	end

	local v13 = v11.universeId or p2 and (p2.analyticsData and p2.analyticsData.universeId)
	local v14 = p3.dependencies.getNavigation()

	if FFlagLuaAppSduiEventDetailsEnabled then
		navigateToEventDetails(v14, tostring(eventId), if not v13 then nil else tostring(v13))

		return
	end

	v14.navigate(AppPage.EventDetails, {
		extraProps = {
			currentTime = DateTime.now(),
			virtualEventId = tostring(eventId)
		}
	})
end
