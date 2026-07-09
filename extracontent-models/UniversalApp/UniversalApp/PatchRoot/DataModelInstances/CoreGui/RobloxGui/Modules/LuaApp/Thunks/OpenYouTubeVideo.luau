local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local openYouTubeVideoEvent = require(CorePackages.Workspace.Packages.DiscoveryAnalytics).Events.openYouTubeVideoEvent
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local t1 = {
	autoplay = 1,
	controls = 0,
	modestbranding = 1,
	rel = 0,
	loop = 0,
	cc_load_policy = 0,
	playsinline = 0
}

return function(p1, p2, p3, p4, p5, p6, p7) -- line: 19
	-- upvalues: UrlBuilder (copy), t1 (copy), openYouTubeVideoEvent (copy), HttpService (copy), NotificationType (copy)
	return function(_) -- line: 20
		-- upvalues: UrlBuilder (copy), t1 (copy), p2 (copy), openYouTubeVideoEvent (copy), p5 (copy), p4 (copy), p3 (copy), p6 (copy), p7 (copy), HttpService (copy), p1 (copy), NotificationType (copy)
		local v16 = UrlBuilder.new({
			base = "https://www.youtube-nocookie.com",
			path = "/embed/{id}",
			query = t1
		})({
			id = p2
		})

		openYouTubeVideoEvent(p5, p4, p3, p2, p6, p7)

		local json = HttpService:JSONEncode({
			animated = true,
			url = v16,
			title = p3
		})

		p1:BroadcastNotification(json, NotificationType.OPEN_YOUTUBE_VIDEO)
	end
end
