local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
return dependencies.enumerate(script.Name, {
	InGame = "inGame",
	InStudio = "inStudio",
	Offline = "offline",
	Online = "online"
})
