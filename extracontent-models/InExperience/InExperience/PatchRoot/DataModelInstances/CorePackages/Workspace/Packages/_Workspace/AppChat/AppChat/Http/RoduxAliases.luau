local Parent = script:FindFirstAncestor("AppChat").Parent

return require(Parent.LuaSocialLibrariesDeps).RoduxAliases.config({
	keyPath = "ChatAppReducer.Aliases"
})
