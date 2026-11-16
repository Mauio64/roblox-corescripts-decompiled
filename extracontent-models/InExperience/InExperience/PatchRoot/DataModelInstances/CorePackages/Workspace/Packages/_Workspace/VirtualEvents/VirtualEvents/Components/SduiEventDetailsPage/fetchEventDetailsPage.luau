local parent = script:FindFirstAncestor("VirtualEvents").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getEventDetailsUrl = require(script.Parent.getEventDetailsUrl)
local getEventDetailsPageKey = require(script.Parent.getEventDetailsPageKey)

local function fetchEventDetailsPage(p: string, loadTimer)
	local eventDetailsUrl = getEventDetailsUrl(p)

	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local experience_event_details_page = ServiceContractsProto.apppageplatform.experienceevents.experience_event_details_page

	getSduiApiStore().fetchIfNeeded({
		responseType = SduiResponseType.Protobuf,
		url = eventDetailsUrl,
		surfaceKey = AppPage.EventDetails,
		configKey = getEventDetailsPageKey(p),
		loadTimer = loadTimer,
		apiProto = experience_event_details_page.ExperienceEventDetailsPageResponse
	})
end

return fetchEventDetailsPage
