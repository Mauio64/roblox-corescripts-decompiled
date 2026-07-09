local AppMusicPlayer = script:FindFirstAncestor("AppMusicPlayer")
local RoactCompat = require(AppMusicPlayer.Parent.Dev.RoactCompat)
local MusicTestingUtils = require(AppMusicPlayer.Parent.Dev.MusicTestingUtils)

return {
	name = AppMusicPlayer.Name,
	roact = RoactCompat,
	storyRoots = { AppMusicPlayer.Components },
	mapStory = function(p1) -- line: 12
		-- upvalues: RoactCompat (copy), MusicTestingUtils (copy)
		return function(p2) -- line: 13
			-- upvalues: RoactCompat (copy), MusicTestingUtils (copy), p1 (copy)
			return RoactCompat.createElement(MusicTestingUtils.ContextProviders, {
				theme = p2.theme,
				overlayGui = p2.focus,
				host = p2.host
			}, RoactCompat.createElement(p1, p2))
		end
	end
}
