local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.dependencies).enumerate(script.Name, {
	InGame = "inGame",
	InStudio = "inStudio",
	Offline = "offline",
	Online = "online"
})
