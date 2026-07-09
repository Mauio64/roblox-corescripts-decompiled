local Events = require(script.Parent.Events)
local EventModes = require(script.Parent.EventModes)

return {
	[Events.TestEvent] = {
		mode = EventModes.Default
	},
	[Events.TestStrictEvent] = {
		mode = EventModes.Strict
	},
	[Events.CaptureShared] = {
		mode = EventModes.Default
	},
	[Events.CaptureTaken] = {
		mode = EventModes.Default
	},
	[Events.EditProfileOpened] = {
		mode = EventModes.Default
	},
	[Events.ProfileOpened] = {
		mode = EventModes.Default
	},
	[Events.JoinGameCardOpened] = {
		mode = EventModes.Default
	},
	[Events.PYMKCarouselLoaded] = {
		mode = EventModes.Default
	},
	[Events.AFPUserTileLoadFromHomeCarousel] = {
		mode = EventModes.Default
	},
	[Events.CustomizeNameOpened] = {
		mode = EventModes.Default
	},
	[Events.StaticShareLinkOpened] = {
		mode = EventModes.Default
	},
	[Events.ShareLinkOpened] = {
		mode = EventModes.Default
	}
}
