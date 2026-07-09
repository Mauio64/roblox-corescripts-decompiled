local Parent = script:FindFirstAncestor("VirtualEvents").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local SduiLoadTimer = require(Parent.SduiSharedUtilities).SduiLoadTimer
local fetchEventDetailsPage = require(script.Parent.fetchEventDetailsPage)

local function navigateToEventDetails(t1: {[any]: any}, s1: string, s2: string?) -- line: 15
	-- upvalues: SduiLoadTimer (copy), AppPage (copy), fetchEventDetailsPage (copy)
	local v9 = SduiLoadTimer.createLoadTimer(AppPage.EventDetails)

	v9.start("navigate")
	fetchEventDetailsPage(s1, v9)
	t1.navigate(AppPage.EventDetails, {
		extraProps = {
			eventId = s1,
			pageTimer = v9,
			universeId = s2
		}
	})
end

return navigateToEventDetails
