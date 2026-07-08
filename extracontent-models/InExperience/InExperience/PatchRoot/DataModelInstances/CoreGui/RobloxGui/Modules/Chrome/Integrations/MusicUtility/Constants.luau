local Chrome = script:FindFirstAncestor("Chrome")
local Constants = require(Chrome.ChromeShared.Unibar.Constants)

return {
	AUDIO_REPORTING_WINDOW_MIN_HEIGHT = 420,
	MIN_TRACK_DETAILS_WIDTH = 48 / Constants.ICON_CELL_WIDTH,
	MAX_TRACK_DETAILS_WIDTH = 78 / Constants.ICON_CELL_WIDTH,
	MUSIC_WINDOW_MAX_SIZE = Vector2.new(400, 80)
}
