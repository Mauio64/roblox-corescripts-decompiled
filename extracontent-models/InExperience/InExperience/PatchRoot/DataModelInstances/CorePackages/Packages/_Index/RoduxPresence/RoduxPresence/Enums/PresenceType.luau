local parent = script:FindFirstAncestor("RoduxPresence").Parent
local enumerate = require(parent.enumerate)

return enumerate(script.Name, {
	Offline = 0,
	Online = 1,
	InGame = 2,
	InStudio = 3,
	Invisible = 4
})
