local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RobloxAppEnums").AppPage
local sduiLoadTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SduiSharedUtilities").SduiLoadTimer
local fetchEventDetailsPage = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/SduiEventDetailsPage/fetchEventDetailsPage")

local function navigateToEventDetails(p2, p3, p4)
	local loadTimer = sduiLoadTimer.createLoadTimer(appPage.EventDetails)
	loadTimer.start("navigate")

	fetchEventDetailsPage(p3, loadTimer)

	p2.navigate(appPage.EventDetails, {
		extraProps = { eventId = p3, pageTimer = loadTimer, universeId = p4 }
	})
end

return navigateToEventDetails
