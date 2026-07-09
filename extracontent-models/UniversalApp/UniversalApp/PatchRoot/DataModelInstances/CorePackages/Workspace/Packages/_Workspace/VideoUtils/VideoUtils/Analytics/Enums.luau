local t1 = {
	AppBackgrounded = "appBackgrounded",
	ExitViewport = "exitViewport",
	ExperienceLaunched = "experienceLaunched",
	PlayabilityCheckFailed = "playabilityCheckFailed",
	ScrollStart = "scrollStart",
	ScrollSettled = "scrollSettled",
	TileClicked = "tileClicked",
	Unhovered = "unhovered",
	Unmounted = "unmounted",
	ViewportResized = "viewportResized"
}
local t2 = {
	VIDEO_UNKNOWN_EVENT = "VIDEO_UNKNOWN_EVENT",
	VIDEO_IMPRESSION = "VIDEO_IMPRESSION",
	VIDEO_ACTION = "VIDEO_ACTION",
	VIDEO_PROGRESS = "VIDEO_PROGRESS"
}
local t3 = {
	unknown = "unknown",
	complete = "complete",
	ended = "end",
	exit_fullscreen = "exit_fullscreen",
	fullscreen = "fullscreen",
	hover = "hover",
	load = "load",
	loop = "loop",
	navigate = "navigate",
	pause = "pause",
	play = "play",
	scrub = "scrub",
	volume = "volume"
}
local t4 = {
	community = "community",
	MediaGallery = "MediaGallery"
}

return {
	VideoEndReason = t1,
	VideoEngagementEvents = t2,
	VideoActions = t3,
	VideoSources = t4
}
