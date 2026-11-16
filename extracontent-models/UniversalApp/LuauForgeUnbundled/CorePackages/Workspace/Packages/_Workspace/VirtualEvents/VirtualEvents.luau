local VirtualEventsState = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState")

local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/EventNotificationsModal")

return {
	AnalyticsEvent = VirtualEventsState.enums.AnalyticsEvent,
	requests = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/requests"),
	EventDetailsPageLoader = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/EventDetailsPageLoader"),
	SduiEventDetailsPage = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/SduiEventDetailsPage/SduiEventDetailsPage"),
	ShareEventModal = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/ShareEventModal"),
	EventNotificationsModal = module2,
	EventsListCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/EventsListCarousel/EventsListCarousel"),
	EventsInExperienceApp = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/EventsInExperienceApp"),
	fireEventDetailsPageVisit = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Analytics/fireEventDetailsPageVisit"),
	fireShareVirtualEventIconClicked = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Analytics/fireShareVirtualEventIconClicked"),
	fireVirtualEventJoined = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Analytics/fireVirtualEventJoined"),
	fireVirtualEventLinkCopied = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Analytics/fireVirtualEventLinkCopied"),
	fireVirtualEventRSVP = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Analytics/fireVirtualEventRSVP"),
	fireEventNotificationEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Analytics/fireEventNotificationEnabled"),
	enablePushNotifications = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/enablePushNotifications"),
	neverShowNotificationsModalAgain = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/neverShowNotificationsModalAgain"),
	fireVirtualEventImpression = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Analytics/fireVirtualEventImpression"),
	navigateToEventDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/SduiEventDetailsPage/navigateToEventDetails")
}
