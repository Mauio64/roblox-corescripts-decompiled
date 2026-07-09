local Songbird = script:FindFirstAncestor("Songbird")
local RoactCompat = require(Songbird.Parent.Dev.RoactCompat)
local MusicTestingUtils = require(Songbird.Parent.Dev.MusicTestingUtils)

return {
	name = Songbird.Name,
	roact = RoactCompat,
	storyRoots = { Songbird.Components },
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
