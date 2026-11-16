local gql = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/ApolloClient").gql

return {
	["GET_VIRTUAL_EVENT"] = gql(require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/GetVirtualEvent")),
	UPDATE_RSVP_STATUS = gql(require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/UpdateRsvpStatus")),
	NEVER_SHOW_NOTIFICATIONS_MODAL_AGAIN = gql(require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/NeverShowNotificationModalAgain")),
	ENABLE_PUSH_NOTIFICATIONS = gql(require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/EnablePushNotifications")),
	GET_EVENTS_FOR_EXPERIENCE = gql(require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/VirtualEventsForExperience"))
}
