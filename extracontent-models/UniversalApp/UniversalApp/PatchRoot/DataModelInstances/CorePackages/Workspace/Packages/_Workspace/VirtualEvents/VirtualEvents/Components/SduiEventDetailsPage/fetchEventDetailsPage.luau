local Parent = script:FindFirstAncestor("VirtualEvents").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getEventDetailsUrl = require(script.Parent.getEventDetailsUrl)
local getEventDetailsPageKey = require(script.Parent.getEventDetailsPageKey)

local function fetchEventDetailsPage(s1: string, p1) -- line: 13
	-- upvalues: getEventDetailsUrl (copy), Parent (copy), getSduiApiStore (copy), SduiResponseType (copy), AppPage (copy), getEventDetailsPageKey (copy)
	local v11 = getEventDetailsUrl(s1)
	local experience_event_details_page = require(Parent.ServiceContractsProto).apppageplatform.experienceevents.experience_event_details_page

	getSduiApiStore().fetchIfNeeded({
		responseType = SduiResponseType.Protobuf,
		url = v11,
		surfaceKey = AppPage.EventDetails,
		configKey = getEventDetailsPageKey(s1),
		loadTimer = p1,
		apiProto = experience_event_details_page.ExperienceEventDetailsPageResponse
	})
end

return fetchEventDetailsPage
