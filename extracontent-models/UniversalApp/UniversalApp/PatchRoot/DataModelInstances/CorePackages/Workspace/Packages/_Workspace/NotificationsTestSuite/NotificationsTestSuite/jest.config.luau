local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.GameInvite)["jest.config"],
		require(ParentParent.NotificationsCommon)["jest.config"],
		require(ParentParent.ToastNotification)["jest.config"],
		require(ParentParent.StreamNotifications)["jest.config"],
		require(ParentParent.NotificationModalsManager)["jest.config"],
		require(ParentParent.NotificationsUpsell)["jest.config"]
	}
}
