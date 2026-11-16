local HttpService = game:GetService("HttpService")
local module = require("@luauforge/bundled/fot")
local openYouTubeVideoEvent = require("@luauforge/bundled/dwD").Events.openYouTubeVideoEvent

local module2 = require("@luauforge/bundled/fsq")

local v5 = {
	autoplay = 1,
	controls = 0,
	modestbranding = 1,
	rel = 0,
	loop = 0,
	cc_load_policy = 0,
	playsinline = 0
}

return function(object, p2, p3, p4, p5, p6, p7)
	return function(p8)
		local v6 = module2.new({
			base = "https://www.youtube-nocookie.com",
			path = "/embed/{id}",
			query = v5
		})({ id = p2 })

		openYouTubeVideoEvent(p5, p4, p3, p2, p6, p7)

		object:BroadcastNotification(
			HttpService:JSONEncode({ url = v6, title = p3, animated = true }),
			module.OPEN_YOUTUBE_VIDEO
		)
	end
end
