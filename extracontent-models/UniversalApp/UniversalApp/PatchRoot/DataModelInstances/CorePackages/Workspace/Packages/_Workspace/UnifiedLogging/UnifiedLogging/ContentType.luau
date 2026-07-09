local FFlagLuaAppUnifiedLoggingDialogContentType = require(script.Parent.FFlagLuaAppUnifiedLoggingDialogContentType)

return {
	Badge = "Badge",
	Filter = "Filter",
	User = "User",
	Game = "Game",
	Song = "Song",
	Dialog = if not FFlagLuaAppUnifiedLoggingDialogContentType then nil else "Dialog"
}
