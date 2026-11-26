local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RobloxAppEnums").AppPage
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SduiSharedUtilities")
local sduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getEventDetailsUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/SduiEventDetailsPage/getEventDetailsUrl")
local getEventDetailsPageKey = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/SduiEventDetailsPage/getEventDetailsPageKey")

local function fetchEventDetailsPage(p2, p3)
	local v5 = getEventDetailsUrl(p2)

	local experience_event_details_page = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/ServiceContractsProto").apppageplatform.experienceevents.experience_event_details_page

	getSduiApiStore().fetchIfNeeded({
		responseType = sduiResponseType.Protobuf,
		url = v5,
		surfaceKey = appPage.EventDetails,
		configKey = getEventDetailsPageKey(p2),
		loadTimer = p3,
		apiProto = experience_event_details_page.ExperienceEventDetailsPageResponse
	})
end

return fetchEventDetailsPage
