local parent = script:FindFirstAncestor("VirtualEvents").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local fetchEventDetailsPage = require(script.Parent.fetchEventDetailsPage)

local function navigateToEventDetails(p, eventId: string, universeId: string?)
	local loadTimer = SduiLoadTimer.createLoadTimer(AppPage.EventDetails)
	loadTimer.start("navigate")

	fetchEventDetailsPage(eventId, loadTimer)

	p.navigate(AppPage.EventDetails, {
		extraProps = { eventId = eventId, pageTimer = loadTimer, universeId = universeId }
	})
end

return navigateToEventDetails
