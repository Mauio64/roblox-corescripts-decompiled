local Songbird = script:FindFirstAncestor("Songbird")

local RoactCompat = require(Songbird.Parent.Dev.RoactCompat)
local MusicTestingUtils = require(Songbird.Parent.Dev.MusicTestingUtils)

return {
	name = Songbird.Name,
	roact = RoactCompat,
	storyRoots = { Songbird.Components },
	mapStory = function(p)
		return function(props)
			return RoactCompat.createElement(
				MusicTestingUtils.ContextProviders,
				{ theme = props.theme, overlayGui = props.focus, host = props.host },
				RoactCompat.createElement(p, props)
			)
		end
	end
}
