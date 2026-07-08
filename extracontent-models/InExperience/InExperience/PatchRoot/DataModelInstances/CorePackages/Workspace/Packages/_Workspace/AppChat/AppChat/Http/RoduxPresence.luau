local Parent = script:FindFirstAncestor("AppChat").Parent

return require(Parent.LuaSocialLibrariesDeps).RoduxPresence.config({
	keyPath = "ChatAppReducer.Presence"
})
