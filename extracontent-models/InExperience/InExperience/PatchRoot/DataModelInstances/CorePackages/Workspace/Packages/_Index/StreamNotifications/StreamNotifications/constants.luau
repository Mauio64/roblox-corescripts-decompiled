local parent = script:FindFirstAncestor("StreamNotifications").Parent
local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images

return {
	DefaultPadding = 8,
	DefaultMaxRows = 20,
	Modal = {
		Width = 540,
		Height = 600,
		Padding = 8,
		CornerRadius = 12,
		WidthLimit = 640,
		CloseIcon = Images["icons/navigation/close"],
		BackIcon = Images["icons/navigation/pushBack"],
		SettingsIcon = Images["icons/common/settings"],
		HeaderHeight = 56
	},
	InitializingNotifications = { Size = 48 },
	LoadingMoreNotifications = { Size = 24, TriggerDistance = 400 },
	EmptyNotifications = {
		Size = 96,
		Graphic = Images["icons/graphic/success_xlarge"],
		LabelHeight = 24
	},
	MetaActions = {
		CloseButtonFrameSize = 36,
		CloseButtonSize = 30,
		CloseIcon = Images["icons/navigation/close"],
		CloseIconSize = 24,
		ActionIcons = {
			turnOnNotifications = Images["icons/common/notificationOn"],
			turnOffNotifications = Images["icons/common/notificationOff"],
			report = Images["icons/actions/feedback"],
			default = Images["icons/placeholder/placeholderOff"]
		}
	},
	Text = {
		HeaderKey = "Notifications.NotificationStream.Label.Notifications",
		EmptyKey = "Notifications.NotificationStream.Label.AllCaughtUp",
		ShowMoreKey = "Notifications.NotificationStream.Bundle.ShowMoreV2",
		ShowLessKey = "Notifications.NotificationStream.Bundle.ShowLess"
	},
	DeliveryChannel = "Stream",
	StreamSessionStructuralIdentifier = {
		Level1 = "level1",
		StreamNotification = "streamNotification",
		DeleteOnGameLeave = "_deleteOnGameLeave"
	},
	SENDRVersion = 0,
	Dropdown = {
		Width = 360,
		MaxHeight = 638,
		MinHeight = 200,
		VerticalMargin = 100,
		CornerRadius = 16,
		HorizontalPadding = 20,
		PaddingTop = 8,
		PaddingBottom = 8,
		HeaderMinHeight = 40,
		CardGap = 16,
		HeaderBodyGap = 8,
		ScrollBarThickness = 4,
		BellIconOpen = Images["icons/common/notificationOn"],
		BellIconClosed = Images["icons/common/notificationOff"]
	}
}
