local SongDetails = script:FindFirstAncestor("SongDetails")
local Roact = require(SongDetails.Parent.Dev.Roact)

return {
	name = SongDetails.Name,
	storyRoots = { script.Parent },
	roact = Roact
}
